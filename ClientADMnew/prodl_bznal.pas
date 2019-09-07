unit prodl_bznal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, StdCtrls, ComCtrls, DBCtrls, Grids, DBGrids, Spin,
  Ask_dlg, prn_talons;

type
  Tfr_prodl_bn = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    ed_nom_komn: TSpinEdit;
    bt_gost: TButton;
    tb_gost: TDBGrid;
    Label3: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    Label2: TLabel;
    ed_date_po: TDateTimePicker;
    ch_pol_sut: TCheckBox;
    Bevel1: TBevel;
    bt_prodlenie: TBitBtn;
    bt_cancel: TBitBtn;
    procedure bt_gostClick(Sender: TObject);
    procedure bt_prodlenieClick(Sender: TObject);
    procedure bt_cancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    nomer : integer;
    dat_s : Tdate;
    dat_po : Tdate;
    sutki : real;
    tim_in : string[8];
    tim_out : string[8];
    tim_work : string[8];
    s_zvtr : real;
    dat_work : TDate;
    mest : integer;
    kvo_talons : integer;
    gost : integer;
    dolg : integer;
    bron : integer;
    sec_pol : boolean;
    Function gt_free_mest : integer;
    Function gt_fool_mest : integer;
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Prodlen_beznal;

var
  fr_prodl_bn: Tfr_prodl_bn;
  tps_prodlen : integer;

implementation

uses MainADM;

{$R *.DFM}

Procedure Prodlen_beznal;
Begin
  try
    try
      fr_prodl_bn:=Tfr_prodl_bn.Create(Application);
      fr_prodl_bn.ShowModal;
    finally
      fr_prodl_bn.free;
    end;
  except
  end;
end;

Function Tfr_prodl_bn.gt_free_mest : integer;
var
  par, rs : variant;
  ott : integer;
Begin
   par:=VarArrayCreate([0, 2], varVariant);
   par[0]:=3;{получаем к-во свободных мест}
   par[1]:=VarArrayOf([DateToStr(dat_s+1),DateToStr(dat_po),IntToStr(nomer)]);
   par[2]:=VarArrayOf(['dt_s','dt_po','nomer']);
   rs:=fr_ClientAdm.GetTehParam(173,par);
   If not VarIsNull(rs[1]) Then ott:=rs[1] Else ott:=0;
   If dat_s=dat_po Then ott:=mest;
   Result:=ott;
end;

Function Tfr_prodl_bn.gt_fool_mest : integer;
var
  par, rs : variant;
  ott : integer;
Begin
   par:=VarArrayCreate([0, 2], varVariant);
   par[0]:=4;{получаем к-во свободных мест}
   par[1]:=VarArrayOf([DateToStr(dat_s),DateToStr(dat_po),IntToStr(nomer),'1']);
   par[2]:=VarArrayOf(['dt_s','dt_po','nomer','prichin']);
   rs:=fr_ClientAdm.GetTehParam(174,par);
   If not VarIsNull(rs[1]) Then ott:=rs[1] Else ott:=0;
   Result:=ott;
end;

procedure Tfr_prodl_bn.bt_gostClick(Sender: TObject);
var
 parametry : variant;
 resSQL,res_op : integer;
begin
  If ed_nom_komn.text>'' Then Begin
     tb_gost.Enabled:=true;
     fr_ClientAdm.CDS_work.Active:=false;
     nomer:=0;
     dat_s:=date;
     dat_po:=date;
     parametry:=VarArrayCreate([0, 5], varVariant);
     parametry[0]:=196;
     parametry[1]:=fr_ClientAdm.kod_adm;
     parametry[2]:=1;
     parametry[3]:=VarArrayOf([IntToStr(ed_nom_komn.Value)]);
     parametry[4]:=VarArrayOf(['nomer']);
     parametry[5]:=5;
     resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
     res_op:=0;
     If resSQL=0 Then Begin
       fr_ClientAdm.CDS_work.Active:=true;
       res_op:=fr_ClientAdm.CDS_work.RecordCount;
     end
     Else Begin
       MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
       Exit;
     end;
     If res_op > 0 Then Begin
       tb_gost.SetFocus
     end
     Else Begin
       MessageDlg('В номере нет гостей с безналичным расчетом!', mtWarning, [mbOk], 0);
       ed_nom_komn.SetFocus;
     end;
  end;
