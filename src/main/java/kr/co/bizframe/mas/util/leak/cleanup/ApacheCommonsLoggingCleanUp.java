package kr.co.bizframe.mas.util.leak.cleanup;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.ClassLoaderPreMortemCleanUp;

/**
 * Release this classloader from Apache Commons Logging (ACL) by calling 
 * {@code LogFactory.release(getCurrentClassLoader());}
 * Use reflection in case ACL is not present.
 * Tip: Do this last, in case other shutdown procedures want to log something.
 * 
 * @author Mattias Jiderhamn
 */
public class ApacheCommonsLoggingCleanUp implements ClassLoaderPreMortemCleanUp {
  @Override
  public void cleanUp(ClassLoaderLeakPreventor preventor) {
    final Class<?> logFactory = preventor.findClass("org.apache.commons.logging.LogFactory");
    if(logFactory != null) { // Apache Commons Logging present
      preventor.info("Releasing web app classloader from Apache Commons Logging");
      try {
        logFactory.getMethod("release", java.lang.ClassLoader.class)
            .invoke(null, preventor.getClassLoader());
      }
      catch (Exception ex) {
        preventor.error(ex);
      }
    }
    
  }
}