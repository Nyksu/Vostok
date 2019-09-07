unit vozvr_nal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, Buttons, Grids, DBGrids, DBCtrls, Spin,
  Mask, Ask_dlg, prn_nal_schet, DB, prn_rash_order;

type
  Tfr_vozvr_nal_singl = class(TForm)
    pnl_top: TPanel;
    Bevel1: TBevel;
    bt_vozvrat: TBitBtn;
    bt_cancel: TBitBtn;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    tb_gost: TDBGrid;
    bt_gost: TButton;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    bt_period: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    lb_dt_s: TLabel;
    lb_dt_po: TLabel;
    GroupBox1: TGroupBox;
    ch_talons: TCheckBox;
    ch_neustoika: TCheckBox;
    ed_talons: TSpinEdit;
    ed_nom_komn: TSpinEdit;
    ed_kv_mest: TSpinEdit;
    procedure FormActivate(Sender: TObject);
    procedure bt_cancelClick(Sender: TObject);
    procedure ed_nom_komnKeyPress(Sender: TObject; var Key: Char);
    procedure bt_gostClick(Sender: TObject);
    procedure bt_periodClick(Sender: TObject);
    procedure ch_talonsClick(Sender: TObject);
    procedure tb_gostDblClick(Sender: TObject);
    procedure tb_gostKeyPress(Sender: TObject; var Key: Char);
    procedure bt_vozvratClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ch_neustoikaClick(Sender: TObject);
  private
    time_work : TTime;
    nomer : integer;
    schet : integer;
    seria : string[2];
    schet_new : integer;
    seria_new : string[2];
    gost : integer;
    sutok : real;
    sut_vozv : real;
    dt_in : TDate;
    dat_s : TDate;
    dat_po : TDate;
    mest : integer;
    sm_bron : real;
    sm_prst : real;
    fam : string;
    io : string;
    tm_in : string[8];
    s_mest : string;

    { Private declarations }
  public
    { Public declarations }
  end;

Function Do_rebay(tip, nom, gost : integer) : variant;

var
  fr_vozvr_nal_singl: Tfr_vozvr_nal_singl;
  in_nom : integer;
  in_gost : integer;
  res_voz : variant;
  tips : integer;
  un_loop : boolean;

implementation

{$R *.DFM}

Uses MainADM;

Function Do_rebay(tip, nom, gost : integer) : variant;
Begin
  un_loop:=false;
  res_voz:=VarArrayCreate([0, 5], varVariant);
  res_voz[0]:='';
  res_voz[1]:=0;
  in_nom:=nom;
  in_gost:=gost;
  tips:=tip;
  Try
    Try
      fr_vozvr_nal_singl:=Tfr_vozvr_nal_singl.Create(Application);
      fr_vozvr_nal_singl.ShowModal;
    finally
      Result:=res_voz;
      fr_vozvr_nal_singl.Free;
    end;
  except
  end;
end;


procedure Tfr_vozvr_nal_singl.FormActivate(Sender: TObject);
begin
  If un_loop Then Begin
    //fr_vozvr_nal_singl.Close;
    Exit;
  end;
  fr_ClientAdm.CDS_sp1.Active:=false;
  time_work:=time;
  res_voz[0]:=TimeToStr(time_work);
  If Length(res_voz[0]) < 8 Then res_voz[0]:='0'+res_voz[0];
  StatusBar1.Panels[1].Text:='Время операции: '+res_voz[0];
  If res_voz[0]<'18:00:00' Then sut_vozv:=0;
  Case tips of
    0 : Begin {неперавильно оформлен гость}
          pnl_top.Caption:='Полный возврат';
          StatusBar1.Panels[0].Text := 'Переоформление гостя';
          ch_talons.Enabled:=false;
          ch_neustoika.Enabled:=false;
        end;
    1 : Begin {возврат при досрочном выезде}
          un_loop:=true;
          pnl_top.Caption:='Частичный возврат';
          StatusBar1.Panels[0].Text := 'Досрочный выезд гостя';
          ch_talons.Enabled:=true;
          ch_neustoika.Enabled:=true;
          ed_kv_mest.Visible:=true;
          ed_nom_komn.Value:=in_nom;
          If in_nom>0 Then bt_gostClick(Sender);
          If bt_period.Enabled=true Then Begin
             fr_ClientAdm.CDS_sp1.AddIndex('i1','kod_gost',[ixCaseInsensitive],'','',0);
             fr_ClientAdm.CDS_sp1.IndexName:='i1';
             If fr_ClientAdm.CDS_sp1.FindKey([in_gost])
                                       Then bt_periodClick(Sender);
             fr_ClientAdm.CDS_sp1.DeleteIndex('i1');
             bt_gost.Enabled:=false;
             bt_period.Enabled:=false;
             ed_nom_komn.Enabled:=false;
          end;
          Exit;
        end;
    2 : Begin {перевод в другой номер}
          un_loop:=true;
          pnl_top.Caption:='Частичный возврат';
          StatusBar1.Panels[0].Text := 'Перевод гостя';
          ed_nom_komn.Value:=in_nom;
          If in_nom>0 Then bt_gostClick(Sender);

          If bt_period.Enabled=true Then Begin
             fr_ClientAdm.CDS_sp1.AddIndex('i1','kod_gost',[ixCaseInsensitive],'','',0);
             fr_ClientAdm.CDS_sp1.IndexName:='i1';
             If fr_ClientAdm.CDS_sp1.FindKey([in_gost])
                                       Then bt_periodClick(Sender);
             fr_ClientAdm.CDS_sp1.DeleteIndex('i1');
             If bt_vozvrat.Enabled Then Begin
                bt_vozvratClick(Sender);
                bt_cancel.SetFocus;
                bt_cancel.Caption:='Продолжить !!';
                bt_vozvrat.Enabled:=false;
                bt_gost.Enabled:=false;
                bt_period.Enabled:=false;
                ed_nom_komn.Enabled:=false;
             end;
          end;
          Exit;
        end;
  end;
  ed_nom_komn.SetFocus;
