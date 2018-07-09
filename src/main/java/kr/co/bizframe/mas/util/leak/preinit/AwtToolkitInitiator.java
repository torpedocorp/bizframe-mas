package kr.co.bizframe.mas.util.leak.preinit;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.PreClassLoaderInitiator;

/**
 * The first call to java.awt.Toolkit.getDefaultToolkit() will spawn a new thread with the
 * same contextClassLoader as the caller.
 * 
 * See http://java.jiderhamn.se/2012/02/26/classloader-leaks-v-common-mistakes-and-known-offenders/
 * @author Mattias Jiderhamn
 */
public class AwtToolkitInitiator implements PreClassLoaderInitiator {
  @Override
  public void doOutsideClassLoader(ClassLoaderLeakPreventor preventor) {
    try {
      java.awt.Toolkit.getDefaultToolkit(); // Will start a Thread
    }
    catch (Throwable t) {
      preventor.error(t);
      preventor.warn("Consider adding -Djava.awt.headless=true to your JVM parameters");
    }
    
  }
}