end;

procedure Tfr_prodl_bn.bt_prodlenieClick(Sender: TObject);
var
 //lnd : integer;
 parametry, par, rs : variant;
 resSQL : integer;
begin
  tb_gost.Enabled:=false;
  kvo_talons:=0;
  dolg:=fr_ClientAdm.CDS_work.FieldByName('dolg').AsInteger;
  tim_in:=fr_ClientAdm.CDS_work.FieldByName('time_out').AsString;
  dat_s:=fr_ClientAdm.CDS_work.FieldByName('date_out').AsDateTime;
  mest:=fr_ClientAdm.CDS_work.FieldByName('mests').AsInteger;
  dat_po:=StrToDate(DateToStr(ed_date_po.Date));
  If dat_s>dat_work Then Begin
     MessageDlg('Этому гостю рано продлевать номер!', mtWarning, [mbOk], 0);
     bt_gostClick(Sender);
     Exit;
  end;
  sutki:=0;
  sec_pol:=tim_in>'12:00:00';
  If sec_pol Then sutki:=-0.5
   Else If dat_s=dat_po Then sutki:=0.5;
  If ((sutki<0) and (dat_s=dat_po))or(dat_s>dat_po) Then
  Begin
     MessageDlg('Не правильная дата продления!', mtWarning, [mbOk], 0);
     bt_gostClick(Sender);
     Exit;
  end;
  nomer:=fr_ClientAdm.CDS_work.FieldByName('nomer').AsInteger;
  If sutki=0.5 Then Begin
    s_zvtr:=0;
   // tim_out:='18:00:00';
  end
  Else
  Begin
    sutki:=sutki+Round(dat_po-dat_s);
    //tim_out:='12:00:00';
    If (tim_work >= '18:00:00')and(dat_po=dat_work) Then sutki:=sutki+0.5;
    If ch_pol_sut.Checked Then Begin
      sutki:=sutki+0.5;
     // tim_out:='18:00:00';
    end;
    If sec_pol Then kvo_talons:=Round(sutki)*mest
    Else kvo_talons:=Trunc(sutki)*mest;
    par:=VarArrayCreate([0, 2], varVariant);
    par[0]:=1;{получаем сумму завтраков}
    par[1]:=VarArrayOf(['1']);
    par[2]:=VarArrayOf([4]);
    rs:=fr_ClientAdm.GetTehParam(147,par);
    If not VarIsNull(rs[1]) Then s_zvtr:=rs[1] Else s_zvtr:=0;
    par[0]:=1;{получаем наличие завтрака}
    par[1]:=VarArrayOf([IntToStr(nomer)]);
    par[2]:=VarArrayOf(['nomer']);
    rs:=fr_ClientAdm.GetTehParam(177,par);
    If not VarIsNull(rs[1]) Then s_zvtr:=0;
  end;
  
  If Round(sutki)<>sutki Then
     If tim_in='12:00:00' Then tim_out:='18:00:00'
     Else tim_out:='12:00:00'
  Else tim_out:=tim_in;

  //lnd:=fr_ClientAdm.CDS_work.FieldByName('land').AsInteger;
  gost:=fr_ClientAdm.CDS_work.FieldByName('kod_gost').AsInteger;
  bron:=fr_ClientAdm.CDS_work.FieldByName('cod_bron').AsInteger;
  parametry:=VarArrayCreate([0, 5], varVariant);
  fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
  If dolg>0 Then Begin
       fr_ClientAdm.MIDASConnection1.AppServer.ChangeZMN(dat_s+1,dat_work,8,-mest,nomer);
       dolg:=Round(dat_work-dat_s);
       parametry[0]:=195;  {Изменение к-ва долга}
       parametry[1]:=fr_ClientAdm.kod_adm;
       parametry[2]:=3;
       parametry[3]:=VarArrayOf(['0',IntToStr(nomer),IntToStr(gost)]);
       parametry[4]:=VarArrayOf(['dolg','nomer','gost']);
       parametry[5]:=0;
       resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
       If resSQL<0 Then Begin
         MessageDlg('Ошибка долга гостя! Попробуйте снова.', mtWarning, [mbOk], 0);
         fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
         Exit;
       end;
  end;

  If mest>gt_free_mest Then Begin
     parametry[0]:=184;
     parametry[1]:=fr_ClientAdm.kod_adm;
     parametry[2]:=3;
     parametry[3]:=VarArrayOf([IntToStr(nomer),DateToStr(dat_s),
                               DateToStr(dat_po)]);
     parametry[4]:=VarArrayOf(['nomer','dat_s','dat_po']);
     parametry[5]:=0;
     resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
     If resSQL<>0 Then Begin
       fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
       MessageDlg('Нет прав на операцию! Или ошибка освобождения мест. Попробуйте еще раз !', mtWarning, [mbOk], 0);
       Exit;
     end;
     parametry[0]:=171;
     resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
     If resSQL<>0 Then Begin
       fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
       MessageDlg('Нет прав на операцию! Или ошибка освобождения мест. Попробуйте еще раз !', mtWarning, [mbOk], 0);
       Exit;
     end;

     If mest>gt_free_mest Then
        fr_ClientAdm.MIDASConnection1.AppServer.MoveBron(dat_s, dat_po, nomer);

     If mest>gt_free_mest Then Begin
        fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
        MessageDlg('Нет возможности продлить на данный период!', mtWarning, [mbOk], 0);
        Exit;
     end;
   end;
   parametry[0]:=170;   {изменяем таблицу миграции гостя}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=5;
   parametry[3]:=VarArrayOf([DateToStr(dat_po),tim_out,IntToStr(gost),'0',
                                                      IntToStr(nomer)]);
   parametry[4]:=VarArrayOf(['d_out','tm_out','gost','stat','nomer']);
   parametry[5]:=0;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Begin
     MessageDlg('Ошибка миграции гостя! Попробуйте снова.', mtWarning, [mbOk], 0);
     fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
     Exit;
   end;
   {изменение к-ва занятых мест в номерах}
   If dat_s<dat_po Then fr_ClientAdm.MIDASConnection1.AppServer.ChangeZMN(dat_s+1,dat_po,1,mest,nomer);

   fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
   If s_zvtr>0 then Begin
     parametry[0]:=190;
     parametry[1]:=fr_ClientAdm.kod_adm;
     parametry[2]:=2;
     parametry[3]:=VarArrayOf([IntToStr(kvo_talons),IntToStr(fr_ClientAdm.kod_smen)]);
     parametry[4]:=VarArrayOf(['talons','smena']);
     parametry[5]:=0;
     If fr_ClientAdm.MIDASConnection1.AppServer.Get_State_DB=0 Then
                             fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
     resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
     If (resSQL<>0)and(fr_ClientAdm.MIDASConnection1.AppServer.Get_State_DB=1)
        Then fr_ClientAdm.MIDASConnection1.AppServer.BackTrans
     Else Begin
      If fr_ClientAdm.MIDASConnection1.AppServer.Get_State_DB=1 Then
                             fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
      MessageDlg('Вставте бланк для '+IntToStr(kvo_talons)+
                       ' талонов! Нажмите <Ок>', mtConfirmation, [mbOk], 0);
      Print_talons(kvo_talons, 'БЕЗНАЛ','Заявка № '+IntToStr(bron));
     end;
   end;
   MessageDlg('Проживание гося продлено!', mtInformation, [mbOk], 0);
   fr_prodl_bn.Close;
end;

procedure Tfr_prodl_bn.bt_cancelClick(Sender: TObject);
begin
  fr_prodl_bn.Close;
end;

procedure Tfr_prodl_bn.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  fr_ClientAdm.CDS_work.Active:=false;
end;

procedure Tfr_prodl_bn.FormActivate(Sender: TObject);
begin
  ed_date_po.Date:=date;
  tim_work:=TimeToStr(time);
  If Length(tim_work)<8 Then tim_work:='0'+tim_work;
  dat_work:=date;
  If ed_date_po.Date < dat_work Then Begin
     tim_work:='0'+TimeToStr(time);
     ed_date_po.Date:=date;
  end;
end;

end.
