package org.lamw.appcompatkref;

import android.content.Context;
import android.net.Uri;
import android.os.Build;
import androidx.core.content.FileProvider;
import java.io.File;
//import android.os.StrictMode;


public class jSupported {	

	public static Uri FileProviderGetUriForFile(Controls controls, File file) {
		Uri r = null;
		if (Build.VERSION.SDK_INT >= 24) {
			//[ifdef_api24up]
			r = FileProvider.getUriForFile(controls.GetContext(), controls.GetContext().getApplicationContext().getPackageName() + ".fileprovider", file);
			//[endif_api24up]
		}
		else {
			r = Uri.fromFile(file);
		}
		return r;
	}

	public static Uri FileProviderGetUriForFile(Context context, File file) {
		Uri r = null;

		if (Build.VERSION.SDK_INT >= 24) {
			//[ifdef_api24up]
			r = FileProvider.getUriForFile(context, context.getApplicationContext().getPackageName() + ".fileprovider", file);
			//[endif_api24up]
		}
		else {
			r = Uri.fromFile(file);
		}
		return r;
	}

	public static boolean IsAppSupportedProject() {
		return true;
	}


	public static void SetStrictMode() { //dummy
		//StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
		//StrictMode.setVmPolicy(builder.build());
	}

}
