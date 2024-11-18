package org.lamw.appwebdavdemo1;

import android.content.Context;
import android.util.Base64;

import java.io.*;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.net.Socket;

import javax.net.ssl.SSLSocketFactory;
/*
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.security.cert.X509Certificate;
import javax.net.ssl.SSLContext;
import java.security.SecureRandom;
*/
import java.security.*;

/* Draft java code by "Lazarus Android Module Wizard" [01.04.2021 17:08:35]   */
/* https://github.com/jmpessoa/lazandroidmodulewizard                         */
/* jControl LAMW template                                                     */

public class jWebDav /*extends ...*/ {

    private long pascalObj      = 0;     // Pascal Object
    private Controls controls   = null;  // Java/Pascal [events] Interface ...
    private Context context     = null;

    private String mUSERNAME    = "USERNAME";
    private String mPASSWORD    = "PASSWORD";
    private String mHOSTNAME    = "HOSTNAME";
    private int    mPORT        = 443;

    private final String EndOfLine        = "\r\n";
    private final byte[] EndOfHeader;
    private final int    AuthModeBasic    = 0;
    private final int    AuthModeDigest   = 1;

    private final int    HderModeNoData   = 0;
    private final int    HderModeWithData = 1;

    private int    mAUTHMODE    = AuthModeBasic;
    private String mAUTHSTRN    = "";
    private String mClientNonce = "0a4f113b";
    private String mServerNonce = "qe8Iuqy-qV3KUK3v7n5oM_3jWX4=";
    private String mServerRealm = "os@xcerion.com";
    private String mClientNC    = "0000100F";
    private String mQualityProt = "auth";
    private String mAlgorithm   = "MD5";
    private String mServerStal  = "";
    private String mPROPFINDstr = "";

    private List<String> outHeadr;
    private List<String> inpHeadr;

    public jWebDav(Controls _ctrls, long _Self) {
        // super(_ctrls.activity);
      context     = _ctrls.activity;
      pascalObj   = _Self;
      controls    = _ctrls;
      EndOfHeader = new byte[]{13, 10, 13, 10};
    }

    public void jFree() {
        // free local objects...
    }

    public void SetUserNameAndPassword(String _userName, String _password) {
      mUSERNAME = _userName;
      mPASSWORD = _password;
    }

    public void SetHostNameAndPort(String _hostName, int _port) {
      mHOSTNAME = _hostName;
      mPORT     = _port;
      mAUTHMODE = AuthModeBasic;
    }

    private String digest32HexDigits(byte[] digest) {
      StringBuilder digestString = new StringBuilder();
      int low, hi;
        for (byte   b : digest) {
            low =  (b & 0x0f);
            hi  = ((b & 0xf0) >> 4);
            digestString.append(Integer.toString(hi, 16));
            digestString.append(Integer.toString(low, 16));
        }
      return digestString.toString();
    }

    private String MD5(String datastr) {
      try {
        MessageDigest md5 = MessageDigest.getInstance("MD5");
        md5.update(datastr.getBytes("UTF-8"));
          return digest32HexDigits(md5.digest());
      } catch (Exception e) {
          return "";
      }
    }

    private void setClientNonce() {
      mClientNonce = "0a4f113b";
/*
      SecureRandom  random          = SecureRandom.getInstance("SHA1PRNG");
                    random.setSeed(System.currentTimeMillis());
      byte[]        nonceBytes      = new byte[16];
                    random.nextBytes(nonceBytes);
      mClientNonce                  = new String(Base64.encode(nonceBytes, Base64.DEFAULT));
 */
    }

