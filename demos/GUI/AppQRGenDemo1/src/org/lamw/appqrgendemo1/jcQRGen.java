package org.lamw.appqrgendemo1;

import android.content.Context;
import android.graphics.Bitmap;

import com.google.zxing.EncodeHintType;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;

import net.glxn.qrgen.android.QRCode;
import net.glxn.qrgen.core.image.ImageType;
import net.glxn.qrgen.core.scheme.EMail;
import net.glxn.qrgen.core.scheme.MMS;
import net.glxn.qrgen.core.scheme.MeCard;
import net.glxn.qrgen.core.scheme.SMS;
import net.glxn.qrgen.core.scheme.VCard;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.OutputStream;

/*Draft java code by "Lazarus Android Module Wizard" [7/21/2020 23:22:34]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref. https://github.com/kenglxn/QRGen

public class jcQRGen /*extends ...*/ {
  
    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context  context   = null;

    OutputStream outputStream;
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
  
    public jcQRGen(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
       //super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;
    }
  
    public void jFree() {
      //free local objects...
    }
  
  //write others [public] methods code here......
  //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public Bitmap GetURLQRCode(String _url) {
        return  QRCode.from(_url).bitmap();
    }

    public Bitmap GetURLQRCode(String _url, int _width, int _height) {
        return  QRCode.from(_url).withSize(_width, _height).bitmap();
    }

    public Bitmap GetTextQRCode(String _txt, int _width, int _height) {
        // override image size to be 250x250
        return QRCode.from(_txt).withSize(_width, _height).bitmap();
    }

    public Bitmap GetTextQRCode(String _txt) {
        return  QRCode.from(_txt).bitmap();
    }

    public Bitmap GetEMailQRCode(String _email) {
        EMail email = new EMail(_email); //"John.Doe@example.org"
        return  QRCode.from(email).bitmap();
    }

    public Bitmap GetEMailQRCode(String _email, int _width, int _height) {
        EMail email = new EMail(_email); //"John.Doe@example.org"
        return  QRCode.from(email).withSize(_width, _height).bitmap();
    }

    // encode MeCard data
    public Bitmap GetMeCardQRCode(String _name, String _email, String _address, String _phone) {
        MeCard mcJohnDoe = new MeCard(_name);//"John Doe"
        mcJohnDoe.setEmail(_email); //"john.doe@example.org"
        mcJohnDoe.setAddress(_address); //"John Doe Street 1, 5678 Doestown"
        mcJohnDoe.setTelephone(_phone); //"1234"
        return QRCode.from(mcJohnDoe).bitmap();
    }

    public Bitmap GetMeCardQRCode(String _name, String _email, String _address, String _phone, int _width, int _height) {
        MeCard mcJohnDoe = new MeCard(_name);//"John Doe"
        mcJohnDoe.setEmail(_email); //"john.doe@example.org"
        mcJohnDoe.setAddress(_address); //"John Doe Street 1, 5678 Doestown"
        mcJohnDoe.setTelephone(_phone); //"1234"
        return QRCode.from(mcJohnDoe).withSize(_width, _height).bitmap();
    }

    // encode contact data as vcard using defaults
    public Bitmap GetVCardQRCode(String _name, String _email,
                                     String _address, String _fone,
                                     String _title, String _company, String _website, int _width, int _height) {
        VCard vCJohnDoe = new VCard(_name) //"John Doe"
                .setEmail(_email) //"john.doe@example.org"
                .setAddress(_address) //"John Doe Street 1, 5678 Doestown"
                .setTitle(_title)  //"Mister"
                .setCompany(_company) //"John Doe Inc."
                .setPhoneNumber(_fone)
                .setWebsite(_website); //"www.example.org"
        return QRCode.from(vCJohnDoe).withSize(_width, _height).bitmap();
    }

    public Bitmap GetVCardQRCode(String _name, String _email,
                                 String _address, String _fone,
                                 String _title, String _company, String _website) {
        VCard vCJohnDoe = new VCard(_name) //"John Doe"
                .setEmail(_email) //"john.doe@example.org"
                .setAddress(_address) //"John Doe Street 1, 5678 Doestown"
                .setTitle(_title)  //"Mister"
                .setCompany(_company) //"John Doe Inc."
                .setPhoneNumber(_fone)
                .setWebsite(_website); //"www.example.org"
        return QRCode.from(vCJohnDoe).bitmap();
    }

    public void GenQRCode() {  //dummy


        Bitmap myBitmap = QRCode.from("www.example.org").bitmap();
        //ImageView myImage = (ImageView) findViewById(R.id.imageView);
        //myImage.setImageBitmap(myBitmap);

        // get QR file from text using defaults
        File file = QRCode.from("Hello World").file();

// get QR stream from text using defaults
        ByteArrayOutputStream stream = QRCode.from("Hello World").stream();

// override the image type to be JPG
        QRCode.from("Hello World").to(ImageType.JPG).file();
        QRCode.from("Hello World").to(ImageType.JPG).stream();

// override image size to be 250x250
        QRCode.from("Hello World").withSize(250, 250).file();
        QRCode.from("Hello World").withSize(250, 250).stream();

// override size and image type
        QRCode.from("Hello World").to(ImageType.GIF).withSize(250, 250).file();
        QRCode.from("Hello World").to(ImageType.GIF).withSize(250, 250).stream();

// override default colors (black on white)
// notice that the color format is "0x(alpha: 1 byte)(RGB: 3 bytes)"
// so in the example below it's red for foreground and yellowish for background, both 100% alpha (FF).
        QRCode.from("Hello World").withColor(0xFFFF0000, 0xFFFFFFAA).file();

// supply own outputstream
        QRCode.from("Hello World").to(ImageType.PNG).writeTo(outputStream);

// supply own file name
        QRCode.from("Hello World").file("QRCode");

// supply charset hint to ZXING
        QRCode.from("Hello World").withCharset("UTF-8");

// supply error correction level hint to ZXING
        QRCode.from("Hello World").withErrorCorrection(ErrorCorrectionLevel.L);

// supply any hint to ZXING
        QRCode.from("Hello World").withHint(EncodeHintType.CHARACTER_SET, "UTF-8");

// encode contact data as vcard using defaults
        VCard vCJohnDoe = new VCard("John Doe")
                .setEmail("john.doe@example.org")
                .setAddress("John Doe Street 1, 5678 Doestown")
                .setTitle("Mister")
                .setCompany("John Doe Inc.")
                .setPhoneNumber("1234")
                .setWebsite("www.example.org");
        QRCode.from(vCJohnDoe).file();

// encode email data
        EMail email = new EMail("John.Doe@example.org");
        QRCode.from(email).file();

// encode mms data
        MMS mms = new MMS(); //"Hello World"
        mms.setNumber("123456");
        mms.setSubject("Hello World");
        QRCode.from(mms).file();

// encode sms data
        SMS sms = new SMS(); //"Hello World"
        sms.setNumber("123456");
        sms.setSubject("Hello World");

        QRCode.from(sms).file();

// encode MeCard data
        MeCard mcJohnDoe = new MeCard("John Doe");
        mcJohnDoe.setEmail("john.doe@example.org");
        mcJohnDoe.setAddress("John Doe Street 1, 5678 Doestown");
        mcJohnDoe.setTelephone("1234");
        QRCode.from(mcJohnDoe).file();

// if using special characters don't forget to supply the encoding
        VCard johnSpecial = new VCard("Jöhn Dɵe")
                .setAddress("ëåäöƞ Sträät 1, 1234 Döestüwn");
        QRCode.from(johnSpecial).withCharset("UTF-8").file();

// QRGen currently supports the following schemas:
// - BizCard
// - Bookmark
// - Email
// - GeoInfo
// - Girocode
// - GooglePlay
// - ICal
// - KddiAu
// - MMS
// - MeCard
// - SMS
// - Telephone
// - Url
// - VCard
// - Wifi
// - YouTube
    }
}
