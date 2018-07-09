package kr.co.bizframe.mas.routing.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import kr.co.bizframe.mas.routing.Attachment;
import kr.co.bizframe.mas.routing.Message;

public class DefaultMessage implements Message {

	private static final long serialVersionUID = 2172900217376573297L;

	private String messageId;

	private String correlationId;

	private Map<String, String> headers = new HashMap<String, String>();

	private Map<String, Object> attributes = new HashMap<String, Object>();

	private Object body;

	private List<Attachment> attachments = new ArrayList<Attachment>();

	public DefaultMessage() {
		this.messageId = UUID.randomUUID().toString();
	}

	public DefaultMessage(String messageId) {
		this.messageId = messageId;
	}

	public String getMessageId() {
		return messageId;
	}

	public String getCorrelationId() {
		return correlationId;
	}

	public void setHeader(String name, String header) {
		if (name == null || header == null)
			throw new NullPointerException();
		headers.put(name, header);
	}

	public String getHeader(String name) {
		return headers.get(name);
	}

	public void setBody(Object obj) {
		this.body = obj;
	}

	public Object getBody() {
		return body;
	}

	public void setAttribute(String key, Object attr) {
		attributes.put(key, attr);
	}

	public Object getAttribute(String key) {
		return attributes.get(key);
	}

	public String getAttributeString(String key) {
		Object attr = attributes.get(key);
		if (attr != null) {
			return attr.toString();
		}
		return null;
	}

	public void addAttachment(Attachment attachment) {
		if (attachment == null)
			throw new NullPointerException();

		attachments.add(attachment);
	}

	public Attachment getAttachment(int ii) {
		return attachments.get(ii);
	}

	public List<Attachment> getAttachments() {
		return attachments;
	}

	@Override
	public String toString() {
		return "DefaultMessage [attachments=" + attachments + ", attributes="
				+ attributes + ", body=" + body + ", correlationId="
				+ correlationId + ", headers=" + headers + ", messageId="
				+ messageId + "]";
	}

}
