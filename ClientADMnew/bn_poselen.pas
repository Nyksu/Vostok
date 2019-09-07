unit bn_poselen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, StdCtrls, Buttons, ComCtrls, Spin, ExtCtrls, change_nomer,
  Ask_dlg, prn_talons, Test_black, other_men, reg_sng, reg_burguys;

type
  Tfr_posel_bn = class(TForm)
    Panel1: TPanel;
    lb_isnomer: TLabel;
    lb_nomer: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lb_cod_bron: TLabel;
    Panel5: TPanel;
    ed_kategor: TSpinEdit;
    ed_kvmest: TSpinEdit;
    ed_mest: TSpinEdit;
    ed_floor: TSpinEdit;
    ch_kategor: TCheckBox;
    ch_kvmest: TCheckBox;
    ch_mest: TCheckBox;
    ch_floor: TCheckBox;
    ed_date_in: TDateTimePicker;
    ed_date_out: TDateTimePicker;
    ch_first: TCheckBox;
    bt_change_nomer: TBitBtn;
    bt_canselNomer: TBitBtn;
    ed_cod_broni: TSpinEdit;
    bt_dat_s_unlock: TBitBtn;
    Panel2: TPanel;
    Panel3: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel8: TPanel;
    ed_fam: TEdit;
    ed_io: TEdit;
    ed_adress: TEdit;
    ch_man: TRadioButton;
    ch_woman: TRadioButton;
    list_land: TDBLookupListBox;
    list_lgot: TDBLookupListBox;
    ed_time_in: TDateTimePicker;
    BitBtn2: TBitBtn;
    Panel10: TPanel;
    Panel11: TPanel;
    bt_poselit: TBitBtn;
    bt_ne_poseliat: TBitBtn;
    ed_dr: TSpinEdit;
    lb_sutok: TLabel;
    Label11: TLabel;
    procedure bt_dat_s_unlockClick(Sender: TObject);
    procedure bt_change_nomerClick(Sender: TObject);
    procedure bt_canselNomerClick(Sender: TObject);
    procedure bt_ne_poseliatClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure bt_poselitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Bn_poselenie;

var
  fr_posel_bn: Tfr_posel_bn;

implementation

uses MainADM;

{$R *.DFM}
 var
  nomer, gost, schet, stat, sutki : integer;
  s_zvtr : real;
  anti_loop : boolean;

Procedure Bn_poselenie;
Begin
  try
   try
     fr_posel_bn:=Tfr_posel_bn.Create(Application);
     Screen.Cursor:=crDefault;
     fr_posel_bn.ShowModal;
   finally
     fr_posel_bn.Free;
     Screen.Cursor:=crDefault;
   end;
  except
  end;
end;



procedure Tfr_posel_bn.bt_dat_s_unlockClick(Sender: TObject);
begin
   ed_date_in.Enabled:=ed_date_out.Enabled;
end;

procedure Tfr_posel_bn.bt_change_nomerClick(Sender: TObject);
var
 sqlstr,str1,str2,str3,str4 : string;
 resSQL, fr_m : integer;
 parametry : Variant;
 ii : integer;
 dat_var : TDateTime;
