<%@ page contentType="text/html; charset=EUC-KR" language="java"%>
<%@ page import="kr.co.bizframe.mxs.MxsEngine"%>
<%@ page import="kr.co.bizframe.mxs.dao.DAOFactory"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.Eb3Constants"%>
<%@ page import="kr.co.bizframe.mxs.common.QueryCondition" %>
<%@ page import="kr.co.bizframe.mxs.common.MxsObject"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.WSSUserVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.MpcVO" %>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PMode"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PModeParty"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PModeLeg"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.MessageProperty"%>
<%@ page import="kr.co.bizframe.mxs.ebms3.model.pmode.PayloadPart"%>
<%@ page import="kr.co.bizframe.BizFrame"%>
<%@ page import="kr.co.bizframe.mxs.web.I18nStrings"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%
/**
 * Register PMode
 *
 * @author Mi-Young Kim
 * @version 1.0 2008.10.23
 */

	// general parameter
	String name = request.getParameter("name");
	String id = request.getParameter("id");
	String agreement = request.getParameter("agreement");
	String mepStr = request.getParameter("mep");
	int mep = Integer.parseInt(mepStr);
	String mepbindingStr = request.getParameter("mepbinding");
	int mepbinding = Integer.parseInt(mepbindingStr);
	String myroleStr = request.getParameter("myrole");
	int myrole = Integer.parseInt(myroleStr);
	String initPartyId = request.getParameter("initPartyId");
	String initRole = request.getParameter("initRole");
	String initWssuser = request.getParameter("initWssuser");
	String respPartyId = request.getParameter("respPartyId");
	String respRole = request.getParameter("respRole");
	String respWssuser = request.getParameter("respWssuser");
	String desc = request.getParameter("desc");

	PMode pmode = new PMode(name, id);
	pmode.setAgreement(agreement);
	pmode.setMep(mep);
	pmode.setMepbinding(mepbinding);
	pmode.setMyRole(myrole);
	pmode.setDescription(desc);

	PModeParty init = pmode.getInitiator();
	init.setParty(initPartyId);
	init.setRole(initRole);
	init.setUserObid(initWssuser);
	init.setUsername(request.getParameter("initWssuserTxt"));
	init.setPassword(request.getParameter("initWssuserPwd"));

	JSONObject json = new JSONObject();
	I18nStrings _i18n = I18nStrings.getInstance();
	if (init.getUserObid().length() == 0
			&& init.getUsername() != null
			&& init.getUsername().length() > 0
			&& init.getPassword() != null
			&& init.getPassword().length() > 0) {
		System.out.println("==== check duplicate initiator wssuser ========= ");

		// 사용할 수 있는 사용자인지 확인
		QueryCondition qc = new QueryCondition();
		qc.add("username", init.getUsername());
		WSSUserVO vo = (WSSUserVO) MxsEngine.getInstance().getObject("WSSUser",
				qc, DAOFactory.EBMS3);
		if (vo != null) {
			if (init.getPassword().equals(vo.getPassword())) {
				init.setUserObid(vo.getObid());
			} else {
				json.put("err", "true");
				json.put("msg", _i18n.get("pmd10ms001.init.userid.nouse.inform"));
				out.print(json);
				return;
			}
		}
	}

	PModeParty resp = pmode.getResponder();
	resp.setParty(respPartyId);
	resp.setRole(respRole);
	resp.setUserObid(respWssuser);
	resp.setUsername(request.getParameter("respWssuserTxt"));
	resp.setPassword(request.getParameter("respWssuserPwd"));
	if (resp.getUserObid().length() == 0
			&& resp.getUsername() != null
			&& resp.getUsername().length() > 0
			&& resp.getPassword() != null
			&& resp.getPassword().length() > 0) {
		System.out.println("==== check duplicate responder wssuser ========= ");

		// 사용할 수 있는 사용자인지 확인
		QueryCondition qc = new QueryCondition();
		qc.add("username", resp.getUsername());
		WSSUserVO vo = (WSSUserVO) MxsEngine.getInstance().getObject("WSSUser",
				qc, DAOFactory.EBMS3);
		if (vo != null) {
			if (resp.getPassword().equals(vo.getPassword())) {
				resp.setUserObid(vo.getObid());
			} else {
				json.put("err", "true");
				json.put("msg", _i18n.get("pmd10ms001.resp.userid.nouse.inform"));
				out.print(json);
				return;
			}
		} else {
			System.out.println("insert resp WSSUser =" + resp.getUserObid());
		}
	}

	// leg
	// ======= LEG[1] or LEG[1][u] =========
	if (mepbinding == Eb3Constants.PMODE_MEPBINDING_PUSH
			|| mepbinding == Eb3Constants.PMODE_MEPBINDING_SYNC
			|| mepbinding == Eb3Constants.PMODE_MEPBINDING_PUSHANDPUSH
			|| mepbinding == Eb3Constants.PMODE_MEPBINDING_PUSHANDPULL
			|| mepbinding == Eb3Constants.PMODE_MEPBINDING_PULL
			|| mepbinding == Eb3Constants.PMODE_MEPBINDING_PULLANDPUSH) {

		int legNo = 1;
		String partType = "";

		if (mepbinding == Eb3Constants.PMODE_MEPBINDING_PULL
				|| mepbinding == Eb3Constants.PMODE_MEPBINDING_PULLANDPUSH) {
			partType = "u";
		}

		PModeLeg leg = new PModeLeg();
		pmode.addLeg(leg);
		leg.setLegNo(legNo);
		if ("u".equals(partType) || "s".equals(partType)) {
			leg.setPartType(partType);
		}

		// protocol
		leg.setProtocolAddress(request.getParameter("protocolAddress"+legNo+partType));
		if ("1".equals(request.getParameter("protocolSoapVersion"+legNo+partType))) {
			leg.setSOAPVersion("1.2");
		} else {
			leg.setSOAPVersion("1.1");
		}

		// errorHandling
		leg.setErrSndErrTo(request.getParameter("errSndErrTo"+legNo+partType));
		leg.setErrRcvErrTo(request.getParameter("errRcvErrTo"+legNo+partType));
		if ("1".equals(request.getParameter("errAsResponse"+legNo+partType))) {
			leg.setErrAsResponse(true);
		}
		if ("1".equals(request.getParameter("errPeNotifyConsumer"+legNo+partType))) {
			leg.setErrPeNotifyConsumer(true);
		}
		if ("1".equals(request.getParameter("errPeNotifyProducer"+legNo+partType))) {
			leg.setErrPeNotifyProducer(true);
		}
		if ("1".equals(request.getParameter("errDfNotifyProducer"+legNo+partType))) {
			leg.setErrDfNotifyProducer(true);
		}

		// businessInfo
		leg.setService(request.getParameter("bizinfoService"+legNo+partType));
		leg.setAction(request.getParameter("bizinfoAction"+legNo+partType));
		leg.setMpcObid(request.getParameter("mpc"+legNo+partType));
		leg.setMpcName(request.getParameter("mpc"+legNo+partType + "Name"));
		leg.setMpcUri(request.getParameter("mpc"+legNo+partType + "Uri"));
		if (leg.getMpcName() != null && leg.getMpcName().length() > 0) {
			leg.setMpcIsLocal(Integer.parseInt(request.getParameter("mpc"+legNo+partType + "IsLocal")));
		}

		// check Mpc
		if (leg.getMpcObid().length() == 0 && leg.getMpcName() != null
				&& leg.getMpcName().length() > 0) {
			System.out.println("==== check duplicate mpc LEG[1][u] ========= ");

			if (pmode.getMyRole() == Eb3Constants.PMODE_MYROLE_INITIATOR) {
				leg.setMpcIsLocal(Eb3Constants.MPC_REMOTE);
			} else {
				leg.setMpcIsLocal(Eb3Constants.MPC_LOCAL);
			}

			QueryCondition qc = new QueryCondition();
			qc.add("display_name", leg.getMpcName());
			MpcVO vo = (MpcVO) MxsEngine.getInstance().getObject("Mpc",
					qc, DAOFactory.EBMS3);

			if (vo != null) {
				if (vo.getMpcUri().equals(leg.getMpcUri()) && vo.getIsLocal() == leg.getMpcIsLocal()) {
					leg.setMpcObid(vo.getObid());
				} else {
					json.put("err", "true");
					json.put("msg", "LEG[1][u]" + _i18n.get("pmd10ms001.mpc.nouse.inform"));
					out.print(json);
					return;
				}
			}
		}
		if (leg.getMpcName() != null && leg.getMpcName().length() > 0) {
			System.out.println("LEG[1][u] MpcIsLocal=" + leg.getMpcIsLocal());
		}
		boolean isExistUser = false;
		if (leg.getMpcObid().length() > 0) {
			QueryCondition qc = new QueryCondition();
			qc.add("mpc_obid", leg.getMpcObid());
			ArrayList list = MxsEngine.getInstance().getObjects("WSSUser",
					1, qc, DAOFactory.EBMS3);
			if (list != null) {
				int useWssAuth = -1;
				// 해당 mpc에 사용자 설정이 되어있는데  initiator에 사용자 값이 없으면 에러
				for (Iterator i=list.iterator(); i.hasNext();) {
					WSSUserVO vo = (WSSUserVO)i.next();
					useWssAuth = vo.getUseWssAuth();

					if (vo.getObid().equals(init.getUserObid())) {
						isExistUser = true;
						break;
					}
				}
				if (!isExistUser) {
					if (list.size() > 0 && useWssAuth == Eb3Constants.MPC_USE_WSS_AUTH) {
						json.put("err", "true");
						json.put("msg", "LEG[1][u]" + _i18n.get("pmd10ms001.init.wssuser.require.inform"));
						out.print(json);
						return;

					} else {
						// mpc에는 사용자 설정이 안되어있고  init에 사용자가 설정되어있는 경우 mpc사용자인증여부를 따져서 처리
						if (init.getUserObid() != null && init.getUserObid().length() > 0 ) {
							qc = new QueryCondition();
							qc.add("obid", leg.getMpcObid());
							MpcVO mpc = (MpcVO)MxsEngine.getInstance().getObject("Mpc", qc, DAOFactory.EBMS3);
							if (mpc.getUseWssAuth() == Eb3Constants.MPC_USE_WSS_AUTH) {
								json.put("err", "true");
								json.put("msg", "LEG[1][u]" + _i18n.get("pmd10ms001.mpc.wssuser.require.inform"));
								out.print(json);
								return;
							} else {
								json.put("err", "true");
								json.put("msg", "LEG[1][u]" + _i18n.get("pmd10ms001.init.wssuser.not.require.inform"));
								out.print(json);
								return;
							}
						}
					}
				}
			}
		}

		String payloadMaxSizeStr = request.getParameter("payloadMaxSize"+legNo+partType);
		int payloadMaxSize = 0;
		if (payloadMaxSizeStr != null && payloadMaxSizeStr.length() > 0) {
			payloadMaxSize = Integer.parseInt(payloadMaxSizeStr);
		}
		leg.setPayloadMaxSize(payloadMaxSize);

		String[] msgPropName_arr = request.getParameterValues("msgPname"+legNo+partType);
		String[] msgPropType_arr = request.getParameterValues("msgPtype"+legNo+partType);
		String[] msgPropDesc_arr = request.getParameterValues("msgPdesc"+legNo+partType);
		String[] msgPropRequired_arr = request.getParameterValues("msgPrequiredVal"+legNo+partType);

		if(msgPropName_arr != null) {
	        for (int i = 0; i <msgPropName_arr.length; i++) {
	            MessageProperty msgProp = new MessageProperty();
	            msgProp.setPropName(msgPropName_arr[i]);
	            msgProp.setType(msgPropType_arr[i]);
	            msgProp.setDescription(msgPropDesc_arr[i]);
	            String msgPropRequired = msgPropRequired_arr[i];
	            if ("1".equalsIgnoreCase(msgPropRequired)) {
	            	msgProp.setRequired(true);
	            } else {
	            	msgProp.setRequired(false);
	            }
	            leg.addMsgProperty(msgProp);
	        }
	    }

		String[] payloadProfName_arr = request.getParameterValues("payloadPname"+legNo+partType);
		String[] payloadProfType_arr = request.getParameterValues("payloadPtype"+legNo+partType);
		String[] payloadProfschemaFile_arr = request.getParameterValues("payloadPschemaFile"+legNo+partType);
		String[] payloadProfSize_arr = request.getParameterValues("payloadPFileSize"+legNo+partType);
		String[] payloadProfRequired_arr = request.getParameterValues("payloadPrequiredVal"+legNo+partType);

	    if(payloadProfName_arr != null) {
	        for (int i = 0; i <payloadProfName_arr.length; i++) {
	            PayloadPart payload = new PayloadPart();
	            payload.setPropName(payloadProfName_arr[i]);
	            payload.setType(payloadProfType_arr[i]);
	            payload.setSchemaFile(payloadProfschemaFile_arr[i]);
	            payload.setMaxSize(0);
	            String sizeStr = payloadProfSize_arr[i];
	            if (sizeStr != null && sizeStr.length() > 0) {
	            	payload.setMaxSize(Integer.parseInt(sizeStr));
	            }
	            String payloadProfRequired = payloadProfRequired_arr[i];
	            if ("1".equalsIgnoreCase(payloadProfRequired)) {
	            	payload.setRequired(true);
	            } else {
	            	payload.setRequired(false);
	            }
	            leg.addPayloadPart(payload);
	        }
	    }
	}

	// LEG[1][s]
	if (mepbinding == Eb3Constants.PMODE_MEPBINDING_PULL
			|| mepbinding == Eb3Constants.PMODE_MEPBINDING_PULLANDPUSH) {
		int legNo = 1;
		String partType = "s";
		PModeLeg leg = new PModeLeg();
		pmode.addLeg(leg);
		leg.setLegNo(legNo);
		if ("u".equals(partType) || "s".equals(partType)) {
			leg.setPartType(partType);
		}

		// protocol
		leg.setProtocolAddress(request.getParameter("protocolAddress"+legNo+partType));
		if ("1".equals(request.getParameter("protocolSoapVersion"+legNo+partType))) {
			leg.setSOAPVersion("1.2");
		} else {
			leg.setSOAPVersion("1.1");
		}

		// service, action DefaultSetting
		leg.setService("signal");
		leg.setAction("pullRequest");

		// errorHandling
		leg.setErrSndErrTo(request.getParameter("errSndErrTo"+legNo+partType));
		leg.setErrRcvErrTo(request.getParameter("errRcvErrTo"+legNo+partType));
		if ("1".equals(request.getParameter("errAsResponse"+legNo+partType))) {
			leg.setErrAsResponse(true);
		}
		if ("1".equals(request.getParameter("errPeNotifyConsumer"+legNo+partType))) {
			leg.setErrPeNotifyConsumer(true);
		}
		if ("1".equals(request.getParameter("errPeNotifyProducer"+legNo+partType))) {
			leg.setErrPeNotifyProducer(true);
		}
		if ("1".equals(request.getParameter("errDfNotifyProducer"+legNo+partType))) {
			leg.setErrDfNotifyProducer(true);
		}
	}

 // ======= LEG[2] or LEG[2][u] =========
	if (mepbinding == Eb3Constants.PMODE_MEPBINDING_SYNC
			|| mepbinding == Eb3Constants.PMODE_MEPBINDING_PUSHANDPUSH
			|| mepbinding == Eb3Constants.PMODE_MEPBINDING_PULLANDPUSH
			|| mepbinding == Eb3Constants.PMODE_MEPBINDING_PUSHANDPULL) {

		int legNo = 2;
		String partType = "";
		if (mepbinding == Eb3Constants.PMODE_MEPBINDING_PUSHANDPULL) {
			partType = "u";
		}

		PModeLeg leg = new PModeLeg();
		pmode.addLeg(leg);
		leg.setLegNo(legNo);
		if ("u".equals(partType) || "s".equals(partType)) {
			leg.setPartType(partType);
		}

		// protocol
		leg.setProtocolAddress(request.getParameter("protocolAddress"+legNo+partType));
		if ("1".equals(request.getParameter("protocolSoapVersion"+legNo+partType))) {
			leg.setSOAPVersion("1.2");
		} else {
			leg.setSOAPVersion("1.1");
		}

		// errorHandling
		leg.setErrSndErrTo(request.getParameter("errSndErrTo"+legNo+partType));
		leg.setErrRcvErrTo(request.getParameter("errRcvErrTo"+legNo+partType));
		if ("1".equals(request.getParameter("errAsResponse"+legNo+partType))) {
			leg.setErrAsResponse(true);
		}
		if ("1".equals(request.getParameter("errPeNotifyConsumer"+legNo+partType))) {
			leg.setErrPeNotifyConsumer(true);
		}
		if ("1".equals(request.getParameter("errPeNotifyProducer"+legNo+partType))) {
			leg.setErrPeNotifyProducer(true);
		}
		if ("1".equals(request.getParameter("errDfNotifyProducer"+legNo+partType))) {
			leg.setErrDfNotifyProducer(true);
		}

		// businessInfo
		leg.setService(request.getParameter("bizinfoService"+legNo+partType));
		leg.setAction(request.getParameter("bizinfoAction"+legNo+partType));
		leg.setMpcObid(request.getParameter("mpc"+legNo+partType));
		leg.setMpcName(request.getParameter("mpc"+legNo+partType + "Name"));
		leg.setMpcUri(request.getParameter("mpc"+legNo+partType + "Uri"));
		if (leg.getMpcName() != null && leg.getMpcName().length() > 0) {
			leg.setMpcIsLocal(Integer.parseInt(request.getParameter("mpc"+legNo+partType + "IsLocal")));
		}

		// check Mpc
		if (leg.getMpcObid().length() == 0 && leg.getMpcName() != null
				&& leg.getMpcName().length() > 0) {
			System.out.println("==== check duplicate mpc LEG[2][u] ========= ");

			if (pmode.getMyRole() == Eb3Constants.PMODE_MYROLE_INITIATOR) {
				leg.setMpcIsLocal(Eb3Constants.MPC_REMOTE);
			} else {
				leg.setMpcIsLocal(Eb3Constants.MPC_LOCAL);
			}

			QueryCondition qc = new QueryCondition();
			qc.add("display_name", leg.getMpcName());
			MpcVO vo = (MpcVO) MxsEngine.getInstance().getObject("Mpc",
					qc, DAOFactory.EBMS3);

			if (vo != null) {
				if (vo.getMpcUri().equals(leg.getMpcUri()) && vo.getIsLocal() == leg.getMpcIsLocal()) {
					leg.setMpcObid(vo.getObid());
				} else {
					json.put("err", "true");
					json.put("msg", "LEG[2][u]" + _i18n.get("pmd10ms001.mpc.nouse.inform"));
					out.print(json);
					return;
				}
			}
		}
		if (leg.getMpcName() != null && leg.getMpcName().length() > 0) {
			System.out.println("LEG[2][u] MpcIsLocal=" + leg.getMpcIsLocal());
		}

		boolean isExistUser = false;
		if (leg.getMpcObid().length() > 0) {
			QueryCondition qc = new QueryCondition();
			qc.add("mpc_obid", leg.getMpcObid());
			ArrayList list = MxsEngine.getInstance().getObjects("WSSUser",
					1, qc, DAOFactory.EBMS3);

			if (list != null) {
				int useWssAuth = -1;
				// 해당 mpc에 사용자 설정이 되어있는데  initiator에 사용자 값이 없으면 에러
				for (Iterator i=list.iterator(); i.hasNext();) {
					WSSUserVO vo = (WSSUserVO)i.next();
					useWssAuth = vo.getUseWssAuth();

					if (vo.getObid().equals(init.getUserObid())) {
						isExistUser = true;
						break;
					}
				}
				if (!isExistUser) {
					if (list.size() > 0 && useWssAuth == Eb3Constants.MPC_USE_WSS_AUTH) {
						json.put("err", "true");
						json.put("msg", "LEG[2][u]" + _i18n.get("pmd10ms001.init.wssuser.require.inform"));
						out.print(json);
						return;

					} else {
						// mpc에는 사용자 설정이 안되어있고  init에 사용자가 설정되어있는 경우 mpc사용자인증여부를 따져서 처리
						if (init.getUserObid() != null && init.getUserObid().length() > 0 ) {
							qc = new QueryCondition();
							qc.add("obid", leg.getMpcObid());
							MpcVO mpc = (MpcVO)MxsEngine.getInstance().getObject("Mpc", qc, DAOFactory.EBMS3);
							if (mpc.getUseWssAuth() == Eb3Constants.MPC_USE_WSS_AUTH) {
								json.put("err", "true");
								json.put("msg", "LEG[2][u]" + _i18n.get("pmd10ms001.mpc.wssuser.require.inform"));
								out.print(json);
								return;
							} else {
								json.put("err", "true");
								json.put("msg", "LEG[2][u]" + _i18n.get("pmd10ms001.init.wssuser.not.require.inform"));
								out.print(json);
								return;
							}
						}
					}
				}
			}
		}

		String payloadMaxSizeStr = request.getParameter("payloadMaxSize"+legNo+partType);
		int payloadMaxSize = 0;
		if (payloadMaxSizeStr != null && payloadMaxSizeStr.length() > 0) {
			payloadMaxSize = Integer.parseInt(payloadMaxSizeStr);
		}
		leg.setPayloadMaxSize(payloadMaxSize);

		String[] msgPropName_arr = request.getParameterValues("msgPname"+legNo+partType);
		String[] msgPropType_arr = request.getParameterValues("msgPtype"+legNo+partType);
		String[] msgPropDesc_arr = request.getParameterValues("msgPdesc"+legNo+partType);
		String[] msgPropRequired_arr = request.getParameterValues("msgPrequiredVal"+legNo+partType);

		if(msgPropName_arr != null) {
	        for (int i = 0; i <msgPropName_arr.length; i++) {
	            MessageProperty msgProp = new MessageProperty();
	            msgProp.setPropName(msgPropName_arr[i]);
	            msgProp.setType(msgPropType_arr[i]);
	            msgProp.setDescription(msgPropDesc_arr[i]);
	            String msgPropRequired = msgPropRequired_arr[i];
	            if ("1".equalsIgnoreCase(msgPropRequired)) {
	            	msgProp.setRequired(true);
	            } else {
	            	msgProp.setRequired(false);
	            }
	            leg.addMsgProperty(msgProp);
	        }
	    }

		String[] payloadProfName_arr = request.getParameterValues("payloadPname"+legNo+partType);
		String[] payloadProfType_arr = request.getParameterValues("payloadPtype"+legNo+partType);
		String[] payloadProfschemaFile_arr = request.getParameterValues("payloadPschemaFile"+legNo+partType);
		String[] payloadProfSize_arr = request.getParameterValues("payloadPFileSize"+legNo+partType);
		String[] payloadProfRequired_arr = request.getParameterValues("payloadPrequiredVal"+legNo+partType);

	    if(payloadProfName_arr != null) {
	        for (int i = 0; i <payloadProfName_arr.length; i++) {
	            PayloadPart payload = new PayloadPart();
	            payload.setPropName(payloadProfName_arr[i]);
	            payload.setType(payloadProfType_arr[i]);
	            payload.setSchemaFile(payloadProfschemaFile_arr[i]);
	            payload.setMaxSize(0);
	            String sizeStr = payloadProfSize_arr[i];
	            if (sizeStr != null && sizeStr.length() > 0) {
	            	payload.setMaxSize(Integer.parseInt(sizeStr));
	            }
	            String payloadProfRequired = payloadProfRequired_arr[i];
	            if ("1".equalsIgnoreCase(payloadProfRequired)) {
	            	payload.setRequired(true);
	            } else {
	            	payload.setRequired(false);
	            }
	            leg.addPayloadPart(payload);
	        }
	    }
	}

	// LEG[2][s]
	if (mepbinding == Eb3Constants.PMODE_MEPBINDING_PUSHANDPULL) {
		int legNo = 2;
		String partType = "s";
		PModeLeg leg = new PModeLeg();
		pmode.addLeg(leg);
		leg.setLegNo(legNo);
		if ("u".equals(partType) || "s".equals(partType)) {
			leg.setPartType(partType);
		}

		// protocol
		leg.setProtocolAddress(request.getParameter("protocolAddress"+legNo+partType));
		if ("1".equals(request.getParameter("protocolSoapVersion"+legNo+partType))) {
			leg.setSOAPVersion("1.2");
		} else {
			leg.setSOAPVersion("1.1");
		}

		// service, action DefaultSetting
		leg.setService("signal");
		leg.setAction("pullRequest");

		// errorHandling
		leg.setErrSndErrTo(request.getParameter("errSndErrTo"+legNo+partType));
		leg.setErrRcvErrTo(request.getParameter("errRcvErrTo"+legNo+partType));
		if ("1".equals(request.getParameter("errAsResponse"+legNo+partType))) {
			leg.setErrAsResponse(true);
		}
		if ("1".equals(request.getParameter("errPeNotifyConsumer"+legNo+partType))) {
			leg.setErrPeNotifyConsumer(true);
		}
		if ("1".equals(request.getParameter("errPeNotifyProducer"+legNo+partType))) {
			leg.setErrPeNotifyProducer(true);
		}
		if ("1".equals(request.getParameter("errDfNotifyProducer"+legNo+partType))) {
			leg.setErrDfNotifyProducer(true);
		}
	}

 MxsEngine engine = MxsEngine.getInstance();
 MxsObject obj = new MxsObject();
 obj.putExtension(Eb3Constants.MXSOBJ_EXTENSION_PMODE, pmode);
 obj.setCreatedBy(BizFrame.SYSTEM_USER_OBID);
 engine.insertObject("PMode", obj, DAOFactory.EBMS3);
 json.put("err", "false");
 out.print(json);
%>

