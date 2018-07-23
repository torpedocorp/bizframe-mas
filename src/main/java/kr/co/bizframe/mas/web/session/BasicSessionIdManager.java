package kr.co.bizframe.mas.web.session;

import java.util.Map;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.eclipse.jetty.server.SessionIdManager;
import org.eclipse.jetty.server.session.AbstractSession;
import org.eclipse.jetty.server.session.AbstractSessionIdManager;

public class BasicSessionIdManager extends AbstractSessionIdManager {

	private static Logger log = LoggerFactory.getLogger(BasicSessionIdManager.class);
	
	private final Map<String, Set<WeakReference<HttpSession>>> sessions = new HashMap();

	public BasicSessionIdManager() {

	}

	public Collection<String> getSessions() {
		return Collections.unmodifiableCollection(this.sessions.keySet());
	}

	public Collection<HttpSession> getSession(String id) {
		
		//System.out.println("getSession id=["+ id+"]");		
		
		ArrayList<HttpSession> sessions = new ArrayList();
		Set<WeakReference<HttpSession>> refs = (Set) this.sessions.get(id);
		if (refs != null) {
			for (WeakReference<HttpSession> ref : refs) {
				HttpSession session = (HttpSession) ref.get();
				if (session != null) {
					sessions.add(session);
				}
			}
		}
		return sessions;
	}

	public String getNodeId(String clusterId, HttpServletRequest request) {
		
		//System.out.println("getNodeId clusterId=["+ clusterId+"], request=["+ request+"]");		
		String worker = request == null ? null : (String) request
				.getAttribute("org.eclipse.jetty.ajp.JVMRoute");
		if (worker != null) {
			return clusterId + '.' + worker;
		}
		if (this._workerName != null) {
			return clusterId + '.' + this._workerName;
		}
		return clusterId;
	}

	@Override
	public String newSessionId(HttpServletRequest request, long created) {
		
		//System.out.println("newSessionId = ["+ request +"], created = ["+ created+"]");
		String ss = super.newSessionId(request, created);

		System.out.println("ss = " + ss); 
		return ss;
	}
	
	
	public String getClusterId(String nodeId) {
	
		int dot = nodeId.lastIndexOf('.');
		return dot > 0 ? nodeId.substring(0, dot) : nodeId;
	}

	protected void doStart() throws Exception {
		super.doStart();
	}

	protected void doStop() throws Exception {
		this.sessions.clear();
		super.doStop();
	}

	public boolean idInUse(String id) {
		System.out.println("idInUse = " + id);		
		synchronized (this) {
			return this.sessions.containsKey(id);
		}
	}

	public void addSession(HttpSession session) {
		
		//System.out.println("addSession = " + session);		
		String id = getClusterId(session.getId());
		WeakReference<HttpSession> ref = new WeakReference(session);
		synchronized (this) {
			Set<WeakReference<HttpSession>> sessions = (Set) this.sessions
					.get(id);
			if (sessions == null) {
				sessions = new HashSet();
				this.sessions.put(id, sessions);
			}
			sessions.add(ref);
		}
	}

	public void removeSession(HttpSession session) {
		
		//System.out.println("removeSession = " + session);				
		String id = getClusterId(session.getId());
		synchronized (this) {
			Collection<WeakReference<HttpSession>> sessions = (Collection) this.sessions
					.get(id);
			if (sessions != null) {
				for (Iterator<WeakReference<HttpSession>> iter = sessions
						.iterator(); iter.hasNext();) {
					WeakReference<HttpSession> ref = (WeakReference) iter
							.next();
					HttpSession s = (HttpSession) ref.get();
					if (s == null) {
						iter.remove();
					} else if (s == session) {
						iter.remove();
						break;
					}
				}
				if (sessions.isEmpty()) {
					this.sessions.remove(id);
				}
			}
		}
	}

	public void invalidateAll(String id) {
		
		//System.out.println("invalidateAll = " + id);				
		Collection<WeakReference<HttpSession>> sessions;
		synchronized (this) {
			sessions = (Collection) this.sessions.remove(id);
		}
		if (sessions != null) {
			for (Object ref : sessions) {
				AbstractSession session = (AbstractSession) ((WeakReference) ref)
						.get();
				if ((session != null) && (session.isValid())) {
					session.invalidate();
				}
			}
			sessions.clear();
		}
	}

}
