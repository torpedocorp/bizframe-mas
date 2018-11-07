/*
 * Copyright 2018 Torpedo corp.
 *  
 * bizframe mas project licenses this file to you under the Apache License,
 * version 2.0 (the "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at:
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */


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
