package kr.co.bizframe.mas.process;

import java.io.File;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecuteResultHandler;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteWatchdog;
import org.apache.commons.exec.PumpStreamHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.bizframe.mas.application.ApplicationContext;
import kr.co.bizframe.mas.application.ApplicationException;

public class ScriptCommandApplication implements ProcessApplication {

	private static Logger log = LoggerFactory.getLogger(ScriptCommandApplication.class);

	private DefaultExecuteResultHandler startProcessResultHandler;
	
	private ExecuteWatchdog startProcessWatchdog;
	
	public void init(ApplicationContext context) throws ApplicationException {

		String start_command = context.getProperty("start_command");
		String work_dir = context.getProperty("work_dir");
		int wait_time = context.getIntProperty("wait_time", 500);
		
		log.info("start_command=["+start_command+"], work_dir=["+ work_dir+"]");
		
		CommandLine cmdLine = CommandLine.parse(start_command);
		startProcessWatchdog = new ExecuteWatchdog(ExecuteWatchdog.INFINITE_TIMEOUT);

		startProcessResultHandler = new DefaultExecuteResultHandler();
		
		DefaultExecutor executor = new DefaultExecutor();
		executor.setWorkingDirectory(new File(work_dir));
		executor.setExitValue(1);
		executor.setWatchdog(startProcessWatchdog);
		executor.setStreamHandler(new PumpStreamHandler(System.out));

		try {
			executor.execute(cmdLine, startProcessResultHandler);
			Thread.sleep(wait_time);
		} catch (Throwable t) {
			throw new ApplicationException(t.getMessage(), t);
		}
		
		if(startProcessResultHandler.hasResult()){
			Exception e = startProcessResultHandler.getException();
			if(e != null){
				throw new ApplicationException(e.getMessage(), e);
			}
		}

	}

	public void destroy(ApplicationContext context) throws ApplicationException {
		
		String stop_command = context.getProperty("stop_command");
		String work_dir = context.getProperty("work_dir");

		log.info("stop_command=["+stop_command+"], work_dir=["+ work_dir+"]");
		
		if(stop_command != null){
			
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
		
		}
		
		try{
			startProcessWatchdog.destroyProcess();
		}catch (Throwable t) {
			throw new ApplicationException(t.getMessage(), t);
		}	
	}

	
	
	public String getStatus() {
		
		String s = null;
		if(!startProcessWatchdog.killedProcess()){
			s = " process alive. ";
		}else{
			s = " process exited. "
					+ " exit_code=[" + startProcessResultHandler.getExitValue() + "]";
		}
		return s;
	}

}
