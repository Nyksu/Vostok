unit ed_arif;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, DBCtrls, db;

type
  Tfr_edit_tarif = class(TForm)
    DBEdit1: TDBEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure EditTarif;

var
  fr_edit_tarif: Tfr_edit_tarif;

implementation

Uses MainADM;

{$R *.DFM}

procedure EditTarif;
Begin
  fr_edit_tarif:=Tfr_edit_tarif.Create(Application);
  try
    fr_edit_tarif.ShowModal;
  finally
    fr_edit_tarif.Free;
  end;
end;

procedure Tfr_edit_tarif.BitBtn2Click(Sender: TObject);
begin
  fr_ClientAdm.Cds_work.Cancel;
  fr_edit_tarif.Close;
end;

procedure Tfr_edit_tarif.FormActivate(Sender: TObject);
begin
   DBEdit1.SetFocus;
end;

procedure Tfr_edit_tarif.BitBtn1Click(Sender: TObject);
var
 resSQL : integer;
 parametry : Variant;
 s1,s2,s3,s4 : string;
begin
  If fr_ClientAdm.Cds_work.State = dsEdit Then Begin
     fr_ClientAdm.Cds_work.Post;
     parametry:=VarArrayCreate([0, 5], varVariant);
     parametry[0]:=129;
     parametry[1]:=fr_ClientAdm.kod_adm;
     parametry[2]:=9;
     s1:=FloatToStr(fr_ClientAdm.Cds_work.FieldByName('tarif').AsFloat);
     s2:=#39+DateToStr(fr_ClientAdm.Cds_work.FieldByName('date_ism').Value)+#39;
     s3:=IntToStr(fr_ClientAdm.Cds_work.FieldByName('land').AsInteger);
     s4:=IntToStr(fr_ClientAdm.Cds_work.FieldByName('nomer').AsInteger);
     parametry[3]:=VarArrayOf([s1,s2,s3,'and t2.nomer =',s4,'','','','']);
     parametry[4]:=VarArrayOf([2,5,7,8,9,10,11,12,13]);
     parametry[5]:=0;
     fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
     resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
     If resSQL<>0 Then Begin
       fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
       MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
       fr_ClientAdm.Cds_work.Close;
       fr_ClientAdm.Cds_work.Open;
       Exit;
     end;
     fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
  end;
end;

end.
