unit print_bn_calc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, QuickRpt, Qrctrls, ExtCtrls, DBClient;

type
  Tfr_prn_calc_bn = class(TForm)
    QuickRep1: TQuickRep;
    DetailBand1: TQRBand;
    PageFooterBand1: TQRBand;
    QRSysData2: TQRSysData;
    TitleBand1: TQRBand;
    QRSysData1: TQRSysData;
    ColumnHeaderBand1: TQRBand;
    QRSubDetail1: TQRSubDetail;
    ds_report: TDataSource;
    QRShape1: TQRShape;
    QRLabel1: TQRLabel;
    cds_report: TClientDataSet;
    cds_detail: TClientDataSet;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRSysData3: TQRSysData;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRMemo1: TQRMemo;
    QRSysData4: TQRSysData;
    QRLabel13: TQRLabel;
    QRDBText13: TQRDBText;
    QRLabel14: TQRLabel;
    QRDBText14: TQRDBText;
    QRBand1: TQRBand;
    QRShape2: TQRShape;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    QRExpr1: TQRExpr;
    QRLabel17: TQRLabel;
    QRExpr2: TQRExpr;
    QRLabel18: TQRLabel;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRShape6: TQRShape;
    QRShape7: TQRShape;
    QRLabel19: TQRLabel;
    QRDBText15: TQRDBText;
    procedure FormCreate(Sender: TObject);
    procedure ds_reportDataChange(Sender: TObject; Field: TField);
    procedure QuickRep1AfterPrint(Sender: TObject);
    procedure QRExpr1Print(sender: TObject; var Value: String);
    procedure QRExpr2Print(sender: TObject; var Value: String);
  private
    procedure Calc_fields;
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Prn_calc_bn(k_b : integer);

var
  fr_prn_calc_bn: Tfr_prn_calc_bn;
  kd_bron : integer;
  br, lv : real;

implementation

Uses MainADM;

{$R *.DFM}

Procedure Prn_calc_bn(k_b : integer);
Begin
  kd_bron:=k_b;
  try
    try
      fr_prn_calc_bn:=Tfr_prn_calc_bn.Create(Application);
      //fr_prn_calc_bn.QuickRep1.Preview;
      fr_prn_calc_bn.QuickRep1.Print;
    finally
      fr_prn_calc_bn.Free;
    end;
  except
  end;
end;

procedure Tfr_prn_calc_bn.Calc_fields;
var
 last_dat : TDate;
 lgota, prc_lgot : real;
 //sm_bron : real;
Begin
   If not cds_report.active Then Exit;
   If not cds_detail.Active Then Exit;
   prc_lgot:=cds_report.FieldByName('procent').AsFloat;
   cds_detail.First;
   last_dat:=cds_detail.FieldByName('date_in').AsDateTime-1;
   While not cds_detail.EOF Do Begin
      If prc_lgot>0 Then Begin
         lgota:=Round(cds_detail.FieldByName('tarif').AsFloat*prc_lgot)/100;
         cds_detail.Edit;
         cds_detail.FieldByName('tarif').AsFloat:=cds_detail.FieldByName('tarif').AsFloat-lgota;
         cds_detail.Post;
      end;
      If last_dat=cds_detail.FieldByName('date_in').AsDateTime Then Begin
         cds_detail.Edit;
         cds_detail.FieldByName('sutok').AsFloat:=cds_detail.FieldByName('sutok').AsFloat-0.5;
         cds_detail.Post;
         cds_detail.Prior;
         cds_detail.Edit;
         cds_detail.FieldByName('sutok').AsFloat:=cds_detail.FieldByName('sutok').AsFloat-0.5;
         cds_detail.FieldByName('fool_sum').AsFloat:=cds_detail.FieldByName('tarif').AsFloat
             *cds_detail.FieldByName('sutok').AsFloat
             *cds_detail.FieldByName('mests').AsInteger;
         cds_detail.Post;
         cds_detail.Next;
      end;
      cds_detail.Edit;
      If cds_detail.FieldByName('sutok').AsFloat=0 Then cds_detail.FieldByName('sutok').AsFloat:=1;
      cds_detail.FieldByName('fool_sum').AsFloat:=cds_detail.FieldByName('tarif').AsFloat
             *cds_detail.FieldByName('sutok').AsFloat
             *cds_detail.FieldByName('mests').AsInteger;
      cds_detail.Post;
      last_dat:=cds_detail.FieldByName('date_out').AsDateTime;
      cds_detail.Next;
   end;
   If cds_detail.FieldByName('time_out').AsString>='18:00:00' Then Begin
      cds_detail.Edit;
      cds_detail.FieldByName('sutok').AsFloat:=cds_detail.FieldByName('sutok').AsFloat+0.5;
      cds_detail.FieldByName('fool_sum').AsFloat:=cds_detail.FieldByName('tarif').AsFloat
             *cds_detail.FieldByName('sutok').AsFloat
             *cds_detail.FieldByName('mests').AsInteger;
      cds_detail.Post;
   end;
   cds_detail.First;
end;

procedure Tfr_prn_calc_bn.FormCreate(Sender: TObject);
var
 resSQL : integer;
 parametry : Variant;
begin
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=228;{Гости по брони}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=2;
   parametry[3]:=VarArrayOf([IntToStr(kd_bron),IntToStr(kd_bron)]);
   parametry[4]:=VarArrayOf(['bron','bron']);
   parametry[5]:=1;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL <>0 Then Begin
      MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
      Exit;
   end;
   cds_report.Active:=true;
   parametry[0]:=236;{Платежи гостя по б/н}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=1;
   parametry[3]:=VarArrayOf([IntToStr(cds_report.FieldByName('kod_gost').AsInteger)]);
   parametry[4]:=VarArrayOf(['gost']);
   parametry[5]:=2;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL <>0 Then Begin
      MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
      Exit;
   end;
   cds_detail.Active:=true;
   Calc_fields;
end;

procedure Tfr_prn_calc_bn.ds_reportDataChange(Sender: TObject;
  Field: TField);
var
 resSQL : integer;
 parametry : Variant;
begin
   cds_detail.Active:=false;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=236;{Платежи гостя по б/н}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=1;
   parametry[3]:=VarArrayOf([IntToStr(cds_report.FieldByName('kod_gost').AsInteger)]);
   parametry[4]:=VarArrayOf(['gost']);
   parametry[5]:=2;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL <>0 Then Begin
      MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
      Exit;
   end;
   cds_detail.Active:=true;
   Calc_fields;
end;

procedure Tfr_prn_calc_bn.QuickRep1AfterPrint(Sender: TObject);
var
 resSQL : integer;
 parametry : Variant;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=239;{Суммы по б/н}
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=3;
  parametry[3]:=VarArrayOf([IntToStr(kd_bron),FloatToStr(br),FloatToStr(lv)]);
  parametry[4]:=VarArrayOf(['bron','s_bron','s_live']);
  parametry[5]:=0;
  fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
      fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
      Exit;
  end;
  fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
end;

procedure Tfr_prn_calc_bn.QRExpr1Print(sender: TObject; var Value: String);
var
 dd : Variant;
begin
  dd:=QRExpr1.Value.dblResult;
  br:=dd;
end;

procedure Tfr_prn_calc_bn.QRExpr2Print(sender: TObject; var Value: String);
var
 dd : Variant;
begin
  dd:=QRExpr2.Value.dblResult;
  lv:=dd;
end;

end.
