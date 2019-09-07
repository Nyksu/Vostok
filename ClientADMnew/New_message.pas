unit New_message;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, DBClient, Grids, DBGrids, ExtCtrls;

type
  Tfr_New_mes = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    m_text: TMemo;
    Label1: TLabel;
    cds_to: TClientDataSet;
    cds_lst_adm: TClientDataSet;
    bt_exit: TBitBtn;
    bt_add_adress: TBitBtn;
    bt_remove_address: TBitBtn;
    ds_to: TDataSource;
    ds_lst_adm: TDataSource;
    bt_send_msg: TBitBtn;
    procedure bt_exitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bt_add_adressClick(Sender: TObject);
    procedure bt_remove_addressClick(Sender: TObject);
    procedure bt_send_msgClick(Sender: TObject);
  private
    Procedure AddAddress(id_adm : integer);
    { Private declarations }
  public
    { Public declarations }
  end;


Function SendNewMsg(To_adm : integer) : boolean;

var
  rs : boolean;
  fr_New_mes: Tfr_New_mes;

implementation

Uses Post, MainAdm;

{$R *.DFM}

Function SendNewMsg(To_adm : integer) : boolean;
Begin
    rs:=false;
    try
      try
        fr_New_mes:=Tfr_New_mes.Create(Application);
        If To_adm>=0 Then fr_New_mes.AddAddress(To_adm);
        fr_New_mes.ShowModal;
      finally
        Result:=rs;
        fr_New_mes.Free;
      end;
    except
    end;
end;

Procedure Tfr_New_mes.AddAddress(id_adm : integer);
Begin
   If (cds_to.Active and cds_lst_adm.Active)and(id_adm>=0) Then If
     cds_lst_adm.Locate('kod_adm',id_adm,[loPartialKey]) Then Begin
       cds_to.InsertRecord([cds_lst_adm.FieldByName('fio').AsString,id_adm]);
       cds_lst_adm.Delete;
   end;
end;

procedure Tfr_New_mes.bt_exitClick(Sender: TObject);
begin
  fr_New_mes.Close;
end;

procedure Tfr_New_mes.FormCreate(Sender: TObject);
var
  parametry : variant;
  resSQL : integer;
begin
   If not fr_post_list.cds_out_mes.Active Then fr_post_list.cds_out_mes.Active:=true;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=231;
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=0;
   parametry[3]:=VarArrayOf(['']);
   parametry[4]:=VarArrayOf(['']);
   parametry[5]:=2;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL>0 Then Begin
      MessageDlg('Нет прав на эту операцию!', mtWarning, [mbOk], 0);
      Exit;
   end;
   cds_to.Active:=true;
   cds_lst_adm.Active:=true;
end;

procedure Tfr_New_mes.bt_add_adressClick(Sender: TObject);
begin
   If not VarIsNull(cds_lst_adm.FieldByName('kod_adm').Value) Then
                     AddAddress(cds_lst_adm.FieldByName('kod_adm').AsInteger);
end;

procedure Tfr_New_mes.bt_remove_addressClick(Sender: TObject);
begin
  If cds_to.Active and cds_lst_adm.Active Then
     If not VarIsNull(cds_to.FieldByName('kod_adm').Value) Then Begin
       cds_lst_adm.InsertRecord([cds_to.FieldByName('fio').AsString,cds_to.FieldByName('kod_adm').Value]);
       cds_to.Delete;
   end;
end;

procedure Tfr_New_mes.bt_send_msgClick(Sender: TObject);
begin
  If cds_to.RecordCount>0 Then Begin
     If m_text.Lines.text>'' Then Begin
        cds_to.First;
        While not cds_to.EOF Do Begin
          fr_post_list.cds_out_mes.InsertRecord([null,null,
                       cds_to.FieldByName('kod_adm').Value,
                       null,null,m_text.Lines.text,null]);
          cds_to.Next;
        end;
        If fr_post_list.cds_out_mes.ApplyUpdates(-1)=0 Then rs:=true;
        fr_New_mes.Close;
        Exit;
     end
     Else ShowMessage('Нет текста письма!!');
  end
  Else ShowMessage('Выберите получателей!!');
end;

end.
