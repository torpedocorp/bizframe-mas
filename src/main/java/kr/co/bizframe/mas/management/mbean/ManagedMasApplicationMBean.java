package kr.co.bizframe.mas.management.mbean;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface ManagedMasApplicationMBean {
	
	public String getName();
	
	public Date getInitTime();
	
	public Date getStartTime();
	
	public Date getStopTime();
	
	public String getStatus();
	
	public boolean getServiceable();
	
	public String getApplicationType();

	public List<String> getSubManagementNames();
	
	public Map<String, String> getParameters();
	
	public String getApplicationPath();
	
	public int getLoadSequence();
	
	public void start() throws Exception;
	
	public void stop() throws Exception;
	
	public void undeploy() throws Exception;
	
	public void deploy() throws Exception;
	
}
