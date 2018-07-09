package kr.co.bizframe.mas.test.engine;

import com.sun.jna.Library;
import com.sun.jna.Native;
import com.sun.jna.platform.win32.Kernel32;

public class PIdTest {
	
	
	public void testWindow(){
		int pid = Kernel32.INSTANCE.GetCurrentProcessId();
		System.out.println("pid = " + pid);
	}
	
	public void testUnix(){
		int pid = CLibrary.INSTANCE.getpid();
		System.out.println("pid = " + pid);
	}
	
	
	private interface CLibrary extends Library {
	    CLibrary INSTANCE = (CLibrary) Native.loadLibrary("c", CLibrary.class);   
	    int getpid ();
	}
	
	
	public static void main(String[] argv){
		
		PIdTest pt = new PIdTest();
		pt.testWindow();
		//pt.testUnix();
	}
}
