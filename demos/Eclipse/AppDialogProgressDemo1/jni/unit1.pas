{Hint: save all files to location: C:\adt32\eclipse\workspace\AppDialogProgressDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
  Laz_And_Controls_Events, AndroidWidget;

type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jButton1: jButton;
    jButton2: jButton;
    jButton3: jButton;
    jDialogProgress1: jDialogProgress;
    jImageList1: jImageList;
    jImageView1: jImageView;
    jPanel1: jPanel;
    jTextView1: jTextView;
    jTextView2: jTextView;
    jTimer1: jTimer;
    procedure AndroidModule1BackButton(Sender: TObject);
    procedure jButton1Click(Sender: TObject);
    procedure jButton2Click(Sender: TObject);
    procedure jButton3Click(Sender: TObject);

    procedure jImageView1Click(Sender: TObject);
    procedure jTimer1Timer(Sender: TObject);
  private
    {private declarations}
    FLoopIndex: integer;
    FRunning: integer;
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation

{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.jTimer1Timer(Sender: TObject);
begin
  Inc(FLoopIndex);
  if FRunning = 1 then //Custom Dialog
  begin
     if  FLoopIndex > 8 then FLoopIndex:= 0;
     jImageView1.ImageIndex:= FLoopIndex;
     jTextView2.Text:= 'Please, wait...[' +IntToStr(FLoopIndex)+ ' ]';
  end
  else   //default
    jDialogProgress1.SetMessage('Please, wait... backKey cancel! [' +IntToStr(FLoopIndex)+ ']');
end;
              //jDialogProgress Demo
procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  FLoopIndex:= -1;
  FRunning:= 0; //default dialog is running !
  jDialogProgress1.Title:= 'Lamw: jDialogProgress';  //!  Try it!
  //jDialogProgress1.Title:= '';    //no title !  Try it!
  jDialogProgress1.Show();
  jTimer1.Enabled:= True;
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
  FLoopIndex:= -1;
  FRunning:= 1; //custom is running !
  jDialogProgress1.Title:= 'Lamw: [Custom] jDialogProgress';
  //jDialogProgress1.Title:= '';    //no title ! Try it!
  jDialogProgress1.Show(jPanel1.View);    //NOTE: jPanel1.Visible:= False [in design time!]
  jTimer1.Enabled:= True;
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
  jDialogProgress1.Close; //close custom dialog !!
end;

procedure TAndroidModule1.jImageView1Click(Sender: TObject);
begin
   jDialogProgress1.Close; //close custom dialog !!
end;

procedure TAndroidModule1.AndroidModule1BackButton(Sender: TObject);
begin
  jTimer1.Enabled:= False; //just cleanup ...
end;

end.
