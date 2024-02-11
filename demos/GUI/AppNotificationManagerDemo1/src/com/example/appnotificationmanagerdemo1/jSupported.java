package com.example.appnotificationmanagerdemo1;

import android.net.Uri;
import java.io.File;
import android.content.Context;
import android.os.StrictMode;

public class jSupported {	//dummy:   app supported!]

	public static Uri FileProviderGetUriForFile(Controls controls, File file) {
	  return Uri.fromFile(file);
	}


	public static Uri FileProviderGetUriForFile(Context context, File file) {
		return Uri.fromFile(file);
	}


	public static boolean IsAppSupportedProject() {
		return false;
	}

	public static void SetStrictMode() {
		StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
		StrictMode.setVmPolicy(builder.build());
	}

}
