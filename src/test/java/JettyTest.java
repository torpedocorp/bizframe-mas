import java.io.File;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;

public class JettyTest {

	public static void main(String[] args) {
		Server server = new Server(8081);
		String appDir = "C:/tomcat/esb_sample/applications/test";
		WebAppContext context = new WebAppContext();		
		File classesDir = new File(appDir, "classes");
		File libDir = new File(appDir, "lib");

		File[] dir1 = { classesDir };
		File[] dir2 = { libDir };
		try {
		ClassLoader classLoader = createClassLoader(dir1, dir2, null, null);
		context.setClassLoader(classLoader);
		context.setDescriptor(appDir + "/webapp/web.xml");
		context.setResourceBase(appDir + "/webapp");
		context.setContextPath("/test");
		server.setHandler(context);
		
			server.start();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public static ClassLoader createClassLoader(File unpacked[], File packed[], URL urls[], ClassLoader parent) throws Exception {

		// System.out.println("createClassLoader()");
		ArrayList list = new ArrayList();

		// Add unpacked directories
		if (unpacked != null) {
			for (int i = 0; i < unpacked.length; i++) {
				File file = unpacked[i];
				if (!file.exists() || !file.canRead())
					continue;
				file = new File(file.getCanonicalPath() + File.separator);
				long lm = file.lastModified();

				URL url = file.toURL();
				list.add(url);
			}
		}

		// Add packed directory JAR files
		if (packed != null) {
			for (int i = 0; i < packed.length; i++) {
				File directory = packed[i];
				if (!directory.isDirectory() || !directory.exists() || !directory.canRead())
					continue;
				String filenames[] = directory.list();
				for (int j = 0; j < filenames.length; j++) {
					String filename = filenames[j].toLowerCase();
					if (!filename.endsWith(".jar"))
						continue;
					File file = new File(directory, filenames[j]);
					URL url = file.toURL();
					list.add(url);
				}
			}
		}

		// Add urls[]
		if (urls != null) {
			for (int i = 0; i < urls.length; i++) {
				URL url = urls[i];
				list.add(url);
			}
		}

		URL[] array = (URL[]) list.toArray(new URL[list.size()]);

		ClassLoader classLoader = null;
		if (parent == null) {
			classLoader = new URLClassLoader(array);
		} else {
			classLoader = new URLClassLoader(array, parent);
		}

		return classLoader;
	}
}
