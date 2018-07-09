package kr.co.bizframe.mas.util.leak.cleanup;

import java.lang.ref.WeakReference;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.ClassLoaderPreMortemCleanUp;

/**
 * Clean all {@link java.beans.ThreadGroupContext#beanInfoCache}s in {@link java.beans.ThreadGroupContext#contexts}
 * since they may contain beans/properties loaded in the protected classloader.
 * @author Mattias Jiderhamn
 */
public class ThreadGroupContextCleanUp implements ClassLoaderPreMortemCleanUp {
  @Override
  public void cleanUp(ClassLoaderLeakPreventor preventor) {
    final Object /*WeakIdentityMap<ThreadGroupContext>*/ contexts = preventor.getStaticFieldValue("java.beans.ThreadGroupContext", "contexts");
    if(contexts != null) { // Since Java 1.7
      // final WeakReference/*java.beans.WeakIdentityMap.Entry*/[] table = preventor.getFieldValue(contexts, "table");
      final Field tableField = preventor.findField(preventor.findClass("java.beans.WeakIdentityMap"), "table");
      if(tableField != null) {
        final WeakReference/*java.beans.WeakIdentityMap.Entry*/[] table = preventor.getFieldValue(tableField, contexts);
        if(table != null) {
          Method clearBeanInfoCache = null;
          for(WeakReference entry : table) {
            if(entry != null) {
              Object /*ThreadGroupContext*/ context = preventor.getFieldValue(entry, "value");
              if(context != null) {
                if(clearBeanInfoCache == null) { // FirstThreadGroupContext 
                  clearBeanInfoCache = preventor.findMethod(context.getClass(), "clearBeanInfoCache");
                }

                try {
                  clearBeanInfoCache.invoke(context);
                }
                catch (Exception e) {
                  preventor.error(e);
                }
              }
            }
          }
        }
      }
    }
  }
}