package kr.co.bizframe.mas.boot;

import java.io.File;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import kr.co.bizframe.mas.util.AddableClassLoader;
import kr.co.bizframe.mas.util.FileScanUtil;


public class Main {

	public static final String BOOT_CLASS = "kr.co.bizframe.mas.boot.Bootstrap";

	private String DEFAULT_HOME_DIR = "../";

	private String homeDir;

	private String confDir = "conf";

	private String systemLibDir = "lib/system";

	private String extendedLibDir = "lib/extended";

	private Set<File> classPaths = new HashSet<File>();

	private Set<File> libPaths = new HashSet<File>();

	public static void main(String[] argv) throws Throwable {
		Main main = new Main();
		main.execute(argv);
	}

	public void execute(String[] argv) throws Throwable {

		// ///////////////////////////////////////////////////////////////
		// 프로퍼티 확인
		// Properties envProps= System.getProperties();
		// envProps.list(System.out);
		// ///////////////////////////////////////////////////////////////
		
		//Map<String, String> env = System.getenv();
        //for (String envName : env.keySet()) {
        //   System.out.println("env properties " + envName + "=" + env.get(envName));
        //}

		String command = null;
		if (argv != null && argv.length > 0) {
			command = argv[0];
		}
		
		// 코드가 어떤게 맞는지 확인 필요
		// 2017.07.04
		File home = new File(DEFAULT_HOME_DIR);
		homeDir = System.getProperty("bizframe.mas.home", home.getCanonicalPath());
		//homeDir = System.getenv("MAS_HOME");
		//if(homeDir == null){
		//	homeDir = DEFAULT_HOME_DIR;
		//}
		System.out.println("MAS_HOME = " + homeDir);
		
		// mas 홈 경로 설정
		File fcd = new File(homeDir, confDir);
		File systemLd = new File(homeDir, systemLibDir);
		File extendedLd = new File(homeDir, extendedLibDir);

		addClassPath(fcd);
		addLibPath(systemLd);

		if ("start".equalsIgnoreCase(command)) {
			addLibPath(extendedLd);
		}

		runTask(command);
	}

	private void runTask(String command) throws Throwable {

		ClassLoader cl = getClassLoader();
		Thread.currentThread().setContextClassLoader(cl);

		// System.out.println("command = " + command);
		try {
			Class task = cl.loadClass(BOOT_CLASS);
			Method runTask = null;

			Constructor constructor = task
					.getConstructor(new Class[] { String.class });
			Object instance = constructor.newInstance(homeDir);
			// command 가 start 일때
			if (command == null || command.equalsIgnoreCase("start")) {
				runTask = task.getMethod("start", new Class[] {});
				runTask.invoke(instance);
				// command 가 shutdown 일때
			} else if (command.equalsIgnoreCase("shutdown")) {
				runTask = task.getMethod("shutdown", new Class[] {});
				runTask.invoke(instance);
			} else if (command.equalsIgnoreCase("version")) {
				runTask = task.getMethod("version", new Class[] {});
				runTask.invoke(instance);
			} else if (command.equalsIgnoreCase("status")) {
				runTask = task.getMethod("status", new Class[] {});
				runTask.invoke(instance);
			} else {
				throw new Exception("invalid command = [" + command + "]");
			}

		} catch (InvocationTargetException e) {
			throw e.getCause();
		}
	}

	public ClassLoader getClassLoader() throws MalformedURLException {
		List<URL> urls = new ArrayList<URL>();

		for (File dir : classPaths) {
			if (dir != null && dir.isDirectory()) {
				System.out.println("[Bootstrap] load classes directory : "
						+ dir.getName());
				urls.add(dir.toURL());
			}
		}

		// sub directory 까지 scan 하도록 수정
		// 2018.01.22
		/*
		for (File dir : libPaths) {
			if (dir != null && dir.isDirectory()) {
				File[] files = dir.listFiles();
				for (int ii = 0; ii < files.length; ii++) {
					File file = files[ii];
					if (file.getName().endsWith(".jar")) {
						System.out.println("[Bootstrap] load jar module : "
								+ file.getName());
						urls.add(file.toURL());
					}
				}
			}
		}
		*/
		
		for (File dir : libPaths) {
			List<File> jarFiles = FileScanUtil.scanJarFiles(dir, true);
			for(File jar : jarFiles){
		
				URL url = jar.toURL();
				System.out.println("[Bootstrap] load jar module : "+ url);
				urls.add(url);
			}
		}
		
		URL u[] = new URL[urls.size()];
		urls.toArray(u);
		ClassLoader classLoader = new AddableClassLoader(u, this.getClass()
				.getClassLoader());

		Thread.currentThread().setContextClassLoader(classLoader);
		return classLoader;
	}
	
	
	
	
	private void addClassPath(File path) {
		classPaths.add(path);
	}

	private void addLibPath(File path) {
		libPaths.add(path);
	}

}
