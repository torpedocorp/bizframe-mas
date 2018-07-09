package kr.co.bizframe.mas.routing;

import kr.co.bizframe.mas.core.MasEngine;

public abstract class AbstractRoutingManager implements RoutingManager {

	protected Status status = Status.SHUTDOWNED;

	protected MasEngine engine;

	protected enum Status {

		SHUTDOWNED, SHUTDOWNING, STARTED, STARTING, FAILED

	}

	public AbstractRoutingManager(MasEngine engine) {
		this.engine = engine;
	}

	public Status getStatus() {
		return status;
	}

}
