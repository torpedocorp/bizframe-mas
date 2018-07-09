package kr.co.bizframe.mas.util.leak.cleanup;

import java.lang.ref.Reference;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.ClassLoaderPreMortemCleanUp;

/**
 * {@link ClassLoaderPreMortemCleanUp} that does not clear {@link ThreadLocal}s to remove the leak, but only logs a 
 * warning
 * @author Mattias Jiderhamn
 */
@SuppressWarnings("unused")
public class WarningThreadLocalCleanUp extends ThreadLocalCleanUp {

  /**
   * Log not {@link ThreadLocal#remove()}ed leak as a warning. 
   */
  protected void processLeak(ClassLoaderLeakPreventor preventor, Thread thread, Reference<?> entry, 
                             ThreadLocal<?> threadLocal, Object value, String message) {
    preventor.warn(message);
  } 
}