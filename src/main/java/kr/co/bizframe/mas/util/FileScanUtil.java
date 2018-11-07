/*
 * Copyright 2018 Torpedo corp.
 *  
 * bizframe mas project licenses this file to you under the Apache License,
 * version 2.0 (the "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at:
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */

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
