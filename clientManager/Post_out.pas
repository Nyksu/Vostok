unit Post_out;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ExtCtrls, StdCtrls, DBCtrls, Buttons, Read_text_post, New_message;

type
  Tfr_post_list_out = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    m_first_string: TDBMemo;
    rg_read_notread: TRadioGroup;
    bt_read_message: TBitBtn;
    bt_delete_mes: TBitBtn;
    bt_exit: TBitBtn;
    Label2: TLabel;
    DBText1: TDBText;
    bt_new_leters: TBitBtn;
    procedure rg_read_notreadClick(Sender: TObject);
    procedure bt_exitClick(Sender: TObject);
    procedure bt_delete_mesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bt_read_messageClick(Sender: TObject);
    procedure bt_new_letersClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


Procedure StartMesOut;

var
  fr_post_list_out: Tfr_post_list_out;

implementation

{$R *.DFM}

Uses Post;


Procedure StartMesOut;
Begin
   try
     try
       fr_post_list_out:=Tfr_post_list_out.Create(Application);
       fr_post_list_out.ShowModal;
     finally
       fr_post_list_out.Free;
     end;
   except
   end;
end;

procedure Tfr_post_list_out.rg_read_notreadClick(Sender: TObject);
begin
  Case rg_read_notread.ItemIndex of
    0 : fr_post_list.cds_out_mes.Filter:='';
    1 : fr_post_list.cds_out_mes.Filter:='receive_date is not null';
    2 : fr_post_list.cds_out_mes.Filter:='receive_date is null';
  end;
  fr_post_list.cds_out_mes.Last;
end;

procedure Tfr_post_list_out.bt_exitClick(Sender: TObject);
begin
  fr_post_list_out.Close;
end;

procedure Tfr_post_list_out.bt_delete_mesClick(Sender: TObject);
begin
   If (fr_post_list.cds_out_mes.Active)and(fr_post_list.cds_out_mes.FieldByName('id').AsInteger>0)
      Then
      If VarIsNull(fr_post_list.cds_out_mes.FieldByName('receive_date').Value) Then Begin
        fr_post_list.cds_out_mes.Delete;
        fr_post_list.cds_out_mes.ApplyUpdates(-1);
      end;
end;

procedure Tfr_post_list_out.FormCreate(Sender: TObject);
begin
  If not fr_post_list.cds_out_mes.Active Then Begin
     fr_post_list.cds_out_mes.Active:=true;
  end;
  fr_post_list.cds_out_mes.Last;
end;

procedure Tfr_post_list_out.bt_read_messageClick(Sender: TObject);
begin
  If fr_post_list.cds_out_mes.FieldByName('id').AsInteger>0 Then
  StartReadMsq(DateTimeToStr(fr_post_list.cds_out_mes.FieldByName('send_date').AsDateTime),
                fr_post_list.cds_out_mes.FieldByName('reader').AsString,
                fr_post_list.cds_out_mes.FieldByName('MESSAGE_TEXT').AsString);
end;

procedure Tfr_post_list_out.bt_new_letersClick(Sender: TObject);
begin
  fr_post_list_out.Visible:=false;
  If SendNewMsg(-1) Then Begin
     fr_post_list.cds_out_mes.Active:=false;
     fr_post_list.cds_out_mes.Active:=true;
  end;
  fr_post_list_out.Visible:=true;
end;

end.
