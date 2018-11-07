/*
 * Copyright 2018 Torpedo corp.
 *  
 * bizframe mas project licenses this file to you under the Apache License,
 * version 2.0 (the "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at:
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */


package kr.co.bizframe.mas.web;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.jetty.annotations.ServletContainerInitializersStarter;
//import org.eclipse.jetty.apache.jsp.JettyJasperInitializer;
import org.eclipse.jetty.http.HttpVersion;
import org.eclipse.jetty.jmx.MBeanContainer;
import org.eclipse.jetty.plus.annotation.ContainerInitializer;
import org.eclipse.jetty.server.Connector;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.HttpConfiguration;
import org.eclipse.jetty.server.HttpConnectionFactory;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.ServerConnector;
import org.eclipse.jetty.server.SslConnectionFactory;
import org.eclipse.jetty.server.handler.ContextHandlerCollection;
import org.eclipse.jetty.util.ssl.SslContextFactory;
import org.eclipse.jetty.webapp.WebAppContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.bizframe.mas.Application;
import kr.co.bizframe.mas.Serviceable;
import kr.co.bizframe.mas.application.ApplicationContext;
import kr.co.bizframe.mas.application.ApplicationException;
import kr.co.bizframe.mas.management.JMXManager;
import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventorFactory;
import kr.co.bizframe.mas.web.WebAppConfigs.WebAppConfig;

public class JettyApplication implements Serviceable, Application {

	private static Logger log = LoggerFactory.getLogger(JettyApplication.class);

	private ApplicationContext appContext;

	private Server jettyServer;

	private List<WebAppContext> webappContexts =  new ArrayList<WebAppContext>();
			
	private List<ClassLoaderLeakPreventor> classLoaderLeakPreventors =
			new ArrayList<ClassLoaderLeakPreventor>();
	
	private boolean enableLeakPreventor = true;
	
