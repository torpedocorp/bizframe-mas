package kr.co.bizframe.mas.example.simple;

import java.io.File;
import java.io.FileInputStream;
import java.net.URL;

import kr.co.bizframe.mas.Application;
import kr.co.bizframe.mas.application.ApplicationContext;

public class SimpleApp implements Application {

	public void init(ApplicationContext context) {
		
		System.out.println("init simple app");
		System.out.println("props = " +context.getProperties());
	
		try{
			URL url = context.getResource("/classes/config.xml");
			System.out.println("url= " + url);
			String fn = url.getFile();
			File f = new File(fn);
			FileInputStream fis =  new FileInputStream(f);
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	public void destroy(ApplicationContext context) {
		System.out.println("destory simple app");
	}
}
