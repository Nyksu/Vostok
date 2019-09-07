unit Last_general;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, DBGrids, ExtCtrls, Db, DBClient;

type
  Tfr_last_general = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    bt_exit: TBitBtn;
    cds_gen: TClientDataSet;
    ds_gen: TDataSource;
    procedure bt_exitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Get_last_generals;


var
  fr_last_general: Tfr_last_general;

implementation

uses DM;

{$R *.DFM}

Procedure Get_last_generals;
Begin
  try
    try
      Screen.Cursor:=crHourGlass;
      fr_last_general:=Tfr_last_general.Create(Application);
      fr_last_general.ShowModal;
    finally
      Screen.Cursor:=crDefault;
      fr_last_general.Free;
    end;
  except
  end;
end;

procedure Tfr_last_general.bt_exitClick(Sender: TObject);
begin
  fr_last_general.Close;
end;

procedure Tfr_last_general.FormCreate(Sender: TObject);
var
  bb : boolean;
  parametry : variant;
  resSQL : integer;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=259;
  parametry[1]:=DataModuls.kod_adm;
  parametry[2]:=0;
  parametry[3]:=null;
  parametry[4]:=null;
  parametry[5]:=1;
  Screen.Cursor:=crHourGlass;
  resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
  bb:=(resSQL=0);
  If bb Then Begin
    cds_gen.Active:=false;
    try
     cds_gen.Active:=true;
    except
      Screen.Cursor:=crDefault;
      Exit;
    end;
  end;
end;

end.
