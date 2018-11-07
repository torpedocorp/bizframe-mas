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

package kr.co.bizframe.mas.conf;

import java.io.File;
import java.net.URL;
import java.util.List;

import kr.co.bizframe.mas.conf.bind.Application;
import kr.co.bizframe.mas.conf.bind.ApplicationsDef;
import kr.co.bizframe.mas.conf.bind.EngineDef;
import kr.co.bizframe.mas.conf.bind.RoutingDef;
import kr.co.bizframe.mas.conf.bind.ServerDef;
import kr.co.bizframe.mas.util.PropertyUtil;
import kr.co.bizframe.mas.util.XMLUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.jdom.Element;

/**
 * 
 * @author Young-jun Bae
 * 
 */
public class MasConfig {

	private static Logger log = LoggerFactory.getLogger(MasConfig.class);

	public final static String MAS_CONF_FILE = "mas-conf.xml";
	
	public static int DEFAULT_SERVER_PORT = 9004;
	
	public static int DEFAULT_SERVER_TIMEOUT = 10000;

	public static ServerDef server;

	public static void init() throws Exception {

		log.info("MasConfig initialize..");
		File file;
		try {
			URL url = MasConfig.class.getResource("/" + MAS_CONF_FILE);
			log.info("MasConfig file=" + url.toString());
			file = new File(url.getFile());
			parse(file);
		} catch (Exception e) {
			throw e;
		}
	}

	public static ServerDef getServer() {
		return server;
	}
	
	private static void parse(File confFile) throws Exception {
		try {
			server = new ServerDef();

			Element masConfEle = XMLUtil.getRootElement(confFile);

			// ////////////////////////////////////////////////////////
			// server conf
			// ///////////////////////////////////////////////////////
			Element serverEle = masConfEle.getChild("server");
			String id = XMLUtil.getAttribute("id", serverEle);
			String sport = XMLUtil.getAttribute("port", serverEle);
			int port = PropertyUtil.getInt(sport, DEFAULT_SERVER_PORT);
			server.setId(id);
			// mykim 2018.08.28
			System.setProperty("mas.id", id);

			server.setPort(port);
			server.setTimeout(DEFAULT_SERVER_TIMEOUT);
			Element engineEle = serverEle.getChild("engine");
			String shotDeploy = XMLUtil.getAttribute("hot-deploy", engineEle);
			boolean hotDeploy = PropertyUtil.getBooleanProperty(shotDeploy, false);
			
			EngineDef engine = new EngineDef();
			engine.setHotDeploy(hotDeploy);
			
			server.setEngine(engine);

			// ////////////////////////////////////////////////////////
			// routing conf (optional)
			// ///////////////////////////////////////////////////////
			Element routingEle = engineEle.getChild("routing");
			if (routingEle != null) {
				String senable = XMLUtil.getAttribute("enable", routingEle);
				boolean routingEnable = PropertyUtil.getBooleanProperty(senable, false);
				String routingClassName = XMLUtil.getAttribute("class-name", routingEle);

				RoutingDef routing = new RoutingDef();
				routing.setEnable(routingEnable);
				routing.setClassName(routingClassName);
 
				engine.setRouting(routing);
			}
			// ////////////////////////////////////////////////////////
			// applications conf (optional)
			// ///////////////////////////////////////////////////////
			Element applicationsEle = engineEle.getChild("applications");
			if (applicationsEle != null) {
				ApplicationsDef applications = new ApplicationsDef();
				String base = XMLUtil.getAttribute("base-dir", applicationsEle);
				applications.setBaseDir(base);

				List applicationEles = applicationsEle.getChildren("application");
				for (int ii = 0; ii < applicationEles.size(); ii++) {

					Element applicationEle = (Element) applicationEles.get(ii);
					String contextPath = XMLUtil.getAttribute("context-path", applicationEle);
					Application application = new Application();
					application.setContextPath(contextPath);
					applications.add(application);
				}
				engine.setApplications(applications);
			}
			log.trace(server.toString());

		} catch (Exception e) {
			throw e;
		}
	}

}