    private String getDigestAuthorization(String ServerMethod, String ServerURI) {
      String entityBody = "";
      String HA1        = "";
      String HA2        = "";
      String response   = "";

      setClientNonce();

      if (mAlgorithm.equals("MD5-sess"))
             HA1      = MD5(MD5(mUSERNAME + ":" + mServerRealm + ":" + mPASSWORD) + ":" +
                                                  mServerNonce + ":" + mClientNonce);
      else   HA1      = MD5(mUSERNAME     + ":" + mServerRealm + ":" + mPASSWORD);

      if (mQualityProt.equals("auth-int"))
             HA2      = MD5(ServerMethod  + ":" + ServerURI + ":" + MD5(entityBody));
      else   HA2      = MD5(ServerMethod  + ":" + ServerURI);

      if (!mQualityProt.equals(""))
             response = MD5(HA1 + ":" + mServerNonce + ":" + mClientNC + ":" + mClientNonce + ":" +
                                        mQualityProt + ":" + HA2);
      else   response = MD5(HA1 + ":" + mServerNonce + ":" + HA2);

      String authorization = "Authorization: " + "Digest " +
              "username=\"" + mUSERNAME     + "\", " +
              "realm=\""    + mServerRealm  + "\", " +
              "nonce=\""    + mServerNonce  + "\", " +
              "algorithm="  + mAlgorithm    + ", "   +
              "uri=\""      + ServerURI     + "\", " +
              "qop="        + mQualityProt  + ", "   +
              "nc="         + mClientNC     + ", "   +  // Increment this each time.
              "cnonce=\""   + mClientNonce  + "\", " +
              "response=\"" + response      + "\"";
      return authorization;
    }

    private String getBasicAuthorization() {
      if (mAUTHSTRN.equals("")) {
        String userCredentials = mUSERNAME + ":"   + mPASSWORD;
        String basicAuth       = "Basic "  + new String(Base64.encode(userCredentials.getBytes(), Base64.DEFAULT));
        String authorization   = "Authorization: " + basicAuth;
        mAUTHSTRN = authorization.trim();
      }
      return mAUTHSTRN;
    }

    private String getAuthorLine(String ServerMethod, String ServerURI){
        if (mAUTHMODE != AuthModeDigest) {
               return getBasicAuthorization();           // Basic  Mode
        }
        if ((!mServerNonce.equals("")) && (!mServerRealm.equals(""))) {
               return getDigestAuthorization(ServerMethod, ServerURI);
                                                         // Digest Mode
        } else return "";
    }

    private SSLSocketFactory getDefaultSocketFactory() {
        return (SSLSocketFactory) SSLSocketFactory.getDefault();
    }

/*
    private SSLSocketFactory GetTrustAllCertsSocketFactory() {
      try {
        TrustManager[] trustAllCerts = new TrustManager[]{
                    new X509TrustManager() {
                        public X509Certificate[] getAcceptedIssuers() {
                            X509Certificate[] myTrustedAnchors = new X509Certificate[0];
                            return myTrustedAnchors;
                        }

                        @Override
                        public void checkClientTrusted(X509Certificate[] certs, String authType) {
                        }

                        @Override
                        public void checkServerTrusted(X509Certificate[] certs, String authType) {
                        }
                    }
            };

        SSLContext sc = SSLContext.getInstance("SSL");
        sc.init(null, trustAllCerts, new SecureRandom());
            return sc.getSocketFactory();

      } catch (Exception e) {
            return getDefaultSocketFactory();
      }
    }
*/

    private String inpHederToString() {
      if  (inpHeadr == null) return "";
      StringBuilder   headBuilder = new StringBuilder();
      for (String headline : inpHeadr) {
                      headBuilder.append(headline );
                      headBuilder.append(EndOfLine); }
        return        headBuilder.toString();
    }

    private String outHederToString() {
      if  (outHeadr == null) return "";
      StringBuilder   headBuilder = new StringBuilder();
      for (String headline : outHeadr) {
                      headBuilder.append(headline );
                      headBuilder.append(EndOfLine); }
        return        headBuilder.toString();
    }

