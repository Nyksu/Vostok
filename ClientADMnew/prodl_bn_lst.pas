unit prodl_bn_lst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBClient, StdCtrls, Spin, Buttons, ComCtrls, Grids, DBGrids;

type
  Tfr_prod_bn_lst = class(TForm)
    bt_gost: TButton;
    tb_gost: TDBGrid;
    Label2: TLabel;
    ed_date_po: TDateTimePicker;
    ch_pol_sut: TCheckBox;
    bt_prodlenie: TBitBtn;
    bt_cancel: TBitBtn;
    ed_cod_bron: TSpinEdit;
    bt_add: TBitBtn;
    bt_del: TBitBtn;
    Label1: TLabel;
    cds_all_gost: TClientDataSet;
    cds_prodl_gost: TClientDataSet;
    DataSource1: TDataSource;
    tb_gost_p: TDBGrid;
    DataSource2: TDataSource;
    procedure bt_gostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bt_addClick(Sender: TObject);
    procedure bt_delClick(Sender: TObject);
    procedure bt_cancelClick(Sender: TObject);
    procedure tb_gostDblClick(Sender: TObject);
    procedure tb_gost_pDblClick(Sender: TObject);
    procedure bt_prodlenieClick(Sender: TObject);
  private
    date_w : TDate;
    time_w : TTime;
    nomer : integer;
    dat_s : Tdate;
    dat_po : Tdate;
    sutki : real;
    tim_in : string[8];
    //tim_out : string[8];
    //tim_work : string[8];
    mest : integer;
    kvo_talons : integer;
    gost : integer;
    dolg : integer;
    bron : integer;
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Prod_bn_lst;

var
  fr_prod_bn_lst: Tfr_prod_bn_lst;

implementation

uses MainADM;

{$R *.DFM}

Procedure Prod_bn_lst;
Begin
  try
    try
      fr_prod_bn_lst:=Tfr_prod_bn_lst.Create(Application);
      fr_prod_bn_lst.ShowModal;
    finally
      fr_prod_bn_lst.Free;
    end;
  except
  end;
end;

procedure Tfr_prod_bn_lst.bt_gostClick(Sender: TObject);
var
 parametry : variant;
 resSQL,res_op : integer;
begin
  If ed_cod_bron.Value>0 Then Begin
     tb_gost.Enabled:=true;
     tb_gost_p.Enabled:=true;
     cds_all_gost.Active:=false;
     cds_prodl_gost.Active:=false;
     //dat_s:=dat_w;
     //dat_po:=dat_w;
     parametry:=VarArrayCreate([0, 5], varVariant);
     parametry[0]:=199;
     parametry[1]:=fr_ClientAdm.kod_adm;
     parametry[2]:=3;
     parametry[3]:=VarArrayOf([IntToStr(ed_cod_bron.Value),DateToStr(date_w),DateToStr(date_w)]);
     parametry[4]:=VarArrayOf(['bron','dat_po','dat_po']);
     parametry[5]:=5;
     resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
     res_op:=0;
     If resSQL=0 Then Begin
       cds_all_gost.Active:=true;
       cds_prodl_gost.Active:=true;
       res_op:=cds_all_gost.RecordCount;
     end
     Else Begin
       MessageDlg('ќтказ в доступе!', mtWarning, [mbOk], 0);
       Exit;
     end;
     If res_op > 0 Then Begin
       tb_gost.SetFocus;
       bron:=ed_cod_bron.Value;
     end
     Else Begin
       MessageDlg('¬ номере нет гостей с безналичным расчетом или продливать рано!', mtWarning, [mbOk], 0);
       ed_cod_bron.SetFocus;
     end;
  end;
end;

procedure Tfr_prod_bn_lst.FormCreate(Sender: TObject);
begin
  date_w:=date;
  time_w:=time;
end;

procedure Tfr_prod_bn_lst.bt_addClick(Sender: TObject);
begin
  If cds_all_gost.EOF Then Exit;
  cds_prodl_gost.InsertRecord([
    cds_all_gost.FieldByName('kod_gost').Value,
    cds_all_gost.FieldByName('nomer').Value,
    cds_all_gost.FieldByName('date_out').Value,
    cds_all_gost.FieldByName('time_out').Value,
    cds_all_gost.FieldByName('famil').Value,
    cds_all_gost.FieldByName('io').Value,
    cds_all_gost.FieldByName('mests').Value,
    cds_all_gost.FieldByName('dolg').Value]);
  cds_all_gost.Delete;
end;

procedure Tfr_prod_bn_lst.bt_delClick(Sender: TObject);
begin
  If cds_prodl_gost.EOF Then Exit;
  cds_all_gost.InsertRecord([
    cds_prodl_gost.FieldByName('kod_gost').Value,
    cds_prodl_gost.FieldByName('nomer').Value,
    cds_prodl_gost.FieldByName('date_out').Value,
    cds_prodl_gost.FieldByName('time_out').Value,
    cds_prodl_gost.FieldByName('famil').Value,
    cds_prodl_gost.FieldByName('io').Value,
    cds_prodl_gost.FieldByName('mests').Value,
    cds_prodl_gost.FieldByName('dolg').Value]);
  cds_prodl_gost.Delete;
end;

procedure Tfr_prod_bn_lst.bt_cancelClick(Sender: TObject);
begin
  fr_prod_bn_lst.Close;
end;

procedure Tfr_prod_bn_lst.tb_gostDblClick(Sender: TObject);
begin
   bt_addClick(Sender);
end;

procedure Tfr_prod_bn_lst.tb_gost_pDblClick(Sender: TObject);
begin
   bt_delClick(Sender);
end;

procedure Tfr_prod_bn_lst.bt_prodlenieClick(Sender: TObject);
//var
 //lnd : integer;
 //parametry, par, rs : variant;
 //resSQL : integer;
begin
  tb_gost_p.Enabled:=false;
  tb_gost.Enabled:=false;
  cds_prodl_gost.First;
  kvo_talons:=0;   {не забыть умножить на к-во мест}
  If cds_prodl_gost.EOF Then Begin
     MessageDlg('Ќе выбраны гости дл€ продлени€!', mtWarning, [mbOk], 0);
     bt_gostClick(Sender);
     Exit;
  end;
  While not cds_prodl_gost.EOF Do Begin
    dat_s:=cds_prodl_gost.FieldByName('date_out').AsDateTime;
    dolg:=cds_prodl_gost.FieldByName('dolg').AsInteger;
    tim_in:=cds_prodl_gost.FieldByName('time_out').AsString;
    dat_s:=cds_prodl_gost.FieldByName('date_out').AsDateTime;
    dat_po:=StrToDate(DateToStr(ed_date_po.Date));
    //lnd:=cds_prodl_gost.FieldByName('land').AsInteger;
    mest:=cds_prodl_gost.FieldByName('mests').AsInteger;
    nomer:=cds_prodl_gost.FieldByName('nomer').AsInteger;
    gost:=cds_prodl_gost.FieldByName('kod_gost').AsInteger;
    sutki:=0;
    cds_prodl_gost.Next;
  end;
end;

end.
