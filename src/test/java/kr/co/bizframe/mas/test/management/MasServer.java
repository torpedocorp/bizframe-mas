package kr.co.bizframe.mas.test.management;


public class MasServer implements MasServerMBean {
	
	private int port = 1000;
	
	private String status = "test";

	public MasServer(){
	}
	
	@Override
	public int getPort(){
		return port;
	}
	
	@Override
	public void setPort(int port){
		this.port = port;
	}
		
	@Override
	public String getStatus(){
		return status;
	}
	
	@Override
	public void setStatus(String status){
		this.status = status;
	}
}
