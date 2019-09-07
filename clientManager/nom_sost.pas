unit nom_sost;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, ComCtrls, Spin, DM, Db, DBClient;

type
  Tfr_sost_nom = class(TForm)
    ed_nomer: TSpinEdit;
    Label1: TLabel;
    ed_dat_s: TDateTimePicker;
    ed_dat_po: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    bt_ask: TBitBtn;
    bt_exit: TBitBtn;
    DBGrid1: TDBGrid;
    Panel4: TPanel;
    Panel5: TPanel;
    DBGrid2: TDBGrid;
    Panel6: TPanel;
    Panel7: TPanel;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    Panel8: TPanel;
    cds_dats: TClientDataSet;
    cds_prich: TClientDataSet;
    cds_gost: TClientDataSet;
    cds_bron: TClientDataSet;
    ds_dats: TDataSource;
    ds_prich: TDataSource;
    ds_gost: TDataSource;
    ds_bron: TDataSource;
    Label4: TLabel;
    lb_mests: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure bt_askClick(Sender: TObject);
    procedure bt_exitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Sostoian_nom;

var
  fr_sost_nom: Tfr_sost_nom;

implementation

Procedure Sostoian_nom;
Begin
  try
    try
      fr_sost_nom:=Tfr_sost_nom.Create(Application);
      fr_sost_nom.ShowModal;
    finally
      fr_sost_nom.Free;
    end;
  except
  end;
end;

{$R *.DFM}

procedure Tfr_sost_nom.FormCreate(Sender: TObject);
begin
  ed_dat_s.date:=date;
  ed_dat_po.date:=ed_dat_s.date;
end;

procedure Tfr_sost_nom.bt_askClick(Sender: TObject);
var
  parametry, param, rs : variant;
  resSQL : integer;
begin
   param:=VarArrayCreate([0, 2], varVariant);
   param[0]:=1;{получаем к-во мест в номере}
   param[1]:=VarArrayOf([IntToStr(ed_nomer.Value)]);
   param[2]:=VarArrayOf(['nomer']);
   rs:=DataModuls.GetTehParam(214,param);
   If VarIsNull(rs[1]) Then Begin
      MessageDlg('Нет такого номера !!', mtError, [mbOk], 0);
      ed_nomer.SetFocus;
      Exit;
   end;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=212;
   parametry[1]:=DataModuls.kod_adm;
   parametry[2]:=3;
   parametry[3]:=VarArrayOf([IntToStr(ed_nomer.Value),DateToStr(ed_dat_s.date),
                             DateToStr(ed_dat_po.date)]);
   parametry[4]:=VarArrayOf(['nomer','dt_s','dt_po']);
   parametry[5]:=1;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Begin
      MessageDlg('Ошибка! 1', mtWarning, [mbOk], 0);
      Exit;
   end;
   parametry[0]:=211;
   parametry[5]:=2;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Begin
      MessageDlg('Ошибка! 2', mtWarning, [mbOk], 0);
      Exit;
   end;
   Screen.Cursor:=crHourGlass;
   try
    cds_prich.Active:=false;
    cds_dats.Active:=false;
    cds_dats.Active:=true;
    cds_prich.Active:=true;
    Screen.Cursor:=crDefault;
   except
    cds_prich.Active:=false;
    cds_dats.Active:=false;
    Screen.Cursor:=crDefault;
    MessageDlg('Ошибка! 3', mtWarning, [mbOk], 0);
    Exit;
   end;
   parametry[0]:=218;
   parametry[5]:=3;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL=0 Then Begin
      cds_bron.Active:=false;
      try
        cds_bron.Active:=true;
      except
      end;
   end;
   parametry[0]:=213;
   parametry[5]:=2;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL=0 Then Begin
      cds_gost.Active:=false;
      try
        cds_gost.Active:=true;
      except
      end;
   end;
   lb_mests.Caption:=IntToStr(rs[1]);
   
end;

procedure Tfr_sost_nom.bt_exitClick(Sender: TObject);
begin
  cds_prich.Active:=false;
  cds_dats.Active:=false;
  cds_gost.Active:=false;
  fr_sost_nom.Close;
end;

end.
