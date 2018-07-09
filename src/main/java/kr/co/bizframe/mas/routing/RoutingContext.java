package kr.co.bizframe.mas.routing;

import java.util.HashMap;

public interface RoutingContext {

	public String getProperty(String key);

	public void setProperty(String key, String value);

	public void setProperties(HashMap<String, String> properties);

	public void route(String applicationId, Exchange exchange)
			throws RoutingException;

	public void route(Exchange exchange) throws RoutingException;

}
