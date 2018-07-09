package kr.co.bizframe.mas.conf.bind;

import java.util.ArrayList;
import java.util.List;

public class ApplicationsDef {

	private String baseDir;

	private List<Application> apps = new ArrayList<Application>();

	public String getBaseDir() {
		return baseDir;
	}

	public void setBaseDir(String base) {
		this.baseDir = baseDir;
	}

	public void add(Application app) {
		apps.add(app);
	}

	public List<Application> getList() {
		return apps;
	}

	@Override
	public String toString() {
		return "ApplicationsDef [apps=" + apps + ", baseDir=" + baseDir + "]";
	}

}
