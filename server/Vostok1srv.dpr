program Vostok1srv;

uses
  Forms,
  srv_face in 'srv_face.pas' {frm_serv_face},
  Vostok1srv_TLB in 'Vostok1srv_TLB.pas',
  srv_Dmod in 'srv_Dmod.pas' {vostok1: TDataModule} {vostok1: CoClass};

{$R *.TLB}

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_serv_face, frm_serv_face);
  Application.Run;
end.
