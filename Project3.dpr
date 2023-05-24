program Project3;

uses
  Vcl.Forms,
  Unit6 in '..\..\..\..\..\..\Documents\Embarcadero\Studio\Projects\Unit6.pas' {Form6},
  Unit1 in 'Unit1.pas' {DataModule1: TDataModule},
  Unit3 in 'Unit3.pas' {Form3},
  PluginBase in 'PluginBase.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TDataModule1, DataModule1);
  //  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
