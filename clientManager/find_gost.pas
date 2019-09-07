unit find_gost;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, Db, DBClient, DM;

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
    bt_save: TButton;
    procedure bt_exitClick(Sender: TObject);
    procedure bt_find_gostClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure ds_rezDataChange(Sender: TObject; Field: TField);
    procedure bt_saveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function GetGostKod : integer;

var
  fr_find_gost: Tfr_find_gost;
  kod_gost : integer;

implementation

{$R *.DFM}

Function GetGostKod : integer;
Begin
  kod_gost:=-1;
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
   parametry[1]:=DataModuls.kod_adm;
   parametry[2]:=12;
   parametry[3]:=VarArrayOf([ed_famil.text,ed_im.text,ed_ot.text,ed_adres.text,zn,s_stat,ed_famil.text,ed_im.text,ed_ot.text,ed_adres.text,zn,s_stat]);
   parametry[4]:=VarArrayOf(['famil','im','ot','adr','znak','stat','famil','im','ot','adr','znak','stat']);
   parametry[5]:=1;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Begin
     MessageDlg('Нет прав на операцию!', mtWarning, [mbOk], 0);
     Exit;
   end;
   parametry[5]:=2;
   parametry[0]:=205;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Begin
     MessageDlg('Нет прав на операцию!', mtWarning, [mbOk], 0);
     Exit;
   end;
   cds_rez_det.Active:=false;
   cds_rez.Active:=false;
   cds_rez.Active:=true;
   cds_rez_det.Active:=true;
   screen.Cursor:=crDefault;
end;

procedure Tfr_find_gost.DBGrid1DblClick(Sender: TObject);
var
  ps,len,d : integer;
  ss : string;
begin
   If cds_rez.FieldByName('kod_gost').AsInteger>0 Then Begin
      ed_famil.text:=cds_rez.FieldByName('famil').AsString;
      ed_im.text:=cds_rez.FieldByName('io').AsString;
      len:=length(ed_im.text);
      ps:=Pos(' ',ed_im.text);
      ed_ot.text:=Copy(ed_im.text,ps+1,len-ps);
      ss:=ed_im.text;
      Delete(ss,ps,len-ps+1);
      ed_im.text:=ss;
      bt_save.Visible:=true;
   end;
end;

procedure Tfr_find_gost.ds_rezDataChange(Sender: TObject; Field: TField);
begin
  bt_save.Visible:=false;
end;

procedure Tfr_find_gost.bt_saveClick(Sender: TObject);
var
  parametry : variant;
  resSQL : integer;
  ss : string;
begin
   bt_save.Visible:=false;
   ss:=IntToStr(cds_rez.FieldByName('kod_gost').AsInteger);
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=263;
   parametry[1]:=DataModuls.kod_adm;
   parametry[2]:=4;
   parametry[3]:=VarArrayOf([ed_famil.text,ed_im.text,ed_ot.text,ss]);
   parametry[4]:=VarArrayOf(['fam','i','o','gost']);
   parametry[5]:=0;
   DataModuls.SockToVostok.AppServer.StartTrans;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Begin
     MessageDlg('Нет прав на операцию! (Или ошибка...)', mtWarning, [mbOk], 0);
     DataModuls.SockToVostok.AppServer.BackTrans;
     Exit;
   end
   Else Begin
    DataModuls.SockToVostok.AppServer.CommitTrans;
    cds_rez.Edit;
    cds_rez.FieldByName('famil').AsString:=ed_famil.text;
    cds_rez.FieldByName('io').AsString:=ed_im.text+' '+ed_ot.text;
    cds_rez.post;
   end;
end;

end.
