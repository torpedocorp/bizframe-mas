package kr.co.bizframe.mas.util.leak.preinit;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.PreClassLoaderInitiator;

/**
 * Loading the class sun.java2d.Disposer will spawn a new thread with the same contextClassLoader.
 * <a href="https://issues.apache.org/bugzilla/show_bug.cgi?id=51687">More info</a>.
 * 
 * See http://java.jiderhamn.se/2012/02/26/classloader-leaks-v-common-mistakes-and-known-offenders/
 * 
 * @author Mattias Jiderhamn
 */
public class Java2dDisposerInitiator implements PreClassLoaderInitiator {
  @Override
  public void doOutsideClassLoader(ClassLoaderLeakPreventor preventor) {
    try {
      Class.forName("sun.java2d.Disposer"); // Will start a Thread
    }
    catch (ClassNotFoundException cnfex) {
      if(preventor.isOracleJRE() && ! preventor.isJBoss()) // JBoss blocks this package/class, so don't warn
        preventor.error(cnfex);
    }
    
  }
}