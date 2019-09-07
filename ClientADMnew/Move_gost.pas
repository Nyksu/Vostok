unit Move_gost;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Grids, DBGrids, StdCtrls, Spin, ExtCtrls, Buttons, DBCtrls,
  change_nomer, vozvr_nal, Ask_dlg, prn_nal_schet, prn_talons;

type
  Tfr_move_gost = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    ed_nom_komn: TSpinEdit;
    bt_gost: TButton;
    tb_gost: TDBGrid;
    rg_tip_move: TRadioGroup;
    bt_move: TBitBtn;
    bt_cancel: TBitBtn;
    bt_change_nomer: TBitBtn;
    Label3: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    Bevel1: TBevel;
    lb_nomer: TLabel;
    Label4: TLabel;
    lb_fix: TLabel;
    ed_fix_sum: TSpinEdit;
    procedure bt_gostClick(Sender: TObject);
    procedure bt_change_nomerClick(Sender: TObject);
    procedure bt_cancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bt_moveClick(Sender: TObject);
    procedure tb_gostDblClick(Sender: TObject);
    procedure tb_gostKeyPress(Sender: TObject; var Key: Char);
  private
    nomer : integer;
    nomer_to : integer;
    dat_s : Tdate;
    dat_po : Tdate;
    sum_sut_new : real;
    lnd : integer;
    mest : integer;
    gost : integer;
    fix : integer;
    tal_vozvr : integer;
    pol : string;
    seria : string;
    time_out : string[8];
    tim_in : string[8];
    time_work : TTime;
    v_schet : variant;
    sutki : real;
    lgta : integer;
    s_zvtr : real;
    sch_nom : integer;
    fam : string;
    io : string;
    dat_work : TDate;
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Move_nal(tip:integer);

var
  fr_move_gost: Tfr_move_gost;
  tps_move : integer;

implementation

Uses MainADM;

{$R *.DFM}

Procedure Move_nal(tip:integer);
Begin
  try
    try
      tps_move:=tip;
      fr_move_gost:=Tfr_move_gost.Create(Application);
      fr_move_gost.dat_work:=StrToDate(DateToStr(date));
      fr_move_gost.time_work:=time;
      fr_move_gost.ShowModal;
    finally
      fr_move_gost.free;
    end;
  except
  end;
end;

procedure Tfr_move_gost.bt_gostClick(Sender: TObject);
var
 parametry : variant;
 resSQL,res_op : integer;
begin
  If ed_nom_komn.text>'' Then Begin
     tb_gost.Enabled:=true;
     bt_move.Enabled:=false;
     rg_tip_move.Enabled:=true;
     fix:=1;
     lb_fix.Visible:=false;
     ed_fix_sum.Visible:=false;
     lb_nomer.Caption:='0';
     nomer_to:=0;
     StatusBar1.Panels[0].Text:='Статус:';
     fr_ClientAdm.CDS_work.Active:=false;
     {StatusBar1.Panels[0].Text:='Статус:';}
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
       MessageDlg('В номере нет гостей с наличным расчетом!', mtWarning, [mbOk], 0);
       ed_nom_komn.SetFocus;
     end;
  end;
end;

procedure Tfr_move_gost.bt_change_nomerClick(Sender: TObject);
var
  parametry, param, rs : variant;
  resSQL, ii, fr_m : integer;
  s_znak, s_sum : string;
