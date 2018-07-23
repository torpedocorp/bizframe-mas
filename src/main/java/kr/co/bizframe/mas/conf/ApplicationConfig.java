package kr.co.bizframe.mas.conf;

import java.io.File;
import java.util.List;

import kr.co.bizframe.mas.application.ApplicationDef;
import kr.co.bizframe.mas.util.XMLUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.jdom.Attribute;
import org.jdom.Element;

public class ApplicationConfig {

	private static Logger log = LoggerFactory.getLogger(ApplicationConfig.class);

	public static ApplicationDef parse(File confFile) throws Exception {
		Element ele = XMLUtil.getRootElement(confFile);

		ApplicationDef def = new ApplicationDef();

		String id = XMLUtil.getText("id", ele);
		String name = XMLUtil.getText("name", ele);
		String loadClass = XMLUtil.getText("load-class", ele);
		def.setId(id);
		def.setName(name);
		def.setLoadClass(loadClass);
		def.setParentFirstClassLoader(false);
		def.setParentOnlyClassLoader(false);

		// optional
		// 상위 클래스 로더를 그대로 사용할지 여부
		// default : 새로 생성
		String parentOnlyClassLoader = XMLUtil.getText("parent-only-classloader", ele, true);
		if ("true".equalsIgnoreCase(parentOnlyClassLoader)) {
			def.setParentOnlyClassLoader(true);
		}

		// optional
		// 상위 클래스 로더를 먼저 사용할지 여부
		// default : 새로 생성
		String parentFirstClassLoader = XMLUtil.getText("parent-first-classloader", ele, true);
		if ("true".equalsIgnoreCase(parentFirstClassLoader)) {
			def.setParentFirstClassLoader(true);
		}

		// optional
		// 어플리케이션 로딩 순번 - integer 낮은 수일수록 먼저 로딩
		// default : 0 (가장 먼저 로딩)
		String spriority = XMLUtil.getText("priority", ele, true);
		if (spriority != null) {
			int priority = 0;
			try {
				priority = Integer.parseInt(spriority);
			} catch (Exception e) {
				throw new Exception("priority is not integer.");
			}
			def.setPriority(priority);
		}

		// optional
		// application 이 sesrvice일 경우 엔진 로딩시 자동 시작 여부
		// default : true
		String autoStart = XMLUtil.getText("auto-start", ele, true);
		if ("false".equalsIgnoreCase(autoStart)) {
			def.setAutoStart(false);
		}

		Element ele_params = ele.getChild("params");
		if (ele_params != null) {
			List<Element> ele_param_list = ele_params.getChildren("param");
			for (Element ele_param : ele_param_list) {

				String key = null;
				Attribute kattribute = ele_param.getAttribute("key");
				if (kattribute != null) {
					key = kattribute.getValue();
				}

				String value = null;
				Attribute vattribute = ele_param.getAttribute("value");
				if (vattribute != null) {
					value = vattribute.getValue();
				}

				def.putProperty(key, value);
			}
		}
		return def;
	}

	public static void main(String[] argv) {

		try {
			ApplicationDef def = ApplicationConfig.parse(new File("C:/workspace/ecf_24_dev/bizframe_mas/dist/application/test1/application.xml"));
			System.out.println("def = " + def);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
