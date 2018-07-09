package kr.co.bizframe.mas.routing.impl;

import java.util.UUID;

import javax.activation.DataHandler;

import kr.co.bizframe.mas.routing.Attachment;

public class DefaultAttachment implements Attachment {

	/**
	 *
	 */
	private static final long serialVersionUID = 4197964497494705869L;

	private String id;

	private String name;

	private DataHandler dataHandler;

	public DefaultAttachment() {
		this.id = UUID.randomUUID().toString();
	}

	public DefaultAttachment(String id) {
		this.id = id;
	}

	public String getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setId(String id) {
		this.id = id;
	}

	public DataHandler getDataHandler() {
		return dataHandler;
	}

	public void setDataHandler(DataHandler dataHandler) {
		this.dataHandler = dataHandler;
	}

}
