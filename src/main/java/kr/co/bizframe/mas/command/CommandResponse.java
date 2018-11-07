/*
 * Copyright 2018 Torpedo corp.
 *  
 * bizframe mas project licenses this file to you under the Apache License,
 * version 2.0 (the "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at:
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
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
