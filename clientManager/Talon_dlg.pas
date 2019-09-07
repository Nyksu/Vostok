unit Talon_dlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin, prn_talons;

type
  Tfr_prn_tal_dlg = class(TForm)
    ed_kvo_tal: TSpinEdit;
    Label1: TLabel;
    bt_prn: TBitBtn;
    bt_exit: TBitBtn;
    procedure bt_prnClick(Sender: TObject);
    procedure bt_exitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure PrnTal;

var
  fr_prn_tal_dlg: Tfr_prn_tal_dlg;

implementation

{$R *.DFM}

Procedure PrnTal;
Begin
   try
      try
        fr_prn_tal_dlg:=Tfr_prn_tal_dlg.Create(Application);
        fr_prn_tal_dlg.ShowModal;
      finally
        fr_prn_tal_dlg.Free;
      end;
   except
   end;
end;

procedure Tfr_prn_tal_dlg.bt_prnClick(Sender: TObject);
begin
  If ed_kvo_tal.Value>0 Then Begin
     ShowMessage('¬ставте бумагу в принтер дл€ печати '+IntToStr(ed_kvo_tal.Value)+' талонов');
     Print_talons(ed_kvo_tal.Value,'0','AS');
  end;
end;

procedure Tfr_prn_tal_dlg.bt_exitClick(Sender: TObject);
begin
  fr_prn_tal_dlg.Close;
end;

end.
