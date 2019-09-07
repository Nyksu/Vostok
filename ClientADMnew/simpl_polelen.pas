unit simpl_polelen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, Spin, ExtCtrls, DBCtrls, Mask, change_nomer,
  Ask_dlg,prn_nal_schet,prn_talons,other_men,Test_black,reg_sng,reg_burguys,
  Unxcrypt;

type
  Tfr_simpl_polelen = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
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
    lb_isnomer: TLabel;
    lb_nomer: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ed_fam: TEdit;
    ed_io: TEdit;
    ed_adress: TEdit;
    ch_man: TRadioButton;
    ch_woman: TRadioButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    list_land: TDBLookupListBox;
    list_lgot: TDBLookupListBox;
    Label8: TLabel;
    Label9: TLabel;
    ed_prl: TMaskEdit;
    bt_calc_schet: TBitBtn;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    lb_sum_sutki: TLabel;
    lb_sutok: TLabel;
    lb_summa: TLabel;
    lb_x: TLabel;
    bt_canselNomer: TBitBtn;
    ed_time_in: TDateTimePicker;
    BitBtn2: TBitBtn;
    lb_lgot_label: TLabel;
    lb_sum_lgot: TLabel;
    ch_bron: TCheckBox;
    lb_cod_bron: TLabel;
    ed_cod_broni: TSpinEdit;
    lb_bron: TLabel;
    lb_prost: TLabel;
    lb_sum_bron: TLabel;
    lb_sum_prost: TLabel;
    ch_prostoy: TCheckBox;
    ed_fix_sum: TSpinEdit;
    Panel10: TPanel;
    Panel11: TPanel;
    bt_poselit: TBitBtn;
    bt_ne_poseliat: TBitBtn;
    bt_dat_s_unlock: TBitBtn;
    ed_dr: TSpinEdit;
    procedure bt_change_nomerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Panel8DblClick(Sender: TObject);
    procedure ed_prlKeyPress(Sender: TObject; var Key: Char);
    procedure bt_canselNomerClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure bt_calc_schetClick(Sender: TObject);
    procedure bt_ne_poseliatClick(Sender: TObject);
    procedure bt_poselitClick(Sender: TObject);
    procedure bt_dat_s_unlockClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Poselen_prost(br:integer);

var
  fr_simpl_polelen: Tfr_simpl_polelen;
  anti_loop : boolean;

implementation

Uses MainADM;

var
  nomer, gost, schet, stat, sutki, b_bron, fix : integer;
  v_schet : variant;
  sser : string;
  s_zvtr : real;

{$R *.DFM}

Procedure Poselen_prost(br:integer);
Begin
  Screen.Cursor:=crHourGlass;
  Case br of
    0 : Begin
         b_bron:=0;
         fix:=0;
        end;
    1 : Begin
         b_bron:=1;
         fix:=0;
        end;
    2 : Begin
         b_bron:=0;
         fix:=1;
        end;
    3 : Begin
         b_bron:=1;
         fix:=1;
        end;
  end;
  try
   try
     fr_simpl_polelen:=Tfr_simpl_polelen.Create(Application);
     Screen.Cursor:=crDefault;
     fr_simpl_polelen.ShowModal;
   finally
     fr_simpl_polelen.Free;
     Screen.Cursor:=crDefault;
   end;
  except
  end;
end;

procedure Tfr_simpl_polelen.bt_change_nomerClick(Sender: TObject);
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
  If ii>0 Then
    If fr_m<ed_kvmest.Value Then Begin
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
   If b_bron = 1 Then ch_prostoy.SetFocus
   Else ed_fam.SetFocus;
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
end;

procedure Tfr_simpl_polelen.FormCreate(Sender: TObject);
var
 resSQL: integer;
 parametry : Variant;
begin
  anti_loop:=true;
  If b_bron = 1 Then Begin
    ch_bron.Enabled:=true;
    ch_bron.Checked:=true;
    ch_prostoy.Visible:=true;
    ed_cod_broni.Visible:=true;
    lb_cod_bron.Visible:=true;
  end
  Else Begin
    ch_bron.Enabled:=false;
    ch_bron.Checked:=false;
    ch_prostoy.Visible:=false;
    ed_cod_broni.Visible:=false;
    lb_cod_bron.Visible:=false;
  end;
  If fix = 1 Then Begin
    lb_lgot_label.Visible:=false;
    lb_sum_lgot.Visible:=false;
    ed_fix_sum.Visible:=true;
  end
  Else Begin
    ed_fix_sum.Visible:=false;
  end;
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