    private String getResultStr(Socket socket, int headermode) {
      try {
                       inpHeadr   = new ArrayList<String>();
//------------------------------------------- header up to empty line ----------------------------------------
        String         inputLine;
        BufferedReader input      = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        while        ((inputLine  = input.readLine()) != null) {
                       inpHeadr.add(inputLine);
                   if (inputLine.length() == 0) break;         }
//-------------------------------------------- result with extra data  ---------------------------------------
        if (headermode == HderModeWithData) {
            for (String headline : inpHeadr) {
                if ((23 < headline.length()) &&
                    (-1 < headline.toLowerCase().indexOf("transfer-encoding", 0)) &&
                    ( 0 < headline.toLowerCase().indexOf("chunked", 18))) {
//-------------------------------------------- find chunked mode ---------------------------------------------
                  while ((inputLine = input.readLine()) != null) {
                    int blocksize;
                    try {
                            blocksize = Integer.parseInt(inputLine, 16);
                        } catch (Exception e) {
                                 return "Chunked blocksize parse Error " + e;
                        }
                        if (blocksize > 0) {
                            char[] buffer      = new char[blocksize];
                            if (input.read(buffer, 0, blocksize)  == blocksize)
                                inpHeadr.add(new String(buffer, 0, blocksize));
                            else return "Chunked blockdata stream read Error";
                        }                                   // blocksize > 0
                        if (!input.readLine().equals(""))   // block final end of line
                                 return "Chunked block end of line Error";
                  }                                         // while readLine()) != null
                                 return inpHederToString(); // for inpHeadr exit
                }                                           // if chunked
            }                                               // for inpHeadr
//-------------------------------------------- string extra data mode -----------------------------------------
            while          ((inputLine = input.readLine()) != null) {
                inpHeadr.add(inputLine);
                if          (inputLine.length() == 0) break;        }
        }
                                 return inpHederToString();
      } catch (Exception e) {    return "ResultError " + e; }
    }

    private boolean getUnauthorized() {
      return ((inpHeadr != null) && (0 < inpHeadr.size()) && (0 < inpHeadr.get(0).indexOf("401")));
    }

    private boolean getMultiStatus() {
      return ((inpHeadr != null) && (0 < inpHeadr.size()) && (0 < inpHeadr.get(0).indexOf("207")));
    }

    private int getDigestServerAuthorization() {
      for (String headline : inpHeadr) {
        if (0   < headline.indexOf("Authenticate")) {
          int idx = headline.indexOf("Digest", 17);
          if (0 < idx) {
            String  substr = headline.substring(idx + 6);
            if (0 < substr.length()) {
              HashMap<String, String> Map = new HashMap<String, String>();
              for (String      retval : substr.split(",")) {
              String[] entry = retval.trim().split("=", 2);
              if  (1 < entry.length)  Map.put(entry[0], entry[1].replace("\"", ""));
              else                    Map.put(entry[0], ""      );
              }
              mAUTHMODE         =     AuthModeDigest;
              mServerRealm      =     Map.get("realm"    );
              mQualityProt      =     Map.get("qop"      );
              mServerNonce      =     Map.get("nonce"    );
              mAlgorithm        =     Map.get("algorithm");
              mServerStal       =     Map.get("stale"    );
              return                  Map.size();
            }
          }
        }
      }       return -1;
    }

    private boolean ReAuthorization(){
      return ( getUnauthorized() && (0 < getDigestServerAuthorization()) );
    }

    private String doServerCommand (String command, int headermode) {
      try {
        SSLSocketFactory ssfact    = getDefaultSocketFactory();
        Socket           socket    = ssfact.createSocket(mHOSTNAME, mPORT);
        DataOutputStream output    = new DataOutputStream(socket.getOutputStream());
        String           header    = outHederToString();
                         output.writeBytes(header);
        String           result    = getResultStr(socket, headermode);
                         output.close();
                         socket.close();
                  return result;
      }  catch (Exception e) {
                  return command + " Error " + e;
      }
    }

    public  String PROPFIND(String _element) throws Exception {
      final String command   = "PROPFIND";
                   outHeadr  = Arrays.asList    (command  + " "     +   _element + " HTTP/1.1",
                                                 "Host: " + mHOSTNAME,
                                                 getAuthorLine(command, _element),
                                                 "Content-Length: " + "0",
                                                 "Content-Type: text/xml",
                                                 "Accept: */*",
                                                 "Connection: Close",
                                                 "Depth: 1",
                                                 "");
            String result    = doServerCommand  (command, HderModeWithData);
      if (ReAuthorization()) {
                   outHeadr.set(2, getAuthorLine(command, _element));
                   result    = doServerCommand  (command, HderModeWithData);
      }
        return     result;
    }

