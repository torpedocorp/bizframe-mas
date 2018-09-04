# bizframe-mas (micro application server)

bizframe-mas는 어플리케이션을 실행 관리하기 위한 어플리케이션 컨테이너입니다.  
bizframe-mas를 이용하여 일반적인 서버 프로그램을 구동하여 관리할 수도 있으며 
Tomcat, Jetty와 같은 웹어플리케이션 혹은 apache-camel과 같은 라우팅 엔진을 구동하여 ESB 서버로 사용할 수 있습니다.    

## feature 

 - JVM 기반하에서 application 구동 및 관리를 위한 서버
 - Application 초기화/종료 액션 가능
 - Service 시작/중지 액션 가능
 - Application 간 독립적인 클래스로더 사용으로 Application간 독립성 강화 
 - 일반 JAVA 클래스를 로딩할 수 있으며 cdi와 jetty는 내장시킴
 - Application 간 메시지 교환을 위해서 route 구조 내장 시킴
 - 커맨드라인 명령 수행 


## Building from the source

 1. jdk 8 이상 설치 
 2. apache ant 설치
 3. bizframe-mas 프로젝트 저장소에서 소스를 clone 혹은 다운르도 (https://github.com/torpedocorp/bizframe-mas)
 4. 커맨드 라인상에서 ant build 수행
 
 
 ## Architecture
 
 링크  
 