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

package kr.co.bizframe.mas.core;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



public class MasProcess {
	
	private static Logger log = LoggerFactory.getLogger(MasProcess.class);

	private String homeDir;
	
	public MasProcess(String homeDir){
		this.homeDir = homeDir;
	}
	
	
	public void create(){
		long pid = getProcessId();
		log.info("mas process id=["+pid+"]");
		createProcessIdFile(pid);
	}
	
	
	public void destroy(){

		try{
			long pid = getProcessIdFromFile();
			log.info("process kill pid = "+ pid);
			String cmd = null;
			if(isWindows()){
				cmd = "Taskkill /PID "+ pid;
			}else{
				cmd = "kill -9 " + pid;
			}
			Runtime.getRuntime().exec(cmd);
		}catch(Exception e){
			log.error(e.getMessage(), e);
		}
	}
	
	private void createProcessIdFile(long pid) {
		FileWriter fw = null;
		try{
			File f = new File(homeDir+"/bin/pid");
			f.deleteOnExit();
			
			fw = new FileWriter(f);
			fw.write(Long.toString(pid));
		}catch(Exception e){
			log.error(e.getMessage(), e);
		}finally{
			try{
				fw.close();
			}catch(Exception e){
				//mute
			}
		}
	}
	
	
	private long getProcessIdFromFile() {
		long pid = 0;
		FileReader fr = null;
		try{
			File f = new File(homeDir+"/bin/pid");
			fr = new FileReader(f);
			BufferedReader br = new BufferedReader(fr);
			String pids = br.readLine();
			pid = Long.parseLong(pids);
		}catch(Exception e){
			log.error(e.getMessage(), e);
		}finally{
			try{
				fr.close();
			}catch(Exception e){
				//mute
			}
		}
		return pid;
	}
	
	
	private long getProcessId(){
		
		if(isWindows()){
			WindowsProcess wp = new WindowsProcess();
			return wp.getProcessId();
		}else{
			UnixProcess up = new UnixProcess();
			return up.getProcessId();
		}
	}
	
	
	
	public static boolean isWindows() {
		String os = System.getProperty("os.name").toLowerCase();
        return (os.indexOf("win") >= 0);
    }
	
	
	
	
}
