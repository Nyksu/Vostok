unit Othc_nach_rasm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ExtCtrls, RXCtrls, ComCtrls, StdCtrls, DBCtrls, Buttons, DM,
  Db, DBClient, prn_otch_sch, prn_otch_ord, Mask, Unxcrypt;

type
  Tfr_otchets_nach_rasm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    tb_smens: TDBGrid;
    ed_dat_s: TDateTimePicker;
    RxLabel1: TRxLabel;
    bt_daly_rep: TBitBtn;
    bt_exit: TBitBtn;
    cds_smens: TClientDataSet;
    ds_smens: TDataSource;
    ch_all_smens: TCheckBox;
    BitBtn1: TBitBtn;
    lb_xx: TLabel;
    ed_x: TMaskEdit;
    procedure FormCreate(Sender: TObject);
    procedure ch_all_smensClick(Sender: TObject);
    procedure bt_exitClick(Sender: TObject);
    procedure ed_dat_sChange(Sender: TObject);
    procedure bt_daly_repClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure lb_xxDblClick(Sender: TObject);
    procedure Panel2DblClick(Sender: TObject);
    procedure ed_xKeyPress(Sender: TObject; var Key: Char);
  private
    pp : string;
    pp2 : string;
    pr : integer;
    procedure S_dat_view;
    procedure All_view;
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Start_smen_nach;


var
  fr_otchets_nach_rasm: Tfr_otchets_nach_rasm;

implementation

{$R *.DFM}


Procedure Start_smen_nach;
Begin
  try
    try
      fr_otchets_nach_rasm:=Tfr_otchets_nach_rasm.Create(application);
      fr_otchets_nach_rasm.ShowModal;
    finally
      fr_otchets_nach_rasm.Free;
    end;
  except
  end;
end;

procedure Tfr_otchets_nach_rasm.S_dat_view;
var
  parametry : variant;
  resSQL : integer;
begin
   cds_smens.Active:=false;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=227;
   parametry[1]:=DataModuls.kod_adm;
   parametry[2]:=1;
   parametry[3]:=VarArrayOf([DateToStr(ed_dat_s.Date)]);
   parametry[4]:=VarArrayOf(['dat_s']);
   parametry[5]:=2;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Begin
     MessageDlg('Нет прав на операцию!', mtWarning, [mbOk], 0);
     Exit;
   end;
   cds_smens.Active:=true;
end;

procedure Tfr_otchets_nach_rasm.All_view;
var
  parametry : variant;
  resSQL : integer;
begin
   cds_smens.Active:=false;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=226;
   parametry[1]:=DataModuls.kod_adm;
   parametry[2]:=0;
   parametry[3]:=VarArrayOf(['']);
   parametry[4]:=VarArrayOf(['']);
   parametry[5]:=2;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Begin
     MessageDlg('Нет прав на операцию!', mtWarning, [mbOk], 0);
     Exit;
   end;
   cds_smens.Active:=true;
end;

procedure Tfr_otchets_nach_rasm.FormCreate(Sender: TObject);
begin
   ed_dat_s.Date:=date-4;
   S_dat_view;
   pp:='RWPPsxJ73..'; //дисерт
   pp2:='/LJ4cKlxwYg'; //шухер
   pr:=DataModuls.SockToVostok.AppServer.IsSys;
   If pr=4 Then Begin
      ch_all_smens.Visible:=true;
      RxLabel1.Visible:=true;
      ed_dat_s.Visible:=true;
   end;
end;

procedure Tfr_otchets_nach_rasm.ch_all_smensClick(Sender: TObject);
begin
  If ch_all_smens.Checked Then All_view Else S_dat_view;
end;

procedure Tfr_otchets_nach_rasm.bt_exitClick(Sender: TObject);
begin
   fr_otchets_nach_rasm.Close;
end;

procedure Tfr_otchets_nach_rasm.ed_dat_sChange(Sender: TObject);
begin
  If not ch_all_smens.Checked Then S_dat_view;
end;

procedure Tfr_otchets_nach_rasm.bt_daly_repClick(Sender: TObject);
var
  sx,pr : integer;
begin
   If lb_xx.Caption='X' Then sx:=1 Else sx:=0;
   If lb_xx.Caption='$' Then sx:=2;
   pr:=DataModuls.SockToVostok.AppServer.IsSys;
   If pr<>4 Then
           If DataModuls.settings[8]<>0 Then sx:=0;
   Screen.Cursor:=crHourGlass;
   If cds_smens.FieldByName('kod_smen').AsInteger>0 Then
       Print_otchet_schets(cds_smens.FieldByName('kod_smen').AsInteger,sx);
   Screen.Cursor:=crDefault;
end;

procedure Tfr_otchets_nach_rasm.BitBtn1Click(Sender: TObject);
var
  sx,pr : integer;
begin
   If lb_xx.Caption='X' Then sx:=1 Else sx:=0;
   If lb_xx.Caption='$' Then sx:=2;
   pr:=DataModuls.SockToVostok.AppServer.IsSys;
   If pr<>4 Then
           If DataModuls.settings[8]<>0 Then sx:=0;
   Screen.Cursor:=crHourGlass;
   If cds_smens.FieldByName('kod_smen').AsInteger>0 Then
       Print_otch_vozvr(cds_smens.FieldByName('kod_smen').AsInteger,sx);
   Screen.Cursor:=crDefault;
end;

procedure Tfr_otchets_nach_rasm.lb_xxDblClick(Sender: TObject);
begin
  If lb_xx.Caption='@' Then lb_xx.Caption:='#' Else lb_xx.Caption:='@';
end;

procedure Tfr_otchets_nach_rasm.Panel2DblClick(Sender: TObject);
begin
  ed_x.Visible:=false;
  If lb_xx.Caption='#' Then ed_x.Visible:=true Else lb_xx.Caption:='@';
  If ed_x.Visible Then ed_x.SetFocus;
  ed_x.text:='';
end;

procedure Tfr_otchets_nach_rasm.ed_xKeyPress(Sender: TObject;
  var Key: Char);
begin
   If Key=#13 Then Begin
      If CreateInterbasePassword(ed_x.text)=pp Then lb_xx.Caption:='X'
         Else If CreateInterbasePassword(ed_x.text)=pp2 Then lb_xx.Caption:='$'
              Else lb_xx.Caption:='@';
      ed_x.Visible:=false;
   end;
end;

end.
