package kr.co.bizframe.mas.util.leak.cleanup;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.ClassLoaderPreMortemCleanUp;

/**
 * Clear {@link java.beans.Introspector} cache
 * @author Mattias Jiderhamn
 */
public class BeanIntrospectorCleanUp implements ClassLoaderPreMortemCleanUp {
  @Override
  public void cleanUp(ClassLoaderLeakPreventor preventor) {
    java.beans.Introspector.flushCaches(); // Clear cache of strong references
  }
}