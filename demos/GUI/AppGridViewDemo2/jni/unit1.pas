{Hint: save all files to location: C:\Documents\lazarus\Essais\AppGridViewDemo2\jni }
unit unit1;

{$mode delphi}

interface

uses
  Classes, SysUtils, AndroidWidget, gridview, Laz_And_Controls;

type
  TCell = record
    Item, ImgIdentifier: string;
  end;
  TCells = array of TCell;

  { TAndroidModule1 }
  TAndroidModule1 = class(jForm)
    BtnAddRow: jButton;
    BtnDelRow: jButton;
    BtnReset: jButton;
    EditCol: jEditText;
    EditValue: jEditText;
    EditRow: jEditText;
    BtnIncVal: jButton;
    BtnAddCol: jButton;
    BtnDelCol: jButton;
    jGridView1: jGridView;
    PanelActionButtons: jPanel;
    LabelCol: jTextView;
    LabelValue: jTextView;
    LabelRow: jTextView;
    PanelBottom: jPanel;
    PanelEdits: jPanel;
    PanelInfo: jTextView;
    PanelTop: jPanel;
    procedure AndroidModule1JNIPrompt(Sender: TObject);
    procedure BtnAddColClick(Sender: TObject);
    procedure BtnAddRowClick(Sender: TObject);
    procedure BtnIncValClick(Sender: TObject);
    procedure BtnDelColClick(Sender: TObject);
    procedure BtnDelRowClick(Sender: TObject);
    procedure BtnResetClick(Sender: TObject);
    procedure EditColChange(Sender: TObject; txt: string; count: integer);
    procedure EditRowChange(Sender: TObject; txt: string; count: integer);
    procedure jGridView1ClickItem(Sender: TObject; ItemIndex: integer;
      itemCaption: string);
  private
    procedure DisplayCellCoords;
    procedure DisplayEdits(Col, Row: integer);
    procedure ShowInfo;
    procedure ShowItem(const Col, Row: integer; const Item: string);
    procedure UpdateButtons;
    procedure UpdateEdits;
    {private declarations}
  public
    {public declarations}
  end;

var
  AndroidModule1: TAndroidModule1;

implementation

{$R *.lfm}

{ TAndroidModule1 }
procedure TAndroidModule1.ShowItem(const Col, Row: integer; const Item: string);

begin
  EditCol.Text := IntToStr(Col);
  EditRow.Text := IntToStr(Row);
end;

procedure TAndroidModule1.UpdateButtons ;

var
  Row, Col : integer;

begin
  if trystrtoint(EditRow.Text,Row) and (Row >= 0) then
    begin
    BtnAddRow.Text := 'Add 1 row after '+Inttostr(Row);
    BtnDelRow.Text := 'Del row '+Inttostr(Row);
    BtnDelRow.Enabled:= true;
    BtnDelRow.Visible := true;
    end
  else
    begin
    BtnAddRow.Text := 'Ins 1 top row';
    BtnDelRow.Text := '';
    BtnDelRow.Enabled:= false;
    BtnDelRow.Visible := false;
    end;

  if trystrtoint(EditCol.Text,Col) and (col >= 0)  then
    begin
    BtnAddCol.Text := 'Add 1 Col after '+Inttostr(Col);
    BtnDelCol.Text := 'Del Col '+Inttostr(Col);
    BtnDelCol.Enabled:= true;
    BtnDelCol.Visible:= true;
    end
  else
    begin
    BtnAddCol.Text := 'Ins 1 left col';
    BtnDelCol.Text := '';
    BtnDelCol.Enabled:= false;
    BtnDelCol.Visible:= false;
    end;
 end;

procedure TAndroidModule1.DisplayCellCoords;

var
  row, col, P: integer;
  Item : string ;

begin
  // display all
  for Col := 0 to jGridView1.ColCount - 1 do
    for Row := 0 to jGridView1.RowCount - 1 do
      begin
      Item := jGridView1.Cells[Col,Row];
      P := pos('=', Item );
      jGridView1.Cells[Col, Row] := GridView_PrintCoord(Col, Row)+'='+copy(Item,P+1, Length(Item)-P ); ;
      end;
end;

procedure TAndroidModule1.DisplayEdits ( Col, Row : integer );

