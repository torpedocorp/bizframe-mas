package kr.co.bizframe.mas.routing.impl.conf;

import java.util.ArrayList;
import java.util.List;

import org.jdom.Element;

public class RouteDef {

	private String id;
	private String name;

	private List<RouteItem> items = new ArrayList<RouteItem>();

	public RouteDef() {

	}

	public void parse(Element ele) throws Exception {

		String id = ele.getAttributeValue("id");
		this.id = id;
		String name = ele.getAttributeValue("name");
		this.name = name;

		List routeItemList = ele.getChildren();
		for (int ii = 0; ii < routeItemList.size(); ii++) {

			RouteItem routeItem = null;
			Element routeItemEle = (Element) routeItemList.get(ii);
			String routeItemName = routeItemEle.getName();
			if ("application".equals(routeItemName)) {
				Application application = new Application();
				application.parse(routeItemEle);
				routeItem = application;

			} else if ("content-based-route".equals(routeItemName)) {

				ContentBasedRoute cbRoute = new ContentBasedRoute();
				cbRoute.parse(routeItemEle);
				routeItem = cbRoute;
			} else {
				throw new Exception("invalid route Item element=[" + routeItemName + "].");
			}
			items.add(routeItem);
		}

	}

	public Element toElement() throws Exception {
		return null;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void addItem(RouteItem item) {
		items.add(item);
	}

	public List<RouteItem> getItems() {
		return items;
	}

	@Override
	public String toString() {
		return "RouteDef [id=" + id + ", name=" + name + ",items=" + items + "]";
	}

}
