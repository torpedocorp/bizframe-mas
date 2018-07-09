package kr.co.bizframe.mas.util.leak.preinit;

import java.lang.reflect.InvocationTargetException;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.PreClassLoaderInitiator;

/**
 * javax.security.auth.Policy.getPolicy() will keep a strong static reference to
 * the contextClassLoader of the first calling thread.
 * 
 * See http://java.jiderhamn.se/2012/02/26/classloader-leaks-v-common-mistakes-and-known-offenders/
 * 
 * @author Mattias Jiderhamn
 */
public class SecurityPolicyInitiator implements PreClassLoaderInitiator {
  @Override
  public void doOutsideClassLoader(ClassLoaderLeakPreventor preventor) {
    try {
      Class.forName("javax.security.auth.Policy")
          .getMethod("getPolicy")
          .invoke(null);
    }
    catch (IllegalAccessException iaex) {
      preventor.error(iaex);
    }
    catch (InvocationTargetException itex) {
      preventor.error(itex);
    }
    catch (NoSuchMethodException nsmex) {
      preventor.error(nsmex);
    }
    catch (ClassNotFoundException e) {
      // Ignore silently - class is deprecated
    }
  }
}