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

public class ApplicationDefInfo implements Serializable{

	private static final long serialVersionUID = -6816176400575038755L;

	private String id;

	private String name;

	private boolean autoStart = true;

	private int loadSequence = 0;

	private String contextDir;

	private String loadClass;

	private boolean parentOnlyClassLoader;

	private boolean parentFirstClassLoader;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean isAutoStart() {
		return autoStart;
	}

	public void setAutoStart(boolean autoStart) {
		this.autoStart = autoStart;
	}

	public int getLoadSequence() {
		return loadSequence;
	}

	public void setLoadSequencey(int sequence) {
		this.loadSequence = sequence;
	}

	public String getContextDir() {
		return contextDir;
	}

	public void setContextDir(String contextDir) {
		this.contextDir = contextDir;
	}

	public String getLoadClass() {
		return loadClass;
	}

	public void setLoadClass(String loadClass) {
		this.loadClass = loadClass;
	}

	public boolean isParentOnlyClassLoader() {
		return parentOnlyClassLoader;
	}

	public void setParentOnlyClassLoader(boolean parentOnlyClassLoader) {
		this.parentOnlyClassLoader = parentOnlyClassLoader;
	}

	public boolean isParentFirstClassLoader() {
		return parentFirstClassLoader;
	}

	public void setParentFirstClassLoader(boolean parentFirstClassLoader) {
		this.parentFirstClassLoader = parentFirstClassLoader;
	}

	@Override
	public String toString() {
		return "ApplicationDefInfo [id=" + id + ", name=" + name
				+ ", autoStart=" + autoStart + ", loadSequence=" + loadSequence
				+ ", contextDir=" + contextDir + ", loadClass=" + loadClass
				+ ", parentOnlyClassLoader=" + parentOnlyClassLoader
				+ ", parentFirstClassLoader=" + parentFirstClassLoader + "]";
	}

	
}