begin
  If ed_date_out.Date < ed_date_in.Date Then Begin
      MessageDlg('Неверная дата выезда!', mtWarning, [mbOk], 0);
      Exit;
  end;
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=136;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=0;
  parametry[3]:=VarArrayOf(['']);
  parametry[4]:=VarArrayOf([-1]);
  parametry[5]:=0;
  fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
      fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
      MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
      Exit;
  end;
  fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
  fr_ClientAdm.cds_jur.Active:=false;
  fr_ClientAdm.cds_sp1.Active:=false;
  parametry[0]:=119;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=0;
  parametry[3]:=VarArrayOf(['']);
  parametry[4]:=VarArrayOf([-1]);
  parametry[5]:=2;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
    MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
    Screen.Cursor:=crDefault;
    Exit;
  end;
  If ch_first.Checked Then parametry[0]:=134
  Else parametry[0]:=133;
  sqlstr:=#39+DateToStr(ed_date_in.Date)+#39+','+
          #39+DateToStr(ed_date_out.Date)+#39;
  str1:='';
  str2:='';
  str3:='';
  str4:='';
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=5;
  parametry[4]:=VarArrayOf([2,6,7,8,9]);
  parametry[5]:=1;
  If ch_kategor.Checked Then str1:='AND t1.klass = '+ed_kategor.Text;
  If ch_kvmest.Checked Then str2:='AND t2.free_mests >= '+ed_kvmest.Text;
  If ch_mest.Checked Then str3:='AND t1.mests = '+ed_mest.Text;
  If ch_floor.Checked Then str4:='AND t1.floor = '+ed_floor.Text;
  parametry[3]:=VarArrayOf([sqlstr,str1,str2,str3,str4]);
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
    MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
    Screen.Cursor:=crDefault;
    Exit;
  end;
  fr_ClientAdm.cds_jur.Active:=true;
  fr_ClientAdm.cds_sp1.MasterSource:=fr_ClientAdm.ds_jur;
  fr_ClientAdm.cds_sp1.MasterFields:='nomer';
  fr_ClientAdm.cds_sp1.IndexFieldNames:='nom';
  fr_ClientAdm.cds_sp1.Active:=true;
  ii:=GetNomNomer(0,1,fr_m);
  If ii>0 Then If fr_m<ed_kvmest.Value Then Begin
          ShowMessage('В номере свободно только '+IntToStr(fr_m)+' мест !!');
          ed_kvmest.Value:=fr_m;
    end;
  lb_nomer.Caption:=IntToStr(ii);
  nomer:=ii;
  dat_var:=ed_date_in.Date;
  Screen.Cursor:=crHourGlass;
  If ii > 0 Then Begin
   While dat_var<=ed_date_out.Date Do Begin
     sqlstr:=#39+DateToStr(dat_var)+#39+','+lb_nomer.Caption+',7,'+ed_kvmest.Text;
     parametry[0]:=137;
     parametry[1]:=fr_ClientAdm.kod_adm;
     parametry[2]:=1;
     parametry[3]:=VarArrayOf([sqlstr]);
     parametry[4]:=VarArrayOf([2]);
     parametry[5]:=0;
     fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
     resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
     If resSQL <>0 Then Begin
       fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
       MessageDlg('Отказ в доступе или ошибка резервирования!', mtWarning, [mbOk], 0);
       Screen.Cursor:=crDefault;
       Exit;
     end;
     fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
     dat_var:=dat_var+1;
   end;
   ed_cod_broni.SetFocus
  end;
  If ii<>0 Then nomer:=ii;
  lb_nomer.Caption:=IntToStr(nomer);
  If lb_nomer.Caption = '0' Then lb_isnomer.Caption:='Номер не выбран'
  Else Begin
    lb_isnomer.Caption:='Выбран номер :';
    bt_canselNomer.Enabled:=true;
    ed_date_out.Enabled:=false;
    ed_date_in.Enabled:=false;
  end;
  If (nomer > 0) and (ii > 0) Then ed_kvmest.Enabled:=false;
  //dat_var:=ed_date_in.Date;
  fr_ClientAdm.cds_jur.Active:=false;
  fr_ClientAdm.cds_sp1.Active:=false;
  fr_ClientAdm.cds_sp1.MasterFields:='';
  fr_ClientAdm.cds_sp1.IndexFieldNames:='';
  Screen.Cursor:=crDefault;
  lb_sutok.Caption:=IntToStr(Round(ed_date_out.Date-ed_date_in.Date));
end;

procedure Tfr_posel_bn.bt_canselNomerClick(Sender: TObject);
var
 resSQL: integer;
 parametry : Variant;
begin
  If gost>=0 Then Begin
     MessageDlg('Сначала необходимо отменить регистрацию гостя!', mtWarning, [mbOk], 0);
     Exit;
  end;
  lb_sutok.Caption:='0';
  bt_canselNomer.Enabled:=false;
  ed_kvmest.Enabled:=true;
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=153;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=1;
  parametry[3]:=VarArrayOf([lb_nomer.Caption]);
  parametry[4]:=VarArrayOf([3]);
  parametry[5]:=0;
  fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
    fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
    MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
    Exit;
  end;
  fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
  lb_isnomer.Caption:='Номер не выбран';
  ed_date_out.Enabled:=true;;
  lb_nomer.Caption:='0';
  nomer:=0;
end;

