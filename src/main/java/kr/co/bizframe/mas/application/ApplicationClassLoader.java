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
import java.net.URL;
import java.net.URLClassLoader;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.bizframe.mas.util.AddableClassLoader;
import kr.co.bizframe.mas.util.FileScanUtil;

public class ApplicationClassLoader extends URLClassLoader {

	private static Logger log = LoggerFactory.getLogger(ApplicationClassLoader.class);

	private String applicationId;

	private ClassLoader parent;

	private String contextDir;
	
	/*
	 * 상위 parent 로더에서 먼저 리소스 찾을지 여부
	 *  useParentFirst = false : 자기 로더에서 먼저 찾음
	 */
	protected boolean useParentFirst = false;

	/*
	 * 상위 parent 클래스 로더만 이용하고
	 * 자신의 로더는 사용하지 않음.
	 */
	protected boolean useParentOnly = false;

	public ApplicationClassLoader(String appId, String contextDir,
			ClassLoader parent){
		this(appId, contextDir, parent, false, false);
	}

	public ApplicationClassLoader(String appId, String contextDir,
			ClassLoader parent, boolean useParentOnly, boolean useParentFirst) {

		super(new URL[0], parent);
		this.applicationId = appId;
		this.contextDir = contextDir;
		this.parent = parent;
		if(parent == null) {
			  throw new IllegalArgumentException("no parent classloader");
		}

		this.useParentOnly = useParentOnly;
		this.useParentFirst = useParentFirst;

		addPath();
		setThreadContextClassLoader();

	}


	/**
	 *
	 *  application에서 보통 동적 클래스 로딩시
	 *	Thread.currentThread().getContextClassLoader() 호출하여
	 *	default 클래스 로더를 구하므로 이 매서드를 추가
	 *  applicaiton이 순차 로딩 되고 application이 스레드로 구성되므로 이 메서드가
	 *  유효
	 **/
	private void setThreadContextClassLoader(){
		if(!useParentOnly){
			Thread.currentThread().setContextClassLoader(this);
		}
	}


	
	private void addPath() {

		String classDir = "classes";
		String libDir = "lib";
		String confDir = "conf";
		
		File ccd = new File(contextDir, classDir);
		File ld = new File(contextDir, libDir);
		File confd = new File(contextDir, confDir);
		
		File[] fcds = new File[1];
		fcds[0] = ccd;

		File[] lds = new File[1];
		lds[0] = ld;

		File[] confds = new File[1];
		confds[0] = confd;
		
		try {
			addClassPaths(confds);
			addClassPaths(fcds);
			addLibPaths(lds);
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
	}

	
	
	private void addClassPaths(File[] classPaths) throws Exception {

		for (int ii = 0; ii < classPaths.length; ii++) {
			File file = classPaths[ii];
			if (!file.exists() || !file.canRead())
				continue;
			file = new File(file.getCanonicalPath() + File.separator);
			long lm = file.lastModified();

			URL url = file.toURL();
			log.info("application=[" + applicationId + "] load file = " + file);
			if(useParentOnly){
				AddableClassLoader cl = (AddableClassLoader)parent;
				cl.addURL(url);
			}else{
				addURL(url);
			}

		}
	}

	private void addLibPaths(File[] libPaths) throws Exception {
		
		/*
		for (int ii = 0; ii < libPaths.length; ii++) {
			File directory = libPaths[ii];
			if (!directory.isDirectory() || !directory.exists() || !directory.canRead())
				continue;
			String filenames[] = directory.list();
			for (int j = 0; j < filenames.length; j++) {
				String filename = filenames[j].toLowerCase();
				if (!filename.endsWith(".jar"))
					continue;
				File file = new File(directory, filenames[j]);
				URL url = file.toURL();
				log.info("application=[" + applicationId + "] load file = " + file);

				if (useParentOnly) {
					AddableClassLoader cl = (AddableClassLoader) parent;
					cl.addURL(url);
				} else {
					addURL(url);
				}
			}
		}
		*/
		
		for (File dir : libPaths) {

			List<File> jars = FileScanUtil.scanJarFiles(dir, true);
			for (File jar : jars) {
				URL url = jar.toURL();
				log.info("application=[" + applicationId + "] load file = " + jar);

				if (useParentOnly) {
					AddableClassLoader cl = (AddableClassLoader) parent;
					cl.addURL(url);
				} else {
					addURL(url);
				}
			}		
		}
		
	}
	
	
	
	public URL getResource(String name) {

		URL url = null;

		// parent 에서만 찾음
		if(useParentOnly){
			return getParentOnlyResource(name);
		}

		// useParentFirst 설정되면 상위에서 먼저 참음
		if (useParentFirst) {
			url = parent.getResource(name);
		}

		if (url == null) {
			url = this.findResource(name);
		}

		if (url == null) {
			url = parent.getResource(name);
		}

		return url;
	}


	private URL getParentOnlyResource(String name){
		URL url = parent.getResource(name);
		return url;
	}

	public Class loadClass(String name) throws ClassNotFoundException {
		return loadClass(name, false);
	}


	protected synchronized Class loadClass(String name, boolean resolve)
			throws ClassNotFoundException {

		Class clazz = findLoadedClass(name);
		ClassNotFoundException cnfe = null;

		// parent 에서만 찾음
		if(useParentOnly){
			log.info("use parent only classloader");
			return loadParentOnlyClass(name, resolve);
		}
			
		if(clazz == null && useParentFirst){
			try{
				clazz = parent.loadClass(name);
			}catch (ClassNotFoundException e){
				cnfe = e;
			}
		}

		if(clazz == null){
			try{
				clazz = this.findClass(name);
			}catch (ClassNotFoundException e){
				cnfe = e;
			}
		}

		if(clazz == null){
			try{
				clazz = parent.loadClass(name);
			}catch (ClassNotFoundException e){
				cnfe = e;
			}
		}

		 if (clazz == null) throw cnfe;
		 if (resolve) resolveClass(clazz);

		return clazz;
	}


	private Class loadParentOnlyClass(String name, boolean resolve)
			throws ClassNotFoundException {

		Class clazz = null;
		ClassNotFoundException cnfe = null;
		try{
			clazz = parent.loadClass(name);
		}catch (ClassNotFoundException e){
			cnfe = e;
		}
		if (clazz == null) throw cnfe;
		if (resolve) resolveClass(clazz);

		return clazz;
	}

	
}
