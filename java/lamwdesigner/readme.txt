

1. Content sample to: "jMyComponente.java" [Must Have!] <-- will be included in project "...\src\..."


public class jMyComponent extends .... {
	.......................
}


2. Content sample to: "jMyComponente.create"  [Must Have!]   <-- will be include in "Controls.java"


   public java.lang.Object jMyComponent_jCreate(long _Self) {
      return (java.lang.Object)(new jMyComponent(this,_Self));
   }

   public native int SUM(int a, int b); //ex. native interface. Warning: need an entry in "ControlsEvents.txt"!


3. Content sample to: "jMyComponente.service"  [Optional]

<service android:name=".jMyComponente"/>

4. Content sample to: "jMyComponente.permission"  [Optional]

<uses-permission android:name="android.permission.INTERNET"/>  
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

5. Content sample to: "jMyComponente.feature"  [Optional]

<uses-feature android:name="android.hardware.camera.flash" android:required="false"/>

6. Content sample to: "jMyComponente.intentfilter"  [Optional]

<action android:name="android.intent.action.SEND"/>
<category android:name="android.intent.category.DEFAULT"/>
<data android:mimeType="text/plain"/>