procedure Tfr_simpl_polelen.BitBtn2Click(Sender: TObject);
begin
  ed_time_in.Time:=Time;
end;

procedure Tfr_simpl_polelen.Panel8DblClick(Sender: TObject);
begin
  {If gost > 0 Then} Exit;
  {If fr_ClientAdm.settings[8]<>0 Then Exit;
  If lb_x.Visible Then lb_x.Visible:=false
  Else Begin
    ed_prl.Text:='';
    ed_prl.Visible:=true;
    ed_prl.SetFocus;
  end; }
end;

procedure Tfr_simpl_polelen.ed_prlKeyPress(Sender: TObject; var Key: Char);
var
 ss : string;
begin
  Exit;
  {If Key = #13 Then Begin
    ed_prl.Visible:=false;
    ss:='Lc/wCJM74HI';
    If fr_ClientAdm.settings[8]<>0 Then Exit;
    If CreateInterbasePassword(ed_prl.text) = ss Then lb_x.Visible:=true;
  end;}
  ed_prl.Visible:=false;
end;

procedure Tfr_simpl_polelen.bt_canselNomerClick(Sender: TObject);
var
 resSQL: integer;
 parametry : Variant;
begin
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

procedure Tfr_simpl_polelen.FormActivate(Sender: TObject);
begin
  If anti_loop Then ed_kvmest.SetFocus;
  anti_loop:=false;
end;

procedure Tfr_simpl_polelen.bt_calc_schetClick(Sender: TObject);
var
prst : integer;
resultat, parametry : Variant;
stoimost : real;
begin
  If lb_nomer.Caption = '0' Then Begin
    MessageDlg('Не выбран номер!', mtWarning, [mbOk], 0);
    Exit;
  end;
  If VarIsNull(list_land.KeyValue) or VarIsNull(list_lgot.KeyValue) Then Begin
     MessageDlg('Укажите льготу и страну!', mtWarning, [mbOk], 0);
     Exit;
  end;
  If (fix=1) and (ed_fix_sum.Value=0) Then begin
     MessageDlg('Внесите фиксированую сумму проживания!', mtWarning, [mbOk], 0);
     ed_fix_sum.SetFocus;
     Exit;
  end;
  If ch_prostoy.Checked Then prst:=1 Else prst:=0;
  If lb_x.Visible Then sser:='AX' Else sser:='AS'; //$$$$$
  If fr_ClientAdm.settings[8]<>0 Then sser:='AS';
  parametry:=VarArrayCreate([0, 2], varVariant);
  parametry[0]:=0;{получаем стоимость завтрака}
  parametry[1]:=VarArrayOf(['']);
  parametry[2]:=VarArrayOf([-1]);
  resultat:=fr_ClientAdm.GetTehParam(145,parametry);
  s_zvtr:=0;
  If not VarIsNull(resultat[1]) Then s_zvtr:=resultat[1];
  parametry[0]:=1;{получаем наличие завтрака}
  parametry[1]:=VarArrayOf([IntToStr(nomer)]);
  parametry[2]:=VarArrayOf(['nomer']);
  resultat:=fr_ClientAdm.GetTehParam(177,parametry);
  If not VarIsNull(resultat[1]) Then s_zvtr:=0;
  sutki:=Round(ed_date_out.Date-ed_date_in.Date);
  If fix=0 Then v_schet:=fr_ClientAdm.GetSumChet(list_lgot.KeyValue,nomer,
    ed_kvmest.Value,list_land.KeyValue,ed_cod_broni.Value,sutki,s_zvtr,prst,false)
  Else Begin
    If lb_x.Visible Then sser:='BX' Else sser:='BS';      //$$$$$ 
    If fr_ClientAdm.settings[8]<>0 Then sser:='BS';
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
  lb_sum_bron.Caption:=FloatToStr(v_schet[5][1]);
  lb_sum_prost.Caption:=FloatToStr(v_schet[4][1]);
