{Hint: save all files to location: C:\android\workspace\AppListViewDemo6\jni }
unit unit2;

{$mode delphi}

interface

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, AndroidWidget, Laz_And_Controls;
  
type

  { TAndroidModule2 }

  TAndroidModule2 = class(jForm)
    jListView1: jListView;
    jTextView1: jTextView;
    procedure AndroidModule2JNIPrompt(Sender: TObject);
  private
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule2: TAndroidModule2;

implementation
  
{$R *.lfm}
  

{ TAndroidModule2 }

procedure TAndroidModule2.AndroidModule2JNIPrompt(Sender: TObject);
begin
   ShowMessage('OnJNIPrompt....');
   jListView1.Clear;
   jListView1.Add('Hello');
   jListView1.Add('Android');
   jListView1.Add('World');
end;

end.
