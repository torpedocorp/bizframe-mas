package kr.co.bizframe.mas.routing.impl.conf;

import java.util.List;

import kr.co.bizframe.mas.routing.Message;
import kr.co.bizframe.mas.routing.impl.DefaultMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.jdom.Element;

public class Condition {

	private static Logger log = LoggerFactory.getLogger(Condition.class);

	private ConditionItem conditionItem;

	private boolean isDefault = false;

	public void parse(Element ele) throws Exception {

		String defaultValue = ele.getAttributeValue("default");
		if (defaultValue != null) {
			if ("true".equalsIgnoreCase(defaultValue)) {
				isDefault = true;
			}
		}

		if (!isDefault) {

			Element headerEle = ele.getChild("header");
			if (headerEle != null) {
				Header header = new Header();
				header.parse(headerEle);
				conditionItem = header;
			}

			Element andEle = ele.getChild("and");
			if (andEle != null) {
				And and = new And();
				and.parse(andEle);
				conditionItem = and;
			}

			Element orEle = ele.getChild("or");
			if (orEle != null) {
				Or or = new Or();
				or.parse(orEle);
				conditionItem = or;
			}
		}
	}

	public ConditionItem getConditionItem() {
		return conditionItem;
	}

	public boolean isDefault() {
		return isDefault;
	}

	public void setDefault(boolean isDefault) {
		this.isDefault = isDefault;
	}

	@Override
	public String toString() {
		return "Condition [conditionItem=" + conditionItem + ", isDefault="
				+ isDefault + "]";
	}

	public boolean isMatching(Message msg) {

		log.trace("isMatching");
		// default condition은 패스
		if (isDefault)
			return false;

		DefaultMessage dm = (DefaultMessage) msg;
		boolean result = false;
		log.trace("conditionItem type=" + conditionItem.getClass().getName());
		if (conditionItem instanceof Header) {
			result = isHeaderMatching((Header) conditionItem, dm);
			log.debug("isHeaderMatching result = " + result);
		} else if (conditionItem instanceof And) {
			result = isAndMatching((And) conditionItem, dm);
			log.debug("isAndMatching result = " + result);
		} else if (conditionItem instanceof Or) {
			result = isOrMatching((Or) conditionItem, dm);
			log.debug("isOrMatching result = " + result);
		}

		return result;
	}

	private boolean isHeaderMatching(Header header, DefaultMessage msg) {

		// log.trace("isHeaderMatching");
		String key = header.getKey();
		String value = header.getValue();

		String rv = msg.getHeader(key);
		log.debug("condition head key=[" + key + "], value=[" + value
				+ "], instance msg value=[" + rv + "]");

		if (rv != null && rv.equals(value)) {
			return true;
		}

		return false;
	}

	private boolean isAndMatching(And and, DefaultMessage msg) {

		// log.trace("isAndMatching");
		List<ConditionItem> conditionItems = and.getConditonItems();

		for (ConditionItem conditionItem : conditionItems) {

			if (conditionItem instanceof Header) {
				boolean bm = isHeaderMatching((Header) conditionItem, msg);
				if (!bm)
					return false;

			} else if (conditionItem instanceof And) {
				boolean bm = isAndMatching((And) conditionItem, msg);
				if (!bm)
					return false;

			} else if (conditionItem instanceof Or) {
				boolean bm = isOrMatching((Or) conditionItem, msg);
				if (!bm)
					return false;
			}
		}

		return true;
	}

	private boolean isOrMatching(Or or, DefaultMessage msg) {

		// log.trace("isOrMatching");
		List<ConditionItem> conditionItems = or.getConditonItems();

		for (ConditionItem conditionItem : conditionItems) {

			if (conditionItem instanceof Header) {
				boolean bm = isHeaderMatching((Header) conditionItem, msg);
				if (bm)
					return true;

			} else if (conditionItem instanceof And) {
				boolean bm = isAndMatching((And) conditionItem, msg);
				if (bm)
					return true;

			} else if (conditionItem instanceof Or) {
				boolean bm = isOrMatching((Or) conditionItem, msg);
				if (bm)
					return true;

			}

		}

		return false;
	}
}
