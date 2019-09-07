unit prn_gost_lst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Qrctrls, QuickRpt, ExtCtrls, DBClient, DM;

type
  Tfr_prn_gost_lst = class(TForm)
    QuickRep1: TQuickRep;
    DetailBand1: TQRBand;
    PageFooterBand1: TQRBand;
    QRSysData2: TQRSysData;
    TitleBand1: TQRBand;
    QRSysData1: TQRSysData;
    ColumnHeaderBand1: TQRBand;
    QRLabel1: TQRLabel;
    cds_report: TClientDataSet;
    lb_period: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRSysData3: TQRSysData;
    QRExpr1: TQRExpr;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


Procedure Start_prn_gost_lst(d_in, d_out : TDate);

var
  fr_prn_gost_lst: Tfr_prn_gost_lst;
  dt_po,dt_s : String;

implementation

{$R *.DFM}

Procedure Start_prn_gost_lst(d_in, d_out : TDate);
Begin
  dt_po:=DateToStr(d_out);
  dt_s:=DateToStr(d_in);
  try
    try
      fr_prn_gost_lst:=Tfr_prn_gost_lst.Create(Application);
      //fr_prn_gost_lst.QuickRep1.Preview;
      fr_prn_gost_lst.QuickRep1.Print;
    finally
      fr_prn_gost_lst.Free;
    end;
  except
  end;
end;

procedure Tfr_prn_gost_lst.FormCreate(Sender: TObject);
var
 parametry : variant;
 resSQL : integer;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=232;
  parametry[1]:=DataModuls.kod_adm;
  parametry[2]:=2;
  parametry[3]:=VarArrayOf([dt_po,dt_s]);
  parametry[4]:=VarArrayOf(['dat_po','dat_s']);
  parametry[5]:=1;
  resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
  cds_report.Active:=true;
  lb_period.Caption:=lb_period.Caption+' c '+dt_s+' по '+dt_po;
end;

end.
