package kr.co.bizframe.mas.web;

import java.util.ArrayList;
import java.util.List;

import kr.co.bizframe.mas.Application;
import kr.co.bizframe.mas.Serviceable;
import kr.co.bizframe.mas.application.ApplicationContext;
import kr.co.bizframe.mas.application.ApplicationContextUtils;
import kr.co.bizframe.mas.application.ApplicationException;
import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventorFactory;
import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventorListener;
import kr.co.bizframe.mas.util.leak.cleanup.ShutdownHookCleanUp;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.eclipse.jetty.server.Connector;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.SessionIdManager;
import org.eclipse.jetty.server.handler.ContextHandlerCollection;
import org.eclipse.jetty.server.nio.SelectChannelConnector;
import org.eclipse.jetty.server.ssl.SslSelectChannelConnector;
import org.eclipse.jetty.util.ssl.SslContextFactory;
//import org.eclipse.jetty.util.preventers.AppContextLeakPreventer;
//import org.eclipse.jetty.util.preventers.DriverManagerLeakPreventer;
import org.eclipse.jetty.webapp.WebAppContext;

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
	
			Connector connector = createConnector(context);
			
			jettyServer.setConnectors(new Connector[] { connector });
			
			List<WebAppConfig> waconfigs = getWebAppConfig(context);
		
			for(WebAppConfig waconfig : waconfigs){
			
				log.info("webapp config = " + waconfig);
				WebAppContext webapp = new WebAppContext();
				webapp.setAttribute("applicationContext", context);
				webapp.setContextPath(waconfig.getContextPath());
				webapp.setResourceBase(waconfig.getDocBase());
			
				// static file locking 해제 
				// 기본 false
				boolean useFileMapperedBuffer = context.getBooleanProperty("use_filemappered_buffer", false);
				log.debug("use fileMapperedBuffer = "+ useFileMapperedBuffer);
				if (!useFileMapperedBuffer) {
					webapp.getInitParams().put("useFileMappedBuffer", "false"); 
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
			
			
			for(WebAppContext webapp :webappContexts){
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
			log.error(t.getMessage(), t);
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
			log.error(e.getMessage(), e);
		}
	}

	public void stop() throws Exception {

		try {
		
			jettyServer.stop();
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
	}

	public void destroy(ApplicationContext context) throws ApplicationException {

		if (jettyServer != null) {

			try {
		
				//webapp.destroy();
				jettyServer.destroy();
			
				if(enableLeakPreventor){
					for(ClassLoaderLeakPreventor classLoaderLeakPreventor : classLoaderLeakPreventors){
						classLoaderLeakPreventor.runCleanUps();
					}
				}
				
			} catch (Throwable t) {
				log.error(t.getMessage(), t);
			}
		}
	}
	
	
	private Connector createConnector(ApplicationContext context){
		
		boolean https = context.getBooleanProperty("https", false);
		int port = context.getIntProperty("port");
		log.debug("port = " + port);
		
		Connector connector = null;
		if(https){
			
			String keystoreFile = context.getProperty("keystoreFile");
			String keystorePass = context.getProperty("keystorePass");
			String truststoreFile = context.getProperty("truststoreFile");
			String truststorePass = context.getProperty("truststorePass");
	     
			SslSelectChannelConnector sslConnector = new SslSelectChannelConnector();
	     	sslConnector.setPort(port);
	        SslContextFactory cf = sslConnector.getSslContextFactory();
	        if(keystoreFile != null) cf.setKeyStorePath(keystoreFile);
	        if(keystorePass != null) cf.setKeyStorePassword(keystorePass);
	        if(truststoreFile != null) cf.setTrustStore(truststoreFile);
	        if(truststorePass != null) cf.setTrustStorePassword(truststorePass);
	        return sslConnector;
		}else{
			
			connector = new SelectChannelConnector();
			connector.setPort(port);
			return connector;
		}
	
	}
	
	
	private List<WebAppConfig> getWebAppConfig(ApplicationContext context){
		
		List<WebAppConfig> waconfig = new ArrayList<WebAppConfig>();
		// docBase 는 기본 /web 디렉토로로 하고 doc_base 설정시 설정 디렉터리로 함..
		// docBase 항상 상대경로로만 함..
		String docBase = context.getProperty("doc_base");
		if (docBase == null) {
			docBase = context.getContextDir() + "/web";
		}
		
		String contextPath = context.getProperty("context_path");
		//log.debug("contextPath = " + contextPath);

		waconfig.add(new WebAppConfig(docBase, contextPath));
		
		String contextPathKeyPrefix = "context_path_";
		String docBaseKeyPrefix = "doc_base_";
		
		List<String> contextPathKeys = context.getPropertiesKey(contextPathKeyPrefix);
		
		for(String contextPathKey : contextPathKeys){
			
			String tail = contextPathKey.substring(13);
			String scontextPath = context.getProperty(contextPathKey);
			String sdocBase = context.getProperty(docBaseKeyPrefix+tail);
			
			//docBase가 설정되지 않으면 기본 docbase 할당
			if(sdocBase == null) {
				sdocBase = docBase;
			}
			waconfig.add(new WebAppConfig(sdocBase, scontextPath));
			
		}
		
		return waconfig;
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
	
}
