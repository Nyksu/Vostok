unit prn_otch_sch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBClient, Qrctrls, QuickRpt, ExtCtrls;

type
  Tfr_prm_schet_otchet = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRSysData1: TQRSysData;
    QRLabel3: TQRLabel;
    lb_fio: TQRLabel;
    QRBand2: TQRBand;
    QRBand3: TQRBand;
    QRBand4: TQRBand;
    QRSysData2: TQRSysData;
    cds_otchet: TClientDataSet;
    QRBand5: TQRBand;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRSysData3: TQRSysData;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRDBText7: TQRDBText;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    QRShape1: TQRShape;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRShape6: TQRShape;
    QRShape7: TQRShape;
    QRShape8: TQRShape;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    QRSysData4: TQRSysData;
    QRLabel17: TQRLabel;
    QRExpr1: TQRExpr;
    QRLabel18: TQRLabel;
    QRLabel19: TQRLabel;
    QRLabel20: TQRLabel;
    QRLabel21: TQRLabel;
    lb_pr: TQRLabel;
    QRLabel23: TQRLabel;
    lb_bron: TQRLabel;
    QRLabel24: TQRLabel;
    QRLabel22: TQRLabel;
    QRSysData5: TQRSysData;
    QRLabel25: TQRLabel;
    lb_talon_out: TQRLabel;
    QRShape9: TQRShape;
    QRLabel26: TQRLabel;
    QRShape10: TQRShape;
    QRLabel27: TQRLabel;
    QRDBText8: TQRDBText;
    cds_plategi: TClientDataSet;
    DataSource1: TDataSource;
    QRSubDetail1: TQRSubDetail;
    QRLabel30: TQRLabel;
    QRLabel31: TQRLabel;
    QRDBText10: TQRDBText;
    QRDBText13: TQRDBText;
    QRDBText14: TQRDBText;
    QRLabel28: TQRLabel;
    QRExpr2: TQRExpr;
    QRLabel29: TQRLabel;
    lb_bad_schets: TQRLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function Print_otchet_schets(kod_smen,x:integer):boolean;

var
  fr_prm_schet_otchet: Tfr_prm_schet_otchet;
  smens, xx : integer;
  otv : boolean;

implementation

Uses DM;
{$R *.DFM}

Function Print_otchet_schets(kod_smen,x:integer):boolean;
Begin
  smens:=kod_smen;
  otv:=false;
  xx:=x;
  try
    try
      fr_prm_schet_otchet:=Tfr_prm_schet_otchet.Create(Application);
      //fr_prm_schet_otchet.QuickRep1.Print;
      fr_prm_schet_otchet.QuickRep1.Preview;
    finally
      Result:=otv;
      fr_prm_schet_otchet.Free;
    end;
  except
  end;
end;

