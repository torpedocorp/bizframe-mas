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

import org.apache.catalina.Context;
import org.apache.catalina.LifecycleState;
import org.apache.catalina.Service;
import org.apache.catalina.connector.Connector;
import org.apache.catalina.startup.Tomcat;
import org.apache.tomcat.util.scan.StandardJarScanner;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.bizframe.mas.Application;
import kr.co.bizframe.mas.Serviceable;
import kr.co.bizframe.mas.application.ApplicationContext;
import kr.co.bizframe.mas.application.ApplicationException;
import kr.co.bizframe.mas.web.WebAppConfigs.WebAppConfig;



public class TomcatApplication implements Serviceable, Application {

	private static Logger log = LoggerFactory.getLogger(JettyApplication.class);

	private Tomcat tomcat;

	private List<Context> tomcatContexts;
	
	private String DEFAULT_TMP = "/tmp/tomcat";
	
	public void init(ApplicationContext context) throws ApplicationException {
		
		tomcat = new Tomcat();
		// 임시 작업 디렉토리 설정
		tomcat.setBaseDir(context.getHomeDir() + DEFAULT_TMP + "/" + context.getId());
		
		Service service = tomcat.getService();
		service.addConnector(createConnector(context));
		service.setParentClassLoader(context.getClassLoader());
		
		List<WebAppConfig> waconfigs = WebAppConfigs.getWebAppConfigs(context);
		tomcatContexts = new ArrayList<Context>();
		for(WebAppConfig waconfig : waconfigs){
			try{
				Context tomcatContext = tomcat.addWebapp(waconfig.getContextPath(), 
						waconfig.getDocBase());
				
				//////////////////////////////////////
				// jna.jar 등 extend에서  이상 작동으로 
				// 인해서 설정함.  좀더  연구 필요
				///////////////////////////////////////
				StandardJarScanner scanner = (StandardJarScanner) tomcatContext.getJarScanner();
				scanner.setScanBootstrapClassPath(false);
				scanner.setScanClassPath(false);
				
				tomcatContext.setParentClassLoader(context.getClassLoader());
				tomcatContexts.add(tomcatContext);
			}catch(Exception e){
				throw new ApplicationException(e.getMessage(), e);
			}
		}
	
	}

	
	public void start() throws Exception {
		tomcat.start();
		
		for(Context context : tomcatContexts){
			LifecycleState ls = context.getState();
			if(ls != LifecycleState.STARTED){
				throw new ApplicationException("tomcat context ="+context.getName() +" did not started");
			}
		}
		
	}

	
	public void stop() throws Exception {
		tomcat.stop();
	}	

	
	public void destroy(ApplicationContext context) throws ApplicationException {
		try{
			tomcat.destroy();
		}catch(Exception e){
			throw new ApplicationException(e.getMessage(), e);
		}
	}

	
	private Connector createConnector(ApplicationContext context) {

		boolean https = context.getBooleanProperty("https", false);
		int port = context.getIntProperty("port");
		log.debug("port = " + port);

		Connector connector = new Connector();
		connector.setPort(port);
		connector.setAttribute("protocol", "HTTP/1.1");
		connector.setAttribute("maxThreads", "200");
		
		//connector.setAttribute("protocol", "org.apache.coyote.http11.Http11AprProtocol");

		
		if (https) {
			connector.setSecure(true);
			connector.setScheme("https");
			connector.setAttribute("SSLEnabled", true);
			
			String keystoreFile = context.getProperty("keystoreFile");
			String keystorePass = context.getProperty("keystorePass");
			String truststoreFile = context.getProperty("truststoreFile");
			String truststorePass = context.getProperty("truststorePass");
			boolean clientAuth = context.getBooleanProperty("clientAuth", false);
			
			connector.setAttribute("keyAlias", "tomcat");
			connector.setAttribute("keystoreType", "JKS");
			connector.setAttribute("keystoreFile", keystoreFile);
			connector.setAttribute("keystorePass", keystorePass);
			connector.setAttribute("truststoreFile", truststoreFile);
			connector.setAttribute("truststorePass", truststorePass);
			
			connector.setAttribute("clientAuth", clientAuth);
			connector.setAttribute("sslProtocol", "TLS");
		}
		return connector;

	}


}
