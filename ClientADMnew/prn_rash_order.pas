unit prn_rash_order;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, QuickRpt, ExtCtrls;

type
  Tfr_rashod_order = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRMemo1: TQRMemo;
    QRLabel1: TQRLabel;
    lb_nom_sch: TQRLabel;
    QRLabel2: TQRLabel;
    lb_sum_prop: TQRMemo;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    lb_seria: TQRLabel;
    QRSysData1: TQRSysData;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    lb_summa: TQRLabel;
    QRLabel8: TQRLabel;
    lb_osnovanie: TQRMemo;
    QRLabel9: TQRLabel;
    lb_FIO: TQRLabel;
    QRLabel10: TQRLabel;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    lb_nomer: TQRLabel;
    QRLabel14: TQRLabel;
    lb_sut: TQRLabel;
    QRLabel15: TQRLabel;
    QRMemo2: TQRMemo;
    QRShape1: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRLabel16: TQRLabel;
    QRLabel17: TQRLabel;
    QRShape6: TQRShape;
    QRShape7: TQRShape;
    QRLabel18: TQRLabel;
    QRShape8: TQRShape;
    QRLabel19: TQRLabel;
    QRLabel20: TQRLabel;
    QRLabel21: TQRLabel;
    QRShape9: TQRShape;
    QRShape10: TQRShape;
    QRShape11: TQRShape;
    QRLabel11: TQRLabel;
    QRLabel22: TQRLabel;
    QRShape12: TQRShape;
    QRShape13: TQRShape;
    QRShape14: TQRShape;
    QRShape15: TQRShape;
    QRShape16: TQRShape;
    QRShape17: TQRShape;
    QRShape18: TQRShape;
    QRShape19: TQRShape;
    QRLabel23: TQRLabel;
    QRLabel24: TQRLabel;
    QRLabel25: TQRLabel;
    QRLabel26: TQRLabel;
    QRLabel27: TQRLabel;
    QRLabel28: TQRLabel;
    QRMemo3: TQRMemo;
    QRLabel29: TQRLabel;
    QRLabel30: TQRLabel;
    QRLabel31: TQRLabel;
    QRShape20: TQRShape;
    QRLabel32: TQRLabel;
    QRShape21: TQRShape;
    QRLabel33: TQRLabel;
    QRShape22: TQRShape;
    QRLabel7: TQRLabel;
    QRShape23: TQRShape;
    QRShape24: TQRShape;
    QRLabel34: TQRLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Prn_order(in_param : variant);

var
  fr_rashod_order: Tfr_rashod_order;
  prm : variant;

implementation

{$R *.DFM}

uses formula;

Procedure Prn_order(in_param : variant);
Begin
  prm:=in_param;
  try
    try
      fr_rashod_order:=Tfr_rashod_order.Create(Application);
      //fr_rashod_order.QuickRep1.Preview;
      fr_rashod_order.QuickRep1.Print;
    finally
      fr_rashod_order.Free;
    end;
  except
  end;
end;

procedure Tfr_rashod_order.FormCreate(Sender: TObject);
var
  kop,rub : Integer;
  s_kop,s_sum : string;
begin
   kop:=Round((prm[2]-Int(prm[2]))*100);
   s_kop:=IntToStr(kop);
   rub:=Trunc(prm[2]);
   While Length(s_kop)<2 Do s_kop:='0'+s_kop;
   s_sum:=IntToStr(rub)+','+s_kop;
   lb_summa.Caption:=IntToStr(rub)+' руб. '+s_kop+' коп.';
   lb_sum_prop.Lines.text:=SumToStr(s_sum,true);
   lb_nom_sch.Caption:=IntToStr(prm[0]);
   lb_seria.Caption:=prm[1];
   lb_FIO.Caption:=prm[3];
   lb_nomer.Caption:=prm[4];
   lb_sut.Caption:=prm[5];
end;

end.
