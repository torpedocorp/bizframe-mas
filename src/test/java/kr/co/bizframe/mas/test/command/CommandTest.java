package kr.co.bizframe.mas.test.command;

import kr.co.bizframe.mas.command.Command;
import kr.co.bizframe.mas.command.CommandInvoker;
import kr.co.bizframe.mas.command.CommandResponse;

public class CommandTest {


	private String ip ="localhost";

	private int port  = 9091;

	public void testVersion(){
		try{
			CommandInvoker ci = new CommandInvoker(ip, port);
			Command.VERSION commmand = new Command.VERSION();
			CommandResponse response = ci.invoke(commmand);
			System.out.println("response = " + response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}



	public void testStatus(){
		try{
			CommandInvoker ci = new CommandInvoker(ip, port);
			Command.STATUS command = new Command.STATUS();
			CommandResponse response = ci.invoke(command);
			System.out.println("response = " + response);
		}catch(Exception e){
			e.printStackTrace();
		}

	}



	public void testDeploy(){
		
		try{
			CommandInvoker ci = new CommandInvoker(ip, port);
			Command.DEPLOY_APP command = new Command.DEPLOY_APP();
			command.addParam("test2");
			CommandResponse response = ci.invoke(command);
			System.out.println("response = " + response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}



	public void testUndeploy(){
		try{
			CommandInvoker ci = new CommandInvoker(ip, port);
			Command.UNDEPLOY_APP command = new Command.UNDEPLOY_APP();
			command.addParam("test2");
			CommandResponse response = ci.invoke(command);
			System.out.println("response = " + response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}




	public void testStart(){
		
		try{
			CommandInvoker ci = new CommandInvoker(ip, port);
			Command.START_APP command = new Command.START_APP();
			command.addParam("test2");
			CommandResponse response = ci.invoke( command);
			System.out.println("response = " + response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}



	public void testStop(){
		
		try{
			CommandInvoker ci = new CommandInvoker(ip, port);
			Command.STOP_APP command = new Command.STOP_APP();
			command.addParam("test2");
			CommandResponse response = ci.invoke(command);
			System.out.println("response = " + response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}




	public void testShutdown(){
		
		try{
			CommandInvoker ci = new CommandInvoker(ip, port);
			Command.SHUTDOWN command = new Command.SHUTDOWN();
			CommandResponse response = ci.invoke(command);
			System.out.println("response = " + response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}



	public static void main(String[] argv){

		CommandTest ct = new CommandTest();
		//ct.testVersion();
		ct.testStatus();
		//ct.testStop();
		//ct.testStart();
		//ct.testUndeploy();
		//ct.testDeploy();
	}
}
