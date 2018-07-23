package kr.co.bizframe.mas.conf.bind;

public class ServerDef {

	private String id;

	private int port;

	private int timeout;

	private EngineDef engine;

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
		return "ServerDef [engine=" + engine + ", id=" + id + ", port=" + port + "]";
	}

}
