unit List_gost;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, prn_gost_lst, prn_ingosts,
  prn_sng_gosts{, Unxcrypt};

type
  Tfr_gost_period = class(TForm)
    Panel1: TPanel;
    ed_dt_in: TDateTimePicker;
    ed_dt_out: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    bt_print: TBitBtn;
    bt_exit: TBitBtn;
    rg_tip_gost: TRadioGroup;
    ed_reset: TEdit;
    procedure bt_exitClick(Sender: TObject);
    procedure bt_printClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1DblClick(Sender: TObject);
    procedure ed_resetKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Start_gost_lst;

var
  fr_gost_period: Tfr_gost_period;
  {pp : string;}

implementation

{$R *.DFM}


Procedure Start_gost_lst;
Begin
  try
    try
      fr_gost_period:=Tfr_gost_period.Create(Application);
      {pp:='RWPPsxJ73..';}
      fr_gost_period.ShowModal;
    finally
      fr_gost_period.Free;
    end;
  except
  end;
end;

procedure Tfr_gost_period.bt_exitClick(Sender: TObject);
begin
  fr_gost_period.Close;
end;

procedure Tfr_gost_period.bt_printClick(Sender: TObject);
begin
   Case rg_tip_gost.ItemIndex of
     0 : Start_prn_gost_lst(ed_dt_in.Date, ed_dt_out.Date);
     1 : Snggosts_prn(ed_dt_in.Date, ed_dt_out.Date);
     2 : Ingosts_prn(ed_dt_in.Date, ed_dt_out.Date);
   end;
end;

procedure Tfr_gost_period.FormCreate(Sender: TObject);
begin
  ed_dt_out.Date:=date;
  ed_dt_in.Date:=date-30;
end;

procedure Tfr_gost_period.Label1DblClick(Sender: TObject);
begin
  {If bt_print.Enabled Then bt_print.Enabled:=false
  Else Begin
    ed_reset.Visible:=true;
    ed_reset.SetFocus;
  end;}
end;

procedure Tfr_gost_period.ed_resetKeyPress(Sender: TObject; var Key: Char);
begin
  {If Key=#13 Then Begin
     If CreateInterbasePassword(ed_reset.text)=pp Then Begin
        bt_print.Enabled:=true;
        bt_print.SetFocus;
     end;
     ed_reset.text:='';
     ed_reset.Visible:=false;
  end;}
end;

end.
