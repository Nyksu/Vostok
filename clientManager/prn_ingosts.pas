unit prn_ingosts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, QuickRpt, Qrctrls, ExtCtrls, DBClient;

type
  Tfr_ingost_prn = class(TForm)
    QuickRep1: TQuickRep;
    DetailBand1: TQRBand;
    PageFooterBand1: TQRBand;
    QRSysData2: TQRSysData;
    TitleBand1: TQRBand;
    QRSysData1: TQRSysData;
    ColumnHeaderBand1: TQRBand;
    QRSubDetail1: TQRSubDetail;
    ds_report: TDataSource;
    lb_period: TQRLabel;
    cds_report: TClientDataSet;
    cds_rep_noms: TClientDataSet;
    QRSysData3: TQRSysData;
    QRExpr1: TQRExpr;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRShape1: TQRShape;
    QRLabel1: TQRLabel;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRLabel2: TQRLabel;
    QRDBText7: TQRDBText;
    QRLabel3: TQRLabel;
    QRDBText8: TQRDBText;
    QRLabel4: TQRLabel;
    QRDBText9: TQRDBText;
    QRLabel5: TQRLabel;
    QRDBText10: TQRDBText;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRDBText11: TQRDBText;
    QRLabel8: TQRLabel;
    QRDBText12: TQRDBText;
    QRLabel9: TQRLabel;
    QRDBText13: TQRDBText;
    QRLabel13: TQRLabel;
    QRDBText14: TQRDBText;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    QRLabel17: TQRLabel;
    QRDBText15: TQRDBText;
    QRLabel18: TQRLabel;
    QRDBText16: TQRDBText;
    procedure FormCreate(Sender: TObject);
    procedure ds_reportDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure Ingosts_prn(d_in, d_out : TDate);

var
  fr_ingost_prn: Tfr_ingost_prn;
  dt_po,dt_s : String;

implementation

Uses DM;

{$R *.DFM}

procedure Ingosts_prn(d_in, d_out : TDate);
Begin
  dt_po:=DateToStr(d_out);
  dt_s:=DateToStr(d_in);
  try
    try
      fr_ingost_prn:=Tfr_ingost_prn.Create(Application);
      //fr_ingost_prn.QuickRep1.Preview;
      fr_ingost_prn.QuickRep1.Print;
    finally
      fr_ingost_prn.Free;
    end;
  except
  end;
end;

procedure Tfr_ingost_prn.FormCreate(Sender: TObject);
var
 parametry : variant;
 resSQL : integer;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=244;
  parametry[1]:=DataModuls.kod_adm;
  parametry[2]:=2;
  parametry[3]:=VarArrayOf([dt_po,dt_s]);
  parametry[4]:=VarArrayOf(['dat_po','dat_s']);
  parametry[5]:=1;
  resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
  cds_report.Active:=true;
  lb_period.Caption:=lb_period.Caption+' c '+dt_s+' по '+dt_po;
  cds_report.Active:=true;
   parametry[0]:=245;{История проживания гостя}
   parametry[1]:=DataModuls.kod_adm;
   parametry[2]:=1;
   parametry[3]:=VarArrayOf([IntToStr(cds_report.FieldByName('kod_gost').AsInteger)]);
   parametry[4]:=VarArrayOf(['gost']);
   parametry[5]:=2;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL <>0 Then Begin
      MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
      Exit;
   end;
   cds_rep_noms.Active:=true;
end;

procedure Tfr_ingost_prn.ds_reportDataChange(Sender: TObject;
  Field: TField);
var
 resSQL : integer;
 parametry : Variant;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  cds_rep_noms.Active:=false;
  parametry[0]:=245;{История проживания гостя}
   parametry[1]:=DataModuls.kod_adm;
   parametry[2]:=1;
   parametry[3]:=VarArrayOf([IntToStr(cds_report.FieldByName('kod_gost').AsInteger)]);
   parametry[4]:=VarArrayOf(['gost']);
   parametry[5]:=2;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL <>0 Then Begin
      MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
      Exit;
   end;
   cds_rep_noms.Active:=true;
end;

end.
