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
import java.io.InputStream;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;

public class XMLUtil {

	public static String getText(String tag, Element ele) {
		return getText(tag, ele, false);
	}

	public static String getText(String tag, Element ele, boolean optional) {
		if (ele == null) {
			throw new RuntimeException("element is not found");
		}

		Element ele_child = ele.getChild(tag);


		if (!optional && ele_child == null) {
			throw new RuntimeException("tag=[" + tag + "] element is not found");
		}

		if (ele_child != null) {
			return ele_child.getText();
		}
		return null;
	}

	public static String getAttribute(String attName, Element ele) {

		if (ele == null) {
			throw new RuntimeException("element is not found");
		}
		return ele.getAttributeValue(attName);

	}

	public static Element getRootElement(InputStream is) throws Exception {

		try {
			SAXBuilder builder = new SAXBuilder(false);
			Document confRoot = builder.build(is);
			Element rootConfEle = confRoot.getRootElement();

			return rootConfEle;
		} catch (Exception e) {
			throw e;
		}
	}

	
	public static Element getRootElement(File confFile) throws Exception {

		try {
			SAXBuilder builder = new SAXBuilder(false);
			Document confRoot = builder.build(confFile);
			Element rootConfEle = confRoot.getRootElement();

			return rootConfEle;
		} catch (Exception e) {
			throw e;
		}
	}

}
