<%@ page contentType="text/html; charset=EUC-KR" language="java"%>

<%@ page import="java.io.File"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>

<%@ page import="org.apache.log4j.Logger"%>
<%@ page import="org.json.JSONObject"%>
<%@ page import="org.json.JSONArray"%>

<%@ page import="java.util.Iterator"%>
<%@ page import="org.apache.log4j.Appender"%>
<%@ page import="kr.co.bizframe.logging.CommonsLoggerAccessor"%>
<%@ page import="kr.co.bizframe.logging.Log4JAppenderAccessor"%>
<%@ page import="kr.co.bizframe.logging.Log4JLoggerAccessor"%>
<%@ page import="kr.co.bizframe.logging.Log4JManagerAccessor"%>
<%@ page import="kr.co.bizframe.logging.LoggerManager"%>
<%@ page import="kr.co.bizframe.logging.TailingFile"%>
<%@ page import="kr.co.bizframe.logging.BackwardsFileStream"%>
<%@ page import="kr.co.bizframe.logging.BackwardsLineReader"%>
<%@ page import="kr.co.bizframe.util.StringUtil"%>
<%
	/**
	 * tailing log
	 *
	 * @version 1.0 2009.06.19
	 * @author Ho-Jin Seo
	 */
	 
	String id = StringUtil.checkNull(request.getParameter("id"));
	
	if (id.length() == 0) {
		return;
	}

	long maxLines = 1000;
	long initialLines = 250;

	LoggerManager mgr = LoggerManager.getInstance();
	Log4JAppenderAccessor lacc = (Log4JAppenderAccessor)mgr.getLogAccessor(id);
	
	if (lacc == null)
		return;
	
	TailingFile ff = (TailingFile) request.getSession(true).getAttribute("log" + id);
	if (ff == null) {
		ff = new TailingFile();
        ff.setFileName(lacc.getFile().getAbsolutePath());
        ff.setLastKnowLength(0);
        ff.setLines(new ArrayList());
        ff.setSize(lacc.getSize());
        ff.setLastModified(lacc.getLastModified());
        request.getSession(true).setAttribute("log" + id, ff);
	}
    if (ff != null) {
        File f = new File(ff.getFileName());

        if (f.exists()) {
            long currentLength = f.length();
            long readSize = 0;
            int listSize = ff.getLines().size();

            if (currentLength < ff.getLastKnowLength()) {
                ff.setLastKnowLength(0);
                ff.getLines().add(listSize, " ------------- THE FILE HAS BEEN TRUNCATED --------------");
            }

            BackwardsFileStream bfs = new BackwardsFileStream(f, currentLength);
            try {
                BackwardsLineReader br = new BackwardsLineReader(bfs);
                String s;
                while (readSize < currentLength - ff.getLastKnowLength() && (s = br.readLine()) != null) {
                    if (ff.getLines().size() >= maxLines) {
                        if (listSize > 0) {
                            ff.getLines().remove(0);
                            listSize--;
                        } else {
                            break;
                        }
                    }
                    ff.getLines().add(listSize, s);
                    readSize += s.length();
                    if (ff.getLastKnowLength() == 0 && ff.getLines().size() >= initialLines) break;
                }

                if (readSize > currentLength - ff.getLastKnowLength() && listSize > 0) {
                    ff.getLines().remove(listSize-1);
                }

                ff.setLastKnowLength(currentLength);
            } finally {
                bfs.close();
            }
        } else {
            ff.getLines().clear();
        }
    }
	
	Iterator itLines = ff.getLines().iterator();
	while(itLines.hasNext()) {
		String line = (String)itLines.next();
		if (line.indexOf("ERROR") > 0 && line.indexOf("ERROR") < 30) {
			out.write("<div class='line_error'>" + line + "</div>");
		} else if (line.indexOf("WARN") > 0 && line.indexOf("WARN") < 30) {
			out.write("<div class='line_warn'>" + line + "</div>");
		} else {
			out.write("<div class='line'>" + line + "</div>");
		}
	}
%>