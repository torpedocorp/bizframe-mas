package kr.co.bizframe.mas;

import kr.co.bizframe.mas.application.ApplicationContext;
import kr.co.bizframe.mas.application.ApplicationException;

public interface Application {

	public void init(ApplicationContext context) throws ApplicationException;

	public void destroy(ApplicationContext context) throws ApplicationException;
	
}