procedure Tfr_posel_bn.bt_ne_poseliatClick(Sender: TObject);
var
parametry : Variant;
resSQL : integer;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=136;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=0;
  parametry[3]:=VarArrayOf(['']);
  parametry[4]:=VarArrayOf([-1]);
  parametry[5]:=0;
  fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL < 0 Then Begin
      fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
      MessageDlg('Ошибка освобождения мест от операции!', mtWarning, [mbOk], 0);
      Exit;
  end;
  fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
  fr_posel_bn.Close;
end;

procedure Tfr_posel_bn.BitBtn2Click(Sender: TObject);
begin
  ed_time_in.Time:=Time;
end;

procedure Tfr_posel_bn.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   fr_ClientAdm.cds_sp2.Active:=false;
   fr_ClientAdm.cds_sp3.Active:=false;
   fr_ClientAdm.cds_sp1.Active:=false;
end;

procedure Tfr_posel_bn.FormCreate(Sender: TObject);
var
 resSQL: integer;
 parametry : Variant;
begin
  anti_loop:=true;
  ed_date_in.Date:=Date;
  ed_date_out.Date:=Date+1;
  ed_time_in.Time:=Time;
  Screen.Cursor:=crHourGlass;
  fr_ClientAdm.Cleaner;
  nomer:=0;
  gost:=-1;
  schet:=-1;
  stat:=0;
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=125;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=0;
  parametry[3]:=VarArrayOf(['']);
  parametry[4]:=VarArrayOf([-1]);
  parametry[5]:=4;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
    MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
    Screen.Cursor:=crDefault;
    Exit;
  end;
  parametry[0]:=132;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=0;
  parametry[3]:=VarArrayOf(['']);
  parametry[4]:=VarArrayOf([-1]);
  parametry[5]:=3;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
    MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
    Screen.Cursor:=crDefault;
    Exit;
  end;
  try
   try
    list_lgot.ListField:='lgota';
    list_lgot.KeyField:='kod_lgot';
    list_land.ListField:='name_land';
    list_land.KeyField:='kod_land';
    fr_ClientAdm.CDS_sp2.Open;
    fr_ClientAdm.CDS_sp3.Open;
   finally
    Screen.Cursor:=crDefault;
   end;
  except
  end;
end;

procedure Tfr_posel_bn.FormActivate(Sender: TObject);
begin
   If anti_loop Then ed_kvmest.SetFocus;
   anti_loop:=false;
end;

procedure Tfr_posel_bn.bt_poselitClick(Sender: TObject);
var
 strsql, pol, s_tim, s_mest, s_dt1, s_dt2, fm, io, adr, yar, pl : string;
 resSQL, i2, ii : integer;
 param, otvet, parametry : Variant;
