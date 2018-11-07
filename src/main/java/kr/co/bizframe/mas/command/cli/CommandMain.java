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

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.StringTokenizer;

import kr.co.bizframe.mas.command.Command;
import kr.co.bizframe.mas.command.CommandInvoker;
import kr.co.bizframe.mas.command.CommandResponse;

public class CommandMain {
	
	private CommandInvoker invoker;
	
	public static String DEFAULT_HOST = "127.0.0.1";
	
	public static int DEFAULT_PORT = 9004;
	
	public static int DEFAULT_TIMEOUT = 100000;
	
	
	public CommandMain(){
		this.invoker = new CommandInvoker(DEFAULT_HOST, DEFAULT_PORT, DEFAULT_TIMEOUT);
	}

	
	public CommandMain(String ip, int port, int timeout){
		this.invoker = new CommandInvoker(ip, port, timeout);
	}

	
	public void process(){
		
		showLogo();
		while(true){
			System.out.print("cmd> ");
			Scanner scan= new Scanner(System.in);
		    String cmdline = scan.nextLine();
		   
		    String[] cmds = parse(cmdline);
		    
		    if(cmds == null || cmds.length < 1){
		    	continue;
		    }
		   
		    String cmd = cmds[0];
		    if(cmd != null ) cmd = cmd.trim();
		    
		    if("help".equals(cmd)){
		    	showHelp();

		    }else if("".equals(cmd)){
		    	continue;
		    
		    }else if("connect".equals(cmd)){
		    	connect(cmds);
		    
		    }else if("status".equals(cmd)){
				status();
		    
		    }else if("shutdown".equals(cmd)){
		    	shutdown();
		    
		    }else if("version".equals(cmd)){
		    	version();
		    
		    }else if("startapp".equals(cmd)){
		    	startApp(cmds);
		    
		    }else if("stopapp".equals(cmd)){
		    	stopApp(cmds);	
		    
		    }else if("deployapp".equals(cmd)){
		    	deployApp(cmds);		    			    	
		   
		    }else if("undeployapp".equals(cmd)){
		    	undeployApp(cmds);		    			    	

		    }else if("removeapp".equals(cmd)){
		    	removeApp(cmds);		    		
		    	
		    }else if("appinfo".equals(cmd)){
		    	appInfo(cmds);		    	
		    	
		    }else if("applist".equals(cmd)){
		    	appList();		    	
		    
		    }else if("appdeflist".equals(cmd)){
		    	appDefList();		 
		    	
		    }else if("appdef".equals(cmd)){
		    	appDef(cmds);		 
		    	
		    }else if("refreshappdef".equals(cmd)){
		    	refreshAppDef(cmds);		 
		    	
		    }else if("quit".equals(cmd)){
		    	System.out.println("bye ..");
		    	break;
		    
		    }else{
		    	System.out.println("unknown command=["+cmd+"]");
		    }

		}
		
	}
	
	
	private void showLogo(){
		System.out.println("==========================================================");
		System.out.println("====== BizFrame micro application server  v2.0.0  ========");
		System.out.println("==========================================================");
	}
	
	
	private void showHelp(){
		System.out.println(" quit - quit command line tool");
		System.out.println(" help - help command line tool");
		System.out.println(" connect [host port [timeout]] - connect server");
		System.out.println(" status - status MAS server");
		System.out.println(" shutdown - shutdown MAS server");	
		System.out.println(" version - version of MAS server");	
		System.out.println(" startapp [app_id] - start application with app_id");	
		System.out.println(" stopapp [app_id] - stop application with app_id");
		System.out.println(" deployapp [app_id] - deploy application with app_id");
		System.out.println(" undeployapp [app_id] - undeploy application with app_id");
		System.out.println(" removeapp [app_id] - remove application with app_id");
		System.out.println(" appinfo [app_id] - application info with app_id");
		System.out.println(" applist  -  application info list");
		System.out.println(" appdef [app_id]- application def info");
		System.out.println(" appdeflist - application def list");
		System.out.println(" refreshappdef - refresh application def list");
	}
	
	 
	private void connect(String[] cmds){
		
		String host = DEFAULT_HOST;
		int port = DEFAULT_PORT;
		int timeout = DEFAULT_TIMEOUT;
	
		if(cmds.length > 2){
			host = cmds[1];
			port = Integer.parseInt(cmds[2]);
			invoker = new CommandInvoker(host, port);
		}else if(cmds.length > 3){
			host = cmds[1];
			port = Integer.parseInt(cmds[2]);
			timeout = Integer.parseInt(cmds[3]);
			invoker = new CommandInvoker(host, port, timeout);
		}
		
		try{
			invoker.invoke(new Command.PING());
			System.out.println("connected");
			printConnectStatus();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	
	private void status(){
		try{
			CommandResponse response = invoker.invoke(new Command.STATUS());
			printConnectStatus();
			printResponse(response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	private void shutdown(){
		
		try{
			CommandResponse response = invoker.invoke(new Command.SHUTDOWN());
			printResponse(response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	private void version(){
		
		try{
			CommandResponse response = invoker.invoke(new Command.VERSION());
			printResponse(response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	private void startApp(String[] cmds){
		
		try{
			if(cmds.length < 2){
				throw new Exception("app id is null.");
			}
		
			Command cmd = new Command.START_APP();
			cmd.addParam(cmds[1]);
			CommandResponse response = invoker.invoke(cmd);
			printResponse(response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	private void stopApp(String[] cmds){
		
		try{
			if(cmds.length < 2){
				throw new Exception("app id is null.");
			}
	
			Command cmd = new Command.STOP_APP();
			cmd.addParam(cmds[1]);
			CommandResponse response = invoker.invoke(cmd);
			printResponse(response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	private void deployApp(String[] cmds){
		
		try{
			if(cmds.length < 2){
				throw new Exception("app id is null.");
			}
	
			Command cmd = new Command.DEPLOY_APP();
			cmd.addParam(cmds[1]);
			CommandResponse response = invoker.invoke(cmd);
			printResponse(response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	private void undeployApp(String[] cmds){
		
		try{
			if(cmds.length < 2){
				throw new Exception("app id is null.");
			}

			Command cmd = new Command.UNDEPLOY_APP();
			cmd.addParam(cmds[1]);
			CommandResponse response = invoker.invoke(cmd);
			printResponse(response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	private void removeApp(String[] cmds){
		
		try{
			if(cmds.length < 2){
				throw new Exception("app id is null.");
			}

			Command cmd = new Command.REMOVE_APP();
			cmd.addParam(cmds[1]);
			CommandResponse response = invoker.invoke(cmd);
			printResponse(response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	

	
	private void refreshAppDef(String[] cmds){
		try{
			CommandResponse response = invoker.invoke(new Command.REFRESH_APP_DEF());
			printResponse(response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	private void appDef(String[] cmds){
		
		try{
			if(cmds.length < 2){
				throw new Exception("app id is null.");
			}
			
			Command cmd = new Command.GET_APP_DEF();
			cmd.addParam(cmds[1]);
			CommandResponse response = invoker.invoke(cmd);
			printResponse(response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}


	private void appDefList(){
		
		try{
			CommandResponse response = invoker.invoke(new Command.GET_APP_DEF_LIST());
			printListResponse(response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	

	private void appInfo(String[] cmds){
		
		try{
			if(cmds.length < 2){
				throw new Exception("app id is null.");
			}
		
			Command cmd = new Command.GET_APP_INFO();
			cmd.addParam(cmds[1]);
			CommandResponse response = invoker.invoke(cmd);
			printResponse(response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	private void appList(){
		
		try{
			CommandResponse response = invoker.invoke(new Command.GET_APP_LIST());
			printListResponse(response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	private String[] parse(String cmd){
		
		List<String> cmds = new ArrayList<String>();
		StringTokenizer st = new StringTokenizer(cmd, " ");
		while (st.hasMoreTokens()) {
			cmds.add(st.nextToken());
		}
		String[] ss = cmds.toArray(new String[cmds.size()]);
		return ss;
	}
		
	
	private void printResponse(CommandResponse response){
		if(response.isOK()){
			System.out.println(response.getResult());
		}else{
			System.out.println(response.getException());
		}
	}

	
	private void printListResponse(CommandResponse response){
		if(response.isOK()){
			List results = (List)response.getResult();
			for(int ii=0;ii<results.size();ii++){
				System.out.println(results.get(ii));
			}
		}else{
			System.out.println(response.getException());
		}
	}
	
	private void printConnectStatus(){
		System.out.println("server connect info : host=["+invoker.getHost()+"],"
				+ " port=["+invoker.getPort()+ "], timeout=["+ invoker.getTimeout()+"]" );
	}
	
	public static void main(String[] argv){
	
		CommandLine cl = new CommandLine(argv);
		String host = cl.getValue("-h", CommandMain.DEFAULT_HOST);
		int port = cl.getIntValue("-p", CommandMain.DEFAULT_PORT);
		int timeout = cl.getIntValue("-t", CommandMain.DEFAULT_TIMEOUT);
		
		CommandMain cm = new CommandMain(host, port, timeout);
		cm.process();
	}
}
