unit U_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBCtrls, StdCtrls;

type
  TFMain = class(TForm)
    Vent_Table: TADOTable;
    Art_Table: TADOTable;
    DS_Article: TDataSource;
    AddBtn: TButton;
    RecordBtn: TButton;
    Grid: TStringGrid;
    procedure DBLookupCBExit(Sender: TObject);
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure GridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure RecordBtnClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure CreateDBLookupComboBox(R : Integer);
  public
    { Déclarations publiques }
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}
//fonction pour trouve une clé non-utlise pour regroupé la vente
function Findkey(Table: TADOTable): Integer;
begin
  Result := 1;
  while Table.Locate('N°',Result,[]) = True do Inc(Result)
end;
//transfère des données de la table Article vers le StringGrid
procedure TFMain.DBLookupCBExit(Sender: TObject);
begin
  With TDBLookupComboBox(Sender).ListSource.DataSet do
  begin
    Grid.Cells[0,Grid.Row] := FieldByName('N°').AsString;  
    Grid.Cells[1,Grid.Row] := FieldByName('Designation').AsString;
    Grid.Cells[2,Grid.Row] := FieldByName('Prix_Vente').AsString
  end;
  Sender.Free
end;

//initialise le stringGrid et des Tables ADO
procedure TFMain.FormCreate(Sender: TObject);
const ConnectionString: String = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source'+
                                        '=Data.mdb;Persist Security Info=False';
begin
  Art_Table.ConnectionString := ConnectionString;
  Vent_Table.ConnectionString := ConnectionString;
  With Grid do
  begin
    Cells[0,0] := 'Code Article';
    Cells[1,0] := 'Article';
    Cells[2,0] := 'Price unitaire';
    Cells[3,0] := 'Quantity';
    Cells[4,0] := 'Total'
  end
end;

//Crée DBLookupComboBox lors de la selection de cellule de l'article
procedure TFMain.GridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if ACol = 1 then CreateDBLookupComboBox(ARow);
end;
//calcule le prix total a partir des données du StringGrid
procedure TFMain.GridSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
begin
  if (ACol = 3) and (Value <> '') and (Grid.Cells[1,ARow] <> '') then
  begin
    Grid.Cells[4,Grid.Row] := FloatToStr((StrToFloat(Grid.Cells[2,Grid.Row]) *
                                 StrToInt(Grid.Cells[3,Grid.Row])));
    if (Grid.RowCount - 1 = ARow) then Grid.RowCount := Grid.RowCount + 1
  end;
end;

procedure TFMain.RecordBtnClick(Sender: TObject);
var i, j: integer;
    Date: TDateTime;
begin
  Date := Now;
  RecordBtn.Enabled := False;
  Vent_Table.Open;
  J := Findkey(Vent_Table);  
  // parcourir le StringGird pour enregistrer les données de la vente 
  With Grid do
  for i := 1 to RowCount do
  if (Cells[1,i] <> '') and (Cells[3,i] <> '') then
  With Vent_Table do
  begin
    Insert;
    FieldByName('Date_Vente').AsDateTime := Date;
    FieldByName('Id_Art').Value := Cells[0,i];
    FieldByName('N°').AsInteger := j;
    Post;
  end;
  Art_Table.Close;
  Vent_Table.Close;
  // Nettoyage du StringGrid
  Grid.RowCount := 2;
  for I := 0 to 5 do
  Grid.Cells[I,1] := '';

  AddBtn.Enabled := Enabled;
end;

procedure TFMain.AddBtnClick(Sender: TObject);
begin
  Art_Table.Open;
  Grid.Enabled := True;
  AddBtn.Enabled := False;
end;

// procedure de la création de TDBLookupComboBox
// toute en l'intégrant dans le StringGrid
procedure TFMain.CreateDBLookupComboBox(R: Integer);
var Com: TDBLookupComboBox;
begin
  Com := TDBLookupComboBox.Create(Self);
  With Com do
  begin
    Parent := Grid;
    Top := 22 * R;
    Left := Grid.ColWidths[0]+ 2;
    Width := Grid.ColWidths[1];
    ListSource := Ds_Article;
    KeyField := 'N°';
    ListField := 'Designation';
    OnExit := DBLookupCBExit;
  end
end;

end.
