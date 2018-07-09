package kr.co.bizframe.mas.util.leak.cleanup;

import java.beans.PropertyEditorManager;
import java.lang.reflect.Field;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.ClassLoaderPreMortemCleanUp;

/**
 * Deregister custom property editors.
 * This has been fixed in Java 7.
 * @author Mattias Jiderhamn
 */
public class PropertyEditorCleanUp implements ClassLoaderPreMortemCleanUp {
  @Override
  public void cleanUp(ClassLoaderLeakPreventor preventor) {
    final Field registryField = preventor.findField(PropertyEditorManager.class, "registry");
    if(registryField == null) {
      preventor.error("Internal registry of " + PropertyEditorManager.class.getName() + " not found");
    }
    else {
      try {
        synchronized (PropertyEditorManager.class) {
          final Map<Class<?>, Class<?>> registry = (Map<Class<?>, Class<?>>) registryField.get(null);
          if(registry != null) { // Initialized
            final Set<Class<?>> toRemove = new HashSet<Class<?>>();
            
            for(Map.Entry<Class<?>, Class<?>> entry : registry.entrySet()) {
              if(preventor.isLoadedByClassLoader(entry.getKey()) ||
                 preventor.isLoadedByClassLoader(entry.getValue())) { // More likely
                toRemove.add(entry.getKey());
              }
            }
            
            for(Class<?> clazz : toRemove) {
              preventor.warn("Property editor for type " + clazz +  " = " + registry.get(clazz) + " needs to be deregistered");
              PropertyEditorManager.registerEditor(clazz, null); // Deregister
            }
          }
        }
      }
      catch (Exception e) { // Such as IllegalAccessException
        preventor.error(e);
      }
    }
  }
}