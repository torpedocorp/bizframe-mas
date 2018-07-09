package kr.co.bizframe.mas.management.mbean;

import javax.management.AttributeChangeNotification;
import javax.management.MBeanNotificationInfo;
import javax.management.Notification;
import javax.management.NotificationBroadcasterSupport;

import kr.co.bizframe.mas.conf.MasConfig;
import kr.co.bizframe.mas.core.MasServer;

public class ManagedMasServer extends NotificationBroadcasterSupport implements ManagedMasServerMBean {
	
	private MasServer server;
	
	private long sequenceNumber = 1;
	
	public ManagedMasServer(MasServer server){
		this.server = server;
	}
	
	@Override
	public int getPort(){
		return MasConfig.getServer().getPort();
	}
		
	@Override
	public String getStatus(){
		return server.getStatus().toString();
	}

	@Override
	public String getHomeDir(){
		return server.getHomeDir();
	}
	
	
	public synchronized void changeStatusNotification(MasServer.Status preStatus,
			MasServer.Status status){
		
		Notification n = new AttributeChangeNotification(this, sequenceNumber++, 
				System.currentTimeMillis(),
				"Status changed", 
				"Status", 
				"String", 
				preStatus.toString(), 
				status.toString());

		sendNotification(n);
	}
	
	@Override
	public MBeanNotificationInfo[] getNotificationInfo() {
		String[] types = new String[] { AttributeChangeNotification.ATTRIBUTE_CHANGE };

		String name = AttributeChangeNotification.class.getName();
		String description = "Mas Server status has changed";
		MBeanNotificationInfo info = new MBeanNotificationInfo(types, name, description);
		return new MBeanNotificationInfo[] { info };
	}
	
}	
