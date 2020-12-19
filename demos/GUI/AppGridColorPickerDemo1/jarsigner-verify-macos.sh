export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd /lamw/projects/AppGridColorPickerDemo1
jarsigner -verify -verbose -certs /lamw/projects/AppGridColorPickerDemo1/bin/AppGridColorPickerDemo1-release.apk