    public  String DELETE(String _elementHref) throws Exception {
      final String command   = "DELETE";
                   outHeadr  = Arrays.asList    (command  + " "     +   _elementHref + " HTTP/1.1",
                                                 "Host: " +  mHOSTNAME,
                                                 getAuthorLine(command, _elementHref),
                                                 "Content-Length: " + "0",
                                                 "Accept: */*",
                                                 "Connection: Close",
                                                 "");
            String result  = doServerCommand    (command, HderModeNoData);
      if (ReAuthorization()) {
                   outHeadr.set(2, getAuthorLine(command, _elementHref));
                   result  = doServerCommand    (command, HderModeNoData);
      }
        return     result;
    }

    private boolean isServerPathExist (String elementHref) {
        try                 {  mPROPFINDstr = PROPFIND(elementHref.substring(0, elementHref.lastIndexOf("/")));
                               return getMultiStatus(); }
        catch (Exception e) {  return false;            }
    }

    private boolean isServerFileExist (String elementHref) {
        try                 {  mPROPFINDstr = PROPFIND(elementHref);
                               return getMultiStatus(); }
        catch (Exception e) {  return false;            }
    }

    private String doServerCommand_PUT (String _elementHref, String _fileName, int callmode) {
      final String       command   = "PUT";
      try {
        SSLSocketFactory ssfact    = getDefaultSocketFactory();
        Socket           socket    = ssfact.createSocket(mHOSTNAME, mPORT);
        DataOutputStream output    = new DataOutputStream(socket.getOutputStream());
        FileInputStream  instm     = new FileInputStream(new File(_fileName));
        int              total     = instm.available();
                         outHeadr  = Arrays.asList    (command  + " "     +    _elementHref + " HTTP/1.1",
                                                       "Host: " +    mHOSTNAME,
                                                        getAuthorLine(command, _elementHref),
                                                       "Content-Length: " + String.valueOf(total),
                                                       "Content-Type: application/binary",
                                                       "Accept: */*",
                                                       "Connection: Close",
                                                       "");
        String           header    = outHederToString();
                         output.writeBytes(header);
        if (callmode==0) total     = 0;
        int              count;
        int              position  = 0;
        byte[]           buffer    = new byte[8192];
          while((count = instm. read (buffer)) > 0) {
                         output.write(buffer, 0, count);
            if      (0 < total) {
                         position += count;
                         controls.pOnWebDavGetProgress(pascalObj, position, total);
            }
          }
        String           result    = getResultStr (socket, HderModeNoData);
                         output.close();
                         instm. close();
                         socket.close();
            return       result;
      } catch (Exception e) {
            return       command + " Error " + e;
      }
    }

    public String PUT(String _elementHref,    String _fileName) throws Exception {
      if  (isServerPathExist(_elementHref))
            return doServerCommand_PUT(_elementHref, _fileName, 0);
      else  return mPROPFINDstr;
    }

    private int HeaderSize_GET(byte[] buffer, int count) {
      for (int i = 0; i <= count - EndOfHeader.length; i++) {
        int    j = 0;
        while (j <  EndOfHeader.length && buffer[j + i] == EndOfHeader[j]) {
               j++;
        }
        if    (j == EndOfHeader.length) {
             return EndOfHeader.length + i;
        }
      }
             return -1;
    }

    private int GetWebDavFileSize(String retheader) {
      int                      result = 0;
      String[] parts = retheader.split(EndOfLine);
      if ((parts != null) && (0 < parts.length)) {
        if ((0 < parts[0].indexOf("200")) || (0 < parts[0].indexOf("204"))) {
          for (int i = 1; i < parts.length; i++) {
            if (-1 < parts[i].toLowerCase().indexOf("content-length")) {
              int      Idx = parts[i].indexOf(":", 14);
              if (13 < Idx) {
                String SizeStr = parts[i].substring(Idx + 1).trim();
                try {
                               result = Integer.parseInt(SizeStr);
                        return result;
                } catch (Exception e) {
                }
              }
            }
          }
        }
      }                 return result;
    }

