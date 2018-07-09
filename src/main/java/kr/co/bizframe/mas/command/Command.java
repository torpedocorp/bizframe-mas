/**
 *  Copyright (c) 2014 Torpedo Inc..  All rights reserved.
 *
 */
package kr.co.bizframe.mas.command;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public abstract class Command implements Serializable {

	private static final long serialVersionUID = 382990331539308438L;

	private String command = null;

	private List<String> params = new ArrayList<String>();

	public Command(String command){
		this.command  = command;
	}

	public String getCommand() {
		return command;
	}

	public void setCommand(String command) {
		this.command = command;
	}

	public List<String> getParams() {
		return params;
	}

	public void addParam(String param){
		this.params.add(param);
	}


	public static class SHUTDOWN extends Command {
		public SHUTDOWN(){
			super("SHUTDOWN");
		}
	}

	public static class VERSION extends Command {
		public VERSION(){
			super("VERSION");
		}
	}


	
	public static class STATUS extends Command {
		public STATUS(){
			super("STATUS");
		}
	}

	public static class START_APP extends Command {
		public START_APP(){
			super("START_APP");
		}
	}

	public static class STOP_APP extends Command {
		public STOP_APP(){
			super("STOP_APP");
		}
	}

	public static class DEPLOY_APP extends Command {
		public DEPLOY_APP(){
			super("DEPLOY_APP");
		}
	}

	public static class UNDEPLOY_APP extends Command {
		public UNDEPLOY_APP(){
			super("UNDEPLOY_APP");
		}
	}

	public static class GET_APP_DEF extends Command {
		public GET_APP_DEF(){
			super("GET_APP_DEF");
		}
	}
	
	public static class GET_APP_DEF_LIST extends Command {
		public GET_APP_DEF_LIST(){
			super("GET_APP_DEF_LIST");
		}
	}
	
	public static class GET_APP_INFO extends Command {
		public GET_APP_INFO(){
			super("GET_APP_INFO");
		}
	}
	
	public static class GET_APP_LIST extends Command {
		public GET_APP_LIST(){
			super("GET_APP_LIST");
		}
	}

	public static class REFRESH_APP_DEF extends Command {
		public REFRESH_APP_DEF(){
			super("REFRESH_APP_DEF");
		}
	}
	
	public static class GET_ROUTE_LIST extends Command {
		public GET_ROUTE_LIST(){
			super("GET_ROUTE_LIST");
		}
	}

	public static class GET_ROUTE_DETAIL extends Command {
		public GET_ROUTE_DETAIL(){
			super("GET_ROUTE_DETAIL");
		}
	}

	@Override
	public String toString() {
		return "Command [command=" + command + ", params=" + params + "]";
	}

	

}
