package kr.co.bizframe.mas.routing.impl.conf;

import java.util.ArrayList;
import java.util.List;

import org.jdom.Element;

public abstract class ConditionItem {

	private List<ConditionItem> nextConditionItems = new ArrayList<ConditionItem>();

	public void addConditionItem(ConditionItem item) {
		this.nextConditionItems.add(item);
	}

	public List<ConditionItem> getConditonItems() {
		return nextConditionItems;
	}

	@SuppressWarnings("unchecked")
	public void parse(Element ele) throws Exception {

		List<Element> headers = ele.getChildren("header");
		for (Element headerEle : headers) {
			if (headerEle != null) {
				Header header = new Header();
				header.parse(headerEle);
				addConditionItem(header);
			}
		}

		List<Element> ands = ele.getChildren("and");
		for (Element andEle : ands) {
			if (andEle != null) {
				And and = new And();
				and.parse(andEle);
				addConditionItem(and);
			}
		}

		List<Element> ors = ele.getChildren("or");
		for (Element orEle : ors) {
			if (orEle != null) {
				Or or = new Or();
				or.parse(orEle);
				addConditionItem(or);
			}
		}
	}

	@Override
	public String toString() {

		StringBuffer sb = new StringBuffer();
		for (ConditionItem item : nextConditionItems) {
			sb.append(item.toString());
		}
		return sb.toString();
	}

}
