package kr.co.bizframe.mas.util;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class FileScanUtil {

	
	public static List<File> scanJarFiles(File dir, boolean nested){
		
		List<File> jfList = new ArrayList<File>();
		if (dir != null && dir.isDirectory()) {
			File[] files = dir.listFiles();
	
			for (File file : files) {
				if(nested && file.isDirectory()){
					List<File> fs = scanJarFiles(file, nested);
					jfList.addAll(fs);
				}else if(file.getName().endsWith(".jar")) {
					jfList.add(file);
				}
			}
		}
		return jfList;
	}
	

}
