/**
 *  Copyright (c) 2014 Torpedo Inc..  All rights reserved.
 *
 */
package kr.co.bizframe.mas.command;

import java.io.Serializable;

/*
 *
 * @author Young-jun Bae
 */
public class CommandResponse implements Serializable {

	private static final long serialVersionUID = -1361932562692367111L;

	private Object result;

	private Throwable exception;
	
	public CommandResponse() {
	}

	public CommandResponse(Object result) {
		this.result = result;
	}

	public boolean isOK(){
		if(exception == null) return true;
		return false;
	}
	
	
	public Throwable getException() {
		return exception;
	}

	public void setException(Throwable exception) {
		this.exception = exception;
	}


	public void setException(String msg) {
		this.exception = new Exception(msg);
	}
	
	public Object getResult() {
		return result;
	}

	public void setResult(Object result) {
		this.result = result;
	}

	public String toString() {
		String cr = null;
		if (result != null)
			cr = result.toString();

		return cr;

	}
}
