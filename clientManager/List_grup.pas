unit List_grup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBClient, ExtCtrls, StdCtrls, Buttons, Grids, DBGrids, prn_group_sch;

type
  Tfr_group_list = class(TForm)
    Panel1: TPanel;
    cds_list: TClientDataSet;
    rg_period: TRadioGroup;
    DBGrid1: TDBGrid;
    bt_print: TBitBtn;
    bt_exit: TBitBtn;
    ds_list: TDataSource;
    procedure bt_exitClick(Sender: TObject);
    procedure bt_printClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rg_periodClick(Sender: TObject);
  private
    Procedure Rescan;
    { Private declarations }
  public
    { Public declarations }
  end;


Procedure StartGroup;

var
  fr_group_list: Tfr_group_list;

implementation

Uses DM;

{$R *.DFM}

Procedure StartGroup;
Begin
   try
     try
       fr_group_list:=Tfr_group_list.Create(Application);
       fr_group_list.ShowModal;
     finally
       fr_group_list.Free;
     end;
   except
   end;
end;

Procedure Tfr_group_list.Rescan;
var
  delta : integer;
  parametry : variant;
  resSQL : integer;
Begin
  Case rg_period.ItemIndex of
     0 : delta:=7;
     1 : delta:=30;
  end;
  Screen.Cursor:=crHourGlass;
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=261;
  parametry[1]:=DataModuls.kod_adm;
  parametry[2]:=1;
  parametry[3]:=VarArrayOf([IntToStr(delta)]);
  parametry[4]:=VarArrayOf(['delta']);
  parametry[5]:=1;
  resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
  If resSQL<>0 Then Begin
    Screen.Cursor:=crDefault;
    Exit;
  end;
  cds_list.Active:=false;
  try
   try
    cds_list.Active:=true;
   finally
    Screen.Cursor:=crDefault;
   end;
  except
    ShowMessage('Îøèáêà!!!!!!!!');
  end;
end;

procedure Tfr_group_list.bt_exitClick(Sender: TObject);
begin
  fr_group_list.Close;
end;

procedure Tfr_group_list.bt_printClick(Sender: TObject);
begin
  If cds_list.FieldByName('id_schet').AsInteger>0 Then
      PrintGroup(cds_list.FieldByName('id_schet').AsInteger);
end;

procedure Tfr_group_list.FormActivate(Sender: TObject);
begin
  Rescan;
end;

procedure Tfr_group_list.rg_periodClick(Sender: TObject);
begin
  Rescan;
end;

end.
