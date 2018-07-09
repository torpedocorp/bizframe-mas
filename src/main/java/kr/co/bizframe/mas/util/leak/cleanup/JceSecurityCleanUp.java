package kr.co.bizframe.mas.util.leak.cleanup;

import java.net.URL;
import java.security.Provider;
import java.util.Map;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.ClassLoaderPreMortemCleanUp;

/**
 * Clean up for the static caches of {@link javax.crypto.JceSecurity}
 * @author Mattias Jiderhamn
 */
public class JceSecurityCleanUp implements ClassLoaderPreMortemCleanUp {
  
  @SuppressWarnings("SynchronizationOnLocalVariableOrMethodParameter")
  @Override
  public void cleanUp(ClassLoaderLeakPreventor preventor) {
    final Class<?> javax_crypto_JceSecurity = preventor.findClass("javax.crypto.JceSecurity");
    if(javax_crypto_JceSecurity != null) {
      synchronized (javax_crypto_JceSecurity) { // synchronized methods are used for querying and updating the caches
        final Map<Provider, Object> verificationResults = preventor.getStaticFieldValue(javax_crypto_JceSecurity, "verificationResults");
        final Map<Provider, Object> verifyingProviders = preventor.getStaticFieldValue(javax_crypto_JceSecurity, "verifyingProviders");
        final Map<Class<?>, URL> codeBaseCacheRef = preventor.getStaticFieldValue(javax_crypto_JceSecurity, "codeBaseCacheRef");
        
        if(verificationResults != null) {
          verificationResults.clear();
        }
        if(verifyingProviders != null) {
          verifyingProviders.clear();
        }
        if(codeBaseCacheRef != null) {
          codeBaseCacheRef.clear();
        }
      }
    }
  }
}