unit prodl_nal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, Buttons, Grids, DBGrids, StdCtrls, Spin, DBCtrls, Ask_dlg;

type
  Tfr_prodlenie = class(TForm)
    StatusBar1: TStatusBar;
    Label1: TLabel;
    ed_nom_komn: TSpinEdit;
    bt_gost: TButton;
    tb_gost: TDBGrid;
    bt_prodlenie: TBitBtn;
    bt_cancel: TBitBtn;
    Panel1: TPanel;
    Bevel1: TBevel;
    ed_date_po: TDateTimePicker;
    Label2: TLabel;
    bt_calc_schet: TBitBtn;
    ed_fix_sum: TSpinEdit;
    lb_fix: TLabel;
    Label11: TLabel;
    lb_sutok: TLabel;
    Label10: TLabel;
    lb_sum_sutki: TLabel;
    lb_lgot_label: TLabel;
    lb_sum_lgot: TLabel;
    Label12: TLabel;
    lb_summa: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    Label3: TLabel;
    ch_pol_sut: TCheckBox;
    procedure bt_cancelClick(Sender: TObject);
    procedure bt_gostClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure bt_calc_schetClick(Sender: TObject);
    procedure bt_prodlenieClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tb_gostDblClick(Sender: TObject);
    procedure tb_gostKeyPress(Sender: TObject; var Key: Char);
  private
    nomer : integer;
    dat_s : Tdate;
    dat_po : Tdate;
    fix : integer;
    nom_schet : integer;
    seria : string[2];
    v_schet : variant;
    sutki : real;
    tim_in : string[8];
    tim_out : string[8];
    tim_work : string[8];
    s_zvtr : real;
    dat_work : TDate;
    mest : integer;
    kvo_talons : integer;
    gost : integer;
    fam : string;
    io : string;
    dolg : integer;
    sec_pol : boolean;
    Function gt_free_mest : integer;
    Function gt_fool_mest : integer;
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Prodlen_nal(tip:integer);

var
  fr_prodlenie: Tfr_prodlenie;
  tps_prodlen : integer;

implementation

Uses MainADM,prn_nal_schet,prn_talons;

{$R *.DFM}

Procedure Prodlen_nal(tip:integer);
Begin
  try
    try
      tps_prodlen:=tip;
      fr_prodlenie:=Tfr_prodlenie.Create(Application);
      fr_prodlenie.ShowModal;
    finally
      fr_prodlenie.free;
    end;
  except
  end;
end;

procedure Tfr_prodlenie.bt_cancelClick(Sender: TObject);
begin
  fr_prodlenie.Close;
end;

procedure Tfr_prodlenie.bt_gostClick(Sender: TObject);
var
 parametry : variant;
 resSQL,res_op : integer;
begin
  If ed_nom_komn.text>'' Then Begin
     tb_gost.Enabled:=true;
     bt_prodlenie.Enabled:=false;
     bt_calc_schet.Enabled:=false;
     lb_fix.Visible:=false;
     ed_fix_sum.Visible:=false;
     lb_sum_sutki.Caption:='0';
     lb_sum_lgot.Caption:='0';
     lb_sutok.Caption:='0';
     lb_summa.Caption:='0';
     ed_fix_sum.Value:=0;
     StatusBar1.Panels[0].Text:='Статус:';
     nomer:=0;
     dat_s:=date;
     dat_po:=date;
     fr_ClientAdm.CDS_sp1.Active:=false;
     parametry:=VarArrayCreate([0, 5], varVariant);
     parametry[0]:=157;
     parametry[1]:=fr_ClientAdm.kod_adm;
     parametry[2]:=3;
     parametry[3]:=VarArrayOf([IntToStr(ed_nom_komn.Value),'','']);
     parametry[4]:=VarArrayOf([5,10,11]);
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
       bt_calc_schet.Enabled:=true;
       tb_gost.SetFocus
     end
     Else Begin
       MessageDlg('В номере нет гостей с наличным расчетом!', mtWarning, [mbOk], 0);
       ed_nom_komn.SetFocus;
     end;
  end;