procedure Tfr_prm_schet_otchet.FormCreate(Sender: TObject);
var
 parametry,par,rs : variant;
 resSQL,tal_out : integer;
 pr,br,lgot : real;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=186;
  parametry[1]:=DataModuls.kod_adm;
  parametry[2]:=3;
  parametry[3]:=VarArrayOf([IntToStr(smens),'not','X']);
  parametry[4]:=VarArrayOf(['smen','not','ser']);
  parametry[5]:=5;                                     //$$$$$
  If xx=1 Then parametry[3]:=VarArrayOf([IntToStr(smens),'','X']);
  If xx=2 Then parametry[3]:=VarArrayOf([IntToStr(smens),'','']);
  resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
  parametry[0]:=197;
  tal_out:=0;
  If resSQL=0 Then Begin
     cds_otchet.Active:=true;
     cds_otchet.AddIndex('i1','nom_schet',[ixCaseInsensitive],'','',0);
     cds_otchet.IndexName:='i1';
     resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
     If resSQL=0 Then Begin
       cds_plategi.Active:=true;
       cds_plategi.IndexFieldNames:='schet';
       par:=VarArrayCreate([0, 2], varVariant);
       par[0]:=3;{получаем число испорченных счетов}
       par[1]:=VarArrayOf([IntToStr(smens),'not','X']);
       par[2]:=VarArrayOf(['smen','not','ser']);        //$$$$$
       If xx=1 Then par[1]:=VarArrayOf([IntToStr(smens),'','X']);
       rs:=DataModuls.GetTehParam(200,par);
       If not VarIsNull(rs[1]) Then lb_bad_schets.Caption:=IntToStr(rs[1])
       Else lb_bad_schets.Caption:='0';
       //cds_plategi.MasterFields:='nom_schet';
       par[0]:=1;{получаем ФИО АДМа}
       par[1]:=VarArrayOf([IntToStr(smens)]);
       par[2]:=VarArrayOf(['smen']);
       rs:=DataModuls.GetTehParam(187,par);
       If not VarIsNull(rs[1]) Then Begin
         lb_fio.Caption:=rs[1];
         tal_out:=rs[2];
         lb_talon_out.Caption:=IntToStr(tal_out);
       end
       Else Begin
         lb_fio.Caption:='';
         lb_pr.Caption:='0';
         lb_bron.Caption:='0';
         lb_talon_out.Caption:=IntToStr(tal_out);
         Screen.Cursor:=crDefault;
         Exit;
       end;
       par[0]:=5;{получаем сумму за проживание}
       par[1]:=VarArrayOf([IntToStr(smens),'1','not','','X']);
       par[2]:=VarArrayOf(['smen','tip','not','kom','ser']);    //$$$$$
       If xx=1 Then par[1]:=VarArrayOf([IntToStr(smens),'1','','','X']);
       If xx=2 Then par[1]:=VarArrayOf([IntToStr(smens),'1','','','']);
       rs:=DataModuls.GetTehParam(188,par);
       If not VarIsNull(rs[1]) Then pr:=rs[1]
       Else Begin
        lb_pr.Caption:='0';
        lb_bron.Caption:='0';
        Screen.Cursor:=crDefault;
        Exit;
       end;
       lgot:=0;
       par[1]:=VarArrayOf([IntToStr(smens),'2','not','','X']);
       If xx=1 Then par[1]:=VarArrayOf([IntToStr(smens),'2','','','X']);
       If xx=2 Then par[1]:=VarArrayOf([IntToStr(smens),'2','','','']);
       rs:=DataModuls.GetTehParam(188,par);
       If not VarIsNull(rs[1]) Then lgot:=rs[1];                   //$$$$$
       par[1]:=VarArrayOf([IntToStr(smens),'4','not','','X']);
       If xx=1 Then par[1]:=VarArrayOf([IntToStr(smens),'4','','','X']);
       If xx=2 Then par[1]:=VarArrayOf([IntToStr(smens),'4','','','']);
       rs:=DataModuls.GetTehParam(188,par);
       If not VarIsNull(rs[1]) Then br:=rs[1]
       Else Begin
         br:=0;
         lb_bron.Caption:='0';
       end;
       pr:=pr-lgot;
       lb_pr.Caption:=FloatToStr(pr);
       lb_bron.Caption:=FloatToStr(br);
     end
     Else Begin
       lb_pr.Caption:='0';
       lb_bron.Caption:='0';
       lb_fio.Caption:='';
       lb_talon_out.Caption:=IntToStr(tal_out);
       Screen.Cursor:=crDefault;
       Exit;
     end;
  end
  Else Begin
    lb_pr.Caption:='0';
    lb_bron.Caption:='0';
    lb_fio.Caption:='';
    lb_talon_out.Caption:=IntToStr(tal_out);
    Screen.Cursor:=crDefault;
    Exit;
  end;
  otv:=true;
  Screen.Cursor:=crDefault;
end;

procedure Tfr_prm_schet_otchet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  cds_otchet.Active:=false;
end;

procedure Tfr_prm_schet_otchet.DataSource1DataChange(Sender: TObject;
  Field: TField);
begin
   cds_plategi.Filter:='schet = '+
               IntToStr(cds_otchet.Fieldbyname('nom_schet').AsInteger);
end;

end.
