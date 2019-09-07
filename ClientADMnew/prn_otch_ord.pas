unit prn_otch_ord;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, QuickRpt, ExtCtrls, Db, DBClient;

type
  Tfr_prn_vozvr_otch = class(TForm)
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
    QRLabel14: TQRLabel;
    QRBand3: TQRBand;
    QRShape1: TQRShape;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText6: TQRDBText;
    QRSysData3: TQRSysData;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
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
    QRLabel17: TQRLabel;
    QRExpr1: TQRExpr;
    QRLabel18: TQRLabel;
    cds_otchet: TClientDataSet;
    QRShape5: TQRShape;
    QRShape6: TQRShape;
    QRShape7: TQRShape;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function Print_otch_vozvr(kod_smen:integer) : boolean;

var
  fr_prn_vozvr_otch: Tfr_prn_vozvr_otch;
  smens : integer;
  otv : boolean;

implementation

Uses MainADM;
{$R *.DFM}

Function Print_otch_vozvr(kod_smen:integer) : boolean;
Begin
  smens:=kod_smen;
  otv:=false;
  try
    try
      fr_prn_vozvr_otch:=Tfr_prn_vozvr_otch.Create(Application);
      fr_prn_vozvr_otch.QuickRep1.Print;
      // fr_prn_vozvr_otch.QuickRep1.Preview;
    finally
      Result:=otv;
      fr_prn_vozvr_otch.Free;
    end;
  except
  end;
end;

procedure Tfr_prn_vozvr_otch.FormCreate(Sender: TObject);
var
 parametry,par,rs : variant;
 resSQL : integer;
begin
  cds_otchet.Active:=false;
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=192;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=3;
  parametry[3]:=VarArrayOf([IntToStr(smens),'not','X']); //$$$$$
  parametry[4]:=VarArrayOf(['smen','not','ser']);
  parametry[5]:=5;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL=0 Then Begin
     cds_otchet.Active:=true;
     par:=VarArrayCreate([0, 2], varVariant);
     par[0]:=1;{получаем ФИО АДМа}
     par[1]:=VarArrayOf([IntToStr(smens)]);
     par[2]:=VarArrayOf(['smen']);
     rs:=fr_ClientAdm.GetTehParam(187,par);
     If not VarIsNull(rs[1]) Then lb_fio.Caption:=rs[1]
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

procedure Tfr_prn_vozvr_otch.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  cds_otchet.Active:=false;
end;

end.
