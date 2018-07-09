package kr.co.bizframe.mas.util.leak.cleanup;

import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import kr.co.bizframe.mas.util.leak.ClassLoaderLeakPreventor;
import kr.co.bizframe.mas.util.leak.ClassLoaderPreMortemCleanUp;

/**
 * Deregister JDBC drivers loaded by classloader
 * @author Mattias Jiderhamn
 */
public class DriverManagerCleanUp implements ClassLoaderPreMortemCleanUp {
  @Override
  public void cleanUp(ClassLoaderLeakPreventor preventor) {
    final List<Driver> driversToDeregister = new ArrayList<Driver>();
    final Enumeration<Driver> allDrivers = DriverManager.getDrivers();
    
    while(allDrivers.hasMoreElements()) {
      final Driver driver = allDrivers.nextElement();
      if(preventor.isLoadedInClassLoader(driver)) // Should be true for all returned by DriverManager.getDrivers()
    	  driversToDeregister.add(driver);
    }
    
    for(Driver driver : driversToDeregister) {
      try {
        preventor.warn("JDBC driver loaded by protected ClassLoader deregistered: " + driver.getClass());
        DriverManager.deregisterDriver(driver);
      }
      catch (SQLException e) {
        preventor.error(e);
      }
    }
  }
}