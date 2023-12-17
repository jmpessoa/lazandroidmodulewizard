export PATH=/adt32/ant/bin:$PATH
export JAVA_HOME=/Program Files/Eclipse Adoptium/jdk-11.0.21.9
cd /android/workspace/AppTextViewVerticalScrolling
ant -Dtouchtest.enabled=true debug
