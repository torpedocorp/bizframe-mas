package kr.co.bizframe.mas.test.engine;

import kr.co.bizframe.mas.core.MasEngine;

public class EngineTest {



	public void start(){

		try{
			MasEngine me = new MasEngine("C:/workspace/ecf_24_dev/bizframe_mas/dist/");
			me.setEnableRouting(true);
			me.startup();


			try{
				Thread.sleep(1000000);
			}catch(Exception e){
				e.printStackTrace();
			}

		}catch(Throwable t){
			t.printStackTrace();
		}
	}



	public static void main(String[] argv){

		EngineTest et = new EngineTest();
		et.start();
	}
}
