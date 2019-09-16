package org.lamw.appjcenteremailreceiverdemo1;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Environment;
//import android.util.Log;

import java.io.IOException;
import java.util.Properties;
import javax.mail.Address;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.NoSuchProviderException;
import javax.mail.Part;
import javax.mail.Session;
import javax.mail.Store;
import javax.mail.internet.MimeBodyPart;

/*Draft java code by "Lazarus Android Module Wizard" [9/14/2019 14:43:24]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/

//ref. https://www.codejava.net/java-ee/javamail/receive-e-mail-messages-from-a-pop3-imap-server
//ref. https://alvinalexander.com/java/javamail-pop-pop3-reader-email-inbox-example
public class jcMail /*extends ...*/ {

    private long pascalObj = 0;        //Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private Context context = null;

    String mProtocol = "imap";
    String mHost;
    String mPort;
    String mUserName;
    String mPassword;
    String mAttachSaveDirectory = "";//Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).getPath();

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    public jcMail(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;
    }

    public void jFree() {
        //free local objects...
    }

    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

    private Properties getServerProperties(String protocol, String host, String port) {
        Properties properties = new Properties();// server setting
        properties.put(String.format("mail.%s.host", protocol), host);
        properties.put(String.format("mail.%s.port", protocol), port);
        // SSL setting
        properties.setProperty(String.format("mail.%s.socketFactory.class", protocol), "javax.net.ssl.SSLSocketFactory");
        properties.setProperty(String.format("mail.%s.socketFactory.fallback", protocol), "false");
        properties.setProperty(String.format("mail.%s.socketFactory.port", protocol), String.valueOf(port));
        return properties;
    }

    private String parseAddresses(Address[] address) {
        String listAddress = "";

        if (address != null) {
            for (int i = 0; i < address.length; i++) {
                listAddress += address[i].toString() + ", ";
            }
        }
        if (listAddress.length() > 1) {
            listAddress = listAddress.substring(0, listAddress.length() - 2);
        }
        return listAddress;
    }

    public void SetProtocol(int _protocol) {

        switch (_protocol) {
            case 0:
                mProtocol = "imap";
                break;
            case 1:
                mProtocol = "pop3";
                break;
        }
    }

    public void SetHostName(String _host) {
        mHost = _host;
    }

    public void SetHostPort(int _port) {
        mPort = String.valueOf(_port);
    }

    public void SetUserName(String _user) {
        mUserName = _user;
    }

    public void SetPassword(String _password) {
        mPassword = _password;
    }

    public void SetAttachmentsSaveDirectory(String _envDirectory) {
        mAttachSaveDirectory = _envDirectory;
    }

    public int GetInBoxCount() { //String protocol, String host, String port, String userName, String password
        Properties properties = getServerProperties(mProtocol, mHost, mPort);
        Session session = Session.getDefaultInstance(properties);
        Message[] messages;
        Folder folderInbox;
        Store store;
        int count = 0;
        try {
            // connects to the message store
            store = session.getStore(mProtocol);
            store.connect(mUserName, mPassword);
            // opens the inbox folder
            folderInbox = store.getFolder("INBOX");
            folderInbox.open(Folder.READ_ONLY);
            // fetches new messages from server
            messages = folderInbox.getMessages();
            count = messages.length;
            // disconnect
            folderInbox.close(false);
            store.close();

        } catch (NoSuchProviderException ex) {
            System.out.println("No provider for protocol: " + mProtocol);
            ex.printStackTrace();
        } catch (MessagingException ex) {
            System.out.println("Could not connect to the message store");
            ex.printStackTrace();
        }
        return count;
    }

