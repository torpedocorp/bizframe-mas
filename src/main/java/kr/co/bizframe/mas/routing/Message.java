package kr.co.bizframe.mas.routing;

import java.io.Serializable;
import java.util.List;

public interface Message extends Serializable {

	public String getMessageId();

	public String getCorrelationId();

	public String getHeader(String name);

	public Object getAttribute(String key);

	public String getAttributeString(String key);

	public Object getBody();

	public List<Attachment> getAttachments();

}
