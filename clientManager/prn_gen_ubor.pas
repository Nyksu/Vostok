unit prn_gen_ubor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Qrctrls, QuickRpt, DBTables, ExtCtrls, DBClient;

type
  Tfr_prn_gen_ubork = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRBand2: TQRBand;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRLabel1: TQRLabel;
    QRBand3: TQRBand;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    lb_period: TQRLabel;
    cds_gornich_ocenk: TClientDataSet;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Gen_list_genubor(ds,dt : TDate);


var
  fr_prn_gen_ubork: Tfr_prn_gen_ubork;
  d_s,d_t : TDate;

implementation

uses DM;

{$R *.DFM}

Procedure Gen_list_genubor(ds,dt : TDate);
Begin
  d_s:=ds;
  d_t:=dt;
  try
     try
       fr_prn_gen_ubork:=Tfr_prn_gen_ubork.Create(Application);
       fr_prn_gen_ubork.QuickRep1.Preview;
     finally
       fr_prn_gen_ubork.Free;
     end
  except
  end;
end;

procedure Tfr_prn_gen_ubork.FormCreate(Sender: TObject);
var
 parametry : variant;
 resSQL : integer;
begin
  lb_period.Caption:='c '+DateToStr(d_s)+' по '+DateToStr(d_t);
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=248;
  parametry[1]:=DataModuls.kod_adm;
  parametry[2]:=2;
  parametry[3]:=VarArrayOf([DateToStr(d_s),DateToStr(d_t)]);
  parametry[4]:=VarArrayOf(['dat_s','dat_po']);
  parametry[5]:=1;
  resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
  If resSQL=0 Then cds_gornich_ocenk.Open;
end;

end.
