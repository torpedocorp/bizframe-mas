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

public class CommandProcessor {

	public CommandResponse process(Command cmd) {

		String ct = cmd.getCommand();

		CommandResponse cr = null;

		/*
		 * if (cmd instace) { //EsbEngine engine = EsbEngine.getInstance();
		 * //String version = engine.getVersion(); String version = null;;
		 * 
		 * cr = new CommandResponse(); cr.setResultValue(version);
		 * 
		 * } else { String retValue =
		 * "canot process command. unknown command=["+ ct+"]"; cr = new
		 * CommandResponse(); cr.setResultValue(retValue); }
		 */

		return cr;
	}
}
