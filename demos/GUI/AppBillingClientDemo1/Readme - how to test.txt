
Here is how to test the jcBillingClient component:

	by jmpessoa


* Create a new LAMW project with these options:

  Min SDK version: 14
  Target SDK version: 29
  Theme: Holo.light.NoActionBar
  Builder: Gradle (this is a must)
  Chipset: ARMv7A+soft

  (Other options may also work, but I successfully used the above)

* Drop a jWebView component in the main form and make it fill the whole screen.

* Drop a jcBillingClient component [Android Bridges jCenter] in the main form

* Into the AndroidModule1JNIPromp handler.
	Those 3 strings are provided by Google for static testing. 

  If you have a real project with real SKUs, add them to the corresponding 
  comma-separated lists, and they will be used as well. (First string is 
  INAPP skus, second string SUBS skus).
  

Thanks to the [jcBillingClient] author  Marco Bramardi!


PS. By Marco Bramarti:

If I have not forgotten anything, that should be it. Reopen Lazarus, connect 
a phone, go Ctrl-F1 and -- fingers crossed! -- it should work... 

If there's a problem that you cannot fix easily, let me know the details. I
have struggled hard for 2 weeks with this code, fixed a lot of errors, so maybe 
I can help.

Cheers

marco.bramardi@gmail.com

Nov 2019
