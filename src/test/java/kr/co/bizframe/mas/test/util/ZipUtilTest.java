package kr.co.bizframe.mas.test.util;

import java.io.File;

import kr.co.bizframe.mas.util.ZipUtil;

public class ZipUtilTest {
	
	
	public void test(){
		
		ZipUtil.deflateZip(new File("D:/test/test.zip"), "d:/test1/");
	}
	
	
	public static void main(String[] argv){
		
		ZipUtilTest zut = new ZipUtilTest();
		zut.test();
	}
}
