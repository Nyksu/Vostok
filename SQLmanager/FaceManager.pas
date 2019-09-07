unit FaceManager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, StdCtrls, DBCtrls, Mask, ExtCtrls, ComCtrls, DBTables, Grids, DBGrids,
  Provider, BdeProv, DBClient;

type
  TForm1 = class(TForm)
    Database1: TDatabase;
    Session1: TSession;
    Query1: TQuery;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Panel1: TPanel;
    DBMemo1: TDBMemo;
    DBEdit1: TDBEdit;
    DBMemo2: TDBMemo;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBNavigator1: TDBNavigator;
    Button1: TButton;
    Button2: TButton;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    Button3: TButton;
    RadioGroup1: TRadioGroup;
    Button4: TButton;
    DBGrid1: TDBGrid;
    DBLookupComboBox1: TDBLookupComboBox;
    ClientDataSet1: TClientDataSet;
    Provider1: TProvider;
    TabSheet3: TTabSheet;
    Table1: TTable;
    DataSource3: TDataSource;
    DBGrid2: TDBGrid;
    DBNavigator2: TDBNavigator;
    Query2: TQuery;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Table1AfterInsert(DataSet: TDataSet);
    procedure Table1AfterEdit(DataSet: TDataSet);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBEdit2KeyPress(Sender: TObject; var Key: Char);
    procedure DBEdit3KeyPress(Sender: TObject; var Key: Char);
    procedure DBEdit4KeyPress(Sender: TObject; var Key: Char);
    procedure ClientDataSet1AfterInsert(DataSet: TDataSet);
    procedure ClientDataSet1AfterEdit(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  ClientDataSet1.Active:=false;
  Query1.Active:=false;
  Query1.SQL.text:='Select kod_sql,sql_txt,koment,date_izm from tb_sql;';
  Query1.Open;
  ClientDataSet1.Active:=true;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Database1.StartTransaction;
  try
    ClientDataSet1.ApplyUpdates(-1);
  except
    Database1.Rollback;
  end;
  Database1.Commit;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Query1.Active:=false;
  ClientDataSet1.Active:=false;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Query1.Active:=false;
  try
    Query1.SQL.text:=Memo1.Lines.Text;
    Database1.StartTransaction;
    Case RadioGroup1.ItemIndex of
       0 : Query1.Open;
       1 : Query1.ExecSQL;
    end;
  except
    Database1.Rollback;
  end;
  Database1.Commit;
end;

procedure TForm1.Table1AfterInsert(DataSet: TDataSet);
var
 nxnom : longint;
begin
  Query2.Open;
  nxnom:=Query2.FieldByName('Max').AsInteger+1;
  Table1.FieldByName('tip_op').Value:=nxnom;
  Query2.Close;
  Table1.FieldByName('date_izm').Value:=date;
  DBEdit2.SetFocus;
end;

procedure TForm1.Table1AfterEdit(DataSet: TDataSet);
begin
  Table1.FieldByName('date_izm').Value:=date;
  DBEdit2.SetFocus;
end;

procedure TForm1.DBGrid2DblClick(Sender: TObject);
begin
  Table1.Edit;
end;

procedure TForm1.DBEdit2KeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then DBEdit3.SetFocus;
end;

procedure TForm1.DBEdit3KeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then DBEdit4.SetFocus;
end;

procedure TForm1.DBEdit4KeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 Then If (Table1.State = dsEdit) or
     (Table1.State = dsInsert) Then Table1.Post;
end;

procedure TForm1.ClientDataSet1AfterInsert(DataSet: TDataSet);
begin
   ClientDataSet1.FieldByName('date_izm').Value:=date;
end;

procedure TForm1.ClientDataSet1AfterEdit(DataSet: TDataSet);
begin
  ClientDataSet1.FieldByName('date_izm').Value:=date;
end;

end.
