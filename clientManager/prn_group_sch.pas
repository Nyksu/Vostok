unit prn_group_sch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, QuickRpt, ExtCtrls, Db, DBClient;

type
  Tfr_prn_grup_sch = class(TForm)
    qr_group: TQuickRep;
    TitleBand1: TQRBand;
    QRSysData1: TQRSysData;
    QRLabel11: TQRLabel;
    QRMemo1: TQRMemo;
    QRShape7: TQRShape;
    QRLabel1: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRLabel2: TQRLabel;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRBand1: TQRBand;
    QRBand2: TQRBand;
    QRBand3: TQRBand;
    QRBand4: TQRBand;
    QRSysData2: TQRSysData;
    QRSysData3: TQRSysData;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRDBText6: TQRDBText;
    QRShape1: TQRShape;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRShape2: TQRShape;
    QRLabel15: TQRLabel;
    QRShape6: TQRShape;
    QRLabel12: TQRLabel;
    lb_summa: TQRLabel;
    QRLabel13: TQRLabel;
    lb_sum_str: TQRMemo;
    QRLabel17: TQRLabel;
    QRLabel16: TQRLabel;
    QRLabel18: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel19: TQRLabel;
    lb_sum_liv: TQRLabel;
    lb_sum_lgot: TQRLabel;
    lb_sum_prost: TQRLabel;
    lb_sum_bron: TQRLabel;
    lb_sum_uder: TQRLabel;
    cds_grup: TClientDataSet;
    QRLabel20: TQRLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


Procedure PrintGroup(id : integer);

var
  fr_prn_grup_sch: Tfr_prn_grup_sch;
  id_s : integer;

implementation

Uses DM, formula;

{$R *.DFM}

Procedure PrintGroup(id : integer);
Begin
  id_s:=id;
  try
    try
      fr_prn_grup_sch:=Tfr_prn_grup_sch.Create(Application);
      //fr_prn_grup_sch.qr_group.Print;
      fr_prn_grup_sch.qr_group.Preview;
    finally
      fr_prn_grup_sch.free;
    end;
  except
  end;
end;

procedure Tfr_prn_grup_sch.FormCreate(Sender: TObject);
var
  parametry, param, re : variant;
  resSQL,ii,rub,kop : integer;
  sm : array[1..6] of real;
  kps,sum_str : string;
begin
   Screen.Cursor:=crHourGlass;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=253;
   parametry[1]:=DataModuls.kod_adm;
   parametry[2]:=1;
   parametry[3]:=VarArrayOf([IntToStr(id_s)]);
   parametry[4]:=VarArrayOf(['id']);
   parametry[5]:=1;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Exit;
   cds_grup.Open;
   param:=VarArrayCreate([0, 2], varVariant);
   param[0]:=2;
   param[2]:=VarArrayOf(['id','tip']);{имена параметров sql}
   For ii:=1 to 5 Do Begin
       param[1]:=VarArrayOf([IntToStr(id_s),ii]);{параметры sql}
       re:=DataModuls.GetTehParam(254,param);
       If not VarIsNull(re[1]) Then sm[ii]:=re[1] Else sm[ii]:=0;
   end;
   sm[6]:=sm[1]-sm[2]+sm[3]+sm[4]+sm[5];
   rub:=Trunc(sm[6]);
   kop:=Round((sm[6]-rub)*100);
   lb_sum_liv.Caption:=FloatToStr(sm[1]);
   lb_sum_lgot.Caption:=FloatToStr(sm[2]);
   lb_sum_prost.Caption:=FloatToStr(sm[3]);
   lb_sum_bron.Caption:=FloatToStr(sm[4]);
   lb_sum_uder.Caption:=FloatToStr(sm[5]);
   kps:=IntToStr(kop);
   If length(kps)<2 Then kps:='0'+kps;
   lb_summa.Caption:=IntToStr(rub)+' руб. '+kps+' коп.';
   sum_str:=SumToStr(IntToStr(rub)+','+kps,true);
   lb_sum_str.Lines.Text:=sum_str;
   Screen.Cursor:=crDefault;
end;

end.
