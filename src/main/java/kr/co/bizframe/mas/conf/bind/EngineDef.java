package kr.co.bizframe.mas.conf.bind;

public class EngineDef {

	private String id;

	private RoutingDef routing;

	private ApplicationsDef applications;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
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
		return "EngineDef [applications=" + applications + ", id=" + id
				+ ", routing=" + routing + "]";
	}

}
