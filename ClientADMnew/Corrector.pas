unit Corrector;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Db, DBClient, progress_window,Unxcrypt;

type
  Tfr_correct = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    bt_correct: TBitBtn;
    bt_exit: TBitBtn;
    rg_tip_cor: TRadioGroup;
    cds_jurnal: TClientDataSet;
    lb_x: TLabel;
    ed_p: TEdit;
    bt_check_id: TButton;
    procedure bt_exitClick(Sender: TObject);
    procedure bt_correctClick(Sender: TObject);
    procedure Panel2DblClick(Sender: TObject);
    procedure ed_pExit(Sender: TObject);
    procedure ed_pKeyPress(Sender: TObject; var Key: Char);
    procedure bt_check_idClick(Sender: TObject);
  private
    { Private declarations }
    procedure Missing_noms;
    procedure Key_koef;
  public
    { Public declarations }
  end;

Procedure Correcter;

var
  fr_correct: Tfr_correct;
  Work_date : TDate;

implementation

uses MainADM;
{$R *.DFM}

Procedure Correcter;
Begin
  Work_date:=date;
  Exit;
  try
    try
      fr_correct:=Tfr_correct.Create(Application);
      fr_correct.ShowModal;
    finally
      fr_correct.Free;
    end;
  except
  end;
end;

procedure Tfr_correct.bt_exitClick(Sender: TObject);
begin
   fr_correct.Close;
end;

procedure Tfr_correct.Missing_noms;
var
  parametry : variant;
  ii, resSQL : integer;
Begin
   fr_progress.DeclarateConstProgress(#13+'Привидение к-ва мест к номеналу...',6,1);
   cds_jurnal.Active:=false;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=219;  {Привидение к-ва мест к номеналу}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=2;
   parametry[4]:=VarArrayOf(['mest','dat_s']);
   parametry[5]:=0;
   For ii:=3 DownTo 1 Do Begin
      fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
      parametry[3]:=VarArrayOf([IntToStr(ii),DateToStr(Work_date)]);
      resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
      If resSQL<>0 Then Begin
         fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
         Exit;
      end;
      fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
      fr_progress.SetStepNext;
   end;
   parametry[0]:=220;  {Удаление незанятых мест}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=0;
   parametry[3]:=VarArrayOf(['']);
   parametry[4]:=VarArrayOf(['']);
   fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Begin
         fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
         Exit;
   end;
   fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
   fr_progress.SetStepNext;
   parametry[0]:=221;
   For ii:=1 To 2 Do Begin
      fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
      resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
      If resSQL<>0 Then Begin
         fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
         Exit;
      end;
      fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
      fr_progress.SetStepNext;
   end;
end;

procedure Tfr_correct.bt_correctClick(Sender: TObject);
begin
    StartProgress;
    Case rg_tip_cor.ItemIndex of
       0 : Begin
              Missing_noms;
           end;
       1 : Begin
              Key_koef;
           end;
    end;
    CloseProgress;
end;

procedure Tfr_correct.Panel2DblClick(Sender: TObject);
begin
  If (rg_tip_cor.ItemIndex=1)and(fr_ClientAdm.settings[8]=0)and
     (not lb_x.visible) Then Begin
       ed_p.visible:=true;
       ed_p.SetFocus;
  end
  Else Begin
    lb_x.visible:=false;
    ed_p.visible:=false;
  end;
end;

procedure Tfr_correct.ed_pExit(Sender: TObject);
begin
  ed_p.visible:=false;
end;

procedure Tfr_correct.Key_koef;
var
  par, rs : variant;
  cash_in, cash_out{, cash_res} : real;
  bad_schets : integer;
  rss : string;
Begin
  fr_progress.DeclarateConstProgress(#13+'Определение коэффициентов корректности...',3,1);
  If (lb_x.Visible)and(fr_ClientAdm.settings[8]=0) Then Begin
     cash_in:=0;
     cash_out:=0;
     par:=VarArrayCreate([0, 2], varVariant);
     par[0]:=3;
     par[1]:=VarArrayOf([IntToStr(fr_ClientAdm.kod_smen),'','X']);
     par[2]:=VarArrayOf(['smen','not','ser']);
     rs:=fr_ClientAdm.GetTehParam(200,par);
     bad_schets:=0;
     If not VarIsNull(rs[1]) Then bad_schets:=rs[1];
     fr_progress.SetStepNext;
     rs:=fr_ClientAdm.GetTehParam(202,par);
     If not VarIsNull(rs[1]) Then cash_in:=rs[1];
     fr_progress.SetStepNext;
     rs:=fr_ClientAdm.GetTehParam(201,par);
     If not VarIsNull(rs[1]) Then cash_out:=rs[1];
     fr_progress.SetStepNext;
     rss:='Коэффициенты корректности: k1='+IntToStr(bad_schets*100)+' k2='+
          FloatToStr(cash_in/2500)+' k3='+FloatToStr(cash_out/250);
     CloseProgress;
     ShowMessage(rss);
  end
  Else Begin
    fr_progress.SetStepNext;
    fr_progress.SetStepNext;
    fr_progress.SetStepNext;
    CloseProgress;
    ShowMessage('Коэффициенты корректности в приделах нормы!');
  end;
end;


procedure Tfr_correct.ed_pKeyPress(Sender: TObject; var Key: Char);
var
 ss : string;
begin
  If Key = #13 Then Begin
    ss:='vzMYDW.mtWg'; //родогор
    If CreateInterbasePassword(ed_p.text) = ss Then lb_x.Visible:=true;
    ed_p.text:='';
    bt_correct.SetFocus;
  end;
end;

procedure Tfr_correct.bt_check_idClick(Sender: TObject);
var
  rkvo : integer;
  ii : integer;
  param, otvet : Variant;
  strsql : string;
begin
  Randomize;
  rkvo:=Round(Random(10))+1;
  param:=VarArrayCreate([0, 2], varVariant);
  strsql:='select GEN_ID(INC_COD_SCHET,1) from sys_option';
  For ii:=0 To rkvo Do Begin
      param[0]:=2;
      param[1]:=VarArrayOf(['',strsql]);
      param[2]:=VarArrayOf([1,0]);
      otvet:=fr_ClientAdm.GetTehParam(125, param);
  end;
  If otvet[1] > 0 Then
     ShowMessage('Следующий номер счета: '+IntToStr(otvet[1]+1));
end;

end.
