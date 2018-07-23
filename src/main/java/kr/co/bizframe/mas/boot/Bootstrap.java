package kr.co.bizframe.mas.boot;

import kr.co.bizframe.mas.command.Command;
import kr.co.bizframe.mas.command.CommandInvoker;
import kr.co.bizframe.mas.conf.MasConfig;
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

	public void shutdown() {
		try{
			CommandInvoker ac = new CommandInvoker();
			Command.SHUTDOWN cmd = new Command.SHUTDOWN();
			ac.invoke(cmd);
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	public void version() {
		try{
			CommandInvoker ac = new CommandInvoker();
			Command.VERSION cmd = new Command.VERSION();
			ac.invoke(cmd);
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	public void status() {
		try{
			CommandInvoker ac = new CommandInvoker();
			Command.STATUS cmd = new Command.STATUS();
			ac.invoke(cmd);
		}catch(Exception e){
			e.printStackTrace();
		}
	}

}
