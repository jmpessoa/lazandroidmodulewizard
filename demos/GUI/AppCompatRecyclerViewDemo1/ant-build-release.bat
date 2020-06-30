set Path=%PATH%;c:\laztoapk\downloads\apache-ant-1.10.3\bin
set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_151
cd C:\laztoapk\projects\project1\demos\GUI\AppCompatRecyclerViewDemo1\
call ant clean release
if errorlevel 1 pause