begin
  If not fr_ClientAdm.CDS_work.Active Then Begin
    MessageDlg('Сначала выбирете номер и гостя', mtWarning, [mbOk], 0);
    Exit;
  end;
  If fr_ClientAdm.CDS_work.EOF Then Begin
    MessageDlg('В номере не проживают гости с наличным расчетом!', mtWarning, [mbOk], 0);
    Exit;
  end;
  dat_po:=fr_ClientAdm.CDS_work.FieldByName('date_out').AsDateTime;
  If dat_po <= dat_s Then Begin
    MessageDlg('У гостя задолженность по оплате номера! Сначала произведите продление', mtWarning, [mbOk], 0);
    Exit;
  end;
  lnd:=fr_ClientAdm.CDS_work.FieldByName('land').AsInteger;
  mest:=fr_ClientAdm.CDS_work.FieldByName('mests').AsInteger;
  gost:=fr_ClientAdm.CDS_work.FieldByName('kod_gost').AsInteger;
  pol:=fr_ClientAdm.CDS_work.FieldByName('pol').AsString;
  time_out:=fr_ClientAdm.CDS_work.FieldByName('time_out').AsString;
  fam:=fr_ClientAdm.CDS_work.FieldByName('famil').AsString;
  io:=fr_ClientAdm.CDS_work.FieldByName('io').AsString;
  lgta:=fr_ClientAdm.CDS_work.FieldByName('lgota').AsInteger;
  sch_nom:=fr_ClientAdm.CDS_work.FieldByName('schet').AsInteger;
  seria:=fr_ClientAdm.CDS_work.FieldByName('seria').AsString;
  If rg_tip_move.ItemIndex<>3 Then
    If dat_s=fr_ClientAdm.CDS_work.FieldByName('date_in').AsDateTime Then Begin
      MessageDlg('Используйте <ОШИБКА ОФОРМЛЕНИЯ>, если гость не пользовался номером или <Выселение> с частичным возвратом', mtWarning, [mbOk], 0);
      Exit;
    end;
  Case seria[1] of
     'A' : fix:=0;
     'B' : Begin
             fix:=1;
             lb_fix.Visible:=true;
             ed_fix_sum.Visible:=true;
           end;
     Else Begin
         MessageDlg('Не тот тип счета! '+seria+' счет!', mtWarning, [mbOk], 0);
         Exit;
     end;
  end;
  If seria[2]='X' Then Begin    //$$$$$
     StatusBar1.Panels[0].Text:='Статус: X';
     MessageDlg('Внимание!!! Устранена ошибка реестра транзакций!!!!', mtWarning, [mbOk], 0);
  end;
  {++++++++++++}
  nomer:=ed_nom_komn.Value;
  param:=VarArrayCreate([0, 2], varVariant);
  param[0]:=2;{получаем текущую стоимость номера}
  param[1]:=VarArrayOf([IntToStr(lnd),IntToStr(nomer)]);
  param[2]:=VarArrayOf(['land','nomer']);
  rs:=fr_ClientAdm.GetTehParam(178,param);
  sum_sut_new:=rs[1];
  {************}
  fr_ClientAdm.cds_jur.Active:=false;
  fr_ClientAdm.cds_sp2.Active:=false;
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=119;  {Справочник оснащения номеров}
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=0;
  parametry[3]:=VarArrayOf(['']);
  parametry[4]:=VarArrayOf([-1]);
  parametry[5]:=3;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
    MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
    Exit;
  end;
  Case rg_tip_move.ItemIndex of
    0 : Begin
          s_znak:='<>';
          s_sum:='0';
        end;
    1 : Begin
          s_znak:='<';
          s_sum:=FloatToStr(sum_sut_new);
        end;
    2 : Begin
          s_znak:='>';
          s_sum:=FloatToStr(sum_sut_new);
        end;
    3 : Begin
          s_znak:='=';
          s_sum:=FloatToStr(sum_sut_new);
        end;
  end;
  parametry[0]:=179;  {выборка номеров по стоимости номеров}
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=7;
  parametry[3]:=VarArrayOf([s_znak,s_sum,DateToStr(dat_s),DateToStr(dat_po),
                            IntToStr(lnd),IntToStr(mest),IntToStr(nomer)]);
  parametry[4]:=VarArrayOf(['znak','summa','dt_s','dt_po','land','mest','nomer']);
  parametry[5]:=1;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
    MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
    Exit;
  end;
  Screen.Cursor:=crHourglass;
  fr_ClientAdm.cds_jur.Active:=true;
  Screen.Cursor:=crDefault;
  fr_ClientAdm.cds_sp2.MasterSource:=fr_ClientAdm.ds_jur;
  fr_ClientAdm.cds_sp2.MasterFields:='nomer';
  fr_ClientAdm.cds_sp2.IndexFieldNames:='nom';
  fr_ClientAdm.cds_sp2.Active:=true;
  ii:=GetNomNomer(0,2,fr_m);
  fr_ClientAdm.cds_jur.Active:=false;
  fr_ClientAdm.cds_sp2.Active:=false;
  fr_ClientAdm.cds_sp2.MasterFields:='';
  fr_ClientAdm.cds_sp2.IndexFieldNames:='';
  nomer_to:=0;
  lb_nomer.Caption:=IntToStr(nomer_to);
  If ii<=0 Then Exit;
  lb_nomer.Caption:=IntToStr(ii);
  nomer_to:=ii;
  bt_move.Enabled:=true;
  rg_tip_move.Enabled:=false;
  tim_in:=TimeToStr(time_work);
  If length(tim_in)<8 Then tim_in:='0'+tim_in;
  param[0]:=1;{получаем сумму завтраков}
  param[1]:=VarArrayOf(['1']);
  param[2]:=VarArrayOf([4]);
  rs:=fr_ClientAdm.GetTehParam(147,param);
  If not VarIsNull(rs[1]) Then s_zvtr:=rs[1] Else s_zvtr:=0;
  param[0]:=1;{получаем наличие завтрака}
  param[2]:=VarArrayOf(['nomer']);
  tal_vozvr:=0;
  If s_zvtr>0 Then Begin
        param[1]:=VarArrayOf([IntToStr(nomer_to)]);
        rs:=fr_ClientAdm.GetTehParam(177,param);
        If not VarIsNull(rs[1]) Then s_zvtr:=0;
        If s_zvtr>0 Then tal_vozvr:=1
        Else tal_vozvr:=0;
  end;
  If (rg_tip_move.ItemIndex=1) or (rg_tip_move.ItemIndex=2) Then Begin
     sutki:=Round(dat_po-date);
     If time_work>StrToTime('18:00:00') Then sutki:=sutki-0.5;
     If time_out<>'12:00:00' Then sutki:=sutki+0.5;
     If fix=0 Then v_schet:=fr_ClientAdm.GetSumChet(lgta,nomer_to,mest,lnd,0,sutki,s_zvtr,0,false);
  end;
  If (rg_tip_move.ItemIndex=0) or (rg_tip_move.ItemIndex=3) Then tal_vozvr:=0;
