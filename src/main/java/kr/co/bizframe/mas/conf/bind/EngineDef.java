package kr.co.bizframe.mas.conf.bind;

public class EngineDef {

	private String id;

	private boolean hotDeploy = false;
	
	private RoutingDef routing;

	private ApplicationsDef applications;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	
	public boolean isHotDeploy() {
		return hotDeploy;
	}

	public void setHotDeploy(boolean hotDeploy) {
		this.hotDeploy = hotDeploy;
	}

	public RoutingDef getRouting() {
		return routing;
	}

	public void setRouting(RoutingDef routing) {
		this.routing = routing;
	}

	public ApplicationsDef getApplications() {
		return applications;
	}

	public void setApplications(ApplicationsDef applications) {
		this.applications = applications;
	}

	@Override
	public String toString() {
		return "EngineDef [id=" + id + ", hotDeploy=" + hotDeploy + ", routing=" + routing + ", applications="
				+ applications + "]";
	}

	
}
