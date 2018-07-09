package kr.co.bizframe.mas.routing.impl.conf;

import java.util.ArrayList;
import java.util.List;

import org.jdom.Element;

public class ContentBasedRoute implements RouteItem {

	private List<Path> paths = new ArrayList<Path>();

	private Path defaultPath;

	public Element toElement() throws Exception {
		return null;
	}

	public void parse(Element ele) throws Exception {

		List pathEles = ele.getChildren();

		for (int ii = 0; ii < pathEles.size(); ii++) {

			Element pathEle = (Element) pathEles.get(ii);
			Path path = new Path();
			path.parse(pathEle);

			if (path.getCondition().isDefault()) {
				if (defaultPath == null) {
					defaultPath = path;
				} else {
					throw new Exception("default path is already assigned");
				}
			}

			addPath(path);
		}

		validate();
	}

	public void addPath(Path path) {
		paths.add(path);
	}

	public List<Path> getPaths() {
		return paths;
	}

	public Path getDefaultPath() {
		return defaultPath;
	}

	private void validate() throws Exception {

	}

	@Override
	public String toString() {
		return "ContentBasedRoute [paths=" + paths + "]";
	}

}
