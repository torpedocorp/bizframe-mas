package kr.co.bizframe.mas.util.leak.cleanup;

import java.lang.reflect.Field;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.ClassLoaderPreMortemCleanUp;

/**
 * Shutdown GeoTools cleaner thread as of https://osgeo-org.atlassian.net/browse/GEOT-2742
 * @author Mattias Jiderhamn
 */
public class GeoToolsCleanUp implements ClassLoaderPreMortemCleanUp {
  @Override
  public void cleanUp(ClassLoaderLeakPreventor preventor) {
    final Class<?> weakCollectionCleanerClass = preventor.findClass("org.geotools.util.WeakCollectionCleaner");
    if(weakCollectionCleanerClass != null) {
      try {
        final Field DEFAULT = preventor.findField(weakCollectionCleanerClass, "DEFAULT");
        weakCollectionCleanerClass.getMethod("exit").invoke(DEFAULT.get(null));
      }
      catch (Exception ex) {
        preventor.error(ex);
      }
    }
    
  }
}