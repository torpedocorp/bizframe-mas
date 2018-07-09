package kr.co.bizframe.mas.test.applicatoin;

import java.util.LinkedHashSet;
import java.util.Set;

public class CollectionTest {
	
	public void test(){
		
		Set<String> s = new LinkedHashSet<String>();
		s.add("3");
		s.add("1");
		s.add("4");
		s.add("5");
		s.add("5");
		
		for(String v : s){
			System.out.println(" v = " + v);
		}
	}
	
	
	public static void main(String[] argv){
		
		CollectionTest ct = new CollectionTest();
		ct.test();
	}
}
