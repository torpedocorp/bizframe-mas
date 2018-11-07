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

package kr.co.bizframe.mas.application;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class ApplicationContextUtils {

	private static Map<String, ApplicationContext> smaps = new HashMap<String, ApplicationContext>();

	private static Map<ClassLoader, String> cmaps = new HashMap<ClassLoader, String>();
	
	public static void putApplicationContext(String applicationId,
			ApplicationContext context) {
		smaps.put(applicationId, context);
	}

	public static ApplicationContext getApplicationContext(String applicationId) {
		return smaps.get(applicationId);
	}

	public static void removeApplicationContext(String applicationId) {
		smaps.remove(applicationId);
	}

	public static void putApplicationId(ClassLoader loader, String applicationId) {
		cmaps.put(loader, applicationId);
	}

	
	public static String getApplicationId(Class clazz) {

		if (clazz != null) {
			ClassLoader loader = clazz.getClassLoader();
			return getApplicationId(loader);
		}
		return null;
	}

	public static String getApplicationId(ClassLoader loader) {
		String id = cmaps.get(loader);
		if (id == null) {
			ClassLoader parent = loader.getParent();
			if (parent == null)
				return null;
			return getApplicationId(parent);
		}
		return id;
	}


	
	public static void removeApplicationId(ClassLoader loader) {
		cmaps.remove(loader);
	}

	
	
	public static void list() {

		System.out.println("=================================");
		Set<ClassLoader> keys = cmaps.keySet();
		for (ClassLoader key : keys) {
			System.out.println("key= " + key);
			System.out.println("value=" + cmaps.get(key));
		}
	}

	

}
