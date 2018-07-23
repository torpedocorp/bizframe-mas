/**
 *  Copyright (c) 2014 Torpedo Inc..  All rights reserved.
 *
 */
package kr.co.bizframe.mas.command;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;

//import kr.co.bizframe.mas.conf.MasConfig;

//import org.apache.log4j.Logger;

/**
 *
 * @author Young-jun Bae
 *
 */
public class CommandInvoker {

	//private static Logger log = Logger.getLogger(CommandInvoker.class);

	public CommandResponse invoke(Command command) throws Exception{
		//int port = MasConfig.getServer().getPort();
		//int timeout = MasConfig.getServer().getTimeout();
		return invoke("127.0.0.1", 9004, 0, command);
	}

	public CommandResponse invoke(String host, int port, Command command) throws Exception{
		return invoke(host, port, 0, command);
	}


	public CommandResponse invoke(String host, int port, int timeout, Command command) throws Exception {

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
			throw e;
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
}
