program Disp;

uses
  Forms,
  uDisp in 'uDisp.pas' {_ALACN_Disp};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Displacement';
  Application.CreateForm(T_ALACN_Disp, _ALACN_Disp);
  Application.Run;
end.
