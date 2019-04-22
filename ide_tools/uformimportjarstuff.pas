unit uformimportjarstuff;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Buttons, ExtCtrls;

type

  { TFormImportJAR }

  TFormImportJAR = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    LabelSelect: TLabel;
    ListBox1: TListBox;
    Panel1: TPanel;
    RadioGroupFrom: TRadioGroup;
    RadioGroupDesign: TRadioGroup;
    SpeedButtonShowMethods: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure RadioGroupFromClick(Sender: TObject);
    procedure SpeedButtonShowMethodsClick(Sender: TObject);
  private

  public
    Task: string;
    Executable: string;
    TaskMode: integer;
    FListMethods: TStringList;
    ConstructorSignature: string;
    MethodSignatureList: TStringList;
  end;

var
  FormImportJAR: TFormImportJAR;

implementation

{$R *.lfm}

{ TFormImportJAR }

procedure TFormImportJAR.FormActivate(Sender: TObject);
var
  i, p: integer;
  jarclassName, temp: string;
begin

   if TaskMode = 0 then
   begin
       for i:= 0 to MethodSignatureList.Count - 1 do
       begin
          if MethodSignatureList.Strings[i] <> '.classpath' then
          begin
             p:= Pos('.', MethodSignatureList.Strings[i]);
             temp:= Copy(MethodSignatureList.Strings[i],1, p-1);
             jarclassName:= StringReplace(temp, '/', '.', [rfIgnoreCase, rfReplaceAll]);
             if Pos('$', jarclassName) <= 0 then
                ListBox1.Items.Add(jarclassName);  //skip class inner class
          end;
       end;
   end;

   if TaskMode = 1 then
   begin
       if Pos('public ', MethodSignatureList.Strings[1])  > 0 then //skip file inner class
       begin
         if Pos('interface ', MethodSignatureList.Strings[1])  <= 0 then
         begin
           for i:= 2 to MethodSignatureList.Count - 2 do
           begin
             if Pos(Self.ConstructorSignature, MethodSignatureList.Strings[i]) > 0 then //public org.lamw.simplemath.Eq2GSolver(
             begin
                //public org.lamw.simplemath.Eq2GSolver(float, float, float);
                ListBox1.Items.Add(MethodSignatureList.Strings[i]);
             end
             else
             begin
               if Pos('public ', MethodSignatureList.Strings[i]) > 0 then  //skip method private
               begin
                 if Pos('(', MethodSignatureList.Strings[i]) > 0 then //skip class filds
                 begin
                   temp:= StringReplace(MethodSignatureList.Strings[i], ';', ' ', [rfIgnoreCase, rfReplaceAll]);
                   FListMethods.add(temp);
                 end;
               end;
             end;
           end;
           if ListBox1.Items.Count > 0 then ListBox1.ItemIndex:= 0;
         end
         else
         begin
           p:= LastDelimiter('.',MethodSignatureList.Strings[1]);
           temp:= Copy(MethodSignatureList.Strings[1], p+1, Length(MethodSignatureList.Strings[1]) - (p+2) );
           ShowMessage('Sorry... "'+temp+'" is an interface, not a class ...');
           Self.ModalResult:= mrCancel;
           Self.Close;
         end;
       end
       else
       begin
         p:= LastDelimiter('.',MethodSignatureList.Strings[1]);
         temp:= Copy(MethodSignatureList.Strings[1], p+1, Length(MethodSignatureList.Strings[1]) - (p+2) );
         ShowMessage('Sorry... "'+temp+'" is not a public class ...');
         Self.ModalResult:= mrCancel;
         Self.Close;
       end;
   end;

end;

procedure TFormImportJAR.FormCreate(Sender: TObject);
begin
  MethodSignatureList:= TStringList.Create;
  FListMethods:= TStringList.Create;
end;

procedure TFormImportJAR.FormDestroy(Sender: TObject);
begin
  MethodSignatureList.Free;
  FListMethods.free;
end;

procedure TFormImportJAR.ListBox1Click(Sender: TObject);
begin
  //
end;

procedure TFormImportJAR.RadioGroupFromClick(Sender: TObject);
begin
 if RadioGroupFrom.ItemIndex = 1 then
    RadioGroupDesign.ItemIndex:= 1;
end;

procedure TFormImportJAR.SpeedButtonShowMethodsClick(Sender: TObject);
begin
  if  TaskMode = 1 then
  begin
    ShowMessage(FListMethods.Text);
  end;
end;

end.
