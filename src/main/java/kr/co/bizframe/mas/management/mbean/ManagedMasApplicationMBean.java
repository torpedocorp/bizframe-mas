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

package kr.co.bizframe.mas.management.mbean;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface ManagedMasApplicationMBean {
	
	public String getName();
	
	public Date getInitTime();
	
	public Date getStartTime();
	
	public Date getStopTime();
	
	public String getStatus();
	
	public boolean getServiceable();
	
	public String getApplicationType();

	public String getSubManagementInfos();
	
	public Map<String, String> getParameters();
	
	public String getApplicationPath();
	
	public int getLoadSequence();
	
	public void start() throws Exception;
	
	public void stop() throws Exception;
	
	public void undeploy() throws Exception;
	
	public void deploy() throws Exception;
	
}
