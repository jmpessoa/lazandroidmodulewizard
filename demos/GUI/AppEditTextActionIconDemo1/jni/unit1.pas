{hint: Pascal files location: ...\AppEditTextActionIconDemo1\jni }
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
    jEditText1: jEditText;
    jTextView1: jTextView;
    jTextView2: jTextView;
    procedure jEditText1ActionIconTouchDown(Sender: TObject; textContent: string
      );
    procedure jEditText1ActionIconTouchUp(Sender: TObject; textContent: string);
    procedure jEditText1Changed(Sender: TObject; txt: string; count: integer);
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

//thanks to @Agmcz!

procedure TAndroidModule1.jEditText1Changed(Sender: TObject; txt: string;  
  count: integer);
begin
     if jEditText1.GetTextLength() > 0 then
   begin
     if not jEditText1.IsActionIconShowing() then
     begin
       ShowMessage('Show');
       jEditText1.ShowActionIcon();
     end;
   end;
end;

procedure TAndroidModule1.jEditText1ActionIconTouchDown(Sender: TObject;
  textContent: string);
begin
    //ShowMessage('[Down] '  + textContent);
end;

procedure TAndroidModule1.jEditText1ActionIconTouchUp(Sender: TObject;
  textContent: string);
begin
  //ShowMessage('[UP] '  + textContent);
  jEditText1.Clear;       // do some action here!!!!
  jEditText1.HideActionIcon();
end;

end.
