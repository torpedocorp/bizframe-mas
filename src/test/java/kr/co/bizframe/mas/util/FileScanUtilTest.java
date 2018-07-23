package kr.co.bizframe.mas.util;

import java.io.File;
import java.util.List;

public class FileScanUtilTest {
	
	
	public void test(){
		
		
		File dir = new File("D:/mas2/lib/extended/");
		List<File> files = FileScanUtil.scanJarFiles(dir, false);
		
		for(File f : files){
			System.out.println("file = " + f);
		}
	}
	
	public static void main(String[] argv){
		
		FileScanUtilTest fsut = new FileScanUtilTest();
		fsut.test();
	}
}
