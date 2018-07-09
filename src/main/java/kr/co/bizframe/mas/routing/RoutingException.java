package kr.co.bizframe.mas.routing;

public class RoutingException extends Exception {

	public RoutingException() {
		super();
	}

	public RoutingException(String message) {
		super(message);
	}

	public RoutingException(Throwable cause) {
		super(cause);
	}

	public RoutingException(String message, Throwable cause) {
		super(message, cause);
	}
}
