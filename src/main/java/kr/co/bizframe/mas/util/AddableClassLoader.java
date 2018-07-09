package kr.co.bizframe.mas.util;

import java.net.URL;
import java.net.URLClassLoader;

public class AddableClassLoader extends URLClassLoader {

	public AddableClassLoader(URL[] urls, ClassLoader parent) {
		super(urls, parent);
	}

	public AddableClassLoader(URL[] urls) {
		super(urls);
	}


	public void addURL(URL url) {
		super.addURL(url);
	}

}
