package kr.co.bizframe.mas.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;


public class ZipUtil {
	
	
	
	public static InputStream getEntryInputStream(File zipf, String name){
		
		try{
			ZipFile zipFile = new ZipFile(zipf);
			Enumeration<? extends ZipEntry> entries = zipFile.entries();
			
			while(entries.hasMoreElements()){
				ZipEntry entry = entries.nextElement();
				//System.out.println("entry = " + entry.getName());
				if(entry.getName().equals(name)){
					return zipFile.getInputStream(entry);
				}
			}			
			
		}catch(Exception e){
			throw new RuntimeException(e.getMessage(), e);
		}
		return null;
	}
	
	
	public static void deflateZip(File zipf, String destDir){
	
        FileInputStream fis;
        byte[] buffer = new byte[1024];
        try {
            fis = new FileInputStream(zipf);
            ZipInputStream zis = new ZipInputStream(fis);
            ZipEntry ze = zis.getNextEntry();
            while(ze != null){
                String fileName = ze.getName();
                File newFile = new File(destDir + File.separator + fileName);
               //System.out.println("Unzipping to "+newFile.getAbsolutePath());

                new File(newFile.getParent()).mkdirs();
                FileOutputStream fos = new FileOutputStream(newFile);
                int len;
                while ((len = zis.read(buffer)) > 0) {
                	fos.write(buffer, 0, len);
                }
                fos.close();
                zis.closeEntry();
                ze = zis.getNextEntry();
            }
            //close last ZipEntry
            zis.closeEntry();
            zis.close();
            fis.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        
		
	}

			
}
