package kr.co.bizframe.mas.routing.impl.conf;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import kr.co.bizframe.mas.command.model.RouteInfo;
import kr.co.bizframe.mas.util.XMLUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.jdom.Element;

public class RouteConfig {

	private static Logger log = LoggerFactory.getLogger(RouteConfig.class);

	private static List<RouteDef> routes = new ArrayList<RouteDef>();

	public final static String routeConfFile = "route-conf.xml";

	public static void init() throws Exception {

		log.info(" RouteConfig initialize..");
		File file;
		URL url = RouteConfig.class.getResource("/" + routeConfFile);
		log.info(" RouteConfig file=" + url.toString());
		try {
			if (url == null)
				throw new Exception("file=" + routeConfFile);
			file = new File(url.getFile());
			parse(file);
		} catch (Exception e) {
			throw e;
		}
	}

	private static void parse(File confFile) throws Exception {
		try {
			Element routeConfEle = XMLUtil.getRootElement(confFile);

			List routeList = routeConfEle.getChildren("route");
			for (int ii = 0; ii < routeList.size(); ii++) {

				RouteDef routeDef = new RouteDef();
				Element routeEle = (Element) routeList.get(ii);
				routeDef.parse(routeEle);

				String routeId = routeDef.getId();
				log.debug("add route id=[" + routeId + "], route =" + routeDef);
				routes.add(routeDef);
			}

			checkValidity();
		} catch (Exception e) {
			throw e;
		}
	}

	private static void checkValidity() throws Exception {

		Set<String> appIdSet = new HashSet<String>();
		for (RouteDef routeDef : routes) {

			List<RouteItem> items = routeDef.getItems();
			RouteItem item = items.get(0);
			if (!(item instanceof Application)) {
				throw new Exception("first route item should be Application.");
			}

			Application application = (Application) item;
			String appId = application.getId();

			if (appIdSet.contains(appId)) {
				throw new Exception("route for first cmp id=[" + appId
						+ "] found other route.!");
			}

			appIdSet.add(appId);

		}

	}

	public static RouteDef findRoute(String initAppId) {
		if (initAppId == null) {
			return null;
		}
		
		log.debug("findRoute : " + routes);
		for (RouteDef routeDef : routes) {			
			for(RouteItem item : routeDef.getItems()) {
				Application cmp = (Application) item;
				String cmpId = cmp.getId();				
				if (initAppId.equals(cmpId)) {
					return routeDef;
				}
			}						
		}
		return null;
	}
	
	// test ........
	public static List<RouteInfo> getRouteDef() {

		List<RouteInfo> routeInfos = new ArrayList();
		log.debug("");
		log.debug("getRouteDef");
		int routeHop = 0;
		for (RouteDef routeDef : routes) {
			RouteInfo routeInfo = new RouteInfo();

			routeHop = 0;
			List<RouteItem> items = routeDef.getItems();
			log.debug("route id : " + routeDef.getId());
			for(RouteItem item: items) {
				if(item instanceof Application) {
					Application cmp = (Application) item;
					log.debug("getRouteDef ... cmpId:"+cmp.getId());
					routeHop++;
					
					routeInfo.addAppId(cmp.getId());
					
					if(routeHop==1)
						routeInfo.setInitAppId(cmp.getId());
				}
			}
			routeInfo.setId(routeDef.getId());
			routeInfo.setName(routeDef.getName());
			routeInfo.setRouteHop(routeHop);
			
			if(routeHop > 1)
				routeInfo.setRouteType("MULTI");
			else
				routeInfo.setRouteType("SINGLE");
			
			routeInfo.setDescription("echo service(??)");
			// TODO 추가 기능?
			routeInfo.setStatus("VALID");
			
			routeInfos.add(routeInfo);
		}
		return routeInfos;
	}

}
