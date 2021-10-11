program Project;

uses
  Forms,
  U_Main in 'U_Main.pas' {FMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