    public String GetInBoxMessage(int _index, String _partsDelimiter) { //String host, String port, String userName, String password

        Properties properties = getServerProperties(mProtocol, mHost, mPort);
        Session session = Session.getDefaultInstance(properties);
        int count =0 ;
        int i = 0;
        String result = null;
        boolean hasAttachment = false;
        String mimetype = "";

        //ArrayList<String> list=new ArrayList<String>();
        try {
            //connects to the message store
            Store store = session.getStore(mProtocol);
            store.connect(mUserName, mPassword);
            //opens the inbox folder
            Folder folderInbox = store.getFolder("INBOX");
            folderInbox.open(Folder.READ_ONLY);
            //fetches new messages from server
            Message[] messages = folderInbox.getMessages();
            count = messages.length;
            if (count <= 0) return null;
            i = _index;
            if (i < 0) i = 0;
            if (i >= count) i = count-1;
            //for (int i = 0; i < messages.length; i++) {
            Message msg = messages[i];
            //Message message = arrayMessages[i];
            // store attachment file name, separated by comma
            String attachFiles = "";
            Address[] fromAddress = msg.getFrom();
            String from = fromAddress[0].toString();
            String subject = msg.getSubject();
            String toList = parseAddresses(msg.getRecipients(RecipientType.TO));
            String ccList = parseAddresses(msg.getRecipients(RecipientType.CC));
            String sentDate = msg.getSentDate().toString();

            String contentType = (msg.getContentType()).toLowerCase();

            String messageContent = "";

            if (contentType.contains("multipart")) {
                //content may contain attachments
                Multipart multiPart = (Multipart) msg.getContent();
                int numberOfParts = multiPart.getCount();
                for (int partCount = 0; partCount < numberOfParts; partCount++) {
                    MimeBodyPart part = (MimeBodyPart) multiPart.getBodyPart(partCount);
                    if (Part.ATTACHMENT.equalsIgnoreCase(part.getDisposition())) {
                        // this part is attachment
                        String fileName = part.getFileName();

                        if (!mAttachSaveDirectory.equals("")) {
                            attachFiles += fileName + _partsDelimiter;
                            part.saveFile(mAttachSaveDirectory + "/" + fileName);
                        }

                    } else {
                        String temp = (part.getContentType()).toLowerCase();
                        //this part may be the message content
                        if ( temp.contains("text/plain") ) {
                            messageContent = part.getContent().toString();
                            mimetype = temp;
                        }
                    }
                }
                if (attachFiles.length() > 1) {
                    attachFiles = attachFiles.substring(0, attachFiles.length() - 1);
                    hasAttachment = true;
                }
            }
            else if (contentType.contains("text/plain") || contentType.contains("text/html") ) {
                try {
                    Object content = msg.getContent();
                    if (content != null) {
                        messageContent = content.toString();
                        mimetype = contentType;
                    }
                } catch (Exception ex) {
                    messageContent = "[Error downloading content]";
                    ex.printStackTrace();
                }
            }
            result ="From: " + from + _partsDelimiter +
                    "To: " + toList + _partsDelimiter +
                    "CC: " + ccList + _partsDelimiter +
                    "Date: " + sentDate + _partsDelimiter +
                    "Subject: " + subject + _partsDelimiter +
                    "ContentType: " + mimetype+_partsDelimiter +
                    "ContentText: " + messageContent+_partsDelimiter +
                    "Attachments: " + attachFiles;

            // disconnect
            folderInbox.close(false);
            store.close();

        } catch (NoSuchProviderException ex) {
            System.out.println("No provider for protocol: " + mProtocol);
            ex.printStackTrace();
        } catch (MessagingException ex) {
            System.out.println("Could not connect to the message store");
            ex.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

    public void GetInBoxCountAsync() {
        (new AsyncTaskGetInBoxCount()).execute();
    }

  /*
    Params [input], the type of the parameters sent to the task upon execution.
    Progress [], the type of the progress units published during the background computation.
    Result [output], the type of the result of the background computation.
     */
    class AsyncTaskGetInBoxCount extends AsyncTask<Void, Integer, Integer> {

        int count;

        public AsyncTaskGetInBoxCount() {
          //
        }

        @Override
        protected void onPreExecute() {
            //
        }

        @Override
        protected Integer doInBackground(Void... params) {
            // Do things
            return GetInBoxCount();
            // Call this to update your progress
            //publishProgress(i);
        }

        @Override
        protected void onProgressUpdate(Integer... progress) {
            // super.onProgressUpdate(values);
        }

        @Override
        protected void onPostExecute(Integer countResult) {
            // super.onPostExecute(result);
            controls.pOnMailMessagesCount(pascalObj, countResult.intValue());
        }

    }

    public void GetInBoxMessageAsync(int _index, String _partsDelimiter) {
        //(new AsyncTaskGetInBoxMessage(_index, _partsDelimiter)).execute();
        (new AsyncTaskGetInBoxMessages(_index, 1,  _partsDelimiter)).execute();
    }

    public void GetInBoxMessagesAsync(int _startIndex, int _count,  String _partsDelimiter) {
        (new AsyncTaskGetInBoxMessages(_startIndex, _count,  _partsDelimiter)).execute();
    }

  /*
    Params [input], the type of the parameters sent to the task upon execution.
    Progress [], the type of the progress units published during the background computation.
    Result [output], the type of the result of the background computation.
     */

    class AsyncTaskGetInBoxMessages extends AsyncTask<Void, String, Integer> {

        String  _partsDelimiter;
        int _startIndex;
        int _count;
        int resIndex;
        boolean hasAttachment = false;

        public AsyncTaskGetInBoxMessages(int startIndex, int count,  String partsDelimiter) {
            _startIndex = startIndex;
            _partsDelimiter = partsDelimiter;
            _count = count;
        }

        @Override
        protected void onPreExecute() {
            //
        }

        @Override
        protected Integer doInBackground(Void... params) {
            // Do things
            Properties properties = getServerProperties(mProtocol, mHost, mPort);
            Session session = Session.getDefaultInstance(properties);
            String attachFiles = "";
            int startIndex = _startIndex;
            int endIndex;
            int count = _count;
            String msgheader="";
            String mimetype="";

            if (startIndex < 0) startIndex = 0;

            try {
                // connects to the message store
                Store store = session.getStore(mProtocol);
                store.connect(mUserName, mPassword);
                // opens the inbox folder
                Folder folderInbox = store.getFolder("INBOX");
                folderInbox.open(Folder.READ_ONLY);
                // fetches new messages from server
                Message[] messages = folderInbox.getMessages();

                if (startIndex > messages.length) {
                    startIndex = messages.length - 1;
                    count = 1;
                }

                endIndex = startIndex + count;

                if  (endIndex > messages.length) endIndex = messages.length;

                //for (int i = 0; i < messages.length; i++) {
                for (int i = startIndex; i < endIndex; i++) {
                    resIndex = i;
                    hasAttachment = false;
                    Message msg = messages[i];
                    Address[] fromAddress = msg.getFrom();
                    String from = fromAddress[0].toString();
                    String subject = msg.getSubject();
                    String toList = parseAddresses(msg.getRecipients(RecipientType.TO));
                    String ccList = parseAddresses(msg.getRecipients(RecipientType.CC));
                    String sentDate = msg.getSentDate().toString();

                    String contentType = (msg.getContentType()).toLowerCase();
                    mimetype = "";
                    String messageContent = "";

                    if (contentType.contains("multipart")) {
                        //content may contain attachments
                        Multipart multiPart = (Multipart) msg.getContent();
                        int numberOfParts = multiPart.getCount();
                       // Log.i("NUMBERPARTS",numberOfParts + "  i = "+i);
                        for (int partCount = 0; partCount < numberOfParts; partCount++) {
                            MimeBodyPart part = (MimeBodyPart) multiPart.getBodyPart(partCount);
                            if (Part.ATTACHMENT.equalsIgnoreCase(part.getDisposition())) {
                                //this part is attachment
                                String fileName = part.getFileName();

                                if (!mAttachSaveDirectory.equals("")) {
                                    attachFiles += fileName + _partsDelimiter;
                                    part.saveFile(mAttachSaveDirectory + "/" + fileName);
                                }

                            } else {
                                String temp = (part.getContentType()).toLowerCase();
                                //this part may be the message content
                                if ( temp.contains("text/plain") ) {
                                    messageContent = part.getContent().toString();
                                    mimetype = temp;
                                }
                            }
                        }

                        if (attachFiles.length() > 1) {
                            attachFiles = attachFiles.substring(0, attachFiles.length() - 1);
                            hasAttachment = true;
                        }
                    }
                    else if (contentType.contains("text/plain") || contentType.contains("text/html")) {
                        try {
                            Object content = msg.getContent();
                            if (content != null) {
                                messageContent = content.toString();
                                mimetype = contentType;
                            }
                        } catch (Exception ex) {
                            messageContent = "[Error downloading content]";
                            ex.printStackTrace();
                        }
                    }

                    msgheader ="From: " + from + _partsDelimiter +
                            "To: " + toList + _partsDelimiter +
                            "CC: " + ccList;

                    //Call this to update your progress
                    publishProgress(msgheader,sentDate, subject, mimetype, messageContent, attachFiles);

                }
                // disconnect
                folderInbox.close(false);
                store.close();
            } catch (NoSuchProviderException ex) {
                System.out.println("No provider for protocol: " + mProtocol);
                ex.printStackTrace();
            } catch (MessagingException ex) {
                System.out.println("Could not connect to the message store");
                ex.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }

            return count;

        }

        @Override
        protected void onProgressUpdate(String... msg) {
            //super.onProgressUpdate(msg[0]);
            //publishProgress(msgheader,sentDate, subject, mimetype, messageContent, attachFiles);
            controls.pOnMailMessageRead(pascalObj,resIndex, msg[0],msg[1],msg[2],msg[3],msg[4],msg[5]);
        }

        @Override
        protected void onPostExecute(Integer count) {
            // super.onPostExecute(result);
        }

    }
}
