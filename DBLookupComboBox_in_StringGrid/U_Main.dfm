object FMain: TFMain
  Left = 230
  Top = 132
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'DBLookupComboBox in StringGrid'
  ClientHeight = 362
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object AddBtn: TButton
    Left = 8
    Top = 328
    Width = 249
    Height = 25
    Caption = 'Add record'
    TabOrder = 0
    OnClick = AddBtnClick
  end
  object RecordBtn: TButton
    Left = 264
    Top = 328
    Width = 225
    Height = 25
    Caption = 'Clear'
    TabOrder = 1
    OnClick = RecordBtnClick
  end
  object Grid: TStringGrid
    Left = 8
    Top = 8
    Width = 481
    Height = 313
    DefaultRowHeight = 21
    Enabled = False
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
    TabOrder = 2
    OnSelectCell = GridSelectCell
    OnSetEditText = GridSetEditText
    ColWidths = (
      88
      105
      92
      96
      64)
  end
  object Vent_Table: TADOTable
    ConnectionString = 'ConnectionString;'
    TableName = 'Vente'
    Left = 48
    Top = 40
  end
  object Art_Table: TADOTable
    ConnectionString = 'ConnectionString;'
    CursorType = ctStatic
    TableName = 'Article'
    Left = 16
    Top = 40
  end
  object DS_Article: TDataSource
    DataSet = Art_Table
    Left = 16
    Top = 72
  end
end