    private String doServerCommand_GET (String _elementHref, String _fileName, int callmode) {
      final String       command   = "GET";
      try {
        SSLSocketFactory ssfact    = getDefaultSocketFactory();
        Socket           socket    = ssfact.createSocket(mHOSTNAME, mPORT);
        DataInputStream  input     = new DataInputStream (socket.getInputStream ());
        DataOutputStream output    = new DataOutputStream(socket.getOutputStream());
        FileOutputStream outstm    = new FileOutputStream(new File(_fileName));
                         outHeadr  = Arrays.asList    (command  + " "     +   _elementHref + " HTTP/1.1",
                                                       "Host: " +       mHOSTNAME,
                                                       getAuthorLine(command, _elementHref),
                                                       "Content-Length: " + "0",
                                                       "Content-Type: application/binary",
                                                       "Accept: */*",
                                                       "Connection: Close",
                                                       "");
        String           header    = outHederToString();
                         output.writeBytes(header);
//----------------------------------------------------------------------------------------------------------------------
        int              count;
        byte[]           buffer    = new byte[8192];
        String           result    = command + " Error " + "No data from server";

        if ((count = input.read(buffer)) > 0) {
          int  HeaderSize;
          if ((HeaderSize = HeaderSize_GET(buffer, count)) > 0) {
            result = new String(buffer, 0, HeaderSize);
            int              total;
            if (callmode==0) total  = 0;
            else             total  = GetWebDavFileSize(result);

            count      -= HeaderSize;
                           outstm.write(buffer, HeaderSize, count);
            int position  = 0;
              if (0 < total) {
                position += count;
                controls.pOnWebDavGetProgress(pascalObj, position, total);
            }

            while((count = input. read (buffer)) > 0) {
                           outstm.write(buffer, 0, count);
              if      (0 < total) {
                position += count;
                controls.pOnWebDavGetProgress(pascalObj, position, total);
              }
            }
          }
        }
//----------------------------------------------------------------------------------------------------------------------
                         input. close();
                   //    output.close();  Android 14
                         outstm.close();
                         socket.close();
            return       result;
      } catch (Exception e) {
            return       command + " Error " + e;
      }
    }

    public String GET(String _elementHref,    String _fileName) throws Exception {
      if  (isServerFileExist(_elementHref))
            return doServerCommand_GET(_elementHref, _fileName, 0);
      else  return mPROPFINDstr;
    }

//----------------------------- to do ------------------------------------------

    public String MKCOL(String _element) {
       return  "MKCOL Error";
    }

    public String PROPPATCH(String _elementHref, String _elementProp) {
       return  "PROPPATCH Error";
    }

//------------------------------------------------------------------------------

    public void   UpLoadFile(String _elementHref, String _fileName) throws Exception {
      final String      elementHref      = _elementHref;
      final String      fileName         = _fileName;

      new   Thread(new Runnable() {
        @Override
        public void run() {
            String             result;
            if (isServerPathExist(elementHref))
                               result    = doServerCommand_PUT(elementHref, fileName, 1);
            else               result    = mPROPFINDstr;
                               controls.pOnWebDavGetResultStr (pascalObj, result);
          }
	        }).start();
    }

    public void   DnLoadFile(String _elementHref, String _fileName) throws Exception {
      final   String      elementHref    = _elementHref;
      final   String      fileName       = _fileName;

      new   Thread(new Runnable() {
        @Override
        public void run() {
            String             result;
            if (isServerFileExist(elementHref))
                               result    = doServerCommand_GET(elementHref, fileName, 1);
            else               result    = mPROPFINDstr;
                               controls.pOnWebDavGetResultStr (pascalObj, result);
       }
          }).start();
    }

}
