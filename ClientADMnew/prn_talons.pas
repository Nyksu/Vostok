unit prn_talons;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, QuickRpt, ExtCtrls, Db, DBClient;

type
  Tfr_prn_talons = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRBand2: TQRBand;
    QRShape1: TQRShape;
    QRShape2: TQRShape;
    QRLabel1: TQRLabel;
    QRMemo1: TQRMemo;
    QRLabel2: TQRLabel;
    lb_s_nom1: TQRLabel;
    QRLabel4: TQRLabel;
    lb_kvo1: TQRLabel;
    QRMemo2: TQRMemo;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRImage1: TQRImage;
    QRMemo3: TQRMemo;
    QRLabel3: TQRLabel;
    lb_seria: TQRLabel;
    QRSysData1: TQRSysData;
    QRLabel5: TQRLabel;
    lb_nom: TQRLabel;
    procedure FormCreate(Sender: TObject);
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure QuickRep1NeedData(Sender: TObject; var MoreData: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Print_talons(kol : integer; schnom, seria : string);

var
  fr_prn_talons: Tfr_prn_talons;
  k_vo, sur : integer;
  s_nom, s_ser : string;

implementation

Uses MainADM;

{$R *.DFM}

Procedure Print_talons(kol : integer; schnom, seria : string);
Begin
  k_vo:=0;
  s_nom:=schnom;
  s_ser:=seria;
  sur:=1;
  k_vo:=kol;
  screen.Cursor:=crHourGlass;
  try
    try
      fr_prn_talons:=Tfr_prn_talons.Create(Application);
      screen.Cursor:=crDefault;
      //fr_prn_talons.QuickRep1.Preview;
      fr_prn_talons.QuickRep1.Print;
    finally
      fr_prn_talons.Free;
      screen.Cursor:=crDefault;
    end;
  except
  end;
end;

procedure Tfr_prn_talons.FormCreate(Sender: TObject);
begin
  lb_s_nom1.Caption:=s_nom;
  lb_seria.Caption:=s_ser;
  lb_kvo1.Caption:=IntToStr(k_vo);
end;

procedure Tfr_prn_talons.QuickRep1BeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  PrintReport:= k_vo >0;
end;

procedure Tfr_prn_talons.QuickRep1NeedData(Sender: TObject;
  var MoreData: Boolean);
begin
  MoreData:= k_vo >= sur;
  Inc(sur);
  If MoreData Then
     lb_nom.Caption:=IntToStr(fr_ClientAdm.MIDASConnection1.AppServer.GetNextID);
end;

end.
