unit Kvo_gosts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, DBClient, ExtCtrls, ComCtrls, StdCtrls, Buttons;

type
  Tfr_count_gost = class(TForm)
    Panel1: TPanel;
    cds_kvo_gost: TClientDataSet;
    Panel2: TPanel;
    ds_kvo_gost: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    lb_sum_gost: TLabel;
    ed_dat_s: TDateTimePicker;
    ed_dat_po: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    bt_exit: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ed_dat_sChange(Sender: TObject);
    procedure bt_exitClick(Sender: TObject);
  private
    parametry : variant;
    Function Rescan : boolean;
    { Private declarations }
  public
    { Public declarations }
  end;


Procedure Get_count_gost;

var
  fr_count_gost: Tfr_count_gost;

implementation

Uses DM;

{$R *.DFM}


Procedure Get_count_gost;
Begin
  try
    try
      fr_count_gost:=Tfr_count_gost.Create(Application);
      fr_count_gost.ShowModal;
    finally
      fr_count_gost.Free;
    end;
  except
  end;
end;

Function Tfr_count_gost.Rescan : boolean;
var
 bb : boolean;
 Ch, resSQL : Integer;
Begin
  Screen.Cursor:=crHourGlass;
  parametry[3]:=VarArrayOf([DateToStr(ed_dat_s.date),DateToStr(ed_dat_po.date)]);
  resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
  bb:=(resSQL=0);
  If bb Then Begin
    cds_kvo_gost.Active:=false;
    try
     cds_kvo_gost.Active:=true;
    except
      Screen.Cursor:=crDefault;
      Exit;
    end;
  end;
  ch:=0;
  While not cds_kvo_gost.EOF Do Begin
    ch:=ch+cds_kvo_gost.FieldByName('Count').AsInteger;
    cds_kvo_gost.Next;
  end;
  lb_sum_gost.Caption:=IntToStr(ch);
  Result:=bb;
  Screen.Cursor:=crDefault;
end;

procedure Tfr_count_gost.FormCreate(Sender: TObject);
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=242;
  parametry[1]:=DataModuls.kod_adm;
  parametry[2]:=2;
  parametry[4]:=VarArrayOf(['dat_s','dat_po']);
  parametry[5]:=1;
  ed_dat_s.date:=date-30;
  ed_dat_po.date:=date;
  If not Rescan Then Begin
    MessageDlg('Ошибка!', mtWarning, [mbOk], 0);
    Exit;
  end;
end;

procedure Tfr_count_gost.ed_dat_sChange(Sender: TObject);
begin
  If not Rescan Then Begin
    MessageDlg('Ошибка!', mtWarning, [mbOk], 0);
    Exit;
  end;
end;

procedure Tfr_count_gost.bt_exitClick(Sender: TObject);
begin
  fr_count_gost.Close;
end;

end.
