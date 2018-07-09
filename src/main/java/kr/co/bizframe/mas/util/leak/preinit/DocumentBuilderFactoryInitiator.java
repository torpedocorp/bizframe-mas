package kr.co.bizframe.mas.util.leak.preinit;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.PreClassLoaderInitiator;

/**
 * The classloader of the first thread to call DocumentBuilderFactory.newInstance().newDocumentBuilder()
 * seems to be unable to garbage collection. Is it believed this is caused by some JVM internal bug.
 * 
 * See http://java.jiderhamn.se/2012/02/26/classloader-leaks-v-common-mistakes-and-known-offenders/
 * @author Mattias Jiderhamn
 */
public class DocumentBuilderFactoryInitiator implements PreClassLoaderInitiator {
  @Override
  public void doOutsideClassLoader(ClassLoaderLeakPreventor preventor) {
    try {
      javax.xml.parsers.DocumentBuilderFactory.newInstance().newDocumentBuilder();
    }
    catch (Exception ex) { // Example: ParserConfigurationException
      preventor.error(ex);
    }
                                            
  }
}