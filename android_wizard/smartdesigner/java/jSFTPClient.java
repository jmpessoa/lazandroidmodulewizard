package org.test.ftp;
 
import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;
import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpATTRS;
import com.jcraft.jsch.SftpException;
import com.jcraft.jsch.ChannelSftp.LsEntry;
import java.io.InputStream;
 
/*Draft java code by "Lazarus Android Module Wizard" [9/23/2019 19:05:10]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jControl LAMW template*/
 
//ref. https://www.woolha.com/tutorials/java-connecting-to-sftp-uploading-downloading-files
//https://ourcodeworld.com/articles/read/29/how-to-list-a-remote-path-with-jsch-sftp-in-android
//https://stackoverflow.com/questions/41050989/basic-ssh-connection-via-jsch-on-android/43147951
//https://stackoverflow.com/questions/14323661/simple-ssh-connect-with-jsch
//https://www.woolha.com/tutorials/java-connecting-to-sftp-uploading-downloading-files
 
public class jSFTPClient /*extends ...*/ {
 
    private long pascalObj = 0;        //Pascal Object
    private Controls controls = null; //Java/Pascal [events] Interface ...
    private Context context = null;
 
    private String host = "test.rebex.net";
    private int port = 22;
    private Session session = null;
 
    private String identityKey = "";//if the FTP server requires certificate
 
    private String username = ""; //demo
    private String password = "";  //password
 
    private boolean isConnected = false;
 
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
    public jSFTPClient(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!
        //super(_ctrls.activity);
        context = _ctrls.activity;
        pascalObj = _Self;
        controls = _ctrls;
    }
 
    public void jFree() {
        //free local objects...
        if (session != null) {
            session.disconnect();
        }
    }
 
    //write others [public] methods code here......
    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
 
    public boolean connect() throws JSchException {
        JSch jsch = new JSch();
        boolean res = false;
        //if the FTP server requires certificate
        if ( !identityKey.equals("") ) {
            jsch.addIdentity(identityKey);
        }
        if (username.equals("")) {
            session = jsch.getSession(host);
        } else { //if the FTP server requires username/password
            session = jsch.getSession(username, host, port);
            session.setPassword(password);
        }
        session.setConfig("StrictHostKeyChecking", "no");
        session.connect();
        isConnected = true;
        return isConnected;
    }
 
    public boolean upload(String source, String destination) throws JSchException, SftpException {
        boolean res = false;
        if (session == null) return res;
        Channel channel = session.openChannel("sftp");
        channel.connect();
        ChannelSftp sftpChannel = (ChannelSftp) channel;
        String  ss = destination;
        String[] arr = ss.split("/");
        String pathfile = arr[arr.length-2];
        //System.out.println("folder:"+pathfile);
 
        sftpChannel.cd(pathfile);
        sftpChannel.put(source, destination);
        res = true;
        sftpChannel.exit();
        return res;
    }
 
    public boolean download(String source, String destination) throws JSchException, SftpException {
        boolean res = false;
        if (session == null) return res;
        Channel channel = session.openChannel("sftp");
        channel.connect();
        ChannelSftp sftpChannel = (ChannelSftp) channel;
        String  ss = source;
        String[] arr = ss.split("/");
        String pathfile = arr[arr.length-2];
        //System.out.println("folder:"+pathfile);
 
        sftpChannel.cd(pathfile);
        sftpChannel.get(source, destination);
        res = true;
        sftpChannel.exit();
        return res;
    }
 
    public void Disconnect() {
        if (session != null) {
            session.disconnect();
        }
    }
 
    public void SetHost(String _host) {
        host = _host;
    }
 
    public void SetPort(int _port) {
        port = _port;
    }
 
    public void SetIdentityCertificateKey(String _certificateKey) {
        identityKey = _certificateKey;//if the FTP server requires certificate
    }
 
    public void SetPassword(String _password) {
        password = _password;
    }
 
    public void SetUsername(String _username) {
       username = _username;
    }
 
    public void Connect() {
       new ConnectTask().execute();
    }
 
    //Params,Progress,Result
    class ConnectTask extends AsyncTask<Void,Void,Boolean> {
 
        @Override
        protected Boolean doInBackground(Void... p) {
 
            boolean res = false;
            try {
                res = connect();
            } catch (JSchException e) {
                res = false;
                e.printStackTrace();
            }
            return res;
        }
        @Override
        protected void onPostExecute(Boolean conn){
            controls.pOnSFTPClientTryConnect(pascalObj, (boolean)conn);
        }
    }
 
    public void Download(String _url, String saveToLocal) {
       new AsyncUpOrDownTask(_url,saveToLocal).execute(0);
    }
 
    public void Upload(String _fromLocal, String _url) {
        new AsyncUpOrDownTask(_fromLocal,_url).execute(1);
    }
 
