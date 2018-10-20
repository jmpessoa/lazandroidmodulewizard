package org.lamw.appsmsmanagerdemo1;

/*Draft java code by "Lazarus Android Module Wizard" [10/4/2018 17:10:08]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.telephony.SmsMessage;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;

public class jSMSManager /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private Context context   = null;

    private ArrayList<String> mInboxList;
    private String mHeaderBodyDelimiter = "|";

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jSMSManager(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
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

    //http://codetheory.in/android-sms/
//http://www.developerfeed.com/java/tutorial/sending-sms-using-android
//http://www.techrepublic.com/blog/software-engineer/how-to-send-a-text-message-from-within-your-android-app/
    public boolean Send(String _phoneNumber, String _msg, boolean _multipartMessage) {
        SmsManager sms = SmsManager.getDefault();
        try {
            //SmsManager.getDefault().sendTextMessage(phoneNumber, null, msg, null, null);
            if (_multipartMessage) {
                ArrayList<String> messages = sms.divideMessage(_msg);
                sms.sendMultipartTextMessage(_phoneNumber, null, messages, null, null);
            } else {
                List<String> messages = sms.divideMessage(_msg);
                for (String message : messages) {
                    sms.sendTextMessage(_phoneNumber, null, message, null, null);
                }
            }
            //Log.i("Send_SMS",phoneNumber+": "+ msg);
            return true; //ok
        } catch (Exception e) {
            //Log.i("Send_SMS Fail",e.toString());
            return false; //fail
        }
    }

    public boolean Send(String _phoneNumber, String _msg, String _packageDeliveredAction, boolean _multipartMessage) {
        String SMS_DELIVERED = _packageDeliveredAction;
        PendingIntent deliveredPendingIntent = PendingIntent.getBroadcast(controls.activity, 0, new Intent(SMS_DELIVERED), 0);
        SmsManager sms = SmsManager.getDefault();
        try {
            //SmsManager.getDefault().sendTextMessage(phoneNumber, null, msg, null, deliveredPendingIntent);
            if (_multipartMessage) {
                ArrayList<String> messages = sms.divideMessage(_msg);
                ArrayList<PendingIntent> deliveredPendingIntents = new ArrayList<PendingIntent>();
                for (int i = 0; i < messages.size(); i++) {
                    deliveredPendingIntents.add(i, deliveredPendingIntent);
                }
                sms.sendMultipartTextMessage(_phoneNumber, null, messages, null, deliveredPendingIntents);
            } else {
                List<String> messages = sms.divideMessage(_msg);
                for (String message : messages) {
                    sms.sendTextMessage(_phoneNumber, null, message, null, deliveredPendingIntent);
                }
            }
            //Log.i("Send_SMS",phoneNumber+": "+ msg);
            return true; //ok
        } catch (Exception e) {
            return false; //fail
        }
    }

    public String Read(Intent _intent, String _addressBodyDelimiter)  {
        //---get the SMS message passed in---
        mHeaderBodyDelimiter = _addressBodyDelimiter;
        SmsMessage[] msgs = null;
        String str = "";
        if (_intent.getAction().equals("android.provider.Telephony.SMS_RECEIVED")) {
            Bundle bundle = _intent.getExtras();
            if (bundle != null)
            {
                //---retrieve the SMS message received---
                Object[] pdus = (Object[]) bundle.get("pdus");
                msgs = new SmsMessage[pdus.length];
                for (int i=0; i<msgs.length; i++){
                    msgs[i] = SmsMessage.createFromPdu((byte[])pdus[i]);
                    str += msgs[i].getOriginatingAddress();
                    str += _addressBodyDelimiter;
                    str += msgs[i].getMessageBody().toString();
                    str += " ";
                }
            }
        }
        return str;
    }

    private String dateFromMiliSeconds(long mili){
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss", Locale.getDefault());
        GregorianCalendar calendar = new GregorianCalendar();
        calendar.setTimeInMillis(mili);
        return (sdf.format(calendar.getTime()));
    }

    private int fetchInbox() {

        if (mInboxList == null)
            mInboxList = new ArrayList<String>();
        else
            mInboxList.clear();

        Uri uriSms = Uri.parse("content://sms/inbox");
        Cursor cursor = controls.activity.getContentResolver().query(uriSms, new String[]{"_id", "address", "date", "body"},null,null,null);
        cursor.moveToFirst();
        while  (cursor.moveToNext()) {
            String address = cursor.getString(1);
            String dateTime = dateFromMiliSeconds(cursor.getLong(2));
            String body = cursor.getString(3);
            mInboxList.add(address+" "+dateTime+mHeaderBodyDelimiter+" "+body);
        }
        return mInboxList.size();
    }

    public int GetInboxCount() {
        return fetchInbox();
    }

    public String ReadInbox(int _index) {
        int p = _index;
        int count = 0;

        if (mInboxList == null)   {
            count = GetInboxCount();
        }
        else {
            count = mInboxList.size();
        }

        if (count > 0) {
            if (p < 0) p = 0;
            if ( p > (count - 1) ) {
              p = mInboxList.size() - 1;
            }

            return (String)mInboxList.get(p);
        }
        else return "";
    }

    public String Read(Intent _intent) {
        return Read(_intent, mHeaderBodyDelimiter);
    }

    public void SetHeaderBodyDelimiter(String _delimiter) {
        mHeaderBodyDelimiter = _delimiter;
    }
}
