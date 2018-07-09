package kr.co.bizframe.mas.application;

public class ApplicationException extends Exception {

	private static final long serialVersionUID = 5947988430130168102L;

	public ApplicationException() {
		super();
	}

	public ApplicationException(String message) {
		super(message);
	}

	public ApplicationException(Throwable cause) {
		super(cause);
	}

	public ApplicationException(String message, Throwable cause) {
		super(message, cause);
	}

}
