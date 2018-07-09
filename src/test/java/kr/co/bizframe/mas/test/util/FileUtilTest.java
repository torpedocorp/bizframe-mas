package kr.co.bizframe.mas.test.util;

import java.io.File;

import kr.co.bizframe.mas.util.FileUtil;

public class FileUtilTest {
	
	
	public void testGetFileName(){
		String s = FileUtil.getFileName(new File("D:/work/프로젝트/camel/text1.xml"), false);
		System.out.println("file name= " + s);
	}
	
	public void testNormalize(){
		String s1 = FileUtil.normalize("D:\\test//test11.txt");
		System.out.println("s1 = " + s1);
		
		String s2 = FileUtil.normalize("D:/test/test.txt");
		System.out.println("s2 = " + s2);
		
		File f = new File(s1);
		System.out.println("exist =" +f.exists());
	}
	
	public static void main(String[] argv){
		
		FileUtilTest fut = new FileUtilTest();
		fut.testNormalize();
	}
}