end;

procedure Tfr_move_gost.bt_cancelClick(Sender: TObject);
begin
  fr_move_gost.Close;
end;

procedure Tfr_move_gost.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  fr_ClientAdm.CDS_work.Active:=false;
end;

procedure Tfr_move_gost.bt_moveClick(Sender: TObject);
var
  oo, par, rs, parametry, sch_pr : variant;
  strsql : string;
  resSQL, ii : integer;
  lst, lst1 : TStringList;
  stoimost : real;
begin
  If (fix = 1) and (ed_fix_sum.Value = 0) Then Begin
     MessageDlg('Введите фиксированую стоимость проживания для гостя.', mtWarning, [mbOk], 0);
     ed_fix_sum.SetFocus;
     Exit;
  end;
  If pol='М' Then strsql:=lb_nomer.Caption+','+#39+'Ж'+#39+','+#39+DateToStr(dat_s)+#39
  Else strsql:=lb_nomer.Caption+','+#39+'М'+#39+','+#39+DateToStr(dat_s)+#39;
  parametry:=VarArrayCreate([0, 5], varVariant);
  par:=VarArrayCreate([0, 2], varVariant);
  par[0]:=1;
  par[1]:=VarArrayOf([strsql]);
  par[2]:=VarArrayOf([2]);
  rs:=fr_ClientAdm.GetTehParam(135, par);
  If rs[1] > 0 Then
    if Get_Answer('Внимание !!!','В номере проживает лицо противоположного пола!'
                    +#13+'Для выбора другого номера нажмите <ДА>',true) Then Exit;

  If fix = 1 Then Begin
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
  Case rg_tip_move.ItemIndex of
   0,3 : Begin
           {Изменить статус проживания}
           fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
           parametry[0]:=170;
           parametry[1]:=fr_ClientAdm.kod_adm;
           parametry[2]:=5;
           parametry[3]:=VarArrayOf([DateToStr(dat_s),TimeToStr(time_work),IntToStr(gost),'1',
                                                               IntToStr(nomer)]);
           parametry[4]:=VarArrayOf(['d_out','tm_out','gost','stat','nomer']);
           parametry[5]:=0;
           resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
           If resSQL<0 Then Begin
             fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
             MessageDlg('Ошибка миграции гостя! Попробуйте снова.', mtWarning, [mbOk], 0);
             Exit;
           end;

           fr_ClientAdm.MIDASConnection1.AppServer.ChangeZMN(dat_s,dat_po,1,-Mest,Nomer);

           parametry[0]:=189;  {изменяем счет}
           parametry[2]:=2;
           parametry[3]:=VarArrayOf([lb_nomer.Caption,IntToStr(sch_nom)]);
           parametry[4]:=VarArrayOf(['nom','schet']);
           resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
           If resSQL<0 Then Begin
                MessageDlg('Ошибка при изменении счета!', mtWarning, [mbOk], 0);
                fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
                Exit;
           end;
           If fr_ClientAdm.settings[1][0]=0 Then Begin
           {Помечаем места как "грязные"}
             fr_ClientAdm.MIDASConnection1.AppServer.ChangeZMN(date,date,4,Mest,Nomer);
           end;
         end;
   1,2 : Begin
           oo:=Do_rebay(2,nomer,gost);
           If oo[1]<=0 Then Begin
             If fr_ClientAdm.MIDASConnection1.AppServer.Get_State_DB = 1 Then
                fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
             MessageDlg('Отказ от перевода!', mtWarning, [mbOk], 0);
             Exit;
           end;
           If fr_ClientAdm.MIDASConnection1.AppServer.Get_State_DB = 0 Then
           Begin
             MessageDlg('Ошибка перевода!', mtWarning, [mbOk], 0);
             Exit;
           end;
           strsql:=#39+DateToStr(dat_work)+#39+','+IntToStr(gost)+',0,'+FloatToStr(v_schet[7][1])
           +',null,0,'+#39+seria+#39+','+lb_nomer.Caption;
           par:=VarArrayCreate([0, 2], varVariant);
           par[0]:=1;         {открытие нового счета}
           par[1]:=VarArrayOf([strsql]);
           par[2]:=VarArrayOf([3]);
           rs:=fr_ClientAdm.GetTehParam(1001,par);
           If rs[1]<=0 Then Begin
              fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
              MessageDlg('Отказ в доступе или ошибка создания счета!', mtWarning, [mbOk], 0);
              Exit;
           end;
           sch_nom:=rs[1];
           parametry[0]:=155;  {заполнение констант счета}
           parametry[1]:=fr_ClientAdm.kod_adm;
           parametry[2]:=1;
           strsql:=IntToStr(sch_nom)+','+FloatToStr(sutki)+','+FloatToStr(v_schet[1][1])+
            ','+FloatToStr(v_schet[6][1])+',0,'+IntToStr(fr_ClientAdm.kod_smen);
           strsql:=strsql+',0,'+#39+DateToStr(dat_s)+#39+','+#39+tim_in+#39+','
            +#39+time_out+#39;
           parametry[3]:=VarArrayOf([strsql]);
           parametry[4]:=VarArrayOf([2]);
           parametry[5]:=0;
           resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
           If resSQL <>0 Then Begin
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
            strsql:=IntToStr(sch_nom)+','+#39+v_schet[ii][0]+#39+','
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
                 MessageDlg('Ошибка! Попробуйте еще раз!', mtWarning, [mbOk], 0);
                 lst1.Free;
                 Exit;
              end;
            end;
            Inc(ii);
           end;
           {++++++++++ Печать счета ++++++++++++++++}
           lst:=TStringList.Create;
           sch_pr:=VarArrayCreate([0, 5], varVariant);
           sch_pr[0]:=IntToStr(sch_nom);
           sch_pr[1]:=v_schet[7][1];
           lst.Add('Дата заезда: '+DateToStr(dat_s)+'г.');
           lst.Add('№ '+IntToStr(nomer_to)+'; мест: '+IntToStr(mest));
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
           MessageDlg('вставте следующий бланк для печати счета! Нажмите <Ок>', mtConfirmation, [mbOk], 0);
           Prn_schet_nal(sch_pr);
           If not Get_Answer('Внимание !!!','Проверьте правильность оформления счета!'
                    +#13+'Продолжить?',true) Then Begin
             fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
             fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
             parametry[0]:=180;
             parametry[1]:=fr_ClientAdm.kod_adm;
             parametry[2]:=4;
             parametry[3]:=VarArrayOf([IntToStr(sch_nom),FloatToStr(v_schet[7][1]),
                                       seria, IntToStr(fr_ClientAdm.kod_smen)]);
             parametry[4]:=VarArrayOf(['nom_schet','summa','seria','smena']);
             parametry[5]:=0;
             resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
             If resSQL <>0 Then Begin
                fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
             end
             Else fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
             MessageDlg('Напечатанный бланк счета подлежит учету!', mtConfirmation, [mbOk], 0);
             Exit;
           end;
         end;
  end;
  strsql:=IntToStr(gost)+','+lb_nomer.Caption+','+IntToStr(mest)+','+#39+
          DateToStr(dat_s)+#39+','+#39+DateToStr(dat_po)+#39+','+#39+tim_in+#39+
          ','+#39+time_out+#39+',0,0';
  parametry[0]:=138;{заполнение журнала перемещения гостя}
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=1;
  parametry[3]:=VarArrayOf([strsql]);
  parametry[4]:=VarArrayOf([2]);
  parametry[5]:=0;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
     fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
     MessageDlg('Отказ в доступе или ошибка перевода!', mtWarning, [mbOk], 0);
     Exit;
  end;

  fr_ClientAdm.MIDASConnection1.AppServer.ChangeZMN(dat_s,dat_po,1,Mest,Nomer_to);

  //fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
  fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;

  If tal_vozvr>0 Then Begin
       tal_vozvr:=Round(dat_po-dat_s)*mest;
       parametry[0]:=190;
       parametry[1]:=fr_ClientAdm.kod_adm;
       parametry[2]:=2;
       parametry[3]:=VarArrayOf([IntToStr(tal_vozvr),IntToStr(fr_ClientAdm.kod_smen)]);
       parametry[4]:=VarArrayOf(['talons','smena']);
       parametry[5]:=0;
       fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
       resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
       If resSQL<>0 Then fr_ClientAdm.MIDASConnection1.AppServer.BackTrans
       Else Begin                      //$$$$$
         If seria[2]<>'X' Then fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans
            Else fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
         MessageDlg('Вставте бланк для '+IntToStr(tal_vozvr)+
                         ' талонов! Нажмите <Ок>', mtConfirmation, [mbOk], 0);
         If s_zvtr>0 Then Print_talons(tal_vozvr,'БЕЗНАЛ','Заявка № '+IntToStr(0));
       end;
  end;

  If (fr_ClientAdm.settings[9][0] = 1) and (not VarIsNull(fr_ClientAdm.DrvFR)) Then Begin
     If not fr_ClientAdm.PrintChekFRK(v_schet[7][1]) Then
        MessageDlg('ВНИМАНИЕ!! Чек не напечатан!', mtError,[mbOk], 0);
  end;
  fr_move_gost.Close;
end;

procedure Tfr_move_gost.tb_gostDblClick(Sender: TObject);
begin
   rg_tip_move.SetFocus;
end;

procedure Tfr_move_gost.tb_gostKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 Then rg_tip_move.SetFocus;
end;

end.
