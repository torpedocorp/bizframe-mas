/**
 *  Copyright (c) 2014 Torpedo Inc..  All rights reserved.
 *
 */
package kr.co.bizframe.mas.command;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;

import kr.co.bizframe.mas.conf.MasConfig;


/**
 *
 * @author Young-jun Bae
 *
 */
public class CommandInvoker {

	//public static String DEFAULT_HOST = "127.0.0.1";
	
	//public static int DEFAULT_PORT = 9004;

	//public static int DEFALUT_TIMEOUT = 100000;
	
	private String host;
	
	private int port;
	
	private int timeout = 100000;
	
	
	//public CommandInvoker(){
	//}
	
	
	public CommandInvoker(String host, int port){
		this.host = host;
		this.port = port;
	}
	
	
	public CommandInvoker(String host, int port, int timeout){
		this.host = host;
		this.port = port;
		this.timeout = timeout;
	}
	
	
	/*
	public CommandResponse invoke(Command command) throws Exception{
		return invoke(DEFAULT_HOST, DEFAULT_PORT, DEFAULT_TIMEOUT, command);
	}
	*/
	
	
	/*
	public CommandResponse invoke(String host, int port, Command command) throws Exception{
		return invoke(host, port, 0, command);
	}
	*/
	

	public CommandResponse invoke(Command command) throws Exception {

		//log.debug("request = " + command);
		CommandResponse cr = null;
		ObjectOutputStream oos = null;
		ObjectInputStream ois = null;
		Socket cl = null;
		try {
			cl = new Socket(host, port);
			cl.setSoTimeout(timeout);
			oos = new ObjectOutputStream(cl.getOutputStream());
			oos.writeObject(command);

			ois = new ObjectInputStream(cl.getInputStream());
			cr = (CommandResponse) ois.readObject();

			// logger.info("return = [" + cr.getResult()+ "]");

		} catch (Exception e) {
			//log.error("command error : ", e);
			String error = "host=["+host +"], port=["+port+"] has problem.!";
			throw new Exception(error, e);
		} finally {
			try {
				if (oos != null) {
					oos.close();
				}
				if (ois != null) {
					ois.close();
				}
				if (cl != null) {
					cl.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		//log.debug("response=" + cr);
		return cr;
	}


	public String getHost() {
		return host;
	}


	public void setHost(String host) {
		this.host = host;
	}


	public int getPort() {
		return port;
	}


	public void setPort(int port) {
		this.port = port;
	}


	public int getTimeout() {
		return timeout;
	}


	public void setTimeout(int timeout) {
		this.timeout = timeout;
	}
	
	
	
}