end;

procedure Tfr_vozvr_nal_singl.bt_cancelClick(Sender: TObject);
begin
  fr_vozvr_nal_singl.Close;
end;

procedure Tfr_vozvr_nal_singl.ed_nom_komnKeyPress(Sender: TObject;
  var Key: Char);
begin
  If Key = #13 Then bt_gostClick(Sender);
end;

procedure Tfr_vozvr_nal_singl.bt_gostClick(Sender: TObject);
var
 parametry : variant;
 resSQL,res_op : integer;
begin
  If ed_nom_komn.text>'' Then Begin
     If res_voz[0]<'18:00:00' Then sut_vozv:=0;
     If res_voz[0]>='18:00:00' Then sut_vozv:=-0.5;
     If tips=0 Then sut_vozv:=0;
     tb_gost.Enabled:=true;
     bt_vozvrat.Enabled:=false;
     StatusBar1.Panels[2].Text:='Счет не определен';
     nomer:=0;
     dat_s:=date;
     dat_po:=date;
     fr_ClientAdm.CDS_sp1.Active:=false;
     parametry:=VarArrayCreate([0, 5], varVariant);
     parametry[0]:=157;
     parametry[1]:=fr_ClientAdm.kod_adm;
     parametry[2]:=1;
     parametry[3]:=VarArrayOf([IntToStr(ed_nom_komn.Value)]);
     parametry[4]:=VarArrayOf([5]);
     parametry[5]:=2;
     resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
     res_op:=0;
     If resSQL=0 Then Begin
       fr_ClientAdm.CDS_sp1.Active:=true;
       res_op:=fr_ClientAdm.CDS_sp1.RecordCount;
     end
     Else Begin
       MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
       Exit;
     end;
     If res_op > 0 Then Begin
       bt_period.Enabled:=true;
       tb_gost.SetFocus
     end
     Else Begin
       MessageDlg('В номере нет проживающих гостей!', mtWarning, [mbOk], 0);
       ed_nom_komn.SetFocus;
     end;
  end;
end;

procedure Tfr_vozvr_nal_singl.bt_periodClick(Sender: TObject);
var
  ss : string;
  rs,par : variant;
