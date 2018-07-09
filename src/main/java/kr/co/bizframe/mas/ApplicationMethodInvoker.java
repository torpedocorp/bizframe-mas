package kr.co.bizframe.mas;

import kr.co.bizframe.mas.routing.Exchange;

public interface ApplicationMethodInvoker {

	public Object invoke(Exchange exchange) throws Exception;
}