end;

procedure Tfr_prodlenie.FormActivate(Sender: TObject);
begin
  ed_date_po.Date:=date;
  tim_work:=TimeToStr(time);
  If Length(tim_work)<8 Then tim_work:='0'+tim_work;
  dat_work:=date;
  If ed_date_po.Date < dat_work Then Begin
     tim_work:='0'+TimeToStr(time);
     ed_date_po.Date:=date;
  end;
  StatusBar1.Panels[0].Text:='Статус:';
  StatusBar1.Panels[1].Text:='Рабочее время: '+tim_work;
end;

procedure Tfr_prodlenie.bt_calc_schetClick(Sender: TObject);
var
 stoimost : real;
 par, rs : variant;
 lnd,lgta : integer;
begin
  tb_gost.Enabled:=false;
  kvo_talons:=0;
  dat_s:=fr_ClientAdm.CDS_sp1.FieldByName('date_out').AsDateTime;
  If ed_date_po.Date<dat_s Then Begin
     MessageDlg('Неправильная дата выезда!', mtWarning, [mbOk], 0);
     bt_gostClick(Sender);
     Exit;
  end;
  seria:=fr_ClientAdm.CDS_sp1.FieldByName('seria').AsString;
  dolg:=fr_ClientAdm.CDS_sp1.FieldByName('dolg').AsInteger;
  lnd:=fr_ClientAdm.CDS_sp1.FieldByName('land').AsInteger;
  lgta:=fr_ClientAdm.CDS_sp1.FieldByName('lgota').AsInteger;
  mest:=fr_ClientAdm.CDS_sp1.FieldByName('mests').AsInteger;
  nomer:=fr_ClientAdm.CDS_sp1.FieldByName('nomer').AsInteger;
  gost:=fr_ClientAdm.CDS_sp1.FieldByName('kod_gost').AsInteger;
  nom_schet:=fr_ClientAdm.CDS_sp1.FieldByName('schet').AsInteger;
  fam:=fr_ClientAdm.CDS_sp1.FieldByName('famil').AsString;
  io:=fr_ClientAdm.CDS_sp1.FieldByName('io').AsString;
  Case seria[1] of
     'A' : fix:=0;
     'B' : Begin
             fix:=1;
             lb_fix.Visible:=true;
             ed_fix_sum.Visible:=true;
           end;
     Else Begin
         MessageDlg('Не тот тип счета! '+seria+' счет!', mtWarning, [mbOk], 0);
         bt_gostClick(Sender);
         Exit;
     end;
  end;
  If (fix=1) and (ed_fix_sum.Value=0) Then begin
     MessageDlg('Внесите фиксированую сумму проживания!', mtWarning, [mbOk], 0);
     ed_fix_sum.Enabled:=true;
     ed_fix_sum.Value:=Round(fr_ClientAdm.CDS_sp1.FieldByName('sum_sut').AsFloat);
     ed_fix_sum.SetFocus;
     Exit;
  end;
  tim_in:=fr_ClientAdm.CDS_sp1.FieldByName('time_out').AsString;
  If dat_s>dat_work Then Begin
     MessageDlg('Этому гостю рано продлевать номер!', mtWarning, [mbOk], 0);
     bt_gostClick(Sender);
     Exit;
  end;
  sutki:=0;
  dat_po:=StrToDate(DateToStr(ed_date_po.Date));
  sec_pol:=tim_in>'12:00:00';
  If sec_pol Then sutki:=-0.5
   Else If dat_s=dat_po Then sutki:=0.5;
  If ((sutki<0) and (dat_s=dat_po))or(dat_s>dat_po) Then
  Begin
     MessageDlg('Не правильная дата продления!', mtWarning, [mbOk], 0);
     bt_gostClick(Sender);
     Exit;
  end;
  If sutki=0.5 Then Begin
    s_zvtr:=0;
    //tim_out:='18:00:00';
  end
  Else Begin
    sutki:=sutki+Round(dat_po-dat_s);
    //tim_out:='12:00:00';
    If (tim_work >= '18:00:00')and(dat_po=dat_work) Then sutki:=sutki+0.5;
    If ch_pol_sut.Checked Then Begin
      sutki:=sutki+0.5;
      //tim_out:='18:00:00';
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

  If fix=0 Then v_schet:=fr_ClientAdm.GetSumChet(lgta,nomer,mest,lnd,0,sutki,s_zvtr,0,sec_pol)
  Else Begin
    stoimost:=ed_fix_sum.Value;
    v_schet:=VarArrayCreate([0, 7], varVariant);
    v_schet[0]:=7;
    v_schet[1]:=VarArrayOf(['Стоимость проживания 1 суток :',stoimost]);
    v_schet[2]:=VarArrayOf(['Итого проживание в номере :',stoimost*sutki,1]);
    v_schet[3]:=VarArrayOf(['Льгота :',0,2]);
    v_schet[4]:=VarArrayOf(['Простой :',0,3]);
    v_schet[5]:=VarArrayOf(['Бронь :',0,4]);
    v_schet[6]:=VarArrayOf(['Завтрак на 1 сут. :',s_zvtr]);
    v_schet[7]:=VarArrayOf(['ИТОГО к оплате :',stoimost*sutki]);
  end;
  lb_sum_sutki.Caption:=FloatToStr(v_schet[1][1]);
  lb_sum_lgot.Caption:=FloatToStr(v_schet[3][1]);
  lb_sutok.Caption:=FloatToStr(sutki);
  lb_summa.Caption:=FloatToStr(v_schet[7][1]);
  If fr_ClientAdm.settings[8]<>0 Then seria[2]:='S';
  If (seria[2]='X')and(StatusBar1.Panels[0].Text<>'Статус: X') Then Begin //$$$$$
     StatusBar1.Panels[0].Text:='Статус: X';
     MessageDlg('Внимание!!! '+seria+' ошибка исправлена!!', mtWarning, [mbOk], 0);
  end;
  ed_fix_sum.Enabled:=false;
  bt_prodlenie.Enabled:=true;
  bt_prodlenie.SetFocus;
