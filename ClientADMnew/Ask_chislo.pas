unit Ask_chislo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXCtrls, StdCtrls, RXSpin, Buttons;

type
  Tfr_get_chislo = class(TForm)
    bt_ok: TBitBtn;
    bt_quit: TBitBtn;
    ed_chislo: TRxSpinEdit;
    lb_coment: TRxLabel;
    procedure bt_okClick(Sender: TObject);
    procedure bt_quitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


function Ask_integer(zg,koment:string;mx,mn,df : integer):integer;

var
  fr_get_chislo: Tfr_get_chislo;
  Res : integer;

implementation

{$R *.DFM}

function Ask_integer(zg,koment:string;mx,mn,df : integer):integer;
Begin
  res:=-1;
  try
    try
      fr_get_chislo:=Tfr_get_chislo.Create(Application);
      fr_get_chislo.ed_chislo.MaxValue:=mx;
      fr_get_chislo.ed_chislo.MinValue:=mn;
      fr_get_chislo.ed_chislo.Value:=df;
      fr_get_chislo.Caption:=zg;
      fr_get_chislo.lb_coment.Caption:=koment;
      fr_get_chislo.ShowModal;
    finally
      Result:=res;
      fr_get_chislo.free;
    end;
  except
  end;
end;



procedure Tfr_get_chislo.bt_okClick(Sender: TObject);
begin
  Res:=Trunc(ed_chislo.Value);
  fr_get_chislo.Close;
end;

procedure Tfr_get_chislo.bt_quitClick(Sender: TObject);
begin
  fr_get_chislo.Close;
end;

end.
