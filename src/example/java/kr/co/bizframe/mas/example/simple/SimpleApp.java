package kr.co.bizframe.mas.example.simple;

import kr.co.bizframe.mas.Application;
import kr.co.bizframe.mas.application.ApplicationContext;

public class SimpleApp implements Application {

	public void init(ApplicationContext context) {
		
		System.out.println("init simple app");
		System.out.println("props = " +context.getProperties());
	
	}

	public void destroy(ApplicationContext context) {
		System.out.println("destory simple app");
	}
}