begin
  tb_gost.Enabled:=false;
  bt_period.Enabled:=false;
  nomer:=fr_ClientAdm.CDS_sp1.FieldByName('nomer').AsInteger;
  dat_po:=fr_ClientAdm.CDS_sp1.FieldByName('date_out').AsDateTime;
  fam:=fr_ClientAdm.CDS_sp1.FieldByName('famil').AsString;
  io:=fr_ClientAdm.CDS_sp1.FieldByName('io').AsString;
  lb_dt_po.Caption:=DateToStr(dat_po);
  dat_s:=date;
  dt_in:=fr_ClientAdm.CDS_sp1.FieldByName('date_in').AsDateTime;
  tm_in:=fr_ClientAdm.CDS_sp1.FieldByName('time_in').AsString;
  s_mest:=IntToStr(fr_ClientAdm.CDS_sp1.FieldByName('mests').AsInteger);
  mest:=fr_ClientAdm.CDS_sp1.FieldByName('mests').AsInteger;
  ed_kv_mest.MaxValue:=mest;
  ed_kv_mest.Value:=mest;
  If tips=0 Then dat_s:=dt_in;
  lb_dt_s.Caption:=DateToStr(dat_s);
  lb_dt_po.Caption:=DateToStr(dat_po);
  bt_vozvrat.Enabled:=true;
  sut_vozv:=sut_vozv+dat_po-dat_s;
  schet:=fr_ClientAdm.CDS_sp1.FieldByName('schet').AsInteger;
  seria:=fr_ClientAdm.CDS_sp1.FieldByName('seria').AsString;
  Case seria[1] of
      'A' : seria_new:='L'+seria[2];
      'B' : seria_new:='M'+seria[2];
  Else Begin
     MessageDlg('Не тот тип счета! Возврат по этому счету в другом разделе!', mtWarning, [mbOk], 0);
     Case seria[1] of
      'C' : MessageDlg('C - серия', mtWarning, [mbOk], 0);
      'D' : MessageDlg('D - серия', mtWarning, [mbOk], 0);
     end;
     bt_gostClick(Sender);
   end;
  End;
  gost:=fr_ClientAdm.CDS_sp1.FieldByName('kod_gost').AsInteger;
  sutok:=dat_po-dt_in;
  ss:='12:00:00';
  sm_bron:=0;
  sm_prst:=0;
  par:=VarArrayCreate([0, 2], varVariant);
  par[0]:=2;{получаем сумму брони}
  par[1]:=VarArrayOf([IntToStr(schet),'4']);
  par[2]:=VarArrayOf([4,6]);
  rs:=fr_ClientAdm.GetTehParam(161,par);
  If not VarIsNull(rs[1]) Then sm_bron:=rs[1];
  par[0]:=2;{получаем сумму простоя}
  par[1]:=VarArrayOf([IntToStr(schet),'3']);
  par[2]:=VarArrayOf([4,6]);
  rs:=fr_ClientAdm.GetTehParam(161,par);
  If not VarIsNull(rs[1]) Then sm_prst:=rs[1];
  If fr_ClientAdm.CDS_sp1.FieldByName('time_out').AsString>ss Then
  sutok:=sutok+0.5;
  StatusBar1.Panels[2].Text:='Счет № '+IntToStr(schet)+' '+seria;
  If ch_talons.Enabled Then ch_talons.SetFocus Else
     If ch_neustoika.Enabled Then ch_neustoika.SetFocus Else
        bt_vozvrat.SetFocus;
end;

procedure Tfr_vozvr_nal_singl.ch_talonsClick(Sender: TObject);
begin
   If ch_talons.Checked Then ed_talons.Enabled:=true
   Else ed_talons.Enabled:=false;
end;

procedure Tfr_vozvr_nal_singl.tb_gostDblClick(Sender: TObject);
begin
  If bt_period.Enabled Then bt_periodClick(Sender);
end;

procedure Tfr_vozvr_nal_singl.tb_gostKeyPress(Sender: TObject;
  var Key: Char);
begin
  If Key = #13 Then If bt_period.Enabled Then bt_periodClick(Sender);
end;

procedure Tfr_vozvr_nal_singl.bt_vozvratClick(Sender: TObject);
var
 sut_new, sm_sut, sum_voz, sum_neust, sum_zvtr, result_sum : real;
 sm_lgot_new, ful_sm_v, rel_vozvrat : real;
 par, rs, parametry, v_schet, sch_pr : variant;
 resSQL, ii, ch_tal : integer;
 stsql : string;
 lst, lst1 : TStringList;
 tm_out : string[8];
