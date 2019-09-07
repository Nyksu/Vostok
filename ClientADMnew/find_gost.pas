unit find_gost;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, Db, DBClient;

type
  Tfr_find_gost = class(TForm)
    ed_famil: TEdit;
    ed_im: TEdit;
    ed_ot: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ed_adres: TEdit;
    rg_dat_chenge: TRadioGroup;
    pn_result: TPanel;
    bt_find_gost: TBitBtn;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    bt_exit: TBitBtn;
    cds_rez: TClientDataSet;
    cds_rez_det: TClientDataSet;
    ds_rez: TDataSource;
    ds_rez_det: TDataSource;
    procedure bt_exitClick(Sender: TObject);
    procedure bt_find_gostClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function GetGostKod(for_schet : boolean) : integer;

var
  fr_find_gost: Tfr_find_gost;
  kod_gost : integer;

implementation

uses MainADM;

{$R *.DFM}

var 
  is_find_for_schet : boolean;

Function GetGostKod(for_schet : boolean) : integer;
Begin
  kod_gost:=-1;
  is_find_for_schet:=for_schet;
  try
    try
      fr_find_gost:=Tfr_find_gost.Create(Application);
      fr_find_gost.ShowModal;
    finally
      Result:=kod_gost;
      fr_find_gost.Free;
    end;
  except
  end
end;


procedure Tfr_find_gost.bt_exitClick(Sender: TObject);
begin
   kod_gost:=-1;
   If not cds_rez.eof Then kod_gost:=cds_rez.FieldByName('kod_gost').AsInteger;
   fr_find_gost.Close;
end;

procedure Tfr_find_gost.bt_find_gostClick(Sender: TObject);
var
  parametry : variant;
  resSQL : integer;
  zn, s_stat : string;
begin
   screen.Cursor:=crHourGlass;
   Case rg_dat_chenge.ItemIndex Of
       0 : Begin
             zn:='>=';
             s_stat:='0';
           end;
       1 : Begin
             zn:='=';
             s_stat:='0';
           end;
       2 : Begin
             zn:='>';
             s_stat:='0';
           end;
   end;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=204;
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=12;
   parametry[3]:=VarArrayOf([ed_famil.text,ed_im.text,ed_ot.text,ed_adres.text,zn,s_stat,ed_famil.text,ed_im.text,ed_ot.text,ed_adres.text,zn,s_stat]);
   parametry[4]:=VarArrayOf(['famil','im','ot','adr','znak','stat','famil','im','ot','adr','znak','stat']);
   parametry[5]:=1;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Begin
     MessageDlg('Нет прав на операцию!', mtWarning, [mbOk], 0);
     screen.Cursor:=crDefault;
     Exit;
   end;
   parametry[5]:=2;
   parametry[0]:=205;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Begin
     MessageDlg('Нет прав на операцию!', mtWarning, [mbOk], 0);
     screen.Cursor:=crDefault;
     Exit;
   end;
   cds_rez_det.Active:=false;
   cds_rez.Active:=false;
   cds_rez.Active:=true;
   cds_rez_det.Active:=true;
   screen.Cursor:=crDefault;
end;

end.
