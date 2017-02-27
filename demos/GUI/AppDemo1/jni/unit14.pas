{Hint: save all files to location: \jni }
unit unit14;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule14 }

  TAndroidModule14 = class(jForm)
      jButton1: jButton;
      jCheckBox1: jCheckBox;
      jEditText1: jEditText;
      jEditText2: jEditText;
      jHttpClient1: jHttpClient;
      jProgressBar1: jProgressBar;
      jScrollView1: jScrollView;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;
      jTimer1: jTimer;
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jCheckBox1Click(Sender: TObject);
      procedure jHttpClient1CodeResult(Sender: TObject; code: integer);
      procedure jHttpClient1ContentResult(Sender: TObject; content: string);
      procedure jTimer1Timer(Sender: TObject);
    private
       {private declarations}
        FTaskDoing: boolean;
        FProgress: integer;
    public
       {public declarations}
  end;

var
  AndroidModule14: TAndroidModule14;

implementation
  
{$R *.lfm}
  

{ TAndroidModule14 }


procedure TAndroidModule14.DataModuleJNIPrompt(Sender: TObject);
begin
   if not Self.isConnected() then
  begin //try wifi
    if Self.SetWifiEnabled(True) then
      jCheckBox1.Checked:= True
    else
      ShowMessage('Please,  try enable some connection...');
  end
  else
  begin
     if Self.isConnectedWifi() then jCheckBox1.Checked:= True
  end;
end;

procedure TAndroidModule14.jButton1Click(Sender: TObject);
begin
  jEditText1.Clear;
  jEditText2.Clear;
  FProgress:= 0;  //out param
  jButton1.Text:= 'Running...';
  jProgressBar1.Progress:= 0;
  jProgressBar1.Start;
  jTimer1.Enabled:= True;

  jHttpClient1.GetAsync;
end;

procedure TAndroidModule14.jCheckBox1Click(Sender: TObject);
begin
   if jCheckBox1.Checked then
   begin
     if not Self.IsWifiEnabled() then Self.SetWifiEnabled(True);
   end else Self.SetWifiEnabled(True);
end;

procedure TAndroidModule14.jHttpClient1CodeResult(Sender: TObject; code: integer);
begin
   ShowMessage('Http Code = '+ IntToStr(code));
end;

procedure TAndroidModule14.jHttpClient1ContentResult(Sender: TObject; content: string);
begin
   FProgress:= 0;  //out param
   jTimer1.Enabled:= False;
   jProgressBar1.Stop;

   jEditText1.Text:= content;
   jEditText2.Text:= content;

   jButton1.Text:= 'Http.GetAsync';
end;

procedure TAndroidModule14.jTimer1Timer(Sender: TObject);
begin
   if FProgress <= jProgressBar1.Max then
   begin
      jProgressBar1.Progress:= FProgress;
      FProgress:=  FProgress + 1; //out param
   end
   else
   begin
      jProgressBar1.Progress:= 0;
      FProgress:= 0;  //out param
   end;
end;

end.
