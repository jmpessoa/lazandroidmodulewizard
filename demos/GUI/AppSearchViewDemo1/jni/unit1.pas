{Hint: save all files to location: C:\lamw\workspace\AppSearchViewDemo1\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, Laz_And_Controls, searchview, radiogroup;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
    jListView1: jListView;
    jRadioGroup1: jRadioGroup;
    jSearchView1: jSearchView;
    jTextView1: jTextView;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure jRadioGroup1CheckedChanged(Sender: TObject;
      checkedIndex: integer; checkedCaption: string);
    procedure jSearchView1QueryTextChange(Sender: TObject; newQuery: string);
    procedure jSearchView1QueryTextSubmit(Sender: TObject; query: string);
    procedure jSearchView1XClick(Sender: TObject);
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

procedure TAndroidModule1.jSearchView1QueryTextSubmit(Sender: TObject;
  query: string);
begin
  //ShowMessage(query);
 jListView1.SetFilterQuery(query);
end;

procedure TAndroidModule1.jSearchView1XClick(Sender: TObject);
begin
 //  ShowMessage('[x] Clicked!!');
   jListView1.ClearFilterQuery();
end;

procedure TAndroidModule1.jSearchView1QueryTextChange(Sender: TObject;
  newQuery: string);
begin
                     {
 if newQuery <> '' then
   jListView1.SetFilterQuery(newQuery);
 else
   jListView1.ClearFilterQuery();
                      }
end;

procedure TAndroidModule1.jRadioGroup1CheckedChanged(Sender: TObject;
  checkedIndex: integer; checkedCaption: string);
begin
    ShowMessage(checkedCaption + ' = ' + IntToStr(checkedIndex));
   if checkedIndex = 0 then
      jListView1.SetFilterMode(fmStartsWith)
   else
     jListView1.SetFilterMode(fmContains);
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
    jRadioGroup1.CheckedIndex:= 0;  // <<-- initialize here!!
    //jListView1.SetFilterMode(fmStartsWith);    //default
end;


end.
