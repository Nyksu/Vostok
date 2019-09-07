unit Move_gost_bn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Buttons, StdCtrls, Grids, DBGrids, Spin, DBCtrls, change_nomer,
  Ask_dlg, prn_talons;

type
  Tfr_move_bn_gost = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    ed_nom_komn: TSpinEdit;
    bt_gost: TButton;
    tb_gost: TDBGrid;
    rg_tip_move: TRadioGroup;
    bt_change_nomer: TBitBtn;
    Label4: TLabel;
    Bevel1: TBevel;
    lb_nomer: TLabel;
    bt_move: TBitBtn;
    bt_cancel: TBitBtn;
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
    dat_in : Tdate;
    lnd : integer;
    mest : integer;
    gost : integer;
    pol : string;
    time_out : string[8];
    tim_in : string[8];
    time_work : TTime;
    sutki : real;
    s_zvtr : real;
    tal_vozvr : integer;
    fam : string;
    io : string;
    dat_work : TDate;
    sum_sut_new : real;
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Move_bznal;

var
  fr_move_bn_gost: Tfr_move_bn_gost;

implementation

uses MainADM;

{$R *.DFM}

Procedure Move_bznal;
Begin
  try
    try
      fr_move_bn_gost:=Tfr_move_bn_gost.Create(Application);
      fr_move_bn_gost.dat_work:=StrToDate(DateToStr(date));
      fr_move_bn_gost.time_work:=time;
      fr_move_bn_gost.ShowModal;
    finally
      fr_move_bn_gost.free;
    end;
  except
  end;
end;

procedure Tfr_move_bn_gost.bt_gostClick(Sender: TObject);
var
 parametry : variant;
 resSQL,res_op : integer;
begin
  If ed_nom_komn.text>'' Then Begin
     tb_gost.Enabled:=true;
     bt_move.Enabled:=false;
     rg_tip_move.Enabled:=true;
     lb_nomer.Caption:='0';
     nomer_to:=0;
     fr_ClientAdm.CDS_work.Active:=false;
     nomer:=0;
     dat_s:=date;
     dat_po:=date;
     fr_ClientAdm.CDS_sp1.Active:=false;
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

procedure Tfr_move_bn_gost.bt_change_nomerClick(Sender: TObject);
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
    MessageDlg('В номере не проживают гости с безналичным расчетом!', mtWarning, [mbOk], 0);
    Exit;
  end;
  dat_po:=fr_ClientAdm.CDS_work.FieldByName('date_out').AsDateTime;
  dat_in:=fr_ClientAdm.CDS_work.FieldByName('date_in').AsDateTime;
  If dat_po <= dat_s Then Begin
    MessageDlg('У гостя задолженность по оплате номера! Сначала произведите продление', mtWarning, [mbOk], 0);
    Exit;
  end;
  tal_vozvr:=0;
  lnd:=fr_ClientAdm.CDS_work.FieldByName('land').AsInteger;
  mest:=fr_ClientAdm.CDS_work.FieldByName('mests').AsInteger;
  gost:=fr_ClientAdm.CDS_work.FieldByName('kod_gost').AsInteger;
  pol:=fr_ClientAdm.CDS_work.FieldByName('pol').AsString;
  time_out:=fr_ClientAdm.CDS_work.FieldByName('time_out').AsString;
  fam:=fr_ClientAdm.CDS_work.FieldByName('famil').AsString;
  io:=fr_ClientAdm.CDS_work.FieldByName('io').AsString;
  nomer:=ed_nom_komn.Value;
  param:=VarArrayCreate([0, 2], varVariant);
  param[0]:=2;{получаем текущую стоимость номера}
  param[1]:=VarArrayOf([IntToStr(lnd),IntToStr(nomer)]);
  param[2]:=VarArrayOf(['land','nomer']);
  rs:=fr_ClientAdm.GetTehParam(178,param);
  sum_sut_new:=rs[1];
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
  fr_ClientAdm.cds_jur.Active:=true;
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
  If s_zvtr>0 Then Begin
        param[1]:=VarArrayOf([IntToStr(nomer)]);
        rs:=fr_ClientAdm.GetTehParam(177,param);
        If VarIsNull(rs[1]) Then tal_vozvr:=1;
        param[1]:=VarArrayOf([IntToStr(nomer_to)]);
        rs:=fr_ClientAdm.GetTehParam(177,param);
        If not VarIsNull(rs[1]) Then s_zvtr:=0;
        If tal_vozvr=1 Then Begin
           If s_zvtr=0 Then tal_vozvr:=-1 Else tal_vozvr:=0;
        end
        Else Begin
           If s_zvtr>0 Then tal_vozvr:=1;
        end;
  end;
  If (rg_tip_move.ItemIndex=1) or (rg_tip_move.ItemIndex=2) Then Begin
     sutki:=Round(dat_po-date);
     If time_work>StrToTime('18:00:00') Then sutki:=sutki-0.5;
     If time_out<>'12:00:00' Then sutki:=sutki+0.5;
  end;