begin
  If not Get_Answer('Внимание !!!','Вы действительно хотите сделать возврат по счету?',false) Then Begin
     bt_cancel.SetFocus;
     Exit;
  end;
  par:=VarArrayCreate([0, 2], varVariant);
  If tips=0 Then Begin
     par[0]:=1;{получаем сумму льгот}
     par[1]:=VarArrayOf([IntToStr(schet)]);
     par[2]:=VarArrayOf(['scht']);
     rs:=fr_ClientAdm.GetTehParam(266,par);
     If not VarIsNull(rs[1]) Then Begin
        ii:=rs[1];
        If ii>0 Then Exit;
     end;
  end;
  v_schet:=VarArrayCreate([0, 8], varVariant);
  {Определяем сумму возврата}
  If time_work > StrToTime('18:00:00') Then tm_out:='18:00:00'
       Else tm_out:='12:00:00';
  sut_new:=0;
  sm_lgot_new:=0;
  If tips>0 Then sut_new:=sutok-sut_vozv;
  sm_sut:=fr_ClientAdm.CDS_sp1.FieldByName('sum_sut').AsFloat;
  ful_sm_v:=fr_ClientAdm.CDS_sp1.FieldByName('summa').AsFloat;
  sum_voz:=sut_vozv*sm_sut;
  par[0]:=1;{получаем сумму льгот}
  par[1]:=VarArrayOf([IntToStr(schet)]);
  par[2]:=VarArrayOf([4]);
  rs:=fr_ClientAdm.GetTehParam(161,par);
  If not VarIsNull(rs[1]) Then Begin
    sum_voz:=sum_voz-rs[1]*sut_vozv/sutok;
    sm_lgot_new:=Round(100*sut_new*rs[1]/sutok)/100;
  end;
  parametry:=VarArrayCreate([0, 5], varVariant);
  sum_zvtr:=0;
  ch_tal:=Trunc(sut_vozv)*mest;
  If ch_neustoika.Checked Then ch_tal:=Trunc(sut_vozv)*ed_kv_mest.Value;
  If (ch_talons.Checked)and(ed_talons.Value<ch_tal) Then sum_zvtr:=
     fr_ClientAdm.CDS_sp1.FieldByName('sum_zvtrk').AsFloat/mest*(ch_tal-ed_talons.Value);
  fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
  parametry[0]:=191;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=2;
  parametry[4]:=VarArrayOf(['talons','smena']);
  parametry[5]:=0;
  If sum_zvtr<0 Then sum_zvtr:=0;
  If ch_talons.Checked Then
     parametry[3]:=VarArrayOf([IntToStr(ed_talons.Value),IntToStr(fr_ClientAdm.kod_smen)])
  Else
     parametry[3]:=VarArrayOf([IntToStr(ch_tal),IntToStr(fr_ClientAdm.kod_smen)]);
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL<>0 Then Begin
    MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
    fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
    Exit;
  end;
  sum_voz:=Round(sum_voz*100)/100;
  par[0]:=1;{получаем процент неустойки}
  par[1]:=VarArrayOf(['3']);
  par[2]:=VarArrayOf([4]);
  rs:=fr_ClientAdm.GetTehParam(147,par);
  If ch_neustoika.Checked Then
                      sum_neust:=Round(sum_voz/mest*ed_kv_mest.Value*rs[1])/100
  Else sum_neust:=0;
  {заполняем журнал возвратов}
  stsql:=IntToStr(schet)+','+FloatToStr(ful_sm_v)+','+IntToStr(tips)+','
  +#39+DateToStr(dat_s)+#39+','+#39+DateToStr(dat_po)+#39+','+FloatToStr(sum_neust)
  +','+FloatToStr(sum_zvtr)+','+IntToStr(fr_ClientAdm.kod_smen)+','+#39+seria+#39+
  ','+FloatToStr(sutok);
  parametry[0]:=162;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=1;
  parametry[3]:=VarArrayOf([stsql]);
  parametry[4]:=VarArrayOf([3]);
  parametry[5]:=0;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL<>0 Then Begin
    MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
    fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
    Exit;
  end;

  {Освобождаем места}
  fr_ClientAdm.MIDASConnection1.AppServer.ChangeZMN(dat_s,dat_po,1,-Mest,ed_nom_komn.Value);


  {изменяем таблицу миграции гостя}
  parametry[0]:=170;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=5;
  parametry[3]:=VarArrayOf([DateToStr(dat_s),TimeToStr(time_work),IntToStr(gost),'1',
                                                    IntToStr(ed_nom_komn.Value)]);
  parametry[4]:=VarArrayOf(['d_out','tm_out','gost','stat','nomer']);
  parametry[5]:=0;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL<0 Then Begin
     MessageDlg('Ошибка миграции гостя! Попробуйте снова.', mtWarning, [mbOk], 0);
     fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
     Exit;
  end;
  {вносим изменения в старый счет}
  result_sum:=sum_voz-sum_zvtr-sum_neust;
  parametry[0]:=163;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=2;
  parametry[3]:=VarArrayOf([FloatToStr(result_sum),IntToStr(schet)]);
  parametry[4]:=VarArrayOf([2,5]);
  parametry[5]:=0;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL<0 Then Begin
     MessageDlg('Ошибка возврата! Попробуйте снова.', mtWarning, [mbOk], 0);
     fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
     Exit;
  end;
  parametry[0]:=165; {Изменение состояния счета}
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=2;{сост. счета: 0-открыт,1-закрыт,2-возврат,3-удален}
  parametry[3]:=VarArrayOf(['2',IntToStr(schet)]);
  parametry[4]:=VarArrayOf([2,5]);
  parametry[5]:=0;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL<0 Then Begin
     MessageDlg('Ошибка возврата! Попробуйте снова.', mtWarning, [mbOk], 0);
     fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
     Exit;
  end;
  rel_vozvrat:=ful_sm_v;
  If tips > 0 Then Begin
  {Оформляем новый счет за прожитый период}
     v_schet[0]:=8;
     v_schet[1]:=VarArrayOf(['Стоимость проживания 1 суток :',sm_sut]);
     v_schet[2]:=VarArrayOf(['Итого проживание в номере :',sm_sut*sut_new,1]);
     v_schet[3]:=VarArrayOf(['Льгота :',sm_lgot_new,2]);
     v_schet[4]:=VarArrayOf(['Простой :',sm_prst,3]);
     v_schet[5]:=VarArrayOf(['Бронь :',sm_bron,4]);
     v_schet[6]:=VarArrayOf(['Завтрак на 1 сут. :',fr_ClientAdm.CDS_sp1.FieldByName('sum_zvtrk').AsFloat]);
     v_schet[7]:=VarArrayOf(['ИТОГО к оплате :',sm_sut*sut_new-sm_lgot_new+sum_neust+sum_zvtr+sm_bron+sm_prst]);
     v_schet[8]:=VarArrayOf(['Удержания за досрочный выезд :',sum_neust+sum_zvtr,5]);
     If v_schet[7][1] > 0 Then Begin
       stsql:=#39+DateToStr(date)+#39+','+IntToStr(gost)+',0,'+FloatToStr(v_schet[7][1])+
              ',null,1,'+#39+seria_new+#39+','+IntToStr(ed_nom_komn.Value);
       par[0]:=1;
       par[1]:=VarArrayOf([stsql]);
       par[2]:=VarArrayOf([3]);
       rs:=fr_ClientAdm.GetTehParam(1001,par);
       If VarIsNull(rs[1]) Then Begin
          MessageDlg('Ошибка возврата! Попробуйте снова.', mtWarning, [mbOk], 0);
          fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
          Exit;
       end;
       rel_vozvrat:=rel_vozvrat-(sm_sut*sut_new-sm_lgot_new+sum_neust+sum_zvtr+sm_bron+sm_prst);
       schet_new:=rs[1];
       {Платежи по счету}
        ii:=2;
        lst1:=TStringList.Create;
        lst1.Add('Ф.И.О.  '+fam+' '+io);
        lst1.Add('');
        lst1.Add(v_schet[1][0]+' '+FloatToStr(v_schet[1][1])+' руб.');
        lst1.Add('Срок проживания : '+FloatToStr(sut_new)+' сут.');
        lst1.Add('--------------------------------------------');
        While ii < 6 Do Begin
          stsql:=IntToStr(schet_new)+','+#39+v_schet[ii][0]+#39+','
           +FloatToStr(v_schet[ii][1])+','+IntToStr(v_schet[ii][2]);
          lst1.Add(v_schet[ii][0]+' '+FloatToStr(v_schet[ii][1])+' руб.');
          If v_schet[ii][1]>0 Then Begin
             parametry[0]:=149; {занесение наличных платежей}
             parametry[1]:=fr_ClientAdm.kod_adm;
             parametry[2]:=1;
             parametry[3]:=VarArrayOf([stsql]);
             parametry[4]:=VarArrayOf([3]);
             parametry[5]:=0;
             resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
             If resSQL <> 0 Then Begin
                fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
                Screen.Cursor:=crDefault;
                MessageDlg('Ошибка! Попробуйте еще раз!', mtWarning, [mbOk], 0);
                lst1.Free;
                Exit;
             end;
          end;
          Inc(ii);
        end;
        stsql:=IntToStr(schet_new)+','+#39+v_schet[8][0]+#39+','
           +FloatToStr(v_schet[8][1])+','+IntToStr(v_schet[8][2]);
        If v_schet[8][1]>0 Then Begin
             lst1.Add(v_schet[8][0]+' '+FloatToStr(v_schet[8][1])+' руб.');
             parametry[0]:=149; {занесение наличных платежей}
             parametry[1]:=fr_ClientAdm.kod_adm;
             parametry[2]:=1;
             parametry[3]:=VarArrayOf([stsql]);
             parametry[4]:=VarArrayOf([3]);
             parametry[5]:=0;
             resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
             If resSQL <> 0 Then Begin
                fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
                Screen.Cursor:=crDefault;
                MessageDlg('Ошибка! Попробуйте еще раз!', mtWarning, [mbOk], 0);
                lst1.Free;
                Exit;
             end;
        end;
       {Новые константы счета}
       parametry[0]:=155;  {заполнение констант счета}
       parametry[1]:=fr_ClientAdm.kod_adm;
       parametry[2]:=1;
       stsql:=IntToStr(schet_new)+','+FloatToStr(sut_new)+','+FloatToStr(v_schet[1][1])+
        ','+FloatToStr(v_schet[6][1])+',0,'+IntToStr(fr_ClientAdm.kod_smen);
       stsql:=stsql+',0,'+#39+DateToStr(dt_in)+#39+',';
       stsql:=stsql+#39+tm_in+#39+','+#39+tm_out+#39;
       parametry[3]:=VarArrayOf([stsql]);
       parametry[4]:=VarArrayOf([2]);
       parametry[5]:=0;
       resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
       If resSQL <>0 Then Begin
          fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
          Screen.Cursor:=crDefault;
          MessageDlg('Отказ в доступе или ошибка открытия сета!', mtWarning, [mbOk], 0);
          lst1.Free;
          Exit;
       end;
       {Печать счета}
       lst:=TStringList.Create;
       sch_pr:=VarArrayCreate([0, 5], varVariant);
       sch_pr[0]:=IntToStr(schet_new);
       sch_pr[1]:=v_schet[7][1];
       lst.Add('Дата заезда: '+DateToStr(dt_in)+'г.');
       lst.Add('№ '+IntToStr(nomer)+'; мест: '+s_mest);
       sch_pr[2]:=lst.Text;
       lst.Clear;
       lst.Add('Время заезда: '+tm_in);
       lst.Add('Выезд: '+DateToStr(date)+'г.');
       lst.Add('ОПЛАТА');
       sch_pr[3]:=lst.Text;
       lst1.Add('--------------------------------------------');
       lst1.Add(v_schet[7][0]+' '+FloatToStr(v_schet[7][1])+' руб.');
       sch_pr[4]:=lst1.Text;
       lst.free;
       lst1.Free;
       sch_pr[5]:=seria_new;
       If fr_ClientAdm.settings[1][0]=0 Then Begin
       {Помечаем места как "грязные"}
         fr_ClientAdm.MIDASConnection1.AppServer.ChangeZMN(date,date,4,Mest,Nomer);
       end;
       MessageDlg('Вставте бланк для печати счета! Нажмите <Ок>', mtConfirmation, [mbOk], 0);
       Prn_schet_nal(sch_pr);
       If (fr_ClientAdm.settings[9][0] = 1) and (not VarIsNull(fr_ClientAdm.DrvFR)) Then Begin
          If not fr_ClientAdm.PrintChekFRK(v_schet[7][1]) Then
          MessageDlg('ВНИМАНИЕ!! Чек не напечатан!', mtError,[mbOk], 0);
       end;
     end;
  end;
  Screen.Cursor:=crDefault;
  res_voz[1]:=rel_vozvrat;
  If fr_ClientAdm.settings[3][0]=0 Then Begin
    MessageDlg('Вставте бланк для печати ордера! Нажмите <Ок>', mtConfirmation, [mbOk], 0);
    parametry[0]:=schet;{kod vosvrata}
    parametry[1]:=seria;{seria vozvrata}
    parametry[2]:=ful_sm_v;{Summa}
    parametry[3]:=fam+' '+io;{FIO}
    parametry[4]:=IntToStr(nomer);{номер}
    parametry[5]:=FloatToStr(sutok);{к-во суток}
    Prn_order(parametry);
  end;
  If tips < 2 Then Begin
    fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
    fr_vozvr_nal_singl.Close;
  end;
end;

procedure Tfr_vozvr_nal_singl.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  fr_ClientAdm.CDS_sp1.Active:=False;
end;

procedure Tfr_vozvr_nal_singl.ch_neustoikaClick(Sender: TObject);
begin
  If ch_neustoika.Enabled Then
     ed_kv_mest.Visible:=ch_neustoika.Checked;
end;

end.
