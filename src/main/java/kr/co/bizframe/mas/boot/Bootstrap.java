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

package kr.co.bizframe.mas.boot;

import kr.co.bizframe.mas.command.Command;
import kr.co.bizframe.mas.command.CommandInvoker;
import kr.co.bizframe.mas.conf.MasConfig;
import kr.co.bizframe.mas.conf.bind.ServerDef;
import kr.co.bizframe.mas.core.MasProcess;
import kr.co.bizframe.mas.core.MasServer;

public class Bootstrap {

	private String homeDir;

	public Bootstrap(String homeDir) throws Exception {

		// 설정 파일 초기화
		MasConfig.init();
		this.homeDir = homeDir;
	}

	public void start() throws Exception {

		// server 로딩
		MasServer server = new MasServer(homeDir);
		server.startup();
	}
	
	
	private CommandInvoker getCommandInovker(){
		ServerDef sd = MasConfig.getServer();
		CommandInvoker ac = new CommandInvoker(sd.getIp(), sd.getPort(),
				sd.getTimeout());
		return ac;
	}
	
	
	public void shutdown() {
		try{
			CommandInvoker ci = getCommandInovker();
			Command.SHUTDOWN cmd = new Command.SHUTDOWN();
			ci.invoke(cmd);
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	public void version() {
		try{
			CommandInvoker ci = getCommandInovker();
			Command.VERSION cmd = new Command.VERSION();
			ci.invoke(cmd);
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	public void status() {
		try{
			CommandInvoker ci = getCommandInovker();
			Command.STATUS cmd = new Command.STATUS();
			ci.invoke(cmd);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	public void shutdownForcelly(){
		MasProcess process = new MasProcess(homeDir);
		process.destroy();
	}
}
