package kr.co.bizframe.mas.management;

import java.lang.management.ManagementFactory;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.management.MBeanServer;
import javax.management.ObjectInstance;
import javax.management.ObjectName;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.bizframe.mas.application.ApplicationContext;
import kr.co.bizframe.mas.application.MasApplication;
import kr.co.bizframe.mas.core.MasServer;
import kr.co.bizframe.mas.management.mbean.ManagedMasApplication;
import kr.co.bizframe.mas.management.mbean.ManagedMasServer;

public class JMXManager {

	private static Logger log = LoggerFactory.getLogger(JMXManager.class);

	public static String SERVER_MGMT_NAME = "kr.co.bizframe.mas:type=server";
	
	public static String APPLICATION_MGMT_NAME = "kr.co.bizframe.mas:type=application";
	
	private static ManagedMasServer serverMgmt = null;
	
	private static Map<String, ManagedMasApplication> applicationMgmts = new HashMap<String, ManagedMasApplication>();
	
	
	public JMXManager() {
	}

	public static void registerServerMgmt(MasServer server) {
		log.info("register server");
		try {
			ObjectName mbeanName = new ObjectName(SERVER_MGMT_NAME);
			MBeanServer ms = getMBeanServer();
			ManagedMasServer object = new ManagedMasServer(server);
			serverMgmt = object;
			ms.registerMBean(object, mbeanName);
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
	}
	
	public static ManagedMasServer getServerMgmt(){
		return serverMgmt;
	}
	
	public static void registerApplicationMgmt(MasApplication application){
		log.info("register application");
		try {
			ApplicationContext context = application.getContext();
			String appId = context.getId();
			String objectName = APPLICATION_MGMT_NAME+",id="+appId;
			ObjectName mbeanName = new ObjectName(objectName);
			MBeanServer ms = getMBeanServer();
			ManagedMasApplication object = new ManagedMasApplication(application);
			applicationMgmts.put(appId, object);
			ms.registerMBean(object, mbeanName);
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
	}
	
	
	public static ManagedMasApplication getMasApplicationMgmt(String appId){
		return applicationMgmts.get(appId);
	}
	
	
	public static void unregisterApplicationMgmt(String appId){
		
		log.info("unregisterApplication application");
		try {
			String objectName = APPLICATION_MGMT_NAME+",id="+appId;
			ObjectName mbeanName = new ObjectName(objectName);
			MBeanServer ms = getMBeanServer();
			ms.unregisterMBean(mbeanName);
			applicationMgmts.remove(appId);
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
	}
	
	
	public static MBeanServer getMBeanServer() {
		return ManagementFactory.getPlatformMBeanServer();
	}
}