    //Parâmetros,Progresso,Resultado
    class AsyncUpOrDownTask extends AsyncTask<Integer,Integer,Boolean> {
 
        public String source;
        public String destination;
        public int task;
 
        public AsyncUpOrDownTask(String _source, String _destination) {
            source = _source;
            destination = _destination;
        }
 
        @Override
        protected Boolean doInBackground(Integer... p) {
 
            boolean success= false;
 
            try {
                if (p[0] == 0) {
                    task = 0;
                    success = download(source, destination);
                }
                else {
                    task = 1;
                    success = upload(source, destination);
                }
 
            } catch (JSchException e) {
                success = false;
                e.printStackTrace();
            } catch (SftpException e) {
                success = false;
                e.printStackTrace();
            }
 
            return success;
        }
 
        protected void onProgressUpdate(Integer params){
            //
        }
 
        @Override
        protected void onPostExecute(Boolean succ){
            if (task == 0)
                controls.pOnSFTPClientDownloadFinished(pascalObj, destination, (boolean)succ);
            else
                controls.pOnSFTPClientUploadFinished(pascalObj, destination, (boolean)succ);
 
        }
    }
 
    public void ListFiles(String _remotePath) {
           new AsyncListTask(_remotePath, 0).execute(_remotePath);
    }
 
    //TODO
    public void CountFiles(String _remotePath) {
        new AsyncListTask(_remotePath, 1).execute(_remotePath);
    }
 
    //Parâmetros,Progresso,Resultado
    class AsyncListTask extends AsyncTask<String,String, Integer> {
 
        public String directory;
        public int task;
 
        public AsyncListTask(String _directory, int _task) {
            directory = _directory;
            task = _task;
        }
 
        @Override
        protected Integer doInBackground(String... path) {
            int count =  0;
 
            try {
                Channel channel = session.openChannel("sftp");
                channel.connect();
                ChannelSftp sftp = (ChannelSftp) channel;
 
                // Now that we have a channel, go to a directory first if we want .. you can give to the ls the path
                //ex "/pub/example"
 
                // Get the content of the actual path using ls instruction or use the previous string of the cd instruction
                @SuppressWarnings("unchecked")
                java.util.Vector<LsEntry> flLst = sftp.ls(path[0]);  //  "/pub/example"
                int i = flLst.size();
                    //get info of every folder/file/link
                for (int j = 0; j < i; j++) {
                        LsEntry entry = flLst.get(j);
                        SftpATTRS attr = entry.getAttrs();
                        System.out.println(entry.getFilename());
                        if (!attr.isDir()) {
                            if (!attr.isLink()) {
                                count = count + 1;
                                if (task == 0) {
                                    publishProgress(path[0], entry.getFilename(), String.valueOf(attr.getSize()));
                                }
                            }
                        }
                }
                channel.disconnect();
                //session.disconnect();
            } catch (JSchException e) {
                System.out.println(e.getMessage().toString());
                e.printStackTrace();
            } catch (SftpException e) {
                System.out.println(e.getMessage().toString());
                e.printStackTrace();
            }
            return count;
        }
 
        protected void onProgressUpdate(String... params){
            controls.pOnSFTPClientListing(pascalObj, params[0], params[1], Integer.parseInt(params[2]));
        }
 
        @Override
        protected void onPostExecute(Integer count){
            controls.pOnSFTPClientListed(pascalObj, (int)count);
        }
 
    }
 
    //TODO
    public void ExecCommand(String _command) {
 
        String host="ssh.journaldev.com";
        String user="sshuser";
        String password="sshpwd";
        String command1="ls -ltr";
 
        try{
            java.util.Properties config = new java.util.Properties();
            config.put("StrictHostKeyChecking", "no");
            JSch jsch = new JSch();
            Session session=jsch.getSession(user, host, 22);
            session.setPassword(password);
            session.setConfig(config);
            session.connect();
            System.out.println("Connected");
 
            Channel channel=session.openChannel("exec");
            ((ChannelExec)channel).setCommand(command1);
            channel.setInputStream(null);
            ((ChannelExec)channel).setErrStream(System.err);
 
            InputStream in=channel.getInputStream();
            channel.connect();
            byte[] tmp=new byte[1024];
            while(true){
                while(in.available()>0){
                    int i=in.read(tmp, 0, 1024);
                    if(i<0)break;
                    System.out.print(new String(tmp, 0, i));
                    Log.i("TAGT", new String(tmp, 0, i));
                }
                if(channel.isClosed()){
                    System.out.println("exit-status: "+channel.getExitStatus());
                    Log.i("TAGEX", "exit-status: "+channel.getExitStatus());
                    break;
                }
                try{Thread.sleep(1000);}catch(Exception ee){}
            }
            channel.disconnect();
            session.disconnect();
            System.out.println("DONE");
        }catch(Exception e){
            e.printStackTrace();
        }
    }
 
}
 