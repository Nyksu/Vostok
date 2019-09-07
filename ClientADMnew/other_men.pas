unit other_men;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, Buttons, RXSpin;

type
  Tfr_add_dr_gost = class(TForm)
    Panel1: TPanel;
    Label4: TLabel;
    ed_fam: TEdit;
    Label5: TLabel;
    ed_io: TEdit;
    Label6: TLabel;
    ed_adress: TEdit;
    Label7: TLabel;
    ch_man: TRadioButton;
    ch_woman: TRadioButton;
    bt_reg: TBitBtn;
    BitBtn1: TBitBtn;
    ed_dr: TRxSpinEdit;
    procedure bt_regClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function Add_other_men(var fm, io, adr, yar, pol : string):boolean;


var
  fr_add_dr_gost: Tfr_add_dr_gost;
  res : boolean;
  fam, i_o, adrs, yare, pl : string;

implementation

{$R *.DFM}


Function Add_other_men(var fm, io, adr, yar, pol : string):boolean;
Begin
  res:=false;
  fam:='';
  i_o:='';
  adrs:='';
  yare:='';
  pl:='';
  try
    try
      fr_add_dr_gost:=Tfr_add_dr_gost.Create(Application);
      fr_add_dr_gost.ShowModal;
    finally
      fm:=fam;
      io:=i_o;
      adr:=adrs;
      yar:=yare;
      pol:=pl;
      Result:=res;
      fr_add_dr_gost.Free;
    end;
  except
  end;
end;

procedure Tfr_add_dr_gost.bt_regClick(Sender: TObject);
begin
  If ed_fam.Text='' Then Begin
     ShowMessage('Введите фамилию !!');
     ed_fam.SetFocus;
     Exit;
  end;
  If ed_io.Text='' Then Begin
     ShowMessage('Введите имя и отчество !!');
     ed_io.SetFocus;
     Exit;
  end;
  If ed_adress.Text='' Then Begin
     ShowMessage('Введите адрес !!');
     ed_adress.SetFocus;
     Exit;
  end;
  If Pos(' ',ed_io.Text)=0 Then Begin
     MessageDlg('Некорректное отчество!', mtWarning, [mbOk], 0);
     ed_io.SetFocus;
     Exit;
  end;
  fam:=ed_fam.Text;
  i_o:=ed_io.Text;
  adrs:=ed_adress.Text;
  yare:=IntToStr(Trunc(ed_dr.Value));
  If ch_man.Checked Then pl:='М';
  If ch_woman.Checked Then pl:='Ж';
  res:=true;
  fr_add_dr_gost.Close;
end;

procedure Tfr_add_dr_gost.BitBtn1Click(Sender: TObject);
begin
   fr_add_dr_gost.Close;
end;

end.
