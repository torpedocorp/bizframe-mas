package kr.co.bizframe.mas.test.management;

import java.lang.management.ManagementFactory;
import java.util.Iterator;
import java.util.Set;

import javax.management.AttributeChangeNotification;
import javax.management.MBeanNotificationInfo;
import javax.management.MBeanServer;
import javax.management.Notification;
import javax.management.NotificationBroadcasterSupport;
import javax.management.NotificationListener;
import javax.management.ObjectInstance;
import javax.management.ObjectName;
import javax.management.Query;
import javax.management.QueryExp;

public class JMXTest {

	public class Hello extends NotificationBroadcasterSupport implements HelloMBean {

		private String message = "Hello World";

		private int cacheSize = DEFAULT_CACHE_SIZE;

		private static final int DEFAULT_CACHE_SIZE = 200;

		private long sequenceNumber = 1;

		@Override
		public void sayHello() {
			System.out.println(message);
		}

		@Override
		public String getMessage() {
			return this.message;
		}

		@Override
		public void setMessage(String message) {
			this.message = message;
		}

		@Override
		public int getCacheSize() {
			return this.cacheSize;
		}

		public synchronized void setCacheSize(int size) {
			int oldSize = this.cacheSize;
			this.cacheSize = size;

			System.out.println("Cache size now " + this.cacheSize);

			Notification n = new AttributeChangeNotification(this, sequenceNumber++, System.currentTimeMillis(),
					"CacheSize changed", "CacheSize", "Integer", new Integer(oldSize), new Integer(this.cacheSize));

			sendNotification(n);
		}

		
		@Override
		public MBeanNotificationInfo[] getNotificationInfo() {
			String[] types = new String[] { AttributeChangeNotification.ATTRIBUTE_CHANGE };

			String name = AttributeChangeNotification.class.getName();
			String description = "An attribute of this MBean has changed";
			MBeanNotificationInfo info = new MBeanNotificationInfo(types, name, description);
			return new MBeanNotificationInfo[] { info };
		}
	}

	public interface HelloMBean {

		// operations
		public void sayHello();

		// attributes
		// a read-write attribute called Message of type String
		public String getMessage();

		public void setMessage(String message);

		public int getCacheSize();

		public void setCacheSize(int size);

	}

	public void test() throws Exception {

		MBeanServer server = ManagementFactory.getPlatformMBeanServer();

		String objectName1 = "kr.co.bizframe.mas.management:type=Hello";
		ObjectName mbeanName1 = new ObjectName(objectName1);
		Hello mbean1 = new Hello();
		server.registerMBean(mbean1, mbeanName1);

		/*
		String objectName2 = "kr.co.bizframe.mas.management:type=Hello, fname=kim, lname=dk, kname=imsi";
		ObjectName mbeanName2 = new ObjectName(objectName2);
		Hello mbean2 = new Hello();
		server.registerMBean(mbean2, mbeanName2);
		*/
		
		/*
		Set names = server.queryNames(null, null);
		for (Iterator i = names.iterator(); i.hasNext();) {
			System.out.println("ObjectName = " + (ObjectName) i.next());
		}
		*/
		
		
		// QueryExp qe = Query.match(Query.attr("j2eeType"),
		// Query.value("Servlet"));
		Set<ObjectInstance> instances = server.queryMBeans(mbeanName1, null);
		ObjectInstance instance = (ObjectInstance) instances.toArray()[0];
		System.out.println("Object Name:" + instance.getObjectName());
		System.out.println("Object Name:" + instance.getClass().getName());
		HelloNotificationListener listener = new HelloNotificationListener();
		server.addNotificationListener(mbeanName1, listener, null, null);
		
		int i = 10;
		while(true){
			try {
				Thread.sleep(5000);
			} catch (Exception e) {
				e.printStackTrace();
			}		
			mbean1.setCacheSize(10*i);
			i++;
		}
	}
	
	
	
	public class HelloNotificationListener implements NotificationListener {
		
		 public void handleNotification(Notification notification,
                 Object handback) {
	      String type = notification.getType();

		        System.out.println(
		            "\n\t>> SimpleStandardListener received notification:" +
		            "\n\t>> ---------------------------------------------");
		        try {
		            if (type.equals(AttributeChangeNotification.ATTRIBUTE_CHANGE)) {

		  System.out.println("\t>> Attribute \"" +
		      ((AttributeChangeNotification)notification).getAttributeName()
		      + "\" has changed");
		  System.out.println("\t>> Old value = " +
		      ((AttributeChangeNotification)notification).getOldValue());
		  System.out.println("\t>> New value = " +
		      ((AttributeChangeNotification)notification).getNewValue());

		            }                
		            else {
		                System.out.println("\t>> Unknown event type (?)\n");
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		            System.exit(1);
		        }			 
			 
		 }
	}
	
	
	
	public static void main(String[] args) throws Exception {

		JMXTest jmx = new JMXTest();
		jmx.test();
		
		
		try {
			Thread.sleep(1000000);
		} catch (Exception e) {

		}
	}

}