unit Calc_besnal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Db, DBClient, Grids, DBGrids, StdCtrls, Buttons, print_bn_calc;

type
  Tfr_calk_besnal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    cds_zayavki: TClientDataSet;
    ds_zayavki: TDataSource;
    bt_print: TBitBtn;
    bt_exit: TBitBtn;
    ch_is_prn: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure bt_exitClick(Sender: TObject);
    procedure ch_is_prnClick(Sender: TObject);
    procedure bt_printClick(Sender: TObject);
  private
    Procedure Show_lst_bron(is_prn : boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Calc_besnals;

var
  fr_calk_besnal: Tfr_calk_besnal;

implementation

uses MainADM;
{$R *.DFM}


Procedure Calc_besnals;
Begin
   try
     try
       fr_calk_besnal:=Tfr_calk_besnal.Create(Application);
       fr_calk_besnal.ShowModal;
     finally
       Screen.Cursor:=crDefault;
       fr_calk_besnal.Free;
     end;
   except
   end;
end;

Procedure Tfr_calk_besnal.Show_lst_bron(is_prn : boolean);
var
  parametry : variant;
  resSQL : integer;
begin
   cds_zayavki.Active:=false;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=229;  {Доступные для полного расчета заявки}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=1;
   If is_prn Then parametry[3]:=VarArrayOf([''])
             Else parametry[3]:=VarArrayOf(['not']);
   parametry[4]:=VarArrayOf(['not']);
   parametry[5]:=1;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   Screen.Cursor:=crHourGlass;
   cds_zayavki.Open;
   cds_zayavki.Last;
   Screen.Cursor:=crDefault;
end;

procedure Tfr_calk_besnal.FormCreate(Sender: TObject);
begin
   Show_lst_bron(false);
end;

procedure Tfr_calk_besnal.bt_exitClick(Sender: TObject);
begin
  fr_calk_besnal.Close;
end;

procedure Tfr_calk_besnal.ch_is_prnClick(Sender: TObject);
begin
  If ch_is_prn.Checked Then Show_lst_bron(true) Else Show_lst_bron(false);
end;

procedure Tfr_calk_besnal.bt_printClick(Sender: TObject);
var
  parametry : variant;
  kd_br, resSQL : integer;
begin
  Screen.Cursor:=crHourGlass;
  If not VarIsNull(cds_zayavki.FieldByName('cod_bron').Value) Then
    kd_br:=cds_zayavki.FieldByName('cod_bron').AsInteger
  Else kd_br:=-1;
  If kd_br>0 Then Begin
        If not ch_is_prn.Checked Then Begin
           parametry:=VarArrayCreate([0, 5], varVariant);
           parametry[0]:=238;  {Пометить заявку напечатаной}
           parametry[1]:=fr_ClientAdm.kod_adm;
           parametry[2]:=2;
           parametry[3]:=VarArrayOf([IntToStr(kd_br),DateToStr(date)]);
           parametry[4]:=VarArrayOf(['bron','dat']);
           parametry[5]:=0;
           fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
           resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
           If resSQL<>0 Then Begin
              MessageDlg('Отказ в доступе! Или ошибка учета б/н.', mtWarning, [mbOk], 0);
              fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
              Exit;
           end;
           fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
        end;
        Prn_calc_bn(kd_br);
  end;
  Screen.Cursor:=crDefault;
end;

end.
