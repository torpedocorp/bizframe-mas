package kr.co.bizframe.mas.example.service;

import java.io.File;
import java.io.FileInputStream;
import java.net.URL;

import org.apache.commons.math3.stat.descriptive.DescriptiveStatistics;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


import kr.co.bizframe.mas.Application;
import kr.co.bizframe.mas.Serviceable;
import kr.co.bizframe.mas.application.ApplicationContext;

public class SimpleService implements Application, Serviceable{
	
	private static Logger log = LoggerFactory.getLogger(SimpleService.class);

	
	public void init(ApplicationContext context) {
		
		log.info("init simple servcie app");
		log.info("props = " +context.getProperties());
	 
	}

	public void destroy(ApplicationContext context) {
		log.info("destory simple service app");
	}
	
	
	public void start() throws Exception{
		log.info("start simple service app");
		// Get a DescriptiveStatistics instance
		DescriptiveStatistics stats = new DescriptiveStatistics();
		
	}

	public void stop() throws Exception{
		log.info("stop simple service app");		
	}
	
}
