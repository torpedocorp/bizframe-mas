package kr.co.bizframe.mas.test.management;

import java.lang.management.ManagementFactory;

import javax.management.MBeanServer;
import javax.management.ObjectName;

import kr.co.bizframe.mas.test.management.JMXTest.Hello;

public class JMXMasServerTest {

	public void test() {

		try {
			String objectName = "kr.co.bizframe.mas.management:type=MasServer";
			MBeanServer server = ManagementFactory.getPlatformMBeanServer();

			// Construct the ObjectName for the Hello MBean we will register
			ObjectName mbeanName = new ObjectName(objectName);
			MasServerMBean mbean = new MasServer();

			server.registerMBean(mbean, mbeanName);

			Thread.sleep(100000);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] argv) {

		JMXMasServerTest jst = new JMXMasServerTest();
		jst.test();
	}
}
