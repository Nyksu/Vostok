unit prn_nal_schet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, QuickRpt, ExtCtrls;

type
  Tfr_prn_nal_schet = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRMemo1: TQRMemo;
    QRShape1: TQRShape;
    QRLabel1: TQRLabel;
    lb_nom_sch: TQRLabel;
    QRShape2: TQRShape;
    lb_pole1: TQRMemo;
    lb_pole2: TQRMemo;
    lb_pole3: TQRMemo;
    QRLabel2: TQRLabel;
    lb_sum_prop: TQRMemo;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    lb_seria: TQRLabel;
    QRLabel5: TQRLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Prn_schet_nal(in_param:variant);

var
  fr_prn_nal_schet: Tfr_prn_nal_schet;
  p1_lst,p2_lst,p3_lst,sum_lst : TStringList;
  sum_str,nom_str,ser_str : string;
  summa : real;

implementation

{$R *.DFM}

uses formula;

Procedure Prn_schet_nal(in_param:variant);
Begin
  p1_lst:=TStringList.Create;
  p2_lst:=TStringList.Create;
  p3_lst:=TStringList.Create;
  sum_lst:=TStringList.Create;
  nom_str:=in_param[0];
  summa:=in_param[1];
  p1_lst.Text:=in_param[2];
  p2_lst.Text:=in_param[3];
  p3_lst.Text:=in_param[4];
  ser_str:=in_param[5];
  Screen.Cursor:=crHourGlass;
  try
    try
      fr_prn_nal_schet:=Tfr_prn_nal_schet.Create(Application);
      Screen.Cursor:=crDefault;
      //fr_prn_nal_schet.QuickRep1.Preview;
      fr_prn_nal_schet.QuickRep1.Print;
    finally
      fr_prn_nal_schet.Free;
      p1_lst.Free;
      p2_lst.Free;
      p3_lst.Free;
      sum_lst.Free;
      Screen.Cursor:=crDefault;
    end;
  except
  end;
end;

procedure Tfr_prn_nal_schet.FormCreate(Sender: TObject);
var
  str_sum : string;
begin
  lb_nom_sch.Caption:=nom_str;
  lb_seria.Caption:=ser_str;
  While Length(lb_nom_sch.Caption)<8 Do
            lb_nom_sch.Caption:='0'+lb_nom_sch.Caption;
  str_sum:=IntToStr(Trunc(summa))+','+IntToStr(Round((summa-Trunc(summa))*100));
  sum_str:=SumToStr(str_sum,true);
  sum_lst.Add(sum_str);
  lb_sum_prop.Lines.Text:=sum_lst.Text;
  lb_pole1.Lines.Text:=p1_lst.Text;
  lb_pole2.Lines.Text:=p2_lst.Text;
  lb_pole3.Lines.Text:=p3_lst.Text;
end;

end.
