package org.lamw.applistviewdemo6;

import android.net.Uri;
import java.io.File;
import android.content.Context;

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

}
