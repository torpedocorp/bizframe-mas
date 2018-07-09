/**
 *  Copyright (c) 2014 Torpedo Inc..  All rights reserved.
 *
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
