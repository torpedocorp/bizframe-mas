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


package kr.co.bizframe.mas.command.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class RouteInfo implements Serializable {

	private static final long serialVersionUID = -8966576368034240592L;

	private String id;

	private String name;

	private String initAppId;

	private String routeType;

	private int routeHop;

	private String description;

	private String status;

	private List<String> appIds = new ArrayList<String>();

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getInitAppId() {
		return initAppId;
	}

	public void setInitAppId(String initAppId) {
		this.initAppId = initAppId;
	}

	public String getRouteType() {
		return routeType;
	}

	public void setRouteType(String routeType) {
		this.routeType = routeType;
	}

	public int getRouteHop() {
		return routeHop;
	}

	public void setRouteHop(int routeHop) {
		this.routeHop = routeHop;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public void addAppId(String appId) {
		appIds.add(appId);
	}

	public List<String> getAppIds() {
		return appIds;
	}

	@Override
	public String toString() {
		return "RoutingInfo [id=" + id + ", initAppId=" + initAppId + ", routeType=" + routeType + ", routeHop=" + routeHop + ", status=" + status + "]";
	}
}
