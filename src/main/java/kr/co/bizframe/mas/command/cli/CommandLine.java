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
