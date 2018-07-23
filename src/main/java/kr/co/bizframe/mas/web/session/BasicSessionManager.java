package kr.co.bizframe.mas.web.session;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectStreamClass;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.eclipse.jetty.server.handler.ContextHandler;
import org.eclipse.jetty.server.session.AbstractSession;
import org.eclipse.jetty.server.session.AbstractSessionManager;

public class BasicSessionManager extends AbstractSessionManager {
	
	private static Logger log = LoggerFactory.getLogger(BasicSessionManager.class);
	
	protected final ConcurrentMap<String, BasicSession> _sessions = new ConcurrentHashMap();
	private static int __id;
	private Timer _timer;
	private boolean _timerStop = false;
	private TimerTask _task;
	long _scavengePeriodMs = 30000L;
	long _savePeriodMs = 0L;
	long _idleSavePeriodMs = 0L;
	private TimerTask _saveTask;
	File _storeDir;
	private boolean _lazyLoad = false;
	private volatile boolean _sessionsLoaded = false;
	private boolean _deleteUnrestorableSessions = false;

	public void doStart() throws Exception {
		super.doStart();

		this._timerStop = false;
		ServletContext context = ContextHandler.getCurrentContext();
		if (context != null)
			this._timer = ((Timer) context
					.getAttribute("org.eclipse.jetty.server.session.timer"));
		if (this._timer == null) {
			this._timerStop = true;
			this._timer = new Timer("HashSessionScavenger-" + (__id++), true);
		}

		setScavengePeriod(getScavengePeriod());

		if (this._storeDir != null) {
			if (!(this._storeDir.exists())) {
				this._storeDir.mkdirs();
			}
			if (!(this._lazyLoad)) {
				restoreSessions();
			}
		}
		setSavePeriod(getSavePeriod());
	}

	public void doStop() throws Exception {
		synchronized (this) {
			if (this._saveTask != null)
				this._saveTask.cancel();
			this._saveTask = null;
			if (this._task != null)
				this._task.cancel();
			this._task = null;
			if ((this._timer != null) && (this._timerStop))
				this._timer.cancel();
			this._timer = null;
		}

		super.doStop();

		this._sessions.clear();
	}

	public int getScavengePeriod() {
		return (int) (this._scavengePeriodMs / 1000L);
	}

	public int getSessions() {
		int sessions = super.getSessions();
		
		if ((log.isDebugEnabled()) && (this._sessions.size() != sessions)) {
			log.warn("sessions: " + this._sessions.size() + "!=" + sessions +","+
					new Object[0]);
		}
		
		return sessions;
	}

	public int getIdleSavePeriod() {
		if (this._idleSavePeriodMs <= 0L) {
			return 0;
		}
		return (int) (this._idleSavePeriodMs / 1000L);
	}

	public void setIdleSavePeriod(int seconds) {
		this._idleSavePeriodMs = (seconds * 1000L);
	}

	public void setMaxInactiveInterval(int seconds) {
		super.setMaxInactiveInterval(seconds);
		if ((this._dftMaxIdleSecs > 0)
				&& (this._scavengePeriodMs > this._dftMaxIdleSecs * 1000L))
			setScavengePeriod((this._dftMaxIdleSecs + 9) / 10);
	}

	public void setSavePeriod(int seconds) {
		long period = seconds * 1000L;
		if (period < 0L)
			period = 0L;
		this._savePeriodMs = period;

		if (this._timer == null)
			return;
		synchronized (this) {
			if (this._saveTask != null)
				this._saveTask.cancel();
			if ((this._savePeriodMs > 0L) && (this._storeDir != null)) {
				this._saveTask = new TimerTask() {
					public void run() {
						try {
							BasicSessionManager.this.saveSessions(true);
						} catch (Exception e) {
							//BasicSessionManager.__log.warn(e);
							e.printStackTrace();
						}
					}
				};
				this._timer.schedule(this._saveTask, this._savePeriodMs,
						this._savePeriodMs);
			}
		}
	}

	public int getSavePeriod() {
		if (this._savePeriodMs <= 0L) {
			return 0;
		}
		return (int) (this._savePeriodMs / 1000L);
	}

	public void setScavengePeriod(int seconds) {
		if (seconds == 0) {
			seconds = 60;
		}
		long old_period = this._scavengePeriodMs;
		long period = seconds * 1000L;
		if (period > 60000L)
			period = 60000L;
		if (period < 1000L) {
			period = 1000L;
		}
		this._scavengePeriodMs = period;
		if ((this._timer == null)
				|| ((period == old_period) && (this._task != null)))
			return;
		synchronized (this) {
			if (this._task != null)
				this._task.cancel();
			this._task = new TimerTask() {
				public void run() {
					BasicSessionManager.this.scavenge();
				}
			};
			this._timer.schedule(this._task, this._scavengePeriodMs,
					this._scavengePeriodMs);
		}
	}

	protected void scavenge() {
		if ((isStopping()) || (isStopped())) {
			return;
		}
		Thread thread = Thread.currentThread();
		ClassLoader old_loader = thread.getContextClassLoader();
		long now;
		Iterator i;
		try {
			if (this._loader != null) {
				thread.setContextClassLoader(this._loader);
			}

			now = System.currentTimeMillis();
			for (i = this._sessions.values().iterator(); i.hasNext();) {
				BasicSession session = (BasicSession) i.next();
				long idleTime = session.getMaxInactiveInterval() * 1000L;
				if ((idleTime > 0L) && (session.getAccessed() + idleTime < now)) {
					session.timeout();
				
				} else if ((this._idleSavePeriodMs > 0L)
						&& (session.getAccessed() + this._idleSavePeriodMs < now)) {
					session.idle();
				}
			}
		} catch (Throwable t) {
			t.printStackTrace();
		} finally {
			thread.setContextClassLoader(old_loader);
		}
	}

