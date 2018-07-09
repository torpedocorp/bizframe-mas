package kr.co.bizframe.mas.conf.bind;

public class ServerDef {

	private String id;

	private String ip;
	
	private int port;

	private int timeout;

	private EngineDef engine;
	
	
	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public int getTimeout() {
		return timeout;
	}

	public void setTimeout(int timeout) {
		this.timeout = timeout;
	}

	public int getPort() {
		return port;
	}

	public void setPort(int port) {
		this.port = port;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public EngineDef getEngine() {
		return engine;
	}

	public void setEngine(EngineDef engine) {
		this.engine = engine;
	}

	@Override
	public String toString() {
		return "ServerDef [id=" + id + ", ip=" + ip + ", port=" + port + ", timeout=" + timeout + "]";
	}

	
	
	
}
