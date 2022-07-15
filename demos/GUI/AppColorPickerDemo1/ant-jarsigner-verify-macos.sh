export JAVA_HOME=${/usr/libexec/java_home}
export PATH=${JAVA_HOME}/bin:$PATH
cd fpcupdeluxe/ccr/lamw/demos/GUI/AppColorPickerDemo1
jarsigner -verify -verbose -certs fpcupdeluxe/ccr/lamw/demos/GUI/AppColorPickerDemo1/bin/AppColorPickerDemo1-release.apk
