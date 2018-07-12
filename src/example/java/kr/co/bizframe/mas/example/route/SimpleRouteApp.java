package kr.co.bizframe.mas.example.route;

import kr.co.bizframe.mas.Application;
import kr.co.bizframe.mas.Routable;
import kr.co.bizframe.mas.application.ApplicationContext;
import kr.co.bizframe.mas.routing.Exchange;

public class SimpleRouteApp implements Routable, Application{
	
	public void init(ApplicationContext context){
		System.out.println("init simple app");
	}

	public void destroy(ApplicationContext context){
		System.out.println("destory simple app");
	}

	public void onMessage(Exchange exchange) throws Exception {
		System.out.println("onMessage simple app");
		
	}
	
}