	public void init(ApplicationContext context) throws ApplicationException {

		try {
			appContext = context;
		
			// boolean disableCreateCL = context.getBooleanProperty("disable_create_cl", false);

			jettyServer = new Server();
			
			// Setup JMX
			boolean enableJMX = context.getBooleanProperty("enable_jmx", false);
			if(enableJMX){
				MBeanContainer mbContainer=new MBeanContainer(JMXManager.getMBeanServer());
				//jettyServer.getContainer().addEventListener(mbContainer);
				jettyServer.addBean(mbContainer);
			}
		
			Connector connector = createConnector(context);
			jettyServer.setConnectors(new Connector[] { connector });
			
			List<WebAppConfig> waconfigs = WebAppConfigs.getWebAppConfigs(context);
		
			for(WebAppConfig waconfig : waconfigs){
			
				log.info("webapp config = " + waconfig);
				WebAppContext webapp = new WebAppContext();
				webapp.setAttribute("applicationContext", context);
				webapp.setContextPath(waconfig.getContextPath());
				webapp.setResourceBase(waconfig.getDocBase());
				
				
				org.eclipse.jetty.webapp.Configuration.ClassList classlist = 
						org.eclipse.jetty.webapp.Configuration.ClassList.setServerDefault(jettyServer);
		        classlist.addAfter("org.eclipse.jetty.webapp.FragmentConfiguration", 
		        		"org.eclipse.jetty.plus.webapp.EnvConfiguration", 
		        		"org.eclipse.jetty.plus.webapp.PlusConfiguration");
		        classlist.addBefore("org.eclipse.jetty.webapp.JettyWebXmlConfiguration",
		        		"org.eclipse.jetty.annotations.AnnotationConfiguration");
				
		        
		        /*
		         * JSP 지원을 위해서 catalina를 사용하나 tomcat 패키지와 
		         * 충돌하므로 jetty에서는 jsp 지원은 종료함. 향후 jsp를 위해서는 
		         * tomcat application 사용을 함.
		         *
		         */
		        
		        /*
		        JettyJasperInitializer sci = new JettyJasperInitializer();
		        ServletContainerInitializersStarter sciStarter = new ServletContainerInitializersStarter(webapp);
		        ContainerInitializer initializer = new ContainerInitializer(sci, null);
		        List<ContainerInitializer> initializers = new ArrayList<ContainerInitializer>();
		        initializers.add(initializer);
		        webapp.setAttribute("org.eclipse.jetty.containerInitializers", initializers);
		        webapp.addBean(sciStarter, true);
		        */
		        
		        
		        webapp.setInitParameter("org.eclipse.jetty.servlet.Default.dirAllowed", "false");
		        
		        // static file locking 해제 
				// 기본 false
				boolean useFileMapperedBuffer = context.getBooleanProperty("use_filemappered_buffer", false);
				log.debug("use fileMapperedBuffer = "+ useFileMapperedBuffer);
				if (!useFileMapperedBuffer) {
					//webapp.getInitParams().put("useFileMappedBuffer", "false"); 
					webapp.getInitParams().put("org.eclipse.jetty.servlet.Default.useFileMappedBuffer", "false");
				}
				
				//jettyServer.setHandler(webapp);
				webappContexts.add(webapp);
			}
			
			
			// ///////////////////////////////////////////////////////////
			// applicatrionId를 찾기 위해서 다음 코드 추가
			//
			// 기본 ApplicationContext의 classloader를 webappcontext의 
			// classloader로 대체
			//////////////////////////////////////////////////////////
		
			//String appId = appContext.getId();
			//ApplicationContextUtils.putApplicationId(webAppClassLoader, appId);
			
			// SessionIdManager sim = new BasicSessionIdManager();
			// jettyServer.setSessionIdManager(sim);
			
			ContextHandlerCollection contexts = new ContextHandlerCollection();
			contexts.setHandlers(webappContexts.toArray(new Handler[0]));
			jettyServer.setHandler(contexts);
			
			
			for(WebAppContext webapp : webappContexts){
				webapp.start();
	
				// leak preventor 추가 
				if(enableLeakPreventor){
					log.debug("enable web leak preventor");
					ClassLoader webAppClassLoader = webapp.getClassLoader();
					ClassLoaderLeakPreventorFactory classLoaderLeakPreventorFactory = 
							new ClassLoaderLeakPreventorFactory() ;
					ClassLoaderLeakPreventor classLoaderLeakPreventor = classLoaderLeakPreventorFactory.
							newLeakPreventor(webAppClassLoader);
					classLoaderLeakPreventor.runPreClassLoaderInitiators();
					classLoaderLeakPreventors.add(classLoaderLeakPreventor);
					
				}
			}
			
		} catch (Throwable t) {
			throw new ApplicationException(t.getMessage(), t);
		}
	}

	public ApplicationContext getAppContext() {
		return appContext;
	}
	
	public void setAppContext(ApplicationContext appContext) {
		this.appContext = appContext;
	}

	public Server getJettyServer() {
		return jettyServer;
	}

	public void setJettyServer(Server jettyServer) {
		this.jettyServer = jettyServer;
	}

	

	public void start() throws Exception {
		try {
			jettyServer.start();
		} catch (Exception e) {
			//log.error(e.getMessage(), e);
			throw new Exception(e.getMessage(), e);
		}
	}

	public void stop() throws Exception {
		try {
			for(WebAppContext context : webappContexts){
				context.stop();
			}
			
			jettyServer.stop();
		} catch (Exception e) {
			//log.error(e.getMessage(), e);
			throw new Exception(e.getMessage(), e);
		}
	}

