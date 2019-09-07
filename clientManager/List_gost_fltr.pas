unit List_gost_fltr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, QuickRpt, Qrctrls, ExtCtrls, DBClient;

type
  Tprn_gost_list_fltr = class(TForm)
    QuickRep1: TQuickRep;
    DetailBand1: TQRBand;
    PageFooterBand1: TQRBand;
    QRSysData2: TQRSysData;
    TitleBand1: TQRBand;
    QRSysData1: TQRSysData;
    QRSubDetail1: TQRSubDetail;
    ds_gost: TDataSource;
    cds_gost: TClientDataSet;
    cds_noms: TClientDataSet;
    QRExpr1: TQRExpr;
    QRShape1: TQRShape;
    QRLabel1: TQRLabel;
    QRDBText1: TQRDBText;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRDBText2: TQRDBText;
    QRLabel4: TQRLabel;
    QRDBText3: TQRDBText;
    QRLabel5: TQRLabel;
    QRDBText4: TQRDBText;
    QRLabel6: TQRLabel;
    QRDBText5: TQRDBText;
    QRLabel7: TQRLabel;
    QRDBText6: TQRDBText;
    procedure FormCreate(Sender: TObject);
    procedure ds_gostDataChange(Sender: TObject; Field: TField);
  private
    procedure RescanNoms;
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure ShowLstGost(us : string);

var
  prn_gost_list_fltr: Tprn_gost_list_fltr;
  dats : string;

implementation

Uses DM;

{$R *.DFM}

Procedure ShowLstGost(us : string);
Begin
  dats:=us;
  try
    try
      prn_gost_list_fltr:=Tprn_gost_list_fltr.Create(Application);
      prn_gost_list_fltr.QuickRep1.Preview;
    finally
      prn_gost_list_fltr.free;
    end;
  except
  end;
end;

procedure Tprn_gost_list_fltr.RescanNoms;
var
 parametry,res : Variant;
begin
   //If cds_gost.RecordCount<1 Then Exit;
   parametry:=VarArrayCreate([0, 2], varVariant);
   parametry[0]:=1;
   parametry[1]:=VarArrayOf([IntToStr(cds_gost.FieldByName('kod_gost').AsInteger)]);
   parametry[2]:=VarArrayOf(['gost']);
   res:=DataModuls.GetData(245,parametry);
   If not VarIsNull(res) Then cds_noms.Data:=res;
end;

procedure Tprn_gost_list_fltr.FormCreate(Sender: TObject);
var
 parametry,res : Variant;
begin
   parametry:=VarArrayCreate([0, 2], varVariant);
   parametry[0]:=2;
   parametry[1]:=VarArrayOf([dats,dats]);
   parametry[2]:=VarArrayOf(['uslovie','uslovie']);
   res:=DataModuls.GetData(265,parametry);
   If not VarIsNull(res) Then cds_gost.Data:=res;
end;

procedure Tprn_gost_list_fltr.ds_gostDataChange(Sender: TObject;
  Field: TField);
begin
   RescanNoms;
end;

end.
