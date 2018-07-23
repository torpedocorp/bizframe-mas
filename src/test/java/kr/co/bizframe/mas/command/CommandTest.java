package kr.co.bizframe.mas.command;

public class CommandTest {


	private String ip ="localhost";

	private int port  = 9004;

	public void testVersion(){
		try{
			CommandInvoker ci = new CommandInvoker();
			Command.VERSION commmand = new Command.VERSION();
			CommandResponse response = ci.invoke(ip, port, commmand);
			System.out.println("response = " + response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}



	public void testStatus(){
		try{
			CommandInvoker ci = new CommandInvoker();
			Command.STATUS command = new Command.STATUS();
			CommandResponse response = ci.invoke(ip, port, command);
			System.out.println("response = " + response);
		}catch(Exception e){
			e.printStackTrace();
		}

	}



	public void testDeploy(){
		
		try{
			CommandInvoker ci = new CommandInvoker();
			Command.DEPLOY_APP command = new Command.DEPLOY_APP();
			command.addParam("test2");
			CommandResponse response = ci.invoke(ip, port, command);
			System.out.println("response = " + response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}



	public void testUndeploy(){
		try{
			CommandInvoker ci = new CommandInvoker();
			Command.UNDEPLOY_APP command = new Command.UNDEPLOY_APP();
			command.addParam("test2");
			CommandResponse response = ci.invoke(ip, port, command);
			System.out.println("response = " + response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}




	public void testStart(){
		
		try{
			CommandInvoker ci = new CommandInvoker();
			Command.START_APP command = new Command.START_APP();
			command.addParam("test2");
			CommandResponse response = ci.invoke(ip, port, command);
			System.out.println("response = " + response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}



	public void testStop(){
		
		try{
			CommandInvoker ci = new CommandInvoker();
			Command.STOP_APP command = new Command.STOP_APP();
			command.addParam("test2");
			CommandResponse response = ci.invoke(ip, port, command);
			System.out.println("response = " + response);
		}catch(Exception e){
			e.printStackTrace();
		}
	}




	public void testShutdown(){
		
		try{
			CommandInvoker ci = new CommandInvoker();
			Command.SHUTDOWN command = new Command.SHUTDOWN();
			CommandResponse response = ci.invoke(ip, port, command);
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
