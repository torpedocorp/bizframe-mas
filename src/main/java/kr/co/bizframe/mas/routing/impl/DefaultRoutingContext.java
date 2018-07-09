package kr.co.bizframe.mas.routing.impl;

import java.util.ArrayList;
import java.util.List;

import kr.co.bizframe.mas.application.ApplicationContext;
import kr.co.bizframe.mas.routing.Exchange;
import kr.co.bizframe.mas.routing.RoutingContext;
import kr.co.bizframe.mas.routing.RoutingException;
import kr.co.bizframe.mas.routing.RoutingManager;
import kr.co.bizframe.mas.routing.impl.conf.RouteDef;
import kr.co.bizframe.mas.util.PropertyHolder;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DefaultRoutingContext extends PropertyHolder implements RoutingContext {

	private static Logger log = LoggerFactory.getLogger(DefaultRoutingContext.class);

	private RoutingManager routingManager;

	private ApplicationContext applicationContext;

	//private HashMap<String, String> properties = new HashMap<String, String>();

	private RouteDef routeDef;

	private List<String> routePath = new ArrayList<String>();

	public DefaultRoutingContext(ApplicationContext applicationContext,
			RoutingManager routingManager) {
		this.applicationContext = applicationContext;
		this.routingManager = routingManager;
	}

	public DefaultRoutingContext(DefaultRoutingManager routingManager) {
		this.routingManager = routingManager;
	}

	public void route(String applicationId, Exchange exchange)
			throws RoutingException {

		DefaultRoutingManager rm = (DefaultRoutingManager) routingManager;
		exchange.setRoutingContext(this);
		rm.route(this, applicationId, exchange);
	}

	public void route(Exchange exchange) throws RoutingException {

		DefaultRoutingManager rm = (DefaultRoutingManager) routingManager;
		exchange.setRoutingContext(this);
		rm.route(this, exchange);
	}

	public void setApplicationContext(ApplicationContext applicationContext) {
		this.applicationContext = applicationContext;
	}

	public void addRoutePath(String applicationId) {
		routePath.add(applicationId);
	}

	public List getRoutePath() {
		return routePath;
	}

	public RouteDef getRouteDef() {
		return routeDef;
	}

	public void setRouteDef(RouteDef routeDef) {
		this.routeDef = routeDef;
	}

	public ApplicationContext getApplicationContext() {
		return applicationContext;
	}

	/*
	public void setProperties(HashMap<String, String> properties) {
		this.properties = properties;
	}

	public void setProperty(String key, String value) {
		properties.put(key, value);
	}

	public String getProperty(String key) {
		return properties.get(key);
	}
	*/

}
