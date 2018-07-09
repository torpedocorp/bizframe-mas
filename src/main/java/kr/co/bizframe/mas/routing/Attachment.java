package kr.co.bizframe.mas.routing;

import java.io.Serializable;

import javax.activation.DataHandler;

public interface Attachment extends Serializable {

	public String getId();

	public String getName();

	public DataHandler getDataHandler();

}