begin
   If (ed_fam.Text='') or (ed_io.Text='') or (ed_adress.text='') Then Begin
     MessageDlg('Заполните необходимые поля в карте гостя!', mtWarning, [mbOk], 0);
     Exit;
  end;
  If Pos(' ',ed_io.Text)=0 Then Begin
     MessageDlg('Некорректное отчество!', mtWarning, [mbOk], 0);
     ed_io.SetFocus;
     Exit;
  end;
  fm:=Copy(ed_io.Text,1,3);
  io:=Copy(ed_io.Text,Pos(' ',ed_io.Text)+1,3);
  fr_ClientAdm.cds_sp1.Active:=false;
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=225;{Черный список}
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=3;
  parametry[3]:=VarArrayOf([ed_fam.Text,fm,io]);
  parametry[4]:=VarArrayOf(['fam','im','ot']);
  parametry[5]:=2;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL=0 Then Begin
     fr_ClientAdm.cds_sp1.Active:=true;
     fr_ClientAdm.cds_sp1.First;
     While not fr_ClientAdm.cds_sp1.EOF Do Begin
       If Test_men_black Then Begin
          fr_ClientAdm.cds_sp1.Active:=false;
          ShowMessage('Поселение отменино !! Человек - в ЧЕРНОМ списке !!!');
          Exit;
       end;
       fr_ClientAdm.cds_sp1.Next;
     end;
     fr_ClientAdm.cds_sp1.Active:=false;
  end;
  param:=VarArrayCreate([0, 2], varVariant);
  If fr_ClientAdm.settings[2][0]=0 Then Begin
    param[0]:=2;
    param[1]:=VarArrayOf([IntToStr(ed_cod_broni.Value),'0']);
    param[2]:=VarArrayOf(['bron','state']);
    otvet:=fr_ClientAdm.GetTehParam(181, param);
    If VarIsNull(otvet[1]) Then
      if not Get_Answer('Внимание !!!','Данная бронь закрыта или не существует!'
          +#13+'Для продолжения нажмите <ДА>, для изменения кода заявки - <НЕТ>',true) Then Begin
          ed_cod_broni.SetFocus;
          Exit;
      end;
  end;
  If ch_man.Checked Then Begin
    pol:='М';
    strsql:=lb_nomer.Caption+','+#39+'Ж'+#39+','
    +#39+DateToStr(ed_date_in.Date)+#39;
  end;
  If ch_woman.Checked Then Begin
    pol:='Ж';
    strsql:=lb_nomer.Caption+','+#39+'М'+#39+','
    +#39+DateToStr(ed_date_in.Date)+#39;
  end;
  param[0]:=1;
  param[1]:=VarArrayOf([strsql]);
  param[2]:=VarArrayOf([2]);
  otvet:=fr_ClientAdm.GetTehParam(135, param);
  If otvet[1] > 0 Then
    if Get_Answer('Внимание !!!','В номере проживает лицо противоположного пола!'
                    +#13+'Для выбора другого номера нажмит <ДА>',true) Then Exit;
  stat:=0;
  Screen.Cursor:=crHourGlass;
  strsql:=#39+ed_fam.Text+#39+','+#39+ed_io.Text+#39+','+#39+
          '01.01.'+IntToStr(ed_dr.Value)+#39+','+#39+ed_adress.text+#39+','+
          IntToStr(list_land.KeyValue)+','+#39+pol+#39+','+
          IntToStr(list_lgot.KeyValue)+','+IntToStr(stat)
          +','+IntToStr(ed_cod_broni.Value);
  param[0]:=1;    {Регистрация гостя}
  param[1]:=VarArrayOf([strsql]);
  param[2]:=VarArrayOf([3]);
  fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
  otvet:=fr_ClientAdm.GetTehParam(1000, param);
  If not VarIsNull(otvet[1]) Then gost:=otvet[1]
  Else Begin
    gost:=-1;
    fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
    MessageDlg('Ошибка!! Гость не поселен! Попробуйте еще раз.', mtWarning, [mbOk], 0);
    Screen.Cursor:=crDefault;
    Exit;
  end;
  If list_land.KeyValue>=10 Then
     If list_land.KeyValue<50 Then Begin
         If not Set_ext_sng_dats(gost,ed_dr.Value) Then Begin
            gost:=-1;
            fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
            MessageDlg('Гость не поселен!', mtWarning, [mbOk], 0);
            Screen.Cursor:=crDefault;
            Exit;
         end
     end
     Else Begin
         If not Set_ext_burg_dats(gost,ed_dr.Value) Then Begin
            gost:=-1;
            fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
            MessageDlg('Гость не поселен!', mtWarning, [mbOk], 0);
            Screen.Cursor:=crDefault;
            Exit;
         end
     end;
  If (ed_kvmest.Value>1)and(list_land.KeyValue<10) Then Begin
  {Регистрация дополнительных гостей}
    If ed_kvmest.Value=3 Then i2:=2 Else i2:=1;
    For ii:=1 To i2 Do Begin
        If not Add_other_men(fm, io, adr, yar, pl) Then Break;
        parametry[0]:=224;{заполнение журнала дополнительных гостей}
        parametry[1]:=fr_ClientAdm.kod_adm;
        parametry[2]:=7;
        parametry[3]:=VarArrayOf([fm,io,adr,yar,pl,IntToStr(gost),IntToStr(list_land.KeyValue)]);
        parametry[4]:=VarArrayOf(['fam','io','adres','god','pol','gost','land']);
        parametry[5]:=0;
        resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
        If resSQL <>0 Then Begin
          fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
          MessageDlg('Отказ в доступе или ошибка поселения доп. гостей!', mtWarning, [mbOk], 0);
          Screen.Cursor:=crDefault;
          Exit;
        end;
    end;
  end;
  {*********************************}
  s_tim:=TimeToStr(ed_time_in.Time);
  If Length(s_tim)<8 Then s_tim:='0'+s_tim;
  strsql:=IntToStr(gost)+','+lb_nomer.Caption+','+ed_kvmest.Text+
    ','+#39+DateToStr(ed_date_in.Date)+#39+','+#39+DateToStr(ed_date_out.Date)+
    #39+','+#39+s_tim+#39+','+#39+'12:00:00'+#39+',0,0';
  parametry[0]:=138;{заполнение журнала перемещения гостя}
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=1;
  parametry[3]:=VarArrayOf([strsql]);
  parametry[4]:=VarArrayOf([2]);
  parametry[5]:=0;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
    fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
    MessageDlg('Отказ в доступе или ошибка поселения!', mtWarning, [mbOk], 0);
    Screen.Cursor:=crDefault;
    Exit;
  end;
  s_mest:=ed_kvmest.text;
  s_dt1:=#39+DateToStr(ed_date_in.date)+#39;
  s_dt2:=#39+DateToStr(ed_date_out.date)+#39;
  parametry[0]:=150; {изменение к-ва занятых мест в номерах}
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=4;
  parametry[3]:=VarArrayOf(['+ '+s_mest,s_dt1,s_dt2,lb_nomer.Caption]);
  parametry[4]:=VarArrayOf([2,5,7,9]);
  parametry[5]:=0;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
    fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
    MessageDlg('Отказ в доступе или ошибка заполнения мест!', mtWarning, [mbOk], 0);
    Screen.Cursor:=crDefault;
    Exit;
  end;
  parametry[0]:=151; {занятие мест в свободных номерах}
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=3;
  parametry[3]:=VarArrayOf([lb_nomer.Caption,s_mest,lb_nomer.Caption]);
  parametry[4]:=VarArrayOf([2,4,9]);
  parametry[5]:=0;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
    fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
    MessageDlg('Отказ в доступе или ошибка заполнения мест!', mtWarning, [mbOk], 0);
    Screen.Cursor:=crDefault;
    Exit;
  end;
  parametry[0]:=153; {Освобождение временно занятых на операцию мест в номерах}
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=1;
  parametry[3]:=VarArrayOf([lb_nomer.Caption]);
  parametry[4]:=VarArrayOf([3]);
  parametry[5]:=0;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
    fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
    MessageDlg('Отказ в доступе или ошибка освобождения мест!', mtWarning, [mbOk], 0);
    Screen.Cursor:=crDefault;
    Exit;
  end;
  {Удаление номера из списка первоочередных}
  parametry[0]:=154;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=1;
  parametry[3]:=VarArrayOf([lb_nomer.Caption]);
  parametry[4]:=VarArrayOf([3]);
  parametry[5]:=0;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL <>0 Then Begin
    fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
    MessageDlg('Отказ в доступе или ошибка освобождения номера!', mtWarning, [mbOk], 0);
    Screen.Cursor:=crDefault;
    Exit;
  end;
  fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
  s_zvtr:=0;
  param[0]:=1;{получаем наличие завтрака}
  param[1]:=VarArrayOf([IntToStr(nomer)]);
  param[2]:=VarArrayOf(['nomer']);
  otvet:=fr_ClientAdm.GetTehParam(177,param);
  If not VarIsNull(otvet[1]) Then s_zvtr:=0
  Else s_zvtr:=1;
  sutki:=Round(ed_date_out.Date-ed_date_in.Date);
  If s_zvtr>0 then Begin
    parametry[0]:=190;
    parametry[1]:=fr_ClientAdm.kod_adm;
    parametry[2]:=2;
    parametry[3]:=VarArrayOf([IntToStr(sutki*ed_kvmest.Value),IntToStr(fr_ClientAdm.kod_smen)]);
    parametry[4]:=VarArrayOf(['talons','smena']);
    parametry[5]:=0;
    fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
    resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
    If resSQL <>0 Then fr_ClientAdm.MIDASConnection1.AppServer.BackTrans
    Else Begin
      fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
      MessageDlg('Вставте бланк '+IntToStr(sutki*ed_kvmest.Value)+
                         ' для талонов! Нажмите <Ок>', mtConfirmation, [mbOk], 0);
      If s_zvtr>0 Then Print_talons(sutki*ed_kvmest.Value,'БЕЗНАЛ','Заявка № '+IntToStr(ed_cod_broni.Value));
    end;
  end;
  MessageDlg('Гость успешно поселен!', mtInformation, [mbOk], 0);
  fr_posel_bn.Close;
end;

end.
