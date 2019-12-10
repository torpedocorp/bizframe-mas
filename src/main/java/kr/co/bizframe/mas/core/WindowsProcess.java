package kr.co.bizframe.mas.core;



import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.platform.win32.Kernel32;




public class WindowsProcess {
	
	
	
	public long getProcessId(){
		
		int pid = Kernel32.INSTANCE.GetCurrentProcessId();
		return pid;
	}
	
	
	private interface CLibrary extends Library {
	    CLibrary INSTANCE = (CLibrary) Native.loadLibrary("c", CLibrary.class);   
	    int getpid ();
	}
	
}
