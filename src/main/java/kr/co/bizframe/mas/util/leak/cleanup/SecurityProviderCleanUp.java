package kr.co.bizframe.mas.util.leak.cleanup;

import java.util.HashSet;
import java.util.Set;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.ClassLoaderPreMortemCleanUp;

/**
 * Deregister custom security providers
 * @author Mattias Jiderhamn
 */
public class SecurityProviderCleanUp implements ClassLoaderPreMortemCleanUp {
  @Override
  public void cleanUp(ClassLoaderLeakPreventor preventor) {
    final Set<String> providersToRemove = new HashSet<String>();
    for(java.security.Provider provider : java.security.Security.getProviders()) {
      if(preventor.isLoadedInClassLoader(provider)) {
        providersToRemove.add(provider.getName());
      }
    }
    
    if(! providersToRemove.isEmpty()) {
      preventor.warn("Removing security providers loaded by protected ClassLoader: " + providersToRemove);
      for(String providerName : providersToRemove) {
        java.security.Security.removeProvider(providerName);
      }
    }
    
  }
}