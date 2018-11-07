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
