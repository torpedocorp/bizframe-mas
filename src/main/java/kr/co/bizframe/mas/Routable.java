package kr.co.bizframe.mas;

import kr.co.bizframe.mas.routing.Exchange;

public interface Routable {

	public void onMessage(Exchange exchange) throws Exception;
}
