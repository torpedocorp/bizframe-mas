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
package kr.co.bizframe.mas.application;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardWatchEventKinds;
import java.nio.file.WatchEvent;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ApplicationWatcher {
	
	private static Logger log = LoggerFactory.getLogger(ApplicationWatcher.class);
	
	private List<WatchThread> watchThreads;
	
	private ApplicationManager applicationManager;
	
	private long DEFAULT_WAIT_TIME = 3000;
	
	public ApplicationWatcher(ApplicationManager applicationManager){
		log.info("create application watcher");
		this.watchThreads = new ArrayList<WatchThread>();
		this.applicationManager = applicationManager;
	}
	
	
	public void addWatch(String dir){
		log.info("add application watch dir=["+dir+"]");
		Path watchDir = Paths.get(dir);
		try {
			WatchService watchService = watchDir.getFileSystem().newWatchService();
			watchDir.register(watchService, StandardWatchEventKinds.ENTRY_CREATE,
					StandardWatchEventKinds.ENTRY_DELETE,
					StandardWatchEventKinds.ENTRY_MODIFY);
			
			WatchThread wr = new WatchThread(watchService, watchDir);
			watchThreads.add(wr);
			wr.start();
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}		
	}


	
	public void shutdown(){
		for(WatchThread watchThread : watchThreads){
			watchThread.shutdown();
			watchThread.interrupt();
		}
	}

	
	private class WatchThread extends Thread {
		
		private WatchService watcher;
		
		private Path path;
		
		private boolean stopped = false;
		
		public WatchThread(WatchService watcher, Path path){
			this.watcher = watcher;
			this.path = path;
			this.setName("watch_thread");
		}
		
		public void run(){
			try{
				while(!stopped && !Thread.interrupted()){
					WatchKey watckKey = watcher.take();
					List<WatchEvent<?>> events = watckKey.pollEvents();

					for (WatchEvent<?> event : events) {
						
						Thread.sleep(DEFAULT_WAIT_TIME);

						if (event.kind() == StandardWatchEventKinds.ENTRY_CREATE) {
							String appDir = path.toAbsolutePath() + "/" + event.context().toString();
							ApplicationDef appDef = applicationManager.scanAppDirectory(new File(appDir));
							applicationManager.deployApplication(appDef.getId());
						}
						
						if (event.kind() == StandardWatchEventKinds.ENTRY_DELETE) {
							//System.out.println("Delete: " + event.context().toString());
							String appDir = path.toAbsolutePath() + "/" + event.context().toString();
							applicationManager.removeApplication(new File(appDir));
						}
						
						if (event.kind() == StandardWatchEventKinds.ENTRY_MODIFY) {
							//System.out.println("Modify: " + event.context().toString());
						}
					}
					watckKey.reset();
				}
			}catch(Exception e){
				log.error(e.getMessage(), e);
			}
		}
		
		
		public void shutdown(){
			this.stopped = true;
			this.interrupt();
		}
	}
}
