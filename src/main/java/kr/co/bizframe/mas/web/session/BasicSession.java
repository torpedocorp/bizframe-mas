package kr.co.bizframe.mas.web.session;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.eclipse.jetty.server.session.AbstractSession;
import org.eclipse.jetty.util.IO;

public class BasicSession  extends AbstractSession {

	private static Logger log = LoggerFactory.getLogger(BasicSession.class);
	
	private final BasicSessionManager _hashSessionManager;
	
	private transient boolean _idled = false;

	private transient boolean _saveFailed = false;

	protected BasicSession(BasicSessionManager hashSessionManager,
			HttpServletRequest request) {
		super(hashSessionManager, request);
		this._hashSessionManager = hashSessionManager;
	}

	protected BasicSession(BasicSessionManager hashSessionManager,
			long created, long accessed, String clusterId) {
		super(hashSessionManager, created, accessed, clusterId);
		this._hashSessionManager = hashSessionManager;
	}

	protected void checkValid() {
		if (this._hashSessionManager._idleSavePeriodMs != 0L)
			deIdle();
		super.checkValid();
	}

	public void setMaxInactiveInterval(int secs) {
		super.setMaxInactiveInterval(secs);
		if ((getMaxInactiveInterval() > 0)
				&& (getMaxInactiveInterval() * 1000L / 10L < this._hashSessionManager._scavengePeriodMs))
			this._hashSessionManager.setScavengePeriod((secs + 9) / 10);
	}

	protected void doInvalidate() throws IllegalStateException {
		super.doInvalidate();

		if ((this._hashSessionManager._storeDir == null) || (getId() == null))
			return;
		String id = getId();
		File f = new File(this._hashSessionManager._storeDir, id);
		f.delete();
	}

	synchronized void save(boolean reactivate) {
		if ((isIdled()) || (this._saveFailed))
			return;
		
		
		if (log.isDebugEnabled()) {
			log.debug("Saving {} {}" +","+
					new Object[] { super.getId(), Boolean.valueOf(reactivate) });
		}
		
		
		File file = null;
		FileOutputStream fos = null;
		try {
			file = new File(this._hashSessionManager._storeDir, super.getId());

			if (file.exists())
				file.delete();
			file.createNewFile();
			fos = new FileOutputStream(file);
			willPassivate();
			save(fos);
			if (reactivate)
				didActivate();
			else
				clearAttributes();
		} catch (Exception e) {
			saveFailed();

			log.warn("Problem saving session " + super.getId(), e);

			if (fos == null) {
				return;
			}
			IO.close(fos);

			file.delete();
			this._idled = false;
		}
	}

	public synchronized void save(OutputStream os) throws IOException {
		DataOutputStream out = new DataOutputStream(os);
		out.writeUTF(getClusterId());
		out.writeUTF(getNodeId());
		out.writeLong(getCreationTime());
		out.writeLong(getAccessed());

		out.writeInt(getRequests());
		out.writeInt(getAttributes());
		ObjectOutputStream oos = new ObjectOutputStream(out);
		Enumeration e = getAttributeNames();
		while (e.hasMoreElements()) {
			String key = (String) e.nextElement();
			oos.writeUTF(key);
			oos.writeObject(doGet(key));
		}
		oos.close();
	}

	public synchronized void deIdle() {
		if (!(isIdled())) {
			return;
		}
		access(System.currentTimeMillis());
		
		
		if (log.isDebugEnabled()) {
			log.debug("Deidling " + super.getId() +", "+ new Object[0]);
		}
		
		
		
		FileInputStream fis = null;
		try {
			File file = new File(this._hashSessionManager._storeDir,
					super.getId());
			if ((!(file.exists())) || (!(file.canRead()))) {
				throw new FileNotFoundException(file.getName());
			}
			fis = new FileInputStream(file);
			this._idled = false;
			this._hashSessionManager.restoreSession(fis, this);

			didActivate();

			if (this._hashSessionManager._savePeriodMs == 0L)
				file.delete();
		} catch (Exception e) {
			//LOG.warn("Problem deidling session " + super.getId(), e);
			IO.close(fis);
			invalidate();
		}
	}
	
	public void timeout(){
		super.timeout();
	}
	
	public synchronized void idle() {
		save(false);
	}

	public synchronized boolean isIdled() {
		return this._idled;
	}

	public synchronized boolean isSaveFailed() {
		return this._saveFailed;
	}

	public synchronized void saveFailed() {
		this._saveFailed = true;
	}
}
