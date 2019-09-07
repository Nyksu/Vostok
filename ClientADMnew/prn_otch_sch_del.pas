unit prn_otch_sch_del;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, QuickRpt, ExtCtrls, Db, DBClient;

type
  Tfr_prn_otch_del_sch = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRSysData1: TQRSysData;
    QRLabel3: TQRLabel;
    lb_fio: TQRLabel;
    QRBand2: TQRBand;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRBand3: TQRBand;
    QRShape1: TQRShape;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRSysData3: TQRSysData;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRBand4: TQRBand;
    QRSysData2: TQRSysData;
    QRLabel4: TQRLabel;
    QRLabel22: TQRLabel;
    QRSysData5: TQRSysData;
    QRBand5: TQRBand;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    QRSysData4: TQRSysData;
    cds_otchet: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function Print_otchet_schdel(kod_smen:integer):boolean;

var
  fr_prn_otch_del_sch: Tfr_prn_otch_del_sch;
  smens : integer;
  otv : boolean;

implementation

Uses MainADM;

{$R *.DFM}

Function Print_otchet_schdel(kod_smen:integer):boolean;
Begin
  smens:=kod_smen;
  otv:=false;
  try
    try
      fr_prn_otch_del_sch:=Tfr_prn_otch_del_sch.Create(Application);
      fr_prn_otch_del_sch.QuickRep1.Print;
      // fr_prn_otch_del_sch.QuickRep1.Preview;
    finally
      Result:=otv;
      fr_prn_otch_del_sch.Free;
    end;
  except
  end;
end;
procedure Tfr_prn_otch_del_sch.FormCreate(Sender: TObject);
var
 parametry,par,rs : variant;
 resSQL : integer;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=193;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=1;
  parametry[3]:=VarArrayOf([IntToStr(smens)]);
  parametry[4]:=VarArrayOf(['smen']);
  parametry[5]:=5;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL=0 Then Begin
     cds_otchet.Active:=true;
     par:=VarArrayCreate([0, 2], varVariant);
     par[0]:=1;{получаем ФИО АДМа}
     par[1]:=VarArrayOf([IntToStr(smens)]);
     par[2]:=VarArrayOf(['smen']);
     rs:=fr_ClientAdm.GetTehParam(187,par);
     If not VarIsNull(rs[1]) Then Begin
      lb_fio.Caption:=rs[1];
     end
     Else Begin
       lb_fio.Caption:='';
       Exit;
     end;
  end
  Else Begin
    lb_fio.Caption:='';
    Exit;
  end;
  otv:=true;
end;

procedure Tfr_prn_otch_del_sch.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  cds_otchet.Active:=false;
end;

end.