end;

procedure Tfr_simpl_polelen.bt_ne_poseliatClick(Sender: TObject);
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
  fr_simpl_polelen.Close;
end;

procedure Tfr_simpl_polelen.bt_poselitClick(Sender: TObject);
var
 strsql, pol, s_tim, s_mest, s_dt1, s_dt2 : string;
 resSQL, ii, i2 : integer;
 param, otvet, parametry, sch_pr : Variant;
 lst1,lst : TStringList;
 fm, io, adr, yar, pl : string;
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
  bt_calc_schetClick(Sender);
  If v_schet[0]<=0 Then Begin
     MessageDlg('Не верная сумма счета!', mtWarning, [mbOk], 0);
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
  If (ch_bron.Checked) and (fr_ClientAdm.settings[2][0]=0) Then Begin
    param[0]:=2;
    param[1]:=VarArrayOf([IntToStr(ed_cod_broni.Value),'0']);
    param[2]:=VarArrayOf(['bron','state']);
    otvet:=fr_ClientAdm.GetTehParam(181, param);
    If VarIsNull(otvet[1]) Then if not Get_Answer('Внимание !!!','Данная бронь закрыта или не существует!'
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
  If lb_x.Visible Then Begin
    stat:=10;
    If fix=1 Then stat:=11;
  end
  Else If fix=1 Then stat:=1 Else stat:=0;
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
  {*********************************}
  end;
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
  {Открытие нового счета}
  strsql:=#39+DateToStr(date)+#39+','+IntToStr(gost)+',0,'+FloatToStr(v_schet[7][1])
  +',null,0,'+#39+sser+#39+','+lb_nomer.Caption;
     parametry[0]:=1;
     parametry[1]:=VarArrayOf([strsql]);
     parametry[2]:=VarArrayOf([3]);
     otvet:=fr_ClientAdm.GetTehParam(1001,parametry);
  If otvet[1]<=0 Then Begin
    fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
    MessageDlg('Отказ в доступе или ошибка создания счета!', mtWarning, [mbOk], 0);
    Screen.Cursor:=crDefault;
    Exit;
  end;
  schet:=otvet[1];
  sutki:=Round(ed_date_out.Date-ed_date_in.Date);
  param:=VarArrayCreate([0, 5], varVariant);
  param[0]:=155;  {заполнение констант счета}
  param[1]:=fr_ClientAdm.kod_adm;
  param[2]:=1;
  strsql:=IntToStr(schet)+','+FloatToStr(sutki)+','+FloatToStr(v_schet[1][1])+
        ','+FloatToStr(v_schet[6][1])+',0,'+IntToStr(fr_ClientAdm.kod_smen);
  strsql:=strsql+',0,'+#39+DateToStr(ed_date_in.Date)+#39+','+#39;
  strsql:=strsql+TimeToStr(ed_time_in.time)+#39+','+#39+'12:00:00'+#39;
  param[3]:=VarArrayOf([strsql]);
  param[4]:=VarArrayOf([2]);
  param[5]:=0;
  resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(param);
  If resSQL <>0 Then Begin
    fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
    MessageDlg('Отказ в доступе или ошибка открытия сета!', mtWarning, [mbOk], 0);
    Screen.Cursor:=crDefault;
    Exit;
  end;
  ii:=2;
  lst1:=TStringList.Create;
  lst1.Add('Ф.И.О.  '+ed_fam.Text+' '+ed_io.Text);
  lst1.Add('');
  lst1.Add(v_schet[1][0]+' '+FloatToStr(v_schet[1][1])+' руб.');
  lst1.Add('Срок проживания : '+IntToStr(sutki)+' сут.');
  lst1.Add('--------------------------------------------');
  While ii < 6 Do Begin
    strsql:=IntToStr(schet)+','+#39+v_schet[ii][0]+#39+','
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
        Screen.Cursor:=crDefault;
        Exit;
      end;
    end;
    Inc(ii);
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
  {++++++++++ Печать счета ++++++++++++++++}
  lst:=TStringList.Create;
  sch_pr:=VarArrayCreate([0, 5], varVariant);
  sch_pr[0]:=IntToStr(schet);
  sch_pr[1]:=v_schet[7][1];
  lst.Add('Дата заезда: '+DateToStr(ed_date_in.date)+'г.');
  lst.Add('№ '+lb_nomer.Caption+'; мест: '+s_mest);
  sch_pr[2]:=lst.Text;
  lst.Clear;
  lst.Add('Время заезда: '+TimeToStr(ed_time_in.Time));
  lst.Add('Выезд: '+DateToStr(ed_date_out.date)+'г.');
  lst.Add('ОПЛАТА');
  sch_pr[3]:=lst.Text;
  lst1.Add('--------------------------------------------');
  lst1.Add(v_schet[7][0]+' '+FloatToStr(v_schet[7][1])+' руб.');
  sch_pr[4]:=lst1.Text;
  lst.free;
  lst1.Free;
  sch_pr[5]:=sser;
  MessageDlg('Вставте бланк для печати счета! Нажмите <Ок>', mtConfirmation, [mbOk], 0);
  Prn_schet_nal(sch_pr);
  If not Get_Answer('Внимание !!!','Проверьте правильность оформления счета!'
                    +#13+'Продолжить?',true) Then Begin
     fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
     fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
     parametry[0]:=180;
     parametry[1]:=fr_ClientAdm.kod_adm;
     parametry[2]:=4;
     parametry[3]:=VarArrayOf([IntToStr(schet),FloatToStr(v_schet[7][1]),sser,
                               IntToStr(fr_ClientAdm.kod_smen)]);
     parametry[4]:=VarArrayOf(['nom_schet','summa','seria','smena']);
     parametry[5]:=0;
     resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
     If resSQL <>0 Then Begin
       fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
       MessageDlg('ОШИБКА !!!!!!  ОШИБКА !!!!!!!  Испорченный счет пропал!!!', mtWarning, [mbOk], 0);
     end
     Else fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
     MessageDlg('Напечатанный бланк счета подлежит учету!', mtConfirmation, [mbOk], 0);
     Screen.Cursor:=crDefault;
     Exit;
  end;
  //fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
  fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
  If s_zvtr>0 then Begin
    parametry[0]:=190;
    parametry[1]:=fr_ClientAdm.kod_adm;
    parametry[2]:=2;
    parametry[3]:=VarArrayOf([IntToStr(sutki*ed_kvmest.Value),IntToStr(fr_ClientAdm.kod_smen)]);
    parametry[4]:=VarArrayOf(['talons','smena']);
    parametry[5]:=0;
    If not lb_x.Visible Then Begin
       fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
       resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry)
    end
    Else resSQL:=0;
    If resSQL <>0 Then fr_ClientAdm.MIDASConnection1.AppServer.BackTrans
    Else Begin
      If not lb_x.Visible Then fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
      MessageDlg('Вставте бланк для '+IntToStr(sutki*ed_kvmest.Value)+
                         ' талонов! Нажмите <Ок>', mtConfirmation, [mbOk], 0);
      If s_zvtr>0 Then Print_talons(sutki*ed_kvmest.Value, IntToStr(schet),sser);
    end;
  end;
  Dec(fr_ClientAdm.numch);
  MessageDlg('Гость успешно поселен!', mtInformation, [mbOk], 0);
  If (fr_ClientAdm.settings[9][0] = 1) and (not VarIsNull(fr_ClientAdm.DrvFR)) Then Begin
     If not fr_ClientAdm.PrintChekFRK(v_schet[7][1]) Then
        MessageDlg('ВНИМАНИЕ!! Чек не напечатан!', mtError,[mbOk], 0);
  end;
  fr_simpl_polelen.Close;
end;

procedure Tfr_simpl_polelen.bt_dat_s_unlockClick(Sender: TObject);
begin
   ed_date_in.Enabled:=ed_date_out.Enabled;
end;

procedure Tfr_simpl_polelen.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   fr_ClientAdm.cds_sp2.Active:=false;
   fr_ClientAdm.cds_sp3.Active:=false;
   fr_ClientAdm.cds_sp1.Active:=false;
end;

end.
