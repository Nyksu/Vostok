unit change_nomer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, DBGrids, ExtCtrls;

type
  Tfr_change_nomer = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    DBGrid2: TDBGrid;
    bt_change_nomer: TBitBtn;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure bt_change_nomerClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function GetNomNomer(n_tab, n_spr : integer; var mestov : integer) : integer;

var
  fr_change_nomer: Tfr_change_nomer;
  tb, sp, nomer, mest : integer;

implementation

Uses MainADM;

{$R *.DFM}

Function GetNomNomer(n_tab, n_spr : integer; var mestov : integer) : integer;
Begin
  nomer:=0;
  tb:=n_tab;
  sp:=n_spr;
  mestov:=0;
  mest:=0;
  Screen.Cursor:=crHourGlass;
  try
   try
     fr_change_nomer:=Tfr_change_nomer.Create(Application);
     Screen.Cursor:=crDefault;
     fr_change_nomer.ShowModal;
   finally
     Screen.Cursor:=crDefault;
     mestov:=mest;
     Result:=nomer;
     fr_change_nomer.Free;
   end;
  except
  end;
end;

procedure Tfr_change_nomer.FormCreate(Sender: TObject);
begin
  Case tb of
    0 : DBGrid1.DataSource:=fr_ClientAdm.ds_jur;
    1 : DBGrid1.DataSource:=fr_ClientAdm.ds_sp1;
    2 : DBGrid1.DataSource:=fr_ClientAdm.ds_sp2;
    3 : DBGrid1.DataSource:=fr_ClientAdm.ds_sp3;
    4 : DBGrid1.DataSource:=fr_ClientAdm.ds_work;
  end;
  Case sp of
       1 : DBGrid2.DataSource:=fr_ClientAdm.ds_sp1;
       2 : DBGrid2.DataSource:=fr_ClientAdm.ds_sp2;
       3 : DBGrid2.DataSource:=fr_ClientAdm.ds_sp3;
  end;
end;

procedure Tfr_change_nomer.bt_change_nomerClick(Sender: TObject);
begin
  Case tb of
    0 : If fr_ClientAdm.cds_jur.FieldValues['nomer']>0 Then Begin
              nomer:=fr_ClientAdm.cds_jur.FieldValues['nomer'];
              mest:=fr_ClientAdm.cds_jur.FieldValues['free_mests'];
        end;
    1 : If fr_ClientAdm.cds_sp1.FieldValues['nomer']>0 Then Begin
              nomer:=fr_ClientAdm.cds_sp1.FieldValues['nomer'];
              mest:=fr_ClientAdm.cds_sp1.FieldValues['free_mests'];
        end;
    2 : If fr_ClientAdm.cds_sp2.FieldValues['nomer']>0 Then Begin
              nomer:=fr_ClientAdm.cds_sp2.FieldValues['nomer'];
              mest:=fr_ClientAdm.cds_sp2.FieldValues['free_mests'];
        end;
    3 : If fr_ClientAdm.cds_sp3.FieldValues['nomer']>0 Then Begin
              nomer:=fr_ClientAdm.cds_sp3.FieldValues['nomer'];
              mest:=fr_ClientAdm.cds_sp3.FieldValues['free_mests'];
        end;
    4 : If fr_ClientAdm.cds_work.FieldValues['nomer']>0 Then Begin
              nomer:=fr_ClientAdm.cds_work.FieldValues['nomer'];
              mest:=fr_ClientAdm.cds_work.FieldValues['free_mests'];
        end;
  end;
  fr_change_nomer.Close;
end;

procedure Tfr_change_nomer.BitBtn1Click(Sender: TObject);
begin
  fr_change_nomer.Close;
end;

procedure Tfr_change_nomer.DBGrid1DblClick(Sender: TObject);
var
  par,rs : variant;
  nom : integer;
  cost_r, cost_sng, cost_in : real;
begin
   Case tb of
    0 : If not fr_ClientAdm.cds_jur.EOF Then
              nom:=fr_ClientAdm.cds_jur.FieldValues['nomer'];
    1 : If not fr_ClientAdm.cds_sp1.EOF Then
              nom:=fr_ClientAdm.cds_sp1.FieldValues['nomer'];
    2 : If not fr_ClientAdm.cds_sp2.EOF Then
              nom:=fr_ClientAdm.cds_sp2.FieldValues['nomer'];
    3 : If not fr_ClientAdm.cds_sp3.EOF Then
              nom:=fr_ClientAdm.cds_sp3.FieldValues['nomer'];
    4 : If not fr_ClientAdm.cds_work.EOF Then
              nom:=fr_ClientAdm.cds_work.FieldValues['nomer'];
   end;
   par:=VarArrayCreate([0, 2], varVariant);
   par[0]:=2;{стоимость суток номера для России}
   par[1]:=VarArrayOf([IntToStr(nom),'0']);
   par[2]:=VarArrayOf(['nomer','land']);
   rs:=fr_ClientAdm.GetTehParam(203,par);
   If not VarIsNull(rs[1]) Then cost_r:=rs[1] Else cost_r:=0;
   par[1]:=VarArrayOf([IntToStr(nom),'10']);
   rs:=fr_ClientAdm.GetTehParam(203,par);
   If not VarIsNull(rs[1]) Then cost_sng:=rs[1] Else cost_sng:=0;
   par[1]:=VarArrayOf([IntToStr(nom),'50']);
   rs:=fr_ClientAdm.GetTehParam(203,par);
   If not VarIsNull(rs[1]) Then cost_in:=rs[1] Else cost_in:=0;
   ShowMessage('Цены для: России='+FloatToStr(cost_r)+';  СНГ='+FloatToStr(cost_sng)
               +';  Зарубежье='+FloatToStr(cost_in));
end;

end.
