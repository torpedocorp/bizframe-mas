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
