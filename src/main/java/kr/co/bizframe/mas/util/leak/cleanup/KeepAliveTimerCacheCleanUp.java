package kr.co.bizframe.mas.util.leak.cleanup;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.ClassLoaderPreMortemCleanUp;
import kr.co.bizframe.mas.util.leak.MustBeAfter;

/**
 * Since Keep-Alive-Timer thread may have terminated, but still be referenced, we need to make sure it does not
 * reference this classloader.
 * @author Mattias Jiderhamn
 */
public class KeepAliveTimerCacheCleanUp implements ClassLoaderPreMortemCleanUp, MustBeAfter<ClassLoaderPreMortemCleanUp> {

  /** Needs to be done after {@link StopThreadsCleanUp}, since in there the Keep-Alive-Timer may be stopped. */
  @Override
  public Class<? extends ClassLoaderPreMortemCleanUp>[] mustBeBeforeMe() {
    return new Class[] {StopThreadsCleanUp.class};
  }

  @Override
  public void cleanUp(ClassLoaderLeakPreventor preventor) {
    Object keepAliveCache = preventor.getStaticFieldValue("sun.net.www.http.HttpClient", "kac", true);
    if(keepAliveCache != null) {
      final Thread keepAliveTimer = preventor.getFieldValue(keepAliveCache, "keepAliveTimer");
      if(keepAliveTimer != null) {
        if(preventor.isClassLoaderOrChild(keepAliveTimer.getContextClassLoader())) {
          keepAliveTimer.setContextClassLoader(preventor.getLeakSafeClassLoader());
          preventor.error("ContextClassLoader of sun.net.www.http.HttpClient cached Keep-Alive-Timer set to " + preventor.getLeakSafeClassLoader());
        }
      }
    }
    
  }
}