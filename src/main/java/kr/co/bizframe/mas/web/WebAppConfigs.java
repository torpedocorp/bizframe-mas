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

package kr.co.bizframe.mas.web;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.bizframe.mas.application.ApplicationContext;


public class WebAppConfigs {

	private static Logger log = LoggerFactory.getLogger(WebAppConfigs.class);

	
	public static List<WebAppConfig> getWebAppConfigs(ApplicationContext context){

		List<WebAppConfig> waconfigs = new ArrayList<WebAppConfig>();
		// docBase 는 기본 /web 디렉토로로 하고 doc_base 설정시 설정 디렉터리로 함..
		// docBase 항상 상대경로로만 함..
		String docBase = context.getProperty("doc_base");
		if (docBase == null) {
			docBase = context.getContextDir() + "/web";
		}
		docBase = getAbsoluteDocBaseDir(context, docBase);
		String contextPath = context.getProperty("context_path");
		log.debug("contextPath = " + contextPath);
		
		waconfigs.add(new WebAppConfig(docBase, contextPath));
		
		String contextPathKeyPrefix = "context_path_";
		String docBaseKeyPrefix = "doc_base_";
		
		List<String> contextPathKeys = context.getPropertiesKey(contextPathKeyPrefix);
		
		for(String contextPathKey : contextPathKeys){
			
			String tail = contextPathKey.substring(13);
			String scontextPath = context.getProperty(contextPathKey);
			String sdocBase = context.getProperty(docBaseKeyPrefix+tail);
			sdocBase = getAbsoluteDocBaseDir(context, sdocBase);
			//docBase가 설정되지 않으면 기본 docbase 할당
			if(sdocBase == null) {
				sdocBase = docBase;
			}
			waconfigs.add(new WebAppConfig(sdocBase, scontextPath));
		}		
		return waconfigs;
	}
	
	
	
	public static class WebAppConfig {
		
		private String contextPath;
		
		private String docBase;
		
		public WebAppConfig(String docBase, String contextPath){
			this.contextPath = contextPath;
			this.docBase = docBase;
		}
		
		public String getContextPath() {
			return contextPath;
		}

		public String getDocBase() {
			return docBase;
		}

		@Override
		public String toString() {
			return "WebAppConfig [contextPath=" + contextPath + ", docBase="
					+ docBase + "]";
		}
	
	}
	
	
	private static String getAbsoluteDocBaseDir(ApplicationContext context, String inputDocBaseDir){
		String docBaseDir = inputDocBaseDir;
		File f = new File(inputDocBaseDir);
		if(!f.isAbsolute()){
			String appDir = context.getContextDir();
			docBaseDir = appDir + "/"+ inputDocBaseDir;
			f = new File(docBaseDir);
		}
		return f.getAbsolutePath();
	}
	

	
}
