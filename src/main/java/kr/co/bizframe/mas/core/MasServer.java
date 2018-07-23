package kr.co.bizframe.mas.core;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.List;

import kr.co.bizframe.mas.Lifecycle;
import kr.co.bizframe.mas.command.Command;
import kr.co.bizframe.mas.command.CommandResponse;
import kr.co.bizframe.mas.command.model.ApplicationDefInfo;
import kr.co.bizframe.mas.command.model.ApplicationInfo;
import kr.co.bizframe.mas.command.model.RouteInfo;
import kr.co.bizframe.mas.conf.MasConfig;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class MasServer implements Lifecycle {

	private static Logger logger = LoggerFactory.getLogger(MasServer.class);

	private Status status = Status.SHUTDOWNED;

	private ServerSocket serverSocket;

	private MasEngine engine;

	private String homeDir;

	// private List<String> filterRemoteAddress = new ArrayList<String>();

	public enum Status {

		SHUTDOWNED, SHUTDOWNING, STARTED, STARTING, FAILED

	}

	private static String RESP_MSG_OK = "OK";
	
	private static String RESP_MSG_FAIL = "FAIL";
	
	public MasServer(String homeDir) {
		this.homeDir = homeDir;

	}

	public void startup() {

		logger.info("mas server is booting..");
		try {
			MasConfig.init();
			start0();
		} catch (Throwable t) {
			logger.error(t.getMessage(), t);
		}
	}

	private synchronized void start0() throws Exception {
	
		int port = 0;
		try {
			port = MasConfig.getServer().getPort();
			this.serverSocket = new ServerSocket(port);
		} catch (Exception e) {
			throw new Exception("could not listen on port: " + port, e);
		}
		logger.info("mas server listen on port=[" + port + "]");

		// 엔진 시작 작업
		engine = new MasEngine(homeDir);
		engine.startup();
		this.status = Status.STARTED;
		await();
	}

	public void shutdown() throws Exception {

		if (engine == null)
			return;
		engine.shutdown();

		this.status = Status.SHUTDOWNED;
		unlockAccept();
	}

	private void await() {

		while (status == Status.STARTED) {
			try {
				Socket socket = serverSocket.accept();
				if (status == Status.STARTED) {
					command(socket);
				}

			} catch (Exception e) {
				logger.error("admin socket error occurs", e);
			}
		}

		try {
			serverSocket.close();
		} catch (Exception ignore) {
			// mute..
		}

	}

	public Status getStatus() {
		return status;
	}

	
	private void command(Socket socket) {

		InetAddress ia = (InetAddress) socket.getInetAddress();
		String address = ia.getHostAddress();
		ObjectInputStream ois = null;
		ObjectOutputStream oos = null;
		CommandResponse cr = null;
		try {
			ois = new ObjectInputStream(socket.getInputStream());
			oos = new ObjectOutputStream(socket.getOutputStream());
			Object ob = ois.readObject();

			if (ob instanceof Command) {
				logger.debug("command =" + (Command) ob);

				Command cmd = (Command) ob;
				String ct = cmd.getCommand();

				if (cmd instanceof Command.SHUTDOWN) {
					
					try{
						shutdown();
						cr = new CommandResponse(RESP_MSG_OK);
					}catch(Throwable t){
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}
				
				} else if (cmd instanceof Command.VERSION) {
					try{
						String version = engine.getVersion();
						cr = new CommandResponse(version);
					}catch(Throwable t){
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}
				
				} else if (cmd instanceof Command.STATUS) {
					try{
						String status = engine.getStatusInfo();
						cr = new CommandResponse(status);
					}catch(Throwable t){
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}
				
				} else if (cmd instanceof Command.REFRESH_APP_DEF){
					
					cr = new CommandResponse();
				
					try {
						engine.refreshApplicationDef();
						cr = new CommandResponse(RESP_MSG_OK);
					}catch(Throwable t){
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}
					
				} else if (cmd instanceof Command.GET_APP_DEF){
					
					cr = new CommandResponse();
				
					cr = new CommandResponse();
					java.util.List<String> list = cmd.getParams();
					if(list.size() == 0) {
						cr.setException("appId parameter is missing.");
					}

					String appId = (String)list.get(0);
					logger.debug("try to app info id = [" + appId+"]");
					
					try {
						ApplicationDefInfo appDefInfoInfo = engine.getApplicationDef(appId);
						cr = new CommandResponse(appDefInfoInfo);
					}catch(Throwable t){
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}
					
				} else if (cmd instanceof Command.GET_APP_DEF_LIST){
					
					cr = new CommandResponse();
				
					try {
						List<ApplicationDefInfo> appDefInfoList = engine.getApplicationDefList();
						cr = new CommandResponse(appDefInfoList);
					}catch(Throwable t){
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}
				
				} else if (cmd instanceof Command.GET_APP_INFO){
			
					cr = new CommandResponse();
					java.util.List<String> list = cmd.getParams();
					if(list.size() == 0) {
						cr.setException("appId parameter is missing.");
					}

					String appId = (String)list.get(0);
					logger.debug("try to app info id = [" + appId+"]");

					try {
						ApplicationInfo appInfo  = engine.getApplicationInfo(appId);
						cr = new CommandResponse(appInfo);
					}catch(Throwable t){
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}
				
					
				} else if (cmd instanceof Command.GET_APP_LIST){
					try{
						List<ApplicationInfo> appInfoList = engine.getApplicationList();
						cr = new CommandResponse(appInfoList);
					}catch(Throwable t){
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}
				
				} else if (cmd instanceof Command.DEPLOY_APP){
					
					cr = new CommandResponse();
					List<String> list = cmd.getParams();
					if(list.size() == 0) {
						cr.setException("appId parameter is missing.");
					}
					
					String appId = (String)list.get(0);
					logger.debug("try to deploy app id = [" + appId+"]");

					try {
						engine.deployApplication(appId);
						cr = new CommandResponse(RESP_MSG_OK);
					}catch(Throwable t){
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}
				

				} else if (cmd instanceof Command.UNDEPLOY_APP){
					
					cr = new CommandResponse();
					java.util.List<String> list = cmd.getParams();
					if(list.size() == 0) {
						cr.setException("appId parameter is missing.");
					}

					String appId = (String)list.get(0);
					logger.debug("try to undeploy app Id = ["+appId+"]");

					try {
						engine.undeployApplication(appId);
						cr = new CommandResponse(RESP_MSG_OK);
					}catch(Throwable t){
						t.printStackTrace();
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}
					

				} else if (cmd instanceof Command.START_APP){
					
					cr = new CommandResponse();
					java.util.List<String> list = cmd.getParams();
					if(list.size() == 0) {
						cr.setException("appId parameter is missing.");
					}
					
					String appId = (String)list.get(0);
					logger.debug("try to start app Id = ["+appId+"]");

					try {
						engine.startApplication(appId);
						cr = new CommandResponse(RESP_MSG_OK);
					}catch(Throwable t){
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}
	

				} else if (cmd instanceof Command.STOP_APP){
					
					cr = new CommandResponse();
					java.util.List<String> list = cmd.getParams();
					if(list.size() == 0) {
						cr.setException("appId parameter is missing.");
					}

				
					String appId = (String)list.get(0);
					logger.debug("try to start app Id = ["+appId+"]");

					try {
						engine.stopApplication(appId);
						cr = new CommandResponse(RESP_MSG_OK);
					}catch(Throwable t){
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}
					
					
				} else if (cmd instanceof Command.GET_ROUTE_LIST){
					
					cr = new CommandResponse();

					try {
						List<RouteInfo> list = engine.getRouteList();
						cr.setResult(list);
					}catch(Throwable t){
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}

				} else if (cmd instanceof Command.GET_ROUTE_DETAIL){
					
					cr = new CommandResponse();

					try {
						List<String> routeIds = cmd.getParams();
						List<ApplicationInfo> list = engine.getRouteDetail(routeIds.get(0));
						cr.setResult(list);
					}catch(Throwable t){
						logger.error(t.getMessage(), t);
						cr.setException(t.getMessage());
					}

				} else {
					// CommandProcessor processor = new CommandProcessor();
					// cr = processor.process(cmd);

				}

				if (cr == null) {
					cr = new CommandResponse();
					cr.setException(new Exception("command is not valid : "
							+ ob.getClass().getName()));
				}
				oos.writeObject(cr);

			} else {
				logger.error("invalid command object.!!");
			}
		} catch (IOException e) {
			// alogger.error(address +" : "+ e.getMessage(), e);
		} catch (Exception e) {
			// alogger.error(address +" : "+ e.getMessage(), e);
		} finally {
			try {
				if (ois != null)
					ois.close();
				if (oos != null)
					oos.close();
				// socket.close();
			} catch (Exception e) {
				// mute
			}
		}

	}
	
	
	
	private void unlockAccept() {
		Socket s = null;
		int port = MasConfig.getServer().getPort();

		try {
			s = new Socket("127.0.0.1", port);
		} catch (Exception e) {
			// logger.debug("unlock port=[" + port+"]", e);
		} finally {
			if (s != null) {
				try {
					s.close();
				} catch (Exception e) {
					// Ignore
				}
			}
		}
	}

	private void addFilterAddress() {

	}

}
