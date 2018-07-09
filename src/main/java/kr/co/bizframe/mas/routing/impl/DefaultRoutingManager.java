package kr.co.bizframe.mas.routing.impl;

import java.util.List;

import kr.co.bizframe.mas.Application;
import kr.co.bizframe.mas.Routable;
import kr.co.bizframe.mas.application.ApplicationContext;
import kr.co.bizframe.mas.core.MasEngine;
import kr.co.bizframe.mas.routing.AbstractRoutingManager;
import kr.co.bizframe.mas.routing.Exchange;
import kr.co.bizframe.mas.routing.Message;
import kr.co.bizframe.mas.routing.RoutingException;
import kr.co.bizframe.mas.routing.impl.conf.Condition;
import kr.co.bizframe.mas.routing.impl.conf.ContentBasedRoute;
import kr.co.bizframe.mas.routing.impl.conf.Path;
import kr.co.bizframe.mas.routing.impl.conf.RouteConfig;
import kr.co.bizframe.mas.routing.impl.conf.RouteDef;
import kr.co.bizframe.mas.routing.impl.conf.RouteItem;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DefaultRoutingManager extends AbstractRoutingManager {

	private static Logger log = LoggerFactory.getLogger(MasEngine.class);

	public DefaultRoutingManager(MasEngine engine) {
		super(engine);
	}

	public void startup() throws Exception {

		if (status == Status.SHUTDOWNED || status == Status.FAILED) {
			status = Status.STARTING;
		} else {
			String errorMsg = "cannot start routing engine : engine status=["
					+ status + "]";
			log.error(errorMsg);
			throw new Exception(errorMsg);
		}

		try {
			RouteConfig.init();
			status = Status.STARTED;
		} catch (Exception e) {
			status = Status.FAILED;
			log.error(e.getMessage(), e);
		}
	}

	public void shutdown() throws Exception {

		if (status == Status.STARTED || status == Status.FAILED) {
			status = Status.SHUTDOWNING;
		} else {
			log.error("cannot shutdown routing engine : engine status=["
					+ status + "]");
			return;
		}

		status = Status.SHUTDOWNED;
	}

	public void route(DefaultRoutingContext routingContext, String applicationId, Exchange exchange) throws RoutingException {
		checkEngineStatus();
		ApplicationContext applicationContext = routingContext.getApplicationContext();
		executeRoute(routingContext, applicationId, exchange);
	}

	public void route(DefaultRoutingContext routingContext, Exchange exchange) throws RoutingException {

		checkEngineStatus();
		ApplicationContext applicationContext = routingContext.getApplicationContext();
		String initAppId = applicationContext.getId();
		log.debug("==========================================");
		log.debug("route manager : route");
		log.debug("init application id= [" + initAppId + "]");
		log.debug("==========================================");

		List<String> routePath = routingContext.getRoutePath();
		RouteDef routeDef = routingContext.getRouteDef();

		if (routeDef == null) {
			routeDef = RouteConfig.findRoute(initAppId);
			if (routeDef == null) {
				throw new RoutingException("route definition is not found for init " + "route application id=[" + initAppId + "]");
			}
			List<RouteItem> routeItems = routeDef.getItems();
			log.info("find route id=[" + routeDef.getId() + "], route name=[" + routeDef.getName() + "], routeItem step=" + routeItems.size());
			routingContext.setRouteDef(routeDef);
		}

		List<RouteItem> routeItems = routeDef.getItems();
		int step = routePath.size();

		for (int ii = 1; ii < routeItems.size(); ii++) {
			RouteItem routeItem = routeItems.get(ii);
			// log.debug("route item = " + routeItem.getClass().getName());

			if (routeItem instanceof kr.co.bizframe.mas.routing.impl.conf.Application) {

				executeRoute(routingContext, (kr.co.bizframe.mas.routing.impl.conf.Application) routeItem, exchange);

			} else if (routeItem instanceof kr.co.bizframe.mas.routing.impl.conf.ContentBasedRoute) {

				routeByContentBased(routingContext, (ContentBasedRoute) routeItem, exchange);

			} else {
				throw new RoutingException("invaild routeItem");
			}

		}

	}

	private void checkEngineStatus() throws RoutingException {

		if (status == Status.STARTED) {
			return;
		}

		if (status == Status.STARTING) {

			while (!(status == Status.STARTED)) {

				if (status == Status.STARTED) {
					return;
				}
				log.warn("wait for routing engine started.");
				try {
					Thread.sleep(500);
				} catch (Exception e) {
					throw new RoutingException(e.getMessage(), e);
				}
			}
		}

		if ((status == Status.FAILED) || (status == Status.SHUTDOWNED)
				|| (status == Status.SHUTDOWNING)) {
			throw new RoutingException(
					"routing engine cannot not accept routing message."
							+ " routing engine status=[" + status + "]");
		}
	}

	private void executeRoute(DefaultRoutingContext routingContext, String applicationId, Exchange exchange) throws RoutingException {
		log.trace("executeRoute routing app id = [" + applicationId + "]");
		Application appObj = engine.getApplicationManager().lookup(applicationId);

		if (appObj == null) {
			throw new RoutingException("route application object is null.");
		}

		// System.out.println("routing app = " + appObj.getClass().getName());
		if (!(appObj instanceof Routable)) {
			throw new RoutingException(applicationId + "," + appObj + " routing application cannot receive message.");
		}

		try {
			Routable mapp = (Routable) appObj;
			mapp.onMessage(exchange);
		} catch (Throwable t) {
			throw new RoutingException(t.getMessage(), t);
		}

	}

	private void executeRoute(DefaultRoutingContext routingContext,
			kr.co.bizframe.mas.routing.impl.conf.Application application,
			Exchange exchange) throws RoutingException {

		String appId = application.getId();
		routingContext.setProperties(application.getProperties());
		executeRoute(routingContext, appId, exchange);
	}

	private void routeByContentBased(DefaultRoutingContext routingContext,
			ContentBasedRoute cbRoute, Exchange exchange)
			throws RoutingException {

		log.trace("route by contentBased.");
		// ///////////////////////////////////////
		// request message로 route 판단
		// //////////////////////////////////////
		Message req = exchange.getRequest();

		List<Path> paths = cbRoute.getPaths();
		Path selectedPath = null;

		// msg 값에 따른 condition 구함.
		for (Path path : paths) {

			Condition condition = path.getCondition();
			boolean result = condition.isMatching(req);
			if (result) {
				selectedPath = path;
				break;
			}
		}

		// default path
		if (selectedPath == null) {
			selectedPath = cbRoute.getDefaultPath();
		}

		if (selectedPath == null) {
			log.error("routing error message = " + req);
			throw new RoutingException("selected path is null.");
		}

		log.debug("selected routing path = " + selectedPath);
		kr.co.bizframe.mas.routing.impl.conf.Application application = selectedPath
				.getApplication();
		executeRoute(routingContext, application, exchange);

	}

}
