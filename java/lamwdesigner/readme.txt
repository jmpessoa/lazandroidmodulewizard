

SMART LAMW DESIGNER HELPERS


1. Content sample to: "jMyComponente.java" <-- will be included in project "...\src\..."


public class jMyComponent extends .... {
	.......................
}


2. Content sample to: "jMyComponente.create"  <-- will be include in "Controls.java"


   public java.lang.Object jMyComponent_jCreate(long _Self) {
      return (java.lang.Object)(new jMyComponent(this,_Self));
   }


3. Content sample to: "jMyComponente.native" 

   public native int SUM(int a, int b); //native method/interface. 

4. Content sample to: "jMyComponente.service" 

<service android:name=".jMyComponente"/>

5. Content sample to: "jMyComponente.permission"  

<uses-permission android:name="android.permission.INTERNET"/>  
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

6. Content sample to: "jMyComponente.feature"  

<uses-feature android:name="android.hardware.camera.flash" android:required="false"/>

7. Content sample to: "jMyComponente.intentfilter"  

<action android:name="android.intent.action.SEND"/>
<category android:name="android.intent.category.DEFAULT"/>
<data android:mimeType="text/plain"/>

