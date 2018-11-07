/*
 * Copyright 2018 Torpedo corp.
 *  
 * bizframe mas project licenses this file to you under the Apache License,
 * version 2.0 (the "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at:
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */


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

	@Override
	public String getId() {
		return MasConfig.getServer().getId();
	}
	
}	
