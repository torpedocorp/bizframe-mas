package kr.co.bizframe.mas.test.management;

public interface MasServerMBean {
	
	public int getPort();
	
	public void setPort(int port);
	
	public String getStatus();
	
	public void setStatus(String status);
}
