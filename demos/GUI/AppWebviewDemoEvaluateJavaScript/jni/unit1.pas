{Hint: save all files to location: C:\android\workspace\AppWebviewDemoEvaluateJavaScript\jni }
unit unit1;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jTextView1: jTextView;
    jWebView1: jWebView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jWebView1EvaluateJavascriptResult(Sender: TObject; data: string);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}
  

{ TAndroidModule1 }

//[Thanks to segator!!]

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  jwebview1.CallEvaluateJavascript('(function() { return document.getElementsByTagName("html")[0].innerText; })();');

  //jwebview1.CallEvaluateJavascript('8*10'); //tested!!!

  //jwebview1.CallEvaluateJavascript('Math.sqrt(2*8)'); //tested!!!

  //jwebview1.CallEvaluateJavascript('(function() { return Math.sqrt(2*18); })();'); //tested!!!

end;

procedure TAndroidModule1.jWebView1EvaluateJavascriptResult(Sender: TObject;
  data: string);
begin
   ShowMessage(data);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  jWebView1.JavaScript:= True;
  jWebView1.LoadFromHtmlString('<html>Hello Android World</html>');
end;

end.
