package kr.co.bizframe.mas.core;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.platform.win32.Kernel32;



public class MasProcess {
	
	private static Logger log = LoggerFactory.getLogger(MasProcess.class);

	private String homeDir;
	
	public MasProcess(String homeDir){
		this.homeDir = homeDir;
	}
	
	
	public void create(){
		long pid = getProcessId();
		log.info("mas process id=["+pid+"]");
		createProcessIdFile(pid);
	}
	
	
	public void destroy(){

		try{
			long pid = getProcessIdFromFile();
			log.info("process kill pid = "+ pid);
			String cmd = null;
			if(isWindows()){
				cmd = "Taskkill /PID "+ pid;
			}else{
				cmd = "kill -9 " + pid;
			}
			Runtime.getRuntime().exec(cmd);
		}catch(Exception e){
			log.error(e.getMessage(), e);
		}
	}
	
	private void createProcessIdFile(long pid) {
		FileWriter fw = null;
		try{
			File f = new File(homeDir+"/bin/pid");
			f.deleteOnExit();
			
			fw = new FileWriter(f);
			fw.write(Long.toString(pid));
		}catch(Exception e){
			log.error(e.getMessage(), e);
		}finally{
			try{
				fw.close();
			}catch(Exception e){
				//mute
			}
		}
	}
	
	
	private long getProcessIdFromFile() {
		long pid = 0;
		FileReader fr = null;
		try{
			File f = new File(homeDir+"/bin/pid");
			fr = new FileReader(f);
			BufferedReader br = new BufferedReader(fr);
			String pids = br.readLine();
			pid = Long.parseLong(pids);
		}catch(Exception e){
			log.error(e.getMessage(), e);
		}finally{
			try{
				fr.close();
			}catch(Exception e){
				//mute
			}
		}
		return pid;
	}
	
	
	private long getProcessId(){
		
		if(isWindows()){
			int pid = Kernel32.INSTANCE.GetCurrentProcessId();
			return pid;
		}else{
			int pid = CLibrary.INSTANCE.getpid();
			return pid;
		}
	}
	
	
	private interface CLibrary extends Library {
	    CLibrary INSTANCE = (CLibrary) Native.loadLibrary("c", CLibrary.class);   
	    int getpid ();
	}
	
	public static boolean isWindows() {
		String os = System.getProperty("os.name").toLowerCase();
        return (os.indexOf("win") >= 0);
    }
	
	
}