	protected void addSession(AbstractSession session) {
		if (isRunning())
			this._sessions.put(session.getClusterId(), (BasicSession) session);
	}

	public AbstractSession getSession(String idInCluster) {
		if ((this._lazyLoad) && (!(this._sessionsLoaded))) {
			try {
				restoreSessions();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		Map sessions = this._sessions;
		if (sessions == null) {
			return null;
		}
		BasicSession session = (BasicSession) sessions.get(idInCluster);

		if ((session == null) && (this._lazyLoad))
			session = restoreSession(idInCluster);
		if (session == null) {
			return null;
		}
		if (this._idleSavePeriodMs != 0L) {
			session.deIdle();
		}
		return session;
	}

	protected void invalidateSessions() throws Exception {
		ArrayList<BasicSession> sessions = new ArrayList<BasicSession>(this._sessions.values());
		int loop = 100;
		while ((sessions.size() > 0) && (loop-- > 0)) {
			if ((isStopping()) && (this._storeDir != null)
					&& (this._storeDir.exists()) && (this._storeDir.canWrite())) {
				for (BasicSession session : sessions) {
					session.save(false);
					removeSession(session, false);
				}

			} else {
				for (BasicSession session : sessions) {
					session.invalidate();
				}
			}

			sessions = new ArrayList(this._sessions.values());
		}
	}

	protected AbstractSession newSession(HttpServletRequest request) {
		return new BasicSession(this, request);
	}

	protected AbstractSession newSession(long created, long accessed,
			String clusterId) {
		return new BasicSession(this, created, accessed, clusterId);
	}

	protected boolean removeSession(String clusterId) {
		return (this._sessions.remove(clusterId) != null);
	}

	public void setStoreDirectory(File dir) {
		this._storeDir = dir;
	}

	public File getStoreDirectory() {
		return this._storeDir;
	}

	public void setLazyLoad(boolean lazyLoad) {
		this._lazyLoad = lazyLoad;
	}

	public boolean isLazyLoad() {
		return this._lazyLoad;
	}

	public boolean isDeleteUnrestorableSessions() {
		return this._deleteUnrestorableSessions;
	}

	public void setDeleteUnrestorableSessions(boolean deleteUnrestorableSessions) {
		this._deleteUnrestorableSessions = deleteUnrestorableSessions;
	}

	public void restoreSessions() throws Exception {
		this._sessionsLoaded = true;

		if ((this._storeDir == null) || (!(this._storeDir.exists()))) {
			return;
		}

		if (!(this._storeDir.canRead())) {
			System.out.println(
					"Unable to restore Sessions: Cannot read from Session storage directory "
							+ this._storeDir.getAbsolutePath());
			return;
		}

		String[] files = this._storeDir.list();
		for (int i = 0; (files != null) && (i < files.length); ++i) {
			restoreSession(files[i]);
		}
	}

	protected synchronized BasicSession restoreSession(String idInCuster) {
		File file = new File(this._storeDir, idInCuster);
		try {
			if (file.exists()) {
				FileInputStream in = new FileInputStream(file);
				BasicSession session = restoreSession(in, null);
				in.close();
				addSession(session, false);
				session.didActivate();
				file.delete();
				return session;
			}

		} catch (Exception e) {
			if (isDeleteUnrestorableSessions()) {
				if (file.exists()) {
					file.delete();
					System.out.println("Deleting file for unrestorable session "
							+ idInCuster);
				}
			} else {
				System.out.println("Problem restoring session " + idInCuster);
			}
		}
		return null;
	}

	public void saveSessions(boolean reactivate) throws Exception {
		if ((this._storeDir == null) || (!(this._storeDir.exists()))) {
			return;
		}

		if (!(this._storeDir.canWrite())) {
			log.warn(
					"Unable to save Sessions: Session persistence storage directory "
							+ this._storeDir.getAbsolutePath()
							+ " is not writeable" +"," + new Object[0]);
			return;
		}

		for (BasicSession session : this._sessions.values())
			session.save(true);
	}

	public BasicSession restoreSession(InputStream is, BasicSession session)
			throws Exception {
		DataInputStream in = new DataInputStream(is);
		String clusterId = in.readUTF();
		in.readUTF();
		long created = in.readLong();
		long accessed = in.readLong();
		int requests = in.readInt();

		if (session == null)
			session = (BasicSession) newSession(created, accessed, clusterId);
		session.setRequests(requests);
		int size = in.readInt();
		if (size > 0) {
			ClassLoadingObjectInputStream ois = new ClassLoadingObjectInputStream(
					in);
			for (int i = 0; i < size; ++i) {
				String key = ois.readUTF();
				Object value = ois.readObject();
				session.setAttribute(key, value);
			}
			ois.close();
		} else {
			in.close();
		}
		return session;
	}

	protected class ClassLoadingObjectInputStream extends ObjectInputStream {
		public ClassLoadingObjectInputStream(InputStream paramInputStream)
				throws IOException {
			super(paramInputStream);
		}

		public ClassLoadingObjectInputStream() throws IOException {
		}

		public Class<?> resolveClass(ObjectStreamClass cl) throws IOException,
				ClassNotFoundException {
			try {
				return Class.forName(cl.getName(), false, Thread
						.currentThread().getContextClassLoader());
			} catch (ClassNotFoundException e) {
			}
			return super.resolveClass(cl);
		}
	}	
	
}