begin
  try
    EditCol.OnChange := nil ;
    EditRow.OnChange:= nil;
    if (Col >=0) and (Col < jGridView1.ColCount) and (Row >=0) and (Row < jGridView1.RowCount) then
      // valid col and row
      ShowItem(Col, Row, jGridView1.Cells[Col, Row])
    else
      begin
      // invalid col or row
      EditValue.Clear ;
      if (Row >= jGridView1.RowCount) or (Row < 0) then
        EditRow.Clear
      else
        EditRow.Text := inttostr(Row);
      if (Col >= jGridView1.ColCount) or (Col < 0) then
        EditCol.Clear
      else
        EditCol.Text := IntToStr(Col);
      end ;
  finally
    EditCol.OnChange := EditColChange ;
    EditRow.OnChange:= EditRowChange;
  end;
end;

procedure TAndroidModule1.UpdateEdits ;

var
  row, col: integer;

begin
  Row := StrToIntDef(EditRow.Text,-1);
  Col := StrToIntDef(EditCol.Text,-1);
  // try to set max possible values
  if (Row >= jGridView1.RowCount) or (Row < 0) then
    Row := jGridView1.Rowcount-1;
  if (Col >= jGridView1.ColCount) or (Col < 0) then
    Col := jGridView1.ColCount-1;
  DisplayEdits( Col, Row);
end;

procedure TAndroidModule1.ShowInfo;



begin
  DisplayCellCoords;
  UpdateEdits ;
  UpdateButtons ;
end;

procedure TAndroidModule1.BtnAddRowClick(Sender: TObject);

var
  row, col: integer;

begin
  Row := StrToIntDef(EditRow.Text, -1);
  jGridView1.AddRow ( Row );

  // set value into new cells
  inc(Row);
  for Col := 0 to jGridView1.ColCount - 1 do
    jGridView1.Cells[Col, Row] := GridView_PrintCoord(Col, Row)+'='+EditValue.Text;

  ShowMessage ( 'Added '+copy(BtnAddRow.Text,4,maxint) );
  ShowInfo;
end;

procedure TAndroidModule1.BtnIncValClick(Sender: TObject);

var
  Item : string ;

begin
  Item :=  EditValue.Text;
  if (Length(Item) <> 1) or (Item[1] = 'Z') then
    EditValue.Text := 'A'
  else
    EditValue.Text := Chr( Ord(Item[1])+1 );
  UpdateButtons;
end;

procedure TAndroidModule1.BtnDelColClick(Sender: TObject);

var
  Col: integer;

begin
  Col := strtointdef(EditCol.Text, -1);
  jGridView1.DeleteCol(Col);
  ShowMessage ( 'Deleted '+copy(BtnAddCol.Text,7,maxint) );
  ShowInfo;
end;

procedure TAndroidModule1.BtnDelRowClick(Sender: TObject);

var
  Row: integer;

begin
  Row := strtointdef(EditRow.Text, -1);
  jGridView1.DeleteRow(Row);
  ShowMessage ( 'Deleted '+copy(BtnAddRow.Text,7,maxint) );
  ShowInfo;
end;

procedure TAndroidModule1.BtnResetClick(Sender: TObject);

var
  row, col: integer;

begin
// display all
for Col := 0 to jGridView1.ColCount - 1 do
  for Row := 0 to jGridView1.RowCount - 1 do
    jGridView1.Cells[Col, Row] := GridView_PrintCoord(Col, Row)+'='+GridView_PrintCoord(Col, Row);
EditCol.Clear;
EditRow.Clear;
EditValue.Clear;
UpdateButtons;
end;

procedure TAndroidModule1.EditColChange(Sender: TObject; txt: string;
  count: integer);

begin
  //ShowInfo ;
end;

procedure TAndroidModule1.EditRowChange(Sender: TObject; txt: string;
  count: integer);

begin
  //ShowInfo ;
end;

procedure TAndroidModule1.jGridView1ClickItem(Sender: TObject;
  ItemIndex: integer; itemCaption: string);

var
  col, row: integer;

begin
  jGridView1.IndexToCoord(ItemIndex, Col, Row);
  DisplayEdits ( Col, Row );
  UpdateButtons;
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);

begin
  jGridView1.Clear;
  EditValue.Clear;
  ShowInfo;
end;

procedure TAndroidModule1.BtnAddColClick(Sender: TObject);

var
  row, col: integer;

begin
  col := StrToIntDef( EditCol.Text, -1 );
  jGridView1.AddCol (Col);

  // show coordinates into new cells
  inc(Col);
  for Row := 0 to jGridView1.Rowcount - 1 do
    jGridView1.Cells[Col, Row] := GridView_PrintCoord(col, row)+'='+EditValue.Text;

  ShowMessage ( 'Added '+copy(BtnAddCol.Text,4,maxint) );
  ShowInfo;
end;

end.
