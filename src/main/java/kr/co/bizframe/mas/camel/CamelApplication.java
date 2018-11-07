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


package kr.co.bizframe.mas.camel;

import java.util.List;
import java.util.concurrent.TimeUnit;

import org.apache.camel.CamelContext;
import org.apache.camel.spi.ShutdownStrategy;
import org.apache.camel.spring.Main;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.AbstractApplicationContext;

import kr.co.bizframe.mas.Application;
import kr.co.bizframe.mas.Serviceable;
import kr.co.bizframe.mas.application.ApplicationContext;
import kr.co.bizframe.mas.application.ApplicationException;

public class CamelApplication implements Application, Serviceable {
	
	private static Logger log = LoggerFactory.getLogger(CamelApplication.class);

	private ApplicationContext appContext;
	
	private Main main;

	public void init(ApplicationContext context) throws ApplicationException{
		
		this.appContext  = context;
		log.info("init camel servcie app");
		log.info("props = " + context.getProperties());
		try{
			String routeConfigFile = context.getProperty("route_xml_file");
			
			String routeXml = "camel-route.xml";
			if(routeConfigFile != null){
				routeXml = routeConfigFile;
			}
	    	main = new Main();
			main.setApplicationContextUri(routeXml);
	
		}catch(Throwable t){
			throw new ApplicationException(t.getMessage(), t);
		}
	}
	
	public void destroy(ApplicationContext context)  throws ApplicationException{
		log.info("destory camel service app");
		try{
			if(!main.isStopped()){
				main.stop();
			}
			main.shutdown();
		}catch(Throwable t){
			throw new ApplicationException(t.getMessage(), t);
		}
	}
	
	
	public void start() throws Exception {
		log.info("start camel service app");
		try{
			AbstractApplicationContext context = main.getApplicationContext();
			if(context != null){
				context.refresh();
			}
			
			// 재기동시 CamelContext가 사라지지 않음 - Main의 버그 같음.
			List<CamelContext> contexts = main.getCamelContexts();
			if(contexts != null) contexts.clear();
			
			main.start();
			
			setupCamelContext();
			
		}catch(Throwable t){
			throw new Exception(t.getMessage(), t);
		}
		//getCamelContexts();
	}
	
	
	
	private void setupCamelContext(){
		//camel context inflight exchange shutdown timeout -> default 5 second 
		for(CamelContext camelContext : getCamelContexts()){
			
			int shutdownTimeout = appContext.getIntProperty("shutdown_timeout", 5);
			ShutdownStrategy shutdownStrategy = camelContext.getShutdownStrategy();
			shutdownStrategy.setTimeUnit(TimeUnit.SECONDS);
			shutdownStrategy.setTimeout(shutdownTimeout);
		}
	}
	
	
	public void stop() throws Exception{
		log.info("stop camel service app");		
		try{
			main.stop();
		}catch(Throwable t){
			throw new Exception(t.getMessage(), t);
		}
	}
	

	public List<CamelContext> getCamelContexts(){
		List<CamelContext> contexts = main.getCamelContexts();
		return contexts;
	}
}
