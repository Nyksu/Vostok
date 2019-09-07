unit Post;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, Db, DBClient, Grids, DBGrids, ExtCtrls, DM, Buttons,
  Read_text_post, Post_out, New_message;

type
  Tfr_post_list = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    cds_in_messages: TClientDataSet;
    cd_in_messages: TDataSource;
    m_first_string: TDBMemo;
    Label1: TLabel;
    bt_exit: TBitBtn;
    bt_read_message: TBitBtn;
    bt_out_leters: TBitBtn;
    bt_new_leters: TBitBtn;
    bt_delete_mes: TBitBtn;
    cds_out_mes: TClientDataSet;
    rg_read_notread: TRadioGroup;
    ds_out_mes: TDataSource;
    lb_count_new_msg: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bt_exitClick(Sender: TObject);
    procedure bt_read_messageClick(Sender: TObject);
    procedure bt_delete_mesClick(Sender: TObject);
    procedure rg_read_notreadClick(Sender: TObject);
    procedure bt_out_letersClick(Sender: TObject);
    procedure bt_new_letersClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    tek_id : integer;
    { Private declarations }
  public
    { Public declarations }
  end;


Procedure StartPost;

var
  fr_post_list: Tfr_post_list;

implementation

{$R *.DFM}

Procedure StartPost;
Begin
   try
     try
       fr_post_list:=Tfr_post_list.Create(Application);
       fr_post_list.ShowModal;
     finally
       fr_post_list.Free;
     end;
   except
   end;
end;

procedure Tfr_post_list.FormCreate(Sender: TObject);
var
 ch_mail : integer;
begin
  cds_out_mes.Active:=true;
  cds_out_mes.Last;
  cds_in_messages.Active:=true;
  cds_in_messages.Last;
  tek_id:=0;
  ch_mail:=DataModuls.SockToVostok.AppServer.CheckNewMessages;
  lb_count_new_msg.Caption:='Новых сообщений: '+IntToStr(ch_mail);
  Timer1.Enabled:=true;
end;

procedure Tfr_post_list.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   cds_in_messages.Active:=false;
   cds_out_mes.Active:=false;
end;

procedure Tfr_post_list.bt_exitClick(Sender: TObject);
begin
   fr_post_list.Close;
end;

procedure Tfr_post_list.bt_read_messageClick(Sender: TObject);
begin
  If cds_in_messages.FieldByName('id').AsInteger>0 Then Begin
    Timer1.Enabled:=false;
    StartReadMsq(DateTimeToStr(cds_in_messages.FieldByName('send_date').AsDateTime),
                cds_in_messages.FieldByName('sender').AsString,
                cds_in_messages.FieldByName('MESSAGE_TEXT').AsString);
    cds_in_messages.Edit;
    cds_in_messages.FieldByName('receive_date').AsDateTime:=now;
    cds_in_messages.Post;
    cds_in_messages.ApplyUpdates(-1);
    Timer1.Enabled:=true;
  end;
end;

procedure Tfr_post_list.bt_delete_mesClick(Sender: TObject);
begin
  If (cds_in_messages.Active)and(cds_in_messages.FieldByName('id').AsInteger>0)
      Then
      If not VarIsNull(cds_in_messages.FieldByName('receive_date').Value) Then Begin
        cds_in_messages.Delete;
        cds_in_messages.ApplyUpdates(-1);
      end;
end;

procedure Tfr_post_list.rg_read_notreadClick(Sender: TObject);
begin
  //cds_in_messages.Active:=false;
  Case rg_read_notread.ItemIndex of
    0 : cds_in_messages.Filter:='';
    1 : cds_in_messages.Filter:='receive_date is not null';
    2 : cds_in_messages.Filter:='receive_date is null';
  end;
  cds_in_messages.Last;
  //cds_in_messages.Active:=true;
end;

procedure Tfr_post_list.bt_out_letersClick(Sender: TObject);
begin
   Timer1.Enabled:=false;
   fr_post_list.Visible:=false;
   StartMesOut;
   fr_post_list.Visible:=true;
   Timer1.Enabled:=true;
end;

procedure Tfr_post_list.bt_new_letersClick(Sender: TObject);
begin
   If cds_in_messages.FieldByName('id').AsInteger>0 Then Begin
      Timer1.Enabled:=false;
      fr_post_list.Visible:=false;
      SendNewMsg(cds_in_messages.FieldByName('from_adm').AsInteger);
      fr_post_list.Visible:=true;
      Timer1.Enabled:=true;
   end;
end;

procedure Tfr_post_list.Timer1Timer(Sender: TObject);
var
  ch_mail : Integer;
begin
   Timer1.Enabled:=false;
   If Timer1.Interval>5000 Then Timer1.Interval:=5000;
   ch_mail:=DataModuls.SockToVostok.AppServer.CheckNewMessages;
   lb_count_new_msg.Caption:='Новых сообщений: '+IntToStr(ch_mail);
   If ch_mail>0 Then Begin
       If cds_in_messages.FieldByName('id').AsInteger>0 Then tek_id:=cds_in_messages.FieldByName('id').AsInteger
       Else tek_id:=-1;
       cds_in_messages.Active:=false;
       cds_in_messages.Active:=true;
       If tek_id>0 Then cds_in_messages.Locate('id',tek_id,[loPartialKey])
       Else Begin
         tek_id:=0;
         cds_in_messages.Last;
       end;
   end;
   Timer1.Enabled:=true;
end;

end.
