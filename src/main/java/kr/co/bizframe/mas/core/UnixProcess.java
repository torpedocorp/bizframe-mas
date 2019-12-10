package kr.co.bizframe.mas.core;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sun.jna.platform.win32.Kernel32;

public class UnixProcess {
	
	private static Logger log = LoggerFactory.getLogger(UnixProcess.class);
	
	public long getProcessId(){
		try {
			int pid = Kernel32.INSTANCE.GetCurrentProcessId();
			return pid;
			
		}catch(Throwable t) {
			try {
				getprocessIdFromJmx();
			}catch(Exception e) {
				log.error(e.getMessage(), e);
			}
		}
		return 0;
	}
	
	/*
	private interface CLibrary extends Library {
	    CLibrary INSTANCE = (CLibrary) Native.loadLibrary("c", CLibrary.class);   
	    int getpid ();
	}
	*/
	
	
	private long getprocessIdFromJmx() {
		try {
			java.lang.management.RuntimeMXBean runtime = 
			    java.lang.management.ManagementFactory.getRuntimeMXBean();
			java.lang.reflect.Field jvm = runtime.getClass().getDeclaredField("jvm");
			jvm.setAccessible(true);
			sun.management.VMManagement mgmt =  
			    (sun.management.VMManagement) jvm.get(runtime);
			java.lang.reflect.Method pid_method =  
			    mgmt.getClass().getDeclaredMethod("getProcessId");
			pid_method.setAccessible(true);

			int pid = (Integer) pid_method.invoke(mgmt);
			return pid;
		}catch(Exception e) {
			throw new RuntimeException(e.getMessage(), e);
		}
		
	}
}
