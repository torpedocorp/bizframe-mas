package kr.co.bizframe.mas.util;

import java.io.File;
import java.net.URI;
import java.nio.file.Path;
import java.nio.file.Paths;

public class FileUtil {
	
	
	public static String getFileName(File f, boolean withoutExt){
		
		String name = f.getName();
		if(withoutExt){
			int i = name.lastIndexOf(".");
			name = name.substring(0, i);
		}
		return name;
	}
	
	
	public static String normalize(String fs){
		
		Path path = Paths.get(fs);
		return path.normalize().toString();
		
	}
}