end;

Function Tfr_prodlenie.gt_free_mest : integer;
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

Function Tfr_prodlenie.gt_fool_mest : integer;
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

procedure Tfr_prodlenie.bt_prodlenieClick(Sender: TObject);
var
  parametry, par, rs, sch_pr : variant;
  resSQL, ii : integer;
  strsql : string;
  lst1, lst : TStringList;
begin
   parametry:=VarArrayCreate([0, 5], varVariant);
   bt_calc_schetClick(Sender);
   fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
   screen.Cursor:=crHourGlass;
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
         screen.Cursor:=crDefault;
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
       screen.Cursor:=crDefault;
       MessageDlg('Нет прав на операцию! Или ошибка освобождения мест. Попробуйте еще раз !', mtWarning, [mbOk], 0);
       Exit;
     end;
     parametry[0]:=171;
     resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
     If resSQL<>0 Then Begin
       fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
       screen.Cursor:=crDefault;
       MessageDlg('Нет прав на операцию! Или ошибка освобождения мест. Попробуйте еще раз !', mtWarning, [mbOk], 0);
       Exit;
     end;

     If mest>gt_free_mest Then
        fr_ClientAdm.MIDASConnection1.AppServer.MoveBron(dat_s, dat_po, nomer);



     If mest>gt_free_mest Then Begin
        fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
        screen.Cursor:=crDefault;
        MessageDlg('Нет возможности продлить на данный период!', mtWarning, [mbOk], 0);
        Exit;
     end;
   end;
   If v_schet[0]<=0 Then Begin
     screen.Cursor:=crDefault;
     MessageDlg('Не верная сумма счета!', mtWarning, [mbOk], 0);
     Exit;
   end;
   {изменяем таблицу миграции гостя}
   parametry[0]:=170;
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=5;
   parametry[3]:=VarArrayOf([DateToStr(dat_po),tim_out,IntToStr(gost),'0',
                                                       IntToStr(nomer)]);
   parametry[4]:=VarArrayOf(['d_out','tm_out','gost','stat','nomer']);
   parametry[5]:=0;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Begin
     screen.Cursor:=crDefault;
     MessageDlg('Ошибка миграции гостя! Попробуйте снова.', mtWarning, [mbOk], 0);
     fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
     Exit;
   end;
   parametry[0]:=165; {Закрытие счета}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=2;{сост. счета: 0-открыт,1-закрыт,2-возврат,3-удален}
   parametry[3]:=VarArrayOf(['1',IntToStr(nom_schet)]);
   parametry[4]:=VarArrayOf([2,5]);
   parametry[5]:=0;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL<0 Then Begin
     screen.Cursor:=crDefault;
     MessageDlg('Ошибка закрытия счета! Попробуйте снова.', mtWarning, [mbOk], 0);
     fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
     Exit;
   end;
   {Создание счета на новый период проживания}
   strsql:=#39+DateToStr(dat_work)+#39+','+IntToStr(gost)+',0,'+FloatToStr(v_schet[7][1])
   +',null,0,'+#39+seria+#39+','+IntToStr(ed_nom_komn.Value);
   par:=VarArrayCreate([0, 2], varVariant);
   par[0]:=1;
   par[1]:=VarArrayOf([strsql]);
   par[2]:=VarArrayOf([3]);
   rs:=fr_ClientAdm.GetTehParam(1001,par);
   If rs[1]<=0 Then Begin
    screen.Cursor:=crDefault;
    fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
    MessageDlg('Отказ в доступе или ошибка создания счета!', mtWarning, [mbOk], 0);
    Exit;
   end;
   nom_schet:=rs[1];
   parametry[0]:=155;  {заполнение констант счета}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=1;
   strsql:=IntToStr(nom_schet)+','+FloatToStr(sutki)+','+FloatToStr(v_schet[1][1])+
        ','+FloatToStr(v_schet[6][1])+',0,'+IntToStr(fr_ClientAdm.kod_smen);
   strsql:=strsql+',0,'+#39+DateToStr(dat_s)+#39+','+#39+tim_in+#39+','
           +#39+tim_out+#39;
   parametry[3]:=VarArrayOf([strsql]);
   parametry[4]:=VarArrayOf([2]);
   parametry[5]:=0;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL <>0 Then Begin
     screen.Cursor:=crDefault;
     fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
     MessageDlg('Отказ в доступе или ошибка открытия сета!', mtWarning, [mbOk], 0);
     Exit;
   end;
   ii:=2;
   lst1:=TStringList.Create;
   lst1.Add('Ф.И.О.  '+fam+' '+io);
   lst1.Add('');
   lst1.Add(v_schet[1][0]+' '+FloatToStr(v_schet[1][1])+' руб.');
   lst1.Add('Срок проживания : '+FloatToStr(sutki)+' сут.');
   lst1.Add('--------------------------------------------');
   While ii < 6 Do Begin
    strsql:=IntToStr(nom_schet)+','+#39+v_schet[ii][0]+#39+','
      +FloatToStr(v_schet[ii][1])+','+IntToStr(v_schet[ii][2]);
    lst1.Add(v_schet[ii][0]+' '+FloatToStr(v_schet[ii][1])+' руб.');
    If v_schet[ii][1]>0 Then Begin
      parametry[0]:=149; {занесение наличных платежей}
      parametry[1]:=fr_ClientAdm.kod_adm;
      parametry[2]:=1;
      parametry[3]:=VarArrayOf([strsql]);
      parametry[4]:=VarArrayOf([3]);
      parametry[5]:=0;
      resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
      If resSQL <> 0 Then Begin
        fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
        screen.Cursor:=crDefault;
        MessageDlg('Ошибка! Попробуйте еще раз!', mtWarning, [mbOk], 0);
        lst1.Free;
        Exit;
      end;
    end;
    Inc(ii);
   end;
   {изменение к-ва занятых мест в номерах}

   If dat_s<dat_po Then fr_ClientAdm.MIDASConnection1.AppServer.ChangeZMN(dat_s+1,dat_po,1,Mest,Nomer);

   {++++++++++ Печать счета ++++++++++++++++}
   lst:=TStringList.Create;
   sch_pr:=VarArrayCreate([0, 5], varVariant);
   sch_pr[0]:=IntToStr(nom_schet);
   sch_pr[1]:=v_schet[7][1];
   lst.Add('Дата заезда: '+DateToStr(dat_s)+'г.');
   lst.Add('№ '+IntToStr(nomer)+'; мест: '+IntToStr(mest));
   sch_pr[2]:=lst.Text;
   lst.Clear;
   lst.Add('Время заезда: '+tim_in);
   lst.Add('Выезд: '+DateToStr(dat_po)+'г.');
   lst.Add('ДОПЛАТА');
   sch_pr[3]:=lst.Text;
   lst1.Add('--------------------------------------------');
   lst1.Add(v_schet[7][0]+' '+FloatToStr(v_schet[7][1])+' руб.');
   sch_pr[4]:=lst1.Text;
   lst.free;
   lst1.Free;
   sch_pr[5]:=seria;
   MessageDlg('Вставте бланк для печати счета! Нажмите <Ок>', mtConfirmation, [mbOk], 0);
   Prn_schet_nal(sch_pr);
   screen.Cursor:=crDefault;
   If not Get_Answer('Внимание !!!','Проверьте правильность оформления счета!'
                    +#13+'Продолжить?',true) Then Begin
     fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
     parametry[0]:=180;
     parametry[1]:=fr_ClientAdm.kod_adm;
     parametry[2]:=4;
     parametry[3]:=VarArrayOf([IntToStr(nom_schet),FloatToStr(v_schet[7][1]),seria,
                               IntToStr(fr_ClientAdm.kod_smen)]);
     parametry[4]:=VarArrayOf(['nom_schet','summa','seria','smena']);
     parametry[5]:=0;
     If fr_ClientAdm.MIDASConnection1.AppServer.Get_State_DB=0 Then
                      fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
     resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
     If resSQL <>0 Then Begin
       If fr_ClientAdm.MIDASConnection1.AppServer.Get_State_DB=1 Then
                            fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
     end
     Else If fr_ClientAdm.MIDASConnection1.AppServer.Get_State_DB=1 Then
                          fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
     MessageDlg('Напечатанный бланк счета подлежит учету!', mtConfirmation, [mbOk], 0);
     Screen.Cursor:=crDefault;
     Exit;
   end;
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
      If fr_ClientAdm.MIDASConnection1.AppServer.Get_State_DB=1 Then  //$$$$$
          If seria[2]<>'X' Then fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans
             Else fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
      MessageDlg('Вставте бланк для '+IntToStr(kvo_talons)+
                           ' талонов! Нажмите <Ок>', mtConfirmation, [mbOk], 0);
      Print_talons(kvo_talons, IntToStr(nom_schet),seria);
     end;
   end;
   Dec(fr_ClientAdm.numch);
   MessageDlg('Проживание гося продлено!', mtInformation, [mbOk], 0);
   If (fr_ClientAdm.settings[9][0] = 1) and (not VarIsNull(fr_ClientAdm.DrvFR)) Then Begin
     If not fr_ClientAdm.PrintChekFRK(v_schet[7][1]) Then
        MessageDlg('ВНИМАНИЕ!! Чек не напечатан!', mtError,[mbOk], 0);
   end;
   fr_prodlenie.Close;
end;

procedure Tfr_prodlenie.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  fr_ClientAdm.CDS_sp1.Active:=false;
end;

procedure Tfr_prodlenie.tb_gostDblClick(Sender: TObject);
begin
  If bt_calc_schet.Enabled Then bt_calc_schetClick(Sender);
end;

procedure Tfr_prodlenie.tb_gostKeyPress(Sender: TObject; var Key: Char);
begin
  If bt_calc_schet.Enabled Then
     If Key = #13 Then bt_calc_schetClick(Sender);
end;

end.