	public void destroy(ApplicationContext context) throws ApplicationException {

		if (jettyServer != null) {

			try {
				jettyServer.destroy();
				if(enableLeakPreventor){
					for(ClassLoaderLeakPreventor classLoaderLeakPreventor : classLoaderLeakPreventors){
						classLoaderLeakPreventor.runCleanUps();
					}
				}
				
			} catch (Throwable t) {
				//log.error(t.getMessage(), t);
				throw new ApplicationException(t.getMessage(), t);
			}
		}
	}
	
	
	private Connector createConnector(ApplicationContext context){
		
		boolean https = context.getBooleanProperty("https", false);
		int port = context.getIntProperty("port");
		log.debug("port = " + port);
		
		ServerConnector connector = null;
		if(https){
			
			String keystoreFile = context.getProperty("keystoreFile");
			String keystorePass = context.getProperty("keystorePass");
			String truststoreFile = context.getProperty("truststoreFile");
			String truststorePass = context.getProperty("truststorePass");
	     
			HttpConfiguration httpsConfig = new HttpConfiguration();
			httpsConfig.setSecureScheme("https");
	        httpsConfig.setSecurePort(port);
	        
			/*
	     	connector.setPort(port);
	        SslContextFactory cf = sslConnector.getSslContextFactory();
	        if(keystoreFile != null) cf.setKeyStorePath(keystoreFile);
	        if(keystorePass != null) cf.setKeyStorePassword(keystorePass);
	        if(truststoreFile != null) cf.setTrustStore(truststoreFile);
	        if(truststorePass != null) cf.setTrustStorePassword(truststorePass);
	        //return sslConnector;
	        */
			
			SslContextFactory sslContextFactory = new SslContextFactory();
			sslContextFactory.setKeyStorePath(keystoreFile);
	        sslContextFactory.setKeyStorePassword(keystorePass);
	        sslContextFactory.setTrustStorePath(truststoreFile);
	        sslContextFactory.setTrustStorePassword(truststorePass);
	        
	        
			connector = new ServerConnector(jettyServer,
		            new SslConnectionFactory(sslContextFactory, HttpVersion.HTTP_1_1.asString()),
		                new HttpConnectionFactory(httpsConfig));
	        
		}else{
			
			connector = new ServerConnector(jettyServer);
			//connector = new SelectChannelConnector();
		}
		
		connector.setPort(port);
		return connector;
	}
	
	/*
	private List<WebAppConfig> getWebAppConfig(ApplicationContext context){
		
		List<WebAppConfig> waconfig = new ArrayList<WebAppConfig>();
		// docBase 는 기본 /web 디렉토로로 하고 doc_base 설정시 설정 디렉터리로 함..
		// docBase 항상 상대경로로만 함..
		String docBase = context.getProperty("doc_base");
		if (docBase == null) {
			docBase = context.getContextDir() + "/web";
		}
		docBase = getAbsoluteDocBaseDir(docBase);
		String contextPath = context.getProperty("context_path");
		log.debug("contextPath = " + contextPath);
		
		waconfig.add(new WebAppConfig(docBase, contextPath));
		
		String contextPathKeyPrefix = "context_path_";
		String docBaseKeyPrefix = "doc_base_";
		
		List<String> contextPathKeys = context.getPropertiesKey(contextPathKeyPrefix);
		
		for(String contextPathKey : contextPathKeys){
			
			String tail = contextPathKey.substring(13);
			String scontextPath = context.getProperty(contextPathKey);
			String sdocBase = context.getProperty(docBaseKeyPrefix+tail);
			sdocBase = getAbsoluteDocBaseDir(sdocBase);
			//docBase가 설정되지 않으면 기본 docbase 할당
			if(sdocBase == null) {
				sdocBase = docBase;
			}
			waconfig.add(new WebAppConfig(sdocBase, scontextPath));
		}
		
		return waconfig;
	}
	
	
	private String getAbsoluteDocBaseDir(String inputDocBaseDir){
		String docBaseDir = inputDocBaseDir;
		File f = new File(inputDocBaseDir);
		if(!f.isAbsolute()){
			String appDir = appContext.getContextDir();
			docBaseDir = appDir + inputDocBaseDir;
		}
		return docBaseDir;
	}
	
	private static class WebAppConfig {
		
		private String contextPath;
		
		private String docBase;
		
		public WebAppConfig(String docBase, String contextPath){
			this.contextPath = contextPath;
			this.docBase = docBase;
		}
		
		public String getContextPath() {
			return contextPath;
		}

		public String getDocBase() {
			return docBase;
		}

		@Override
		public String toString() {
			return "WebAppConfig [contextPath=" + contextPath + ", docBase="
					+ docBase + "]";
		}
	
	}
	*/
	
}
