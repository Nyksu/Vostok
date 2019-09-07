unit prn_kalkulat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, Db, DBClient, QuickRpt, ExtCtrls, DM, progress_window;

type
  Tfr_prn_kalc_noms = class(TForm)
    qr_calc: TQuickRep;
    QRBand1: TQRBand;
    QRBand2: TQRBand;
    QRBand3: TQRBand;
    QRBand4: TQRBand;
    QRLabel1: TQRLabel;
    QRSysData1: TQRSysData;
    QRLabel2: TQRLabel;
    QRShape1: TQRShape;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRShape6: TQRShape;
    QRShape7: TQRShape;
    QRShape8: TQRShape;
    QRShape9: TQRShape;
    QRShape10: TQRShape;
    QRShape11: TQRShape;
    QRShape12: TQRShape;
    QRShape16: TQRShape;
    QRShape13: TQRShape;
    QRShape14: TQRShape;
    QRShape15: TQRShape;
    cds_calc: TClientDataSet;
    QRSysData2: TQRSysData;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    QRLabel17: TQRLabel;
    QRLabel18: TQRLabel;
    QRLabel19: TQRLabel;
    QRLabel20: TQRLabel;
    QRLabel21: TQRLabel;
    QRShape17: TQRShape;
    QRShape18: TQRShape;
    QRShape19: TQRShape;
    QRShape20: TQRShape;
    QRShape21: TQRShape;
    QRShape22: TQRShape;
    QRShape23: TQRShape;
    QRShape24: TQRShape;
    QRShape25: TQRShape;
    QRShape26: TQRShape;
    QRShape27: TQRShape;
    QRShape28: TQRShape;
    QRShape29: TQRShape;
    QRShape30: TQRShape;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText13: TQRDBText;
    QRDBText14: TQRDBText;
    cds_predm: TClientDataSet;
    DataSource1: TDataSource;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


Procedure Kalkulate;

var
  fr_prn_kalc_noms: Tfr_prn_kalc_noms;

implementation

{$R *.DFM}

Procedure Kalkulate;
Begin
   Try
     try
       fr_prn_kalc_noms:=Tfr_prn_kalc_noms.Create(Application);
       fr_prn_kalc_noms.qr_calc.Preview;
     finally
       Screen.Cursor:=crDefault;
       fr_prn_kalc_noms.Free;
     end;
   except
   end;
end;


procedure Tfr_prn_kalc_noms.FormCreate(Sender: TObject);
const
  prd : array[0..6] of integer = (4,0,1,7,6,2,3);
var
  parametry, param, rs : variant;
  resSQL, ii, noms : integer;
  tarif : array[0..6] of real;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=215;
  parametry[1]:=DataModuls.kod_adm;
  parametry[2]:=0;
  parametry[3]:=VarArrayOf([null]);
  parametry[4]:=VarArrayOf(['']);
  parametry[5]:=1;
  resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
  If resSQL<>0 Then Begin
      Exit;
  end;
  Screen.Cursor:=crHourGlass;
  try
   StartProgress;
   cds_calc.Active:=true;
   Screen.Cursor:=crDefault;
  except
   Screen.Cursor:=crDefault;
   CloseProgress;
   Exit;
  end;
  noms:=cds_calc.RecordCount;
  fr_progress.DeclarateConstProgress('Идёт процесс выявления'+#13
         +'оснащения номеров.(около 2-х мин.)',noms*7,1);
  param:=VarArrayCreate([0, 2], varVariant);
  param[0]:=1;{получаем тарифы предметов}
  param[2]:=VarArrayOf(['predmet']);
  For ii:=0 To 6 Do Begin
     param[1]:=VarArrayOf([prd[ii]]);
     rs:=DataModuls.GetTehParam(216,param);
     tarif[ii]:=rs[1];
  end;
  parametry[0]:=217;
  parametry[1]:=DataModuls.kod_adm;
  parametry[2]:=1;
  parametry[4]:=VarArrayOf(['predmet']);
  parametry[5]:=2;
  Screen.Cursor:=crHourGlass;
  fr_progress.SetStepNext;

  
  For ii:=0 To 6 Do Begin
    cds_predm.Active:=false;
    cds_calc.First;
    parametry[3]:=VarArrayOf([prd[ii]]);
    resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
    If resSQL<>0 Then Begin
      Screen.Cursor:=crDefault;
      CloseProgress;
      Exit;
    end;
    cds_predm.Active:=true;
    While not cds_calc.EOF Do Begin
     If not cds_predm.EOF Then Begin
       cds_calc.Edit;
       Case ii of
            0 : cds_calc.FieldByName('column8').AsFloat:=tarif[ii];
            1 : cds_calc.FieldByName('column9').AsFloat:=tarif[ii];
            2 : cds_calc.FieldByName('column10').AsFloat:=tarif[ii];
            3 : cds_calc.FieldByName('column11').AsFloat:=tarif[ii];
            4 : cds_calc.FieldByName('column12').AsFloat:=tarif[ii];
            5 : cds_calc.FieldByName('column13').AsFloat:=tarif[ii];
            6 : cds_calc.FieldByName('column14').AsFloat:=tarif[ii];
       end;
       cds_calc.Post;
     end;
     fr_progress.SetStepNext;
     cds_calc.Next;
    end;
  end;
  CloseProgress;
  cds_predm.Active:=false;
  Screen.Cursor:=crDefault;
end;

end.
