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


package kr.co.bizframe.mas.command.cli;

import java.util.HashMap;
import java.util.Map;

public class CommandLine {
	
	private Map<String, String> values = new HashMap<String ,String>();
	
	public CommandLine(String[] inputs){
		parse(inputs);
	}
	
	private void parse(String[] inputs){
		
		String k = null;
		String v = null;
		
		for(int i=0;i<inputs.length;i++){
			
			String s = inputs[i];
			if(k == null) k = s; 
			else v = s;
		
			if(k != null && v != null){
				k = k.toLowerCase();
				values.put(k, v);
				k = null;
				v = null;
			}
		}
	}
	
	
	public String getValue(String key, String defaultValue){
		key = key.toLowerCase();
		String vs = values.get(key);
		if(vs != null){
			return vs;
		}
		return defaultValue;
	}
	
	
	public int getIntValue(String key, int defaultValue){
		key = key.toLowerCase();
		String vs = values.get(key);
		if(vs != null){
			return Integer.parseInt(vs);
		}
		return defaultValue;
	}
}
