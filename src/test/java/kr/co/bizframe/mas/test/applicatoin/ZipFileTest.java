package kr.co.bizframe.mas.test.applicatoin;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.net.URI;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;


public class ZipFileTest {
	
	
	public void scanZipFileSystemApp(File f){
		
		try{
			//FileInputStream input = new FileInputStream(zipFile);
			//ZipInputStream zip = new ZipInputStream(input);
			
			ZipFile zipFile = new ZipFile(f);
			Enumeration<? extends ZipEntry> entries = zipFile.entries();
			while(entries.hasMoreElements()){
				ZipEntry entry = entries.nextElement();
				System.out.println("entry = " + entry);
				InputStream stream = zipFile.getInputStream(entry);
				
			}			
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	public void test2(Path zipFile){

		try{
			Map<String, String> env = new HashMap<String, String>();
			env.put("create", "true");
			URI uri = URI.create("jar:" + zipFile.toUri());       
			FileSystem fileSystem = FileSystems.newFileSystem(uri, env);
			Iterable<Path> roots = fileSystem.getRootDirectories();
		
			URL[] urls = new URL[15];
			
			int i=0;
			for(Path path : roots){
				System.out.println("root =" + path);
				Stream<Path> sp = Files.list(path);
				List<Path> list = sp.collect(Collectors.toList());
				for(Path ip : list){
					System.out.println("path = " + ip.getFileName());
					System.out.println(ip.toUri());
					System.out.println("i =" + i);
					urls[i] = ip.toUri().toURL();
					i++;
				}
			}
			
			
			Path ap = fileSystem.getPath("/application.xml");
			System.out.println("path = " + ap.getFileName());
			System.out.println(ap.toUri());
			//ZipClassLoader cl = new ZipClassLoader("D:/mas/imsi/spring.zip", urls, Thread.currentThread().getContextClassLoader());
			//cl.loadClass("com.fasterxml.jackson.core.type.TypeReference");

		}catch(Exception e){
			e.printStackTrace();
		}
	
	}
	
	
	public static void main(String[] argv){
		ZipFileTest zft = new ZipFileTest();
		//zft.scanZipFileSystemApp(new File("D:/mas/imsi/spring.zip"));
		zft.test2(Paths.get("D:/mas/imsi/spring.zip"));
	}
}