end;

procedure Tfr_move_bn_gost.bt_cancelClick(Sender: TObject);
begin
  fr_move_bn_gost.Close;
end;

procedure Tfr_move_bn_gost.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  fr_ClientAdm.CDS_work.Active:=false;
end;

procedure Tfr_move_bn_gost.bt_moveClick(Sender: TObject);
var
  par, rs, parametry : variant;
  strsql : string;
  resSQL : integer;
begin
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
                    +#13+'Для выбора другого номера нажмит <ДА>',true) Then Exit;

           {Изменить статус проживания}
  fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
  If dat_s=dat_in Then Begin
     parametry[0]:=230;
     parametry[1]:=fr_ClientAdm.kod_adm;
     parametry[2]:=2;
     parametry[3]:=VarArrayOf([IntToStr(gost),IntToStr(nomer)]);
     parametry[4]:=VarArrayOf(['gost','nomer']);
     parametry[5]:=0;
     resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
     If resSQL<0 Then Begin
      fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
      MessageDlg('Ошибка миграции гостя! Попробуйте снова.', mtWarning, [mbOk], 0);
      Exit;
     end;
  end;
  parametry[0]:=170;
  parametry[1]:=fr_ClientAdm.kod_adm;
  parametry[2]:=5;
  parametry[3]:=VarArrayOf([DateToStr(dat_s),time_out,IntToStr(gost),'1',
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

  If fr_ClientAdm.settings[1][0]=0 Then Begin
           {Помечаем места как "грязные"}
    fr_ClientAdm.MIDASConnection1.AppServer.ChangeZMN(date,date,4,Mest,Nomer);
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

  fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;

  If tal_vozvr<>0 Then Begin
     tal_vozvr:=tal_vozvr*Round(dat_po-dat_s)*mest;
     If tal_vozvr<0 Then Begin
        MessageDlg('Гость должен вернуть '+IntToStr(tal_vozvr)+' талонов !!!!!!', mtWarning, [mbOk], 0);
     end
     Else If tal_vozvr>0 Then Begin
       parametry[0]:=190;
       parametry[1]:=fr_ClientAdm.kod_adm;
       parametry[2]:=2;
       parametry[3]:=VarArrayOf([IntToStr(tal_vozvr),IntToStr(fr_ClientAdm.kod_smen)]);
       parametry[4]:=VarArrayOf(['talons','smena']);
       parametry[5]:=0;
       fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
       resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
       If resSQL <>0 Then fr_ClientAdm.MIDASConnection1.AppServer.BackTrans
       Else Begin
         fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
         MessageDlg('Вставте бланк для '+IntToStr(tal_vozvr)+
                         ' талонов! Нажмите <Ок>', mtConfirmation, [mbOk], 0);
         If s_zvtr>0 Then Print_talons(tal_vozvr,'БЕЗНАЛ','Заявка № '+IntToStr(0));
       end;
     end;
  end;

  MessageDlg('Гость успешно переведен в другой номер!', mtInformation, [mbOk], 0);
  fr_move_bn_gost.Close;
end;

procedure Tfr_move_bn_gost.tb_gostDblClick(Sender: TObject);
begin
   rg_tip_move.SetFocus;
end;

procedure Tfr_move_bn_gost.tb_gostKeyPress(Sender: TObject; var Key: Char);
begin
   If key=#13 Then rg_tip_move.SetFocus;
end;

end.
