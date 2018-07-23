package kr.co.bizframe.mas.test.applicatoin;

import java.io.File;

public class DirTest {
	
	
	public void test(){
		
		String s = "./imsi";
		
		File f = new File(s);
		System.out.println("f  = " + f);
		
		String s2 = "/test1/test2/";
		
		File f2 = new File(s2 + s);
		System.out.println("f2  = " + f2);
		
	}
	
	public static void main(String[] argv){
		
		DirTest dt = new DirTest();
		dt.test();
	}
}
