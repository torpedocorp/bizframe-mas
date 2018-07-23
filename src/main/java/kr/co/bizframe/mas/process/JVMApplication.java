package kr.co.bizframe.mas.process;

import java.io.File;
import java.lang.reflect.Field;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecuteResultHandler;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteWatchdog;
import org.apache.commons.exec.ProcessDestroyer;
import org.apache.commons.exec.PumpStreamHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sun.jna.Pointer;
import com.sun.jna.platform.win32.Kernel32;
import com.sun.jna.platform.win32.WinNT;

import kr.co.bizframe.mas.application.ApplicationContext;
import kr.co.bizframe.mas.application.ApplicationException;

public class JVMApplication implements ProcessApplication {

	private static Logger log = LoggerFactory.getLogger(JVMApplication.class);

	private long pid = 0L;

	private DefaultExecuteResultHandler resultHandler;

	private ExecuteWatchdog watchdog;

	public void init(ApplicationContext context) throws ApplicationException {

		String java_home = context.getProperty("java_home");
		String main_class = context.getProperty("main_class");
		String options = context.getProperty("options", "");
		String arguments = context.getProperty("arguments", "");
		String work_dir = context.getProperty("work_dir");

		int wait_time = context.getIntProperty("wait_time", 500);

		String java = null;
		if (java_home != null) {
			java = "java";
		} else {
			java = java_home + "/bin/java";
		}

		String command = java + " " + options + " " + main_class + " "
				+ arguments;

		log.info("command =[" + command + "], work_dir=[" + work_dir + "]");

		CommandLine cmdLine = CommandLine.parse(command);
		watchdog = new ExecuteWatchdog(ExecuteWatchdog.INFINITE_TIMEOUT);

		resultHandler = new DefaultExecuteResultHandler();
		TargetProcessDestroyer pd = new TargetProcessDestroyer();

		DefaultExecutor executor = new DefaultExecutor();
		executor.setProcessDestroyer(pd);
		executor.setWorkingDirectory(new File(work_dir));
		executor.setExitValue(1);
		executor.setWatchdog(watchdog);
		executor.setStreamHandler(new PumpStreamHandler(System.out));

		try {
			executor.execute(cmdLine, resultHandler);
			Thread.sleep(wait_time);
		} catch (Throwable t) {
			throw new ApplicationException(t.getMessage(), t);
		}

		if (resultHandler.hasResult()) {
			Exception e = resultHandler.getException();
			if (e != null) {
				throw new ApplicationException(e.getMessage(), e);
			}
		}
		Process p = pd.getProcess();
		pid = getPID(p);

		log.info("jvm pid =[" + pid + "] created");
	}

	
	public void destroy(ApplicationContext context) throws ApplicationException {

		if(watchdog.killedProcess()){
			log.info("application = ["+context.getId() +"] is already killed");
		}
		
		String stop_command = "kill -9 " + pid;
		int wait_time = context.getIntProperty("wait_time", 500);
		String work_dir = context.getProperty("work_dir");
		
		CommandLine cmdLine = CommandLine.parse(stop_command);
		DefaultExecuteResultHandler resultHandler = new DefaultExecuteResultHandler();
		
		DefaultExecutor executor = new DefaultExecutor();
		executor.setWorkingDirectory(new File(work_dir));
		executor.setExitValue(1);
		executor.setStreamHandler(new PumpStreamHandler(System.out));
		
		try {
			executor.execute(cmdLine, resultHandler);
			resultHandler.waitFor(1000*5);
		} catch (Throwable t) {
			throw new ApplicationException(t.getMessage(), t);
		}		
	
		
		try {
			watchdog.destroyProcess();
			Thread.sleep(wait_time);
		} catch (Throwable t) {
			throw new ApplicationException(t.getMessage(), t);
		}
	}

	
	public String getStatus() {
		
		String s = null;
		if(!watchdog.killedProcess()){
			s = " JVM PID=[" + pid + "], process alive. ";
		}else{
			s = " JVM PID=[" + pid + "], process exited. "
					+ " exit_code=[" + resultHandler.getExitValue() + "]";
		}
		return s;
	}

	
	private class TargetProcessDestroyer implements ProcessDestroyer {

		private Process process = null;

		public boolean add(Process process) {
			this.process = process;
			return true;
		}

		public boolean remove(Process process) {
			return true;
		}

		public Process getProcess() {
			return process;
		}

		public int size() {
			if (process != null)
				return 1;
			return 0;
		}

	}

	public static long getPID(Process p) {
		long result = -1;
		try {
			// for windows
			if (p.getClass().getName().equals("java.lang.Win32Process")
					|| p.getClass().getName().equals("java.lang.ProcessImpl")) {
				Field f = p.getClass().getDeclaredField("handle");
				f.setAccessible(true);
				long handl = f.getLong(p);
				Kernel32 kernel = Kernel32.INSTANCE;
				WinNT.HANDLE hand = new WinNT.HANDLE();
				hand.setPointer(Pointer.createConstant(handl));
				result = kernel.GetProcessId(hand);
				f.setAccessible(false);
			}
			// for unix based operating systems
			else if (p.getClass().getName().equals("java.lang.UNIXProcess")) {
				Field f = p.getClass().getDeclaredField("pid");
				f.setAccessible(true);
				result = f.getLong(p);
				f.setAccessible(false);
			}
		} catch (Exception ex) {
			result = -1;
		}
		return result;
	}

}
