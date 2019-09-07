unit MainADM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ToolWin, Menus, DBClient, MIDASCon, Buttons,
  DBCtrls, DBTables, Grids, DBGrids, Db, autitarif, ed_arif, simpl_polelen,
  MConnect, vozvr_nal, prodl_nal, Move_gost, Go_out, registry, prn_otch_sch,
  prn_otch_ord, prn_otch_sch_del, bn_poselen, Move_gost_bn, prodl_bznal,
  SConnect, prodl_bn_lst, RXClock, find_gost, DateUtil, nom_sost, Corrector,
  Calc_besnal, Post, progress_window, group_schet, Kvo_gosts, GetDataDlg,
  prn_ingosts, prn_sng_gosts, dubSch, List_grup, ComObj;

type
  Tfr_ClientAdm = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Panel1: TPanel;
    Status: TStatusBar;
    MainPages: TPageControl;
    ts_registr: TTabSheet;
    ts_work: TTabSheet;
    ts_vedspr: TTabSheet;
    ts_info: TTabSheet;
    ts_reports: TTabSheet;
    ed_login: TEdit;
    ed_psw: TEdit;
    bt_connect: TButton;
    bt_disconnect: TButton;
    Label1: TLabel;
    bt_EXIT: TButton;
    Label2: TLabel;
    Bevel1: TBevel;
    Memo1: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    CDS_jur: TClientDataSet;
    CDS_sp1: TClientDataSet;
    CDS_sp2: TClientDataSet;
    CDS_sp3: TClientDataSet;
    CDS_work: TClientDataSet;
    ds_jur: TDataSource;
    ds_sp1: TDataSource;
    ds_sp2: TDataSource;
    ds_sp3: TDataSource;
    ds_work: TDataSource;
    CDS_teh: TClientDataSet;
    Spr_pages: TPageControl;
    ts_groups: TTabSheet;
    ts_nomers: TTabSheet;
    ts_predm: TTabSheet;
    ts_osnast: TTabSheet;
    grd_groups: TDBGrid;
    DBNavigator1: TDBNavigator;
    bt_ins_grup: TBitBtn;
    bt_ed_grup: TBitBtn;
    bt_del_grup: TBitBtn;
    bt_sav_grup: TButton;
    bt_cnsl_grup: TButton;
    ed_group_nam: TEdit;
    Label6: TLabel;
    grd_nomers: TDBGrid;
    bt_ins_nom: TBitBtn;
    bt_ed_nom: TBitBtn;
    bt_sav_nom: TButton;
    bt_cnsl_nom: TButton;
    bt_del_nom: TBitBtn;
    ed_nom_nom: TEdit;
    ed_nom_mest: TComboBox;
    ed_nom_klas: TComboBox;
    ed_nom_grp: TDBLookupComboBox;
    ed_nom_flo: TComboBox;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    grd_predm: TDBGrid;
    bt_ins_pred: TBitBtn;
    bt_ed_pred: TBitBtn;
    bt_sav_pred: TButton;
    bt_cnsl_pred: TButton;
    bt_del_pred: TBitBtn;
    DBNavigator2: TDBNavigator;
    GroupBox2: TGroupBox;
    Label12: TLabel;
    ed_pred_nam: TEdit;
    ed_pred_tar: TEdit;
    Label13: TLabel;
    grd_nom_osna: TDBGrid;
    grd_osna_osna: TDBGrid;
    grd_pred_osna: TDBGrid;
    bt_add_pred: TBitBtn;
    bt_setout_pred: TBitBtn;
    ts_tarifs: TTabSheet;
    grd_nom_farif: TDBGrid;
    Splitter1: TSplitter;
    Panel2: TPanel;
    grd_tarif_farif: TDBGrid;
    Panel3: TPanel;
    Label14: TLabel;
    dbt_nomer_trf: TDBText;
    Label15: TLabel;
    dbt_grup_trf: TDBText;
    bt_auto_tarif: TButton;
    bt_update_tarif: TButton;
    Panel4: TPanel;
    DBGrid1: TDBGrid;
    Panel_work1: TPanel;
    Panel_work2: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    bt_poselenie: TBitBtn;
    bt_prodlenie: TBitBtn;
    bt_perevod: TBitBtn;
    Bevel2: TBevel;
    rb_simpl_poselen: TRadioButton;
    rb_predp_poselen: TRadioButton;
    rb_ch_z_poselen: TRadioButton;
    bt_viselenie: TBitBtn;
    rb_grup_poselen: TRadioButton;
    rb_fix_sum: TRadioButton;
    bt_vozvrat: TBitBtn;
    bt_tek_otchets: TBitBtn;
    MIDASConnection1: TSocketConnection;
    Timer1: TTimer;
    RxClock1: TRxClock;
    bt_cash_check: TButton;
    bt_find_gost: TBitBtn;
    bt_sost_nom: TBitBtn;
    N5: TMenuItem;
    n_korrect: TMenuItem;
    bt_calc_besnal: TBitBtn;
    N_post: TMenuItem;
    bt_reset_tar: TButton;
    bt_lock_reset: TBitBtn;
    bt_lock_otchet: TBitBtn;
    bt_grup_sch: TBitBtn;
    bt_kvo_ingost: TBitBtn;
    bt_sng_lst: TBitBtn;
    bt_ingos_lst: TBitBtn;
    bt_dpsch: TBitBtn;
    bt_gr_schets: TBitBtn;
    Timer2: TTimer;
    pn_frk_key: TGroupBox;
    bt_fr_x_report: TButton;
    bt_fr_z_report: TButton;
    bt_fr_options: TButton;
    bt_fr_print: TButton;
    procedure N3Click(Sender: TObject);
    procedure bt_connectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bt_disconnectClick(Sender: TObject);
    procedure MainPagesChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure ed_loginKeyPress(Sender: TObject; var Key: Char);
    procedure ed_pswKeyPress(Sender: TObject; var Key: Char);
    procedure MainPagesChange(Sender: TObject);
    procedure ts_groupsEnter(Sender: TObject);
    procedure bt_ins_grupClick(Sender: TObject);
    procedure ed_group_namKeyPress(Sender: TObject; var Key: Char);
    procedure bt_sav_grupClick(Sender: TObject);
    procedure bt_cnsl_grupClick(Sender: TObject);
    procedure bt_ed_gruplick(Sender: TObject);
    procedure Spr_pagesChanging(Sender: TObject; var AllowChange: Boolean);
    procedure Spr_pagesChange(Sender: TObject);
    procedure bt_del_grupClick(Sender: TObject);
    procedure ts_nomersEnter(Sender: TObject);
    procedure bt_ins_nomClick(Sender: TObject);
    procedure bt_sav_nomClick(Sender: TObject);
    procedure bt_cnsl_nomClick(Sender: TObject);
    procedure bt_ed_nomClick(Sender: TObject);
    procedure bt_del_nomClick(Sender: TObject);
    procedure bt_ins_predClick(Sender: TObject);
    procedure bt_ed_predClick(Sender: TObject);
    procedure bt_del_predClick(Sender: TObject);
    procedure bt_sav_predClick(Sender: TObject);
    procedure bt_cnsl_predClick(Sender: TObject);
    procedure ts_predmEnter(Sender: TObject);
    procedure ed_nom_nomKeyPress(Sender: TObject; var Key: Char);
    procedure ed_nom_mestKeyPress(Sender: TObject; var Key: Char);
    procedure ed_nom_klasKeyPress(Sender: TObject; var Key: Char);
    procedure ed_nom_grpKeyPress(Sender: TObject; var Key: Char);
    procedure ed_nom_floKeyPress(Sender: TObject; var Key: Char);
    procedure grd_nomersKeyPress(Sender: TObject; var Key: Char);
    procedure grd_predmKeyPress(Sender: TObject; var Key: Char);
    procedure ed_pred_namKeyPress(Sender: TObject; var Key: Char);
    procedure ed_pred_tarKeyPress(Sender: TObject; var Key: Char);
    procedure ts_osnastEnter(Sender: TObject);
    procedure bt_add_predClick(Sender: TObject);
    procedure bt_setout_predClick(Sender: TObject);
    procedure ts_tarifsEnter(Sender: TObject);
    procedure bt_auto_tarifClick(Sender: TObject);
    procedure bt_update_tarifClick(Sender: TObject);
    procedure bt_poselenieClick(Sender: TObject);
    procedure ts_workEnter(Sender: TObject);
    procedure bt_vozvratClick(Sender: TObject);
    procedure bt_prodlenieClick(Sender: TObject);
    procedure bt_perevodClick(Sender: TObject);
    procedure bt_viselenieClick(Sender: TObject);
    procedure bt_tek_otchetsClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure bt_cash_checkClick(Sender: TObject);
    procedure bt_find_gostClick(Sender: TObject);
    procedure bt_sost_nomClick(Sender: TObject);
    procedure n_korrectClick(Sender: TObject);
    procedure bt_calc_besnalClick(Sender: TObject);
    procedure N_postClick(Sender: TObject);
    procedure bt_reset_tarClick(Sender: TObject);
    procedure bt_lock_resetClick(Sender: TObject);
    procedure bt_lock_otchetClick(Sender: TObject);
    procedure rb_grup_poselenClick(Sender: TObject);
    procedure rb_simpl_poselenClick(Sender: TObject);
    procedure bt_grup_schClick(Sender: TObject);
    procedure bt_kvo_ingostClick(Sender: TObject);
    procedure bt_sng_lstClick(Sender: TObject);
    procedure bt_ingos_lstClick(Sender: TObject);
    procedure bt_dpschClick(Sender: TObject);
    procedure bt_gr_schetsClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure bt_fr_optionsClick(Sender: TObject);
    procedure bt_fr_z_reportClick(Sender: TObject);
    procedure bt_fr_x_reportClick(Sender: TObject);
    procedure bt_fr_printClick(Sender: TObject);
  private
    procedure Re;
    procedure FreeFR;
    procedure CancelFR;
    { Private declarations }
  public
   kod_adm : integer;
   nom_adm : integer;
   kod_smen : integer;
   settings : variant;
   numch : integer;
   kkmpsw : integer;
   port_kkm : integer;
   DrvFR : OleVariant;
   procedure Cleaner;
   function InitKKM(nport:integer) : boolean;
   function TestStateFRK : boolean;
   function PrintChekFRK(sum : real) : boolean;
   function GetTehParam(nsql : integer; param : variant) : variant;
   function GetData(nsql : integer; param : variant) : variant;
   function NextID(nsql : integer) : longint;
   function GetSumChet(lgota,nomer,mest,strana,bron:integer;sutok
                         ,zavtrak:real;prostoy:integer;is_sec_pol:boolean) : variant;
    { Public declarations }
  end;

var
  fr_ClientAdm: Tfr_ClientAdm;
  connect : boolean;
  ch_connect  : integer;
  diagnos_tbl : array [0..4] of integer;
  lastpages : integer;
  rus, lat : HKL;
  test_post : boolean;
  {diagnos_tbl - (1 - инс, 2 - едит, 3- дел, 0 - нет изменений) [0]jur, [1..3]spr1..3,
  [4]work}

implementation

{$R *.DFM}

procedure Tfr_ClientAdm.Cleaner;
Begin
  CDS_jur.Active:=false;
  CDS_jur.MasterFields:='';
  CDS_jur.MasterSource:=nil;
  CDS_jur.IndexFieldNames:='';
  CDS_jur.IndexName:='';
  CDS_sp1.Active:=false;
  CDS_sp1.MasterFields:='';
  CDS_sp1.MasterSource:=nil;
  CDS_sp1.IndexFieldNames:='';
  CDS_sp1.IndexName:='';
  CDS_sp2.Active:=false;
  CDS_sp2.MasterFields:='';
  CDS_sp2.MasterSource:=nil;
  CDS_sp2.IndexFieldNames:='';
  CDS_sp2.IndexName:='';
  CDS_sp3.Active:=false;
  CDS_sp3.MasterFields:='';
  CDS_sp3.MasterSource:=nil;
  CDS_sp3.IndexFieldNames:='';
  CDS_sp3.IndexName:='';
  CDS_work.Active:=false;
  CDS_work.MasterFields:='';
  CDS_work.MasterSource:=nil;
  CDS_work.IndexFieldNames:='';
  CDS_work.IndexName:='';
  ed_nom_grp.DataField:='';
  ed_nom_grp.KeyField:='';
  ed_nom_grp.ListField:='';
  dbt_nomer_trf.DataField:='';
  dbt_grup_trf.DataField:='';
end;

function Tfr_ClientAdm.GetSumChet(lgota,nomer,mest,strana,bron:integer;
         sutok,zavtrak:real;prostoy:integer;is_sec_pol:boolean) : variant;
var
 k_vo_pred,k_vo_strok, ii, dir_lgot, re : integer;
 resultat, par, parametry, otvet : Variant;
 c_nom, c_pred, c_lgot, c_zavtrak, c_sut,
 c_sum, c_bron, c_prost, pros, lgot_prc, summa : real;
Begin
   parametry:=VarArrayCreate([0, 2], varVariant);
   parametry[0]:=1;{получаем кол-во предметов в номере}
   parametry[1]:=VarArrayOf([IntToStr(nomer)]);
   parametry[2]:=VarArrayOf([4]);
   resultat:=GetTehParam(141,parametry);
   k_vo_pred:=resultat[1];
   k_vo_strok:=7+k_vo_pred;{определяем количество строк результата}
   otvet:=VarArrayCreate([0, k_vo_strok], varVariant);
   otvet[0]:=k_vo_strok;
   parametry[0]:=2;{определение тарифа на проживание в номере (1 место 1 сутки)}
   parametry[1]:=VarArrayOf([IntToStr(nomer),IntToStr(strana)]);
   parametry[2]:=VarArrayOf([4,7]);
   resultat:=GetTehParam(142,parametry);
   If VarIsNull(resultat[1]) Then c_nom:=0
   Else c_nom:=resultat[1];
   If sutok>=1 Then c_zavtrak:=zavtrak Else c_zavtrak:=0;
   c_zavtrak:=zavtrak*mest;
   c_nom:=c_nom*mest;
   CDS_teh.Active:=false;
   c_pred:=0;
   If k_vo_pred>0 Then Begin
     par:=VarArrayCreate([0, 5], varVariant);
     par[0]:=143; {получаем тарифы на предметы}
     par[1]:=kod_adm;
     par[2]:=1;{количество параметров в sql}
     par[3]:=VarArrayOf([IntToStr(nomer)]);{параметры sql}
     par[4]:=VarArrayOf([4]);{номера строк параметров sql}
     par[5]:=6;
     re:=MIDASConnection1.AppServer.RunSQL(par);
     If re<>0 Then Begin
       otvet[0]:=0;
       Result:=otvet;
       Exit;
     end;
     try
       CDS_teh.Active:=true;
     except
       otvet[0]:=0;
       Result:=otvet;
       Exit;
     end;
     ii:=8;
     While not CDS_teh.EOF Do Begin
        c_pred:=c_pred+CDS_teh.FieldByName('tarif').AsFloat*mest;
        otvet[ii]:=VarArrayOf([CDS_teh.FieldByName('name').AsString,
                               CDS_teh.FieldByName('tarif').AsFloat*mest]);
        Inc(ii);
        CDS_teh.Next;
     end;
     CDS_teh.Active:=false;
   end;
   c_sut:=c_pred+c_nom+c_zavtrak;
   c_sum:=(c_sut-c_zavtrak)*sutok;
   If is_sec_pol Then c_sum:=c_sum+c_zavtrak*Round(sutok)
   Else c_sum:=c_sum+c_zavtrak*Trunc(sutok);
   If lgota>0 Then Begin
     parametry[0]:=1;{определяем направление льготы}
     parametry[1]:=VarArrayOf([IntToStr(lgota)]);
     parametry[2]:=VarArrayOf([4]);
     resultat:=GetTehParam(144,parametry);
     If VarIsNull(resultat[1]) Then dir_lgot:=0
     Else dir_lgot:=resultat[1];
     lgot_prc:=resultat[2];
     c_lgot:=0;
     Case dir_lgot of
        0 : c_lgot:=Round(c_sum*lgot_prc)/100;
        1 : c_lgot:=Round(c_sut*lgot_prc)/100;
     end;
   end
   Else c_lgot:=0;
   If bron > 0 Then Begin
      parametry[0]:=1;{Правила расчета суммы брони номера}
      parametry[1]:=VarArrayOf(['0']);
      parametry[2]:=VarArrayOf([4]);
      resultat:=GetTehParam(147,parametry);
      pros:=resultat[1];
      If resultat[2] = 'Р' Then c_bron:=pros
      Else Case resultat[3] of
         0 : c_bron:=Round(pros*c_sum)/100;
         1 : c_bron:=Round(pros*c_sut)/100;
      end;
      //If strana>=50 Then c_bron:=0;
   end
   Else c_bron:=0;
   If prostoy > 0 Then Begin
      parametry[0]:=0;{Правила расчета суммы простоя номера}
      parametry[1]:=VarArrayOf(['']);
      parametry[2]:=VarArrayOf([-1]);
      resultat:=GetTehParam(147,parametry);
      pros:=resultat[1];
      If resultat[2] = 'Р' Then c_prost:=pros
      Else Case resultat[3] of
         0 : c_prost:=Round(pros*c_sum)/100;
         1 : c_prost:=Round(pros*c_sut)/100;
      end;
   end
   Else c_prost:=0;
   summa:=c_sum+c_bron+c_prost-c_lgot;
   otvet[1]:=VarArrayOf(['Стоимость проживания 1 суток :',c_sut]);
   otvet[2]:=VarArrayOf(['Итого проживание в номере :',c_sum,1]);
   otvet[3]:=VarArrayOf(['Льгота :',c_lgot,2]);
   otvet[4]:=VarArrayOf(['Простой :',c_prost,3]);
   otvet[5]:=VarArrayOf(['Бронь :',c_bron,4]);
   otvet[6]:=VarArrayOf(['Завтрак на 1 сут. :',c_zavtrak]);
   otvet[7]:=VarArrayOf(['ИТОГО к оплате :',summa]);
   Result:=otvet;
end;

procedure Tfr_ClientAdm.N3Click(Sender: TObject);
begin
  Timer2.Enabled:=false;
  fr_ClientAdm.Close;
end;

procedure Tfr_ClientAdm.bt_connectClick(Sender: TObject);
var
  log,re,re1,parametry : Variant;
  time_serv : TDateTime;
  sys_date : TSystemTime;
  ch_mail : integer;
begin
  nom_adm:=-1;
  kod_smen:=0;
  numch:=0;
  test_post:=true;
  Try
   try
    screen.Cursor:=crHourGlass;
    MIDASConnection1.Connected:=true;
   finally
    screen.Cursor:=crDefault;
   end;
  except
    MessageDlg('Нет базы!! Или Вы не зашли в сеть!!', mtWarning, [mbOk], 0);
    exit;
  end;
  If settings[6][0]=0 Then Begin
     time_serv:=MIDASConnection1.AppServer.Idle;
     time_serv:=IncHour(time_serv,-1*settings[7][0]);
     //ShowMessage(DateTimeToStr(time_serv));
     DateTimeToSystemTime(time_serv,sys_date);
     SetSystemTime(sys_date);
  end;
  log:=VarArrayCreate([0,1], varVariant);
  log[0]:=ed_login.text;
  log[1]:=ed_psw.text;
  kod_adm:=MIDASConnection1.AppServer.Reception(log);
  If kod_adm<=0 Then Begin
    MIDASConnection1.Connected:=false;
    connect:=false;
    Dec(ch_connect);
    If ch_connect=0 Then Begin
       MessageDlg('Полный отказ доступа.', mtWarning, [mbOk], 0);
       MessageDlg('О следующей попытке взлома будет информирована служба безопасности.', mtWarning, [mbOk], 0);
       fr_ClientAdm.Close;
    end;
    label4.Visible:=true;
    Label5.Enabled:=true;
    Label3.Visible:=false;
    ActivateKeyboardLayout(lat,0);
    ed_login.SetFocus;
    ed_psw.Text:='';
    Exit;
    {Добавить в регистри счетчик}
  end
  Else Begin
    label4.Visible:=false;
    Label5.Enabled:=false;
    Label3.Visible:=true;
    connect:=true;
    ch_connect:=3;
    bt_disconnect.Enabled:=true;
    bt_connect.Enabled:=false;
    parametry:=VarArrayCreate([0, 2], varVariant);
    parametry[0]:=1;{получаем номер администратора}
    parametry[1]:=VarArrayOf([#39+ed_login.text+#39]);
    parametry[2]:=VarArrayOf([3]);
    re:=GetTehParam(156,parametry);
    nom_adm:=re[1];
    parametry[0]:=2;{Ищем смену администратора}
    parametry[1]:=VarArrayOf([#39+DateToStr(date-2)+#39,IntToStr(nom_adm)]);
    parametry[2]:=VarArrayOf([3,6]);
    re:=GetTehParam(160,parametry);
    kod_smen:=-1;
    If (VarIsNull(re[1]))or(settings[4][0]=1) Then Begin
      parametry[0]:=1;{Занести новую смену}
      parametry[1]:=VarArrayOf([#39+DateToStr(date)+#39+','+
                                #39+TimeToStr(time)+#39+','+
                                IntToStr(nom_adm)+',0,0,0']);
      parametry[2]:=VarArrayOf([3]);
      MIDASConnection1.AppServer.StartTrans;
      re1:=GetTehParam(1002,parametry);
      If VarIsNull(re1[1]) Then Begin
         MIDASConnection1.AppServer.BackTrans;
         kod_smen:=-1;
      end
      Else Begin
        MIDASConnection1.AppServer.CommitTrans;
        kod_smen:=re1[1];
      end;
    end
    Else if re[5]=0 Then kod_smen:=re[1]
  end;
  ActivateKeyboardLayout(rus,0);
  ed_psw.Text:='';
  If kod_smen<0 Then Begin
     MessageDlg('Ваша смена закрыта!', mtWarning, [mbOk], 0);
     ed_login.Text:='';
     bt_disconnectClick(Sender);
     ActivateKeyboardLayout(lat,0);
  end
  Else Begin
     ch_mail:=MIDASConnection1.AppServer.CheckNewMessages;
     If ch_mail>0 Then Begin
       ShowMessage(IntToStr(ch_mail)+' новых писем!!');
       StartPost;
     end;
     N_post.Enabled:=true;
     N5.Enabled:=true;
     settings[8]:=MIDASConnection1.AppServer.GetRiteExtra;
     Timer2.Enabled:=true;
     kkmpsw:=kod_adm;
  end;
end;

procedure Tfr_ClientAdm.FormCreate(Sender: TObject);
var
 rr : Tregistry;
 ss : TStringList;
 indss : integer;
begin
  settings:=VarArrayCreate([0, 10], varVariant);
  connect:=false;
  ch_connect:=3;
  lastpages:=0;
  rus:=LoadKeyboardLayout('00000419', 0);
  lat:=LoadKeyboardLayout('00000409', 0);
  ActivateKeyboardLayout(lat,0);
  ss:=TstringList.Create;
  rr:=Tregistry.Create;
  rr.RootKey:= HKEY_LOCAL_MACHINE;
  rr.OpenKey('SOFTWARE\Vostok\Main_admin',true);
  rr.GetValueNames(ss);
  indss:=ss.IndexOf('Need_wash');
  If indss>=0 Then Begin
     settings[1]:=VarArrayOf([rr.ReadInteger(ss.Strings[indss]),'Помечать грязные номера при выезде гостя.']);
     If settings[1][0] < 0 Then Begin
         settings[1]:=VarArrayOf([0,'Помечать грязные номера при выезде гостя.']);
         rr.WriteInteger('Need_wash',settings[1][0]);
     end
  end
  Else Begin
    rr.WriteInteger('Need_wash',0);
    settings[1]:=VarArrayOf([0,'Помечать грязные номера при выезде гостя.']);
  end;
  indss:=ss.IndexOf('Test_bron');
  If indss>=0 Then Begin
     settings[2]:=VarArrayOf([rr.ReadInteger(ss.Strings[indss]),'Проверять номер брони при поселении.']);
     If settings[2][0] < 0 Then Begin
         settings[2]:=VarArrayOf([0,'Проверять номер брони при поселении.']);
         rr.WriteInteger('Test_bron',settings[2][0]);
     end
  end
  Else Begin
    rr.WriteInteger('Test_bron',0);
    settings[2]:=VarArrayOf([0,'Проверять номер брони при поселении.']);
  end;
  indss:=ss.IndexOf('Print_order');
  If indss>=0 Then Begin
     settings[3]:=VarArrayOf([rr.ReadInteger(ss.Strings[indss]),'Печатать расходный кассовый ордер.']);
     If settings[3][0] < 0 Then Begin
         settings[3]:=VarArrayOf([0,'Печатать расходный кассовый ордер.']);
         rr.WriteInteger('Print_order',settings[3][0]);
     end
  end
  Else Begin
    rr.WriteInteger('Print_order',0);
    settings[3]:=VarArrayOf([0,'Печатать расходный кассовый ордер.']);
  end;
  indss:=ss.IndexOf('Is_duble_smens');
  If indss>=0 Then Begin
     settings[4]:=VarArrayOf([rr.ReadInteger(ss.Strings[indss]),'Возможность открытия 2-й смены подряд.']);
     If settings[4][0] < 0 Then Begin
         settings[4]:=VarArrayOf([0,'Возможность открытия 2-й смены подряд.']);
         rr.WriteInteger('Is_duble_smens',settings[4][0]);
     end
  end
  Else Begin
    rr.WriteInteger('Is_duble_smens',0);
    settings[4]:=VarArrayOf([0,'Возможность открытия 2-й смены подряд.']);
  end;
  indss:=ss.IndexOf('Server_name');
  If indss>=0 Then Begin
     settings[5]:=VarArrayOf([rr.ReadString(ss.Strings[indss]),'*Имя сервера.']);
  end
  Else Begin
    rr.WriteString('Server_name','localhost');
    settings[5]:=VarArrayOf(['localhost','*Имя сервера.']);
  end;
  indss:=ss.IndexOf('Is_server_time');
  If indss>=0 Then Begin
     settings[6]:=VarArrayOf([rr.ReadInteger(ss.Strings[indss]),'Брать время и дату с сервера.']);
     If settings[6][0] < 0 Then Begin
         settings[6]:=VarArrayOf([0,'Брать время и дату с сервера.']);
         rr.WriteInteger('Is_server_time',settings[6][0]);
     end
  end
  Else Begin
    rr.WriteInteger('Is_server_time',0);
    settings[6]:=VarArrayOf([0,'Брать время и дату с сервера.']);
  end;
  indss:=ss.IndexOf('Delta_local_time');
  If indss>=0 Then Begin
     settings[7]:=VarArrayOf([rr.ReadInteger(ss.Strings[indss]),'Разница времени с Гринвичем.']);
     If settings[7][0] < 0 Then Begin
         settings[7]:=VarArrayOf([0,'Разница времени с Гринвичем.']);
         rr.WriteInteger('Delta_local_time',settings[7][0]);
     end
  end
  Else Begin
    rr.WriteInteger('Delta_local_time',5);
    settings[7]:=VarArrayOf([0,'Разница времени с Гринвичем.']);
  end;
  MIDASConnection1.Host:=settings[5][0];

  // Кассовый аппарат
  kkmpsw:=0;
  DrvFR:=null;
  indss:=ss.IndexOf('KKM');
  If indss>=0 Then Begin
     settings[9]:=VarArrayOf([rr.ReadInteger(ss.Strings[indss]),'ККМ.']);
     If settings[9][0] < 0 Then Begin
         settings[9]:=VarArrayOf([0,'ККМ.']);
         rr.WriteInteger('KKM',settings[9][0]);
     end
  end
  Else Begin
    rr.WriteInteger('KKM',0);
    settings[9]:=VarArrayOf([0,'KKM.']);
  end;
  If settings[9][0] = 1 Then Begin
     indss:=ss.IndexOf('portKKM');
     If indss>=0 Then Begin
        port_kkm:=rr.ReadInteger(ss.Strings[indss]);
        kkmpsw:=1;
        If not InitKKM(port_kkm) Then settings[9]:=VarArrayOf([0,'KKM.']);
     end
     Else Begin
       rr.WriteInteger('portKKM',0);
       settings[9]:=VarArrayOf([0,'KKM.']);
     end;
  end;
  If settings[9][0] <> 1 Then FreeFR
  Else pn_frk_key.Visible:=true;
  Timer1.Enabled:=True;
  ss.Free;
end;

function Tfr_ClientAdm.PrintChekFRK(sum : real) : boolean;
Begin
  Result:=false;
  If not TestStateFRK Then Exit;
  try
   DrvFR.Quantity:=1;
   DrvFR.Price:=sum;
   DrvFR.Department:=1;
   DrvFR.Tax1:=0;
   DrvFR.Tax2:=0;
   DrvFR.Tax3:=0;
   DrvFR.Tax4:=0;
   DrvFR.StringForPrinting:='Услуги гостиницы';
   DrvFR.Sale;
   If DrvFR.ResultCode<>0 Then Begin
     MessageDlg(DrvFR.ResultCodeDescription, mtError,[mbOk], 0);
     Exit
   end;
   DrvFR.Summ1:=sum;
   DrvFR.Summ2:=0;
   DrvFR.Summ3:=0;
   DrvFR.Summ4:=0;
   DrvFR.DiscountOnCheck:=0;
   DrvFR.Tax1:=1;
   DrvFR.Tax2:=0;
   DrvFR.Tax3:=0;
   DrvFR.Tax4:=0;
   DrvFR.StringForPrinting:= '====================================';
   DrvFR.CloseCheck;
   If DrvFR.ResultCode<>0 Then Begin
     MessageDlg(DrvFR.ResultCodeDescription, mtError,[mbOk], 0);
     Exit
   end;
   Result:=true;
   DrvFR.DrawerNumber:=0;
   DrvFR.OpenDrawer;
  except
  end;
end;

function Tfr_ClientAdm.InitKKM(nport:integer) : boolean;
Begin
  Result:=false;
  try
  FreeFR;
  DrvFR:=CreateOleObject('Addin.DrvFR'); 
  DrvFR.Password := kkmpsw;
  DrvFR.ComNumber := nport;
  DrvFR.BaudRate := 6;
  DrvFR.Timeout := 100;
  DrvFR.Connect;
  Result:=true;
  Status.Panels.Items[1].Text:='ФР';
  pn_frk_key.Visible:=true;
  except
    FreeFR;
  end;
end;

procedure Tfr_ClientAdm.CancelFR;
Begin
  settings[9]:=VarArrayOf([0,'KKM.']);
  FreeFR;
end;

procedure Tfr_ClientAdm.FreeFR;
Begin
  if not VarIsNull(DrvFR) Then Begin
     try
       DrvFR.Disconnect;
     except
     end;
     //DrvFR.free;
     //DrvFR.dispose;
     DrvFR:=null;
  end;
  Status.Panels.Items[1].Text:='';
  pn_frk_key.Visible:=false;
end;

function Tfr_ClientAdm.TestStateFRK : boolean;
var
  needrefrash : boolean;
Begin
  Result:=false;
  needrefrash:=false;
  DrvFR.Password:=kkmpsw;
  If settings[9][0] <> 1 Then Exit;
  if VarIsNull(DrvFR) Then Exit;
  try
    Case DrvFR.ECRMode of
      0,2,4 : Begin // All rite
            // MessageDlg(DrvFR.ECRModeDescription, mtInformation,[mbOk], 0);
          end;
      3 : Begin // Need end smen
            MessageDlg('Необходимо напечатать отчет с гашением! Закрыть кассовую смену!', mtError,[mbOk], 0);
            if MessageDlg('напечатать отчет с гашением?',mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
            DrvFR.PrintReportWithCleaning;
            If DrvFR.ResultCode<>0 Then Begin
               MessageDlg(DrvFR.ResultCodeDescription, mtError,[mbOk], 0);
               MessageDlg('Необходимо вмешательсво кассового мастера!', mtInformation,[mbOk], 0);
               MessageDlg('Фискальный регистратор отключён (касса отключена)!', mtInformation,[mbOk], 0);
               CancelFR;
               Exit;
            end;
            needrefrash:=true;
          end;
      1,5,6,7,8,9,10,11,12,13,14,15 : Begin
            MessageDlg(DrvFR.ECRModeDescription, mtError,[mbOk], 0);
            MessageDlg('Необходимо вмешательсво кассового мастера!', mtInformation,[mbOk], 0);
            MessageDlg('Фискальный регистратор отключён (касса отключена)!', mtInformation,[mbOk], 0);
            CancelFR;
            Exit;
          end;
    Else Begin
      MessageDlg('Необходимо вмешательсво кассового мастера!', mtError,[mbOk], 0);
      MessageDlg('Фискальный регистратор отключён (касса отключена)!', mtInformation,[mbOk], 0);
      CancelFR;
      Exit;
    end;
    end;
    if needrefrash Then InitKKM(port_kkm);
    DrvFR.Password:=kkmpsw;
    DrvFR.GetECRStatus;
    if not DrvFR.ReceiptRibbonIsPresent Then Begin
       MessageDlg('Вставьте чековую ленту!!', mtError,[mbOk], 0);
       Exit;
    end; 
    if not DrvFR.EKLZIsPresent Then Begin
       MessageDlg('В аппарате нет ЭКЛЗ!! Вызывайте кассового мастера!', mtError,[mbOk], 0);
       MessageDlg('Фискальный регистратор отключён (касса отключена)!', mtInformation,[mbOk], 0);
       CancelFR;
       Exit;
    end;
    if not DrvFR.ReceiptRibbonOpticalSensor Then Begin
       MessageDlg('Чековая лента закончилась! Вставьте чековую ленту!!', mtError,[mbOk], 0);
       Exit;
    end;
    if DrvFR.LidPositionSensor Then Begin
       MessageDlg('Закройте крышку!!', mtError,[mbOk], 0);
       Exit;
    end;
    if DrvFR.IsPrinterLeftSensorFailure Then Begin
       MessageDlg('Отказ левого датчика печ. мех.! Вызывайте кассового мастера!', mtError,[mbOk], 0);
       MessageDlg('Фискальный регистратор отключён (касса отключена)!', mtInformation,[mbOk], 0);
       CancelFR;
       Exit;
    end; 
    if DrvFR.IsPrinterRightSensorFailure Then Begin
       MessageDlg('Отказ правого датчика печ. мех.! Вызывайте кассового мастера!', mtError,[mbOk], 0);
       MessageDlg('Фискальный регистратор отключён (касса отключена)!', mtInformation,[mbOk], 0);
       CancelFR;
       Exit;
    end;
    if DrvFR.IsEKLZOverflow Then Begin
       MessageDlg('ЭКЛЗ скоро закончится! Вызывайте кассового мастера!', mtError,[mbOk], 0);
       Exit;
    end;
    if DrvFR.FMOverflow Then Begin
       MessageDlg('Фискальная память переполнена! Вызывайте кассового мастера!', mtError,[mbOk], 0);
       Exit;
    end;
    Result:=true;
  except
  end;
end;

procedure Tfr_ClientAdm.bt_disconnectClick(Sender: TObject);
begin
  label4.Visible:=false;
  Label5.Enabled:=false;
  Label3.Visible:=false;
  Timer2.Enabled:=false;
  connect:=false;
  MIDASConnection1.Connected:=false;
  bt_disconnect.Enabled:=false;
  bt_connect.Enabled:=true;
  ed_login.Text:='';
  N_post.Enabled:=false;
  N5.Enabled:=false;
  ActivateKeyboardLayout(lat,0);
  ed_login.SetFocus;
end;

procedure Tfr_ClientAdm.MainPagesChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=connect;
  CDS_jur.Active:=false;
  CDS_sp1.Active:=false;
  CDS_sp2.Active:=false;
  CDS_sp3.Active:=false;
  CDS_work.Active:=false;
end;

procedure Tfr_ClientAdm.ed_loginKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 Then ed_psw.SetFocus;
end;

procedure Tfr_ClientAdm.ed_pswKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 Then bt_connect.SetFocus;
end;

procedure Tfr_ClientAdm.MainPagesChange(Sender: TObject);
begin
  lastpages:=0;
  Case MainPages.ActivePage.TabIndex of
     0 : Begin end;
     1 : Begin

         end;
     2 : Begin
           Spr_pages.ActivePage:=ts_groups;
           grd_groups.SetFocus;
         end;
     3 : Begin end;
     4 : Begin end;
  end;
end;

function Tfr_ClientAdm.GetData(nsql : integer; param : variant) : variant;  
var
 re, countfield, ii : integer;
 parametry,otvet : Variant;
 fildname : string;
 varmem : tstringlist;
Begin
   Result:=null;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=nsql;
   parametry[1]:=kod_adm;
   parametry[2]:=param[0];{количество параметров в sql}
   parametry[3]:=param[1];{параметры sql}
   parametry[4]:=param[2];{номера строк параметров sql}
   parametry[5]:=6;
   try
    re:=MIDASConnection1.AppServer.RunSQL(parametry);
   except
      re:=-1;
   end;
   If re=0 Then Begin
     CDS_teh.Open;
     Result:=CDS_teh.Data;
     CDS_teh.Active:=false;
   end;
end;

function Tfr_ClientAdm.GetTehParam(nsql : integer; param : variant) : variant;
var
 re, countfield, ii : integer;
 parametry,otvet : Variant;
 fildname : string;
 varmem : tstringlist;
Begin
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=nsql;
   parametry[1]:=kod_adm;
   parametry[2]:=param[0];{количество параметров в sql}
   parametry[3]:=param[1];{параметры sql}
   parametry[4]:=param[2];{номера строк параметров sql}
   parametry[5]:=6;
   try
    re:=MIDASConnection1.AppServer.RunSQL(parametry);
   except
      Result:=null;
      re:=-1;
   end;
   If re=0 Then Begin
     CDS_teh.Open;
     varmem:=Tstringlist.create;
     CDS_teh.GetFieldNames(Varmem);
     countfield:=Varmem.Count;
     otvet:=VarArrayCreate([0, countfield], varVariant);
     otvet[0]:=countfield;
     For ii:=1 to countfield Do Begin
       fildname:=Varmem.Strings[ii-1];
       otvet[ii]:=CDS_teh.FieldByName(fildname).Value;
     end;
     Result:=otvet;
     varmem.free;
     CDS_teh.Active:=false;
   end
   else Begin
      Result:=null;
   end;
end;

function Tfr_ClientAdm.NextID(nsql : integer) : longint;
var
 parametry, resultat : Variant;
Begin
   parametry:=VarArrayCreate([0, 2], varVariant);
   parametry[0]:=0;{количество параметров в sql}
   parametry[1]:=VarArrayOf(['']);{параметры sql}
   parametry[2]:=VarArrayOf([0]);{номера строк параметров sql}
   resultat:=GetTehParam(nsql,parametry);
   If not VarIsNull(resultat[1]) Then Result:=resultat[1]+1
   Else Result:=0;
end;

procedure Tfr_ClientAdm.ts_groupsEnter(Sender: TObject);
var
 resSQL : integer;
 parametry : Variant;
begin
   If lastpages = 1 Then Exit;
   lastpages:=1;
   Cleaner;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=104;
   parametry[1]:=kod_adm;
   parametry[2]:=0;
   parametry[3]:=VarArrayOf(['']);
   parametry[4]:=VarArrayOf([-1]);
   parametry[5]:=1;
   resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL=0 Then Begin
     CDS_jur.IndexFieldNames:='name_group';
     CDS_jur.Open;
   end
   else
     If resSQL=1 Then MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
end;

procedure Tfr_ClientAdm.bt_ins_grupClick(Sender: TObject);
begin
  diagnos_tbl[0]:=1;
  ed_group_nam.SetFocus;
  bt_ins_grup.Enabled:=false;
  bt_ed_grup.Enabled:=false;
  bt_del_grup.Enabled:=false;
end;

procedure Tfr_ClientAdm.ed_group_namKeyPress(Sender: TObject;
  var Key: Char);
begin
  If Key = #13 Then bt_sav_grup.SetFocus;
end;

procedure Tfr_ClientAdm.bt_sav_grupClick(Sender: TObject);
var
  ind : longint;
  str : string;
  resSQL : integer;
  parametry : Variant;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  Case diagnos_tbl[0] of
    1 : If ed_group_nam.Text > '' Then Begin
          ind:=NextID(105);
          str:='('+IntToStr(ind)+','+#39+ed_group_nam.Text+#39+');';
          parametry[0]:=106;
          parametry[1]:=kod_adm;
          parametry[2]:=1;
          parametry[3]:=VarArrayOf([str]);
          parametry[4]:=VarArrayOf([2]);
          parametry[5]:=0;
          MIDASConnection1.AppServer.StartTrans;
          resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
          If resSQL=0 Then Begin
             MIDASConnection1.AppServer.CommitTrans;
             CDS_jur.InsertRecord([ind,ed_group_nam.Text])
          end
          Else Begin
           MIDASConnection1.AppServer.BackTrans;
           If resSQL>0 Then MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0)
               Else MessageDlg('Ошибка. Повторите операцию. При повторе ошибки сообщите производителю.', mtWarning, [mbOk], 0);
          end;
        end;
    2 : If ed_group_nam.Text > '' Then Begin
          ind:=CDS_jur.FieldByName('nom_group').AsInteger;
          str:=#39+ed_group_nam.Text+#39;
          parametry[0]:=107;
          parametry[1]:=kod_adm;
          parametry[2]:=2;
          parametry[3]:=VarArrayOf([str,IntToStr(ind)]);
          parametry[4]:=VarArrayOf([2,5]);
          parametry[5]:=0;
          resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
          If resSQL=0 Then Begin
             CDS_jur.Edit;
             CDS_jur.FieldByName('name_group').Value:=ed_group_nam.Text;
             CDS_jur.Post;
          end
          Else If resSQL>0 Then MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0)
               Else MessageDlg('Ошибка. Повторите операцию. При повторе ошибки сообщите производителю.', mtWarning, [mbOk], 0);
        end;
  end;
  ed_group_nam.Text:='';
  bt_ins_grup.Enabled:=true;
  bt_ed_grup.Enabled:=true;
  bt_del_grup.Enabled:=true;
  grd_groups.SetFocus;
end;

procedure Tfr_ClientAdm.bt_cnsl_grupClick(Sender: TObject);
begin
  diagnos_tbl[0]:=0;
  ed_group_nam.Text:='';
  bt_ins_grup.Enabled:=true;
  bt_ed_grup.Enabled:=true;
  bt_del_grup.Enabled:=true;
  grd_groups.SetFocus;
end;

procedure Tfr_ClientAdm.bt_ed_gruplick(Sender: TObject);
begin
  diagnos_tbl[0]:=2;
  ed_group_nam.text:=CDS_jur.FieldByName('name_group').AsString;
  ed_group_nam.SetFocus;
  bt_ins_grup.Enabled:=false;
  bt_ed_grup.Enabled:=false;
  bt_del_grup.Enabled:=false;
end;

procedure Tfr_ClientAdm.Spr_pagesChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=connect;
  CDS_jur.Active:=false;
  CDS_sp1.Active:=false;
  CDS_sp2.Active:=false;
  CDS_sp3.Active:=false;
  CDS_work.Active:=false;
  Case Spr_pages.ActivePage.TabIndex of
     0 : Begin
         end;
     1 : Begin
           ed_nom_grp.DataField:='';
         end;
     2 : Begin end;
     3 : Begin end;
     4 : Begin end;
  end;
end;

procedure Tfr_ClientAdm.Spr_pagesChange(Sender: TObject);
begin
  Case Spr_pages.ActivePage.TabIndex of
     0 : Begin
         end;
     1 : Begin
         end;
     2 : Begin end;
     3 : Begin end;
     4 : Begin end;
  end;
  lastpages:=0;
end;

procedure Tfr_ClientAdm.bt_del_grupClick(Sender: TObject);
var
  ind : longint;
  resSQL : integer;
  parametry : Variant;
begin
  If MessageDlg('Вы действительно хотите удалить название группы номеров?',
  mtConfirmation, [mbYes, mbNo], 0) = mrYes then Begin
     parametry:=VarArrayCreate([0, 5], varVariant);
     ind:=CDS_jur.FieldByName('nom_group').AsInteger;
     parametry[0]:=108;
     parametry[1]:=kod_adm;
     parametry[2]:=1;
     parametry[3]:=VarArrayOf([IntToStr(ind)]);
     parametry[4]:=VarArrayOf([3]);
     parametry[5]:=0;
     MIDASConnection1.AppServer.StartTrans;
     resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
     If resSQL=0 Then Begin
         MIDASConnection1.AppServer.CommitTrans;
         CDS_jur.Delete;
     end
     Else begin
       MIDASConnection1.AppServer.BackTrans;
       If resSQL>0 Then MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0)
            Else MessageDlg('Нельзя удалить используюмую группу !!!', mtWarning, [mbOk], 0)
     end
  end;
end;

procedure Tfr_ClientAdm.ts_nomersEnter(Sender: TObject);
var
 resSQL, resSQL2 : integer;
 parametry, parametry2 : Variant;
begin
   If lastpages = 2 Then Exit;
   Screen.Cursor:=crHourGlass;
   lastpages:=2;
   Cleaner;
   ed_nom_grp.KeyField:='name_group';
   ed_nom_grp.ListField:='name_group';
   ed_nom_grp.DataField:='name_group';
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=109;
   parametry[1]:=kod_adm;
   parametry[2]:=0;
   parametry[3]:=VarArrayOf(['']);
   parametry[4]:=VarArrayOf([-1]);
   parametry[5]:=1;
   resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL=0 Then Begin
     parametry2:=VarArrayCreate([0, 5], varVariant);
     parametry2[0]:=104;
     parametry2[1]:=kod_adm;
     parametry2[2]:=0;
     parametry2[3]:=VarArrayOf(['']);
     parametry2[4]:=VarArrayOf([-1]);
     parametry2[5]:=2;
     resSQL2:=MIDASConnection1.AppServer.RunSQL(parametry2);
     If resSQL2=0 Then Begin
       CDS_sp1.IndexFieldNames:='name_group';
       CDS_sp1.Open;
     end
     else Begin
       If resSQL2=1 Then MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
       Screen.Cursor:=crDefault;
       Exit;
     end;
     CDS_jur.IndexFieldNames:='nomer';
     CDS_jur.Open;
   end
   else
     If resSQL=1 Then MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
   Screen.Cursor:=crDefault;
end;

procedure Tfr_ClientAdm.bt_ins_nomClick(Sender: TObject);
begin
  diagnos_tbl[0]:=1;
  ed_nom_nom.SetFocus;
  bt_ins_nom.Enabled:=false;
  bt_ed_nom.Enabled:=false;
  bt_del_nom.Enabled:=false;
  CDS_jur.Insert;
end;

procedure Tfr_ClientAdm.bt_sav_nomClick(Sender: TObject);
var
  ind : longint;
  str, kd_grp, s1,s2,s3,s4 : string;
  resSQL, p1, p2, p3 : integer;
  parametry : Variant;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  Case diagnos_tbl[0] of
    1 : If (ed_nom_nom.Text > '')and(ed_nom_grp.Text <> '') and
        (ed_nom_mest.Text<>'')and(ed_nom_klas.Text<>'') Then Begin
          kd_grp:=IntToStr(CDS_sp1.FieldByName('nom_group').AsInteger);
          str:='('+ed_nom_nom.Text+','+ed_nom_mest.Text+','+ed_nom_klas.text+
               ','+kd_grp+','+ed_nom_flo.text+');';
          parametry[0]:=110;
          parametry[1]:=kod_adm;
          parametry[2]:=1;
          parametry[3]:=VarArrayOf([str]);
          parametry[4]:=VarArrayOf([2]);
          parametry[5]:=0;
          MIDASConnection1.AppServer.StartTrans;
          resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
          If resSQL=0 Then Begin
             MIDASConnection1.AppServer.CommitTrans;
             str:=ed_nom_grp.Text;
             CDS_jur.Cancel;
             ind:=StrToInt(ed_nom_nom.text);
             p1:=StrToInt(ed_nom_mest.Text);
             p2:=StrToInt(ed_nom_klas.text);
             p3:=StrToInt(ed_nom_flo.text);
             CDS_jur.InsertRecord([ind,p1,p2,str,p3]);
          end
          Else Begin
            MIDASConnection1.AppServer.BackTrans;
            If resSQL>0 Then MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0)
               Else MessageDlg('Ошибка. Повторите операцию. При повторе ошибки сообщите производителю.', mtWarning, [mbOk], 0)
          end
        end;
    2 : If ed_nom_grp.Text > '' Then Begin
          If CDS_jur.State = dsEdit Then CDS_jur.Post;
          s1:=IntToStr(CDS_sp1.FieldByName('nom_group').Value);
          s2:=ed_nom_mest.Text;
          s3:=ed_nom_klas.Text;
          s4:=ed_nom_flo.Text;
          ind:=CDS_jur.FieldByName('nomer').AsInteger;
          parametry[0]:=111;
          parametry[1]:=kod_adm;
          parametry[2]:=5;
          parametry[3]:=VarArrayOf([s2,s3,s1,s4,IntToStr(ind)]);
          parametry[4]:=VarArrayOf([3,5,7,9,12]);
          parametry[5]:=0;
          MIDASConnection1.AppServer.StartTrans;
          resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
          If resSQL=0 Then Begin
             MIDASConnection1.AppServer.CommitTrans;
             If CDS_jur.State <> dsEdit Then CDS_jur.Edit;
             CDS_jur.FieldByName('mests').Value:=StrToInt(ed_nom_mest.Text);
             CDS_jur.FieldByName('klass').Value:=StrToInt(ed_nom_klas.Text);
             CDS_jur.FieldByName('floor').Value:=StrToInt(ed_nom_flo.Text);
             CDS_jur.Post;
          end
          Else  Begin
            MIDASConnection1.AppServer.BackTrans;
            If resSQL>0 Then MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0)
               Else MessageDlg('Ошибка. Повторите операцию. При повторе ошибки сообщите производителю.', mtWarning, [mbOk], 0)
          end
        end;
  end;
  ed_nom_nom.Text:='';
  ed_nom_mest.Text:='1';
  ed_nom_klas.Text:='2';
  {ed_nom_grp.Text:='';}
  ed_nom_flo.Text:='2';
  bt_ins_nom.Enabled:=true;
  bt_ed_nom.Enabled:=true;
  bt_del_nom.Enabled:=true;
  grd_nomers.SetFocus;
  diagnos_tbl[0]:=0;
end;

procedure Tfr_ClientAdm.bt_cnsl_nomClick(Sender: TObject);
begin
  ed_nom_nom.Text:='';
  ed_nom_mest.Text:='1';
  ed_nom_klas.Text:='2';
  {ed_nom_grp.Text:='';}
  ed_nom_flo.Text:='2';
  CDS_jur.Cancel;
  bt_ins_nom.Enabled:=true;
  bt_ed_nom.Enabled:=true;
  bt_del_nom.Enabled:=true;
  grd_nomers.SetFocus;
  diagnos_tbl[0]:=0;
end;

procedure Tfr_ClientAdm.bt_ed_nomClick(Sender: TObject);
begin
  ed_nom_mest.SetFocus;
  ed_nom_nom.Text:=IntToStr(CDS_jur.FieldByName('nomer').Value);
  ed_nom_mest.Text:=IntToStr(CDS_jur.FieldByName('mests').Value);
  ed_nom_klas.Text:=IntToStr(CDS_jur.FieldByName('klass').Value);
  ed_nom_flo.Text:=IntToStr(CDS_jur.FieldByName('floor').Value);
  bt_ins_nom.Enabled:=false;
  bt_ed_nom.Enabled:=false;
  bt_del_nom.Enabled:=false;
  diagnos_tbl[0]:=2;
end;

procedure Tfr_ClientAdm.bt_del_nomClick(Sender: TObject);
var
  ind : longint;
  resSQL : integer;
  parametry : Variant;
begin
  If MessageDlg('Вы действительно хотите удалить номер?',
  mtConfirmation, [mbYes, mbNo], 0) = mrYes then Begin
     parametry:=VarArrayCreate([0, 5], varVariant);
     ind:=CDS_jur.FieldByName('nomer').AsInteger;
     parametry[0]:=112;
     parametry[1]:=kod_adm;
     parametry[2]:=1;
     parametry[3]:=VarArrayOf([IntToStr(ind)]);
     parametry[4]:=VarArrayOf([3]);
     parametry[5]:=0;
     MIDASConnection1.AppServer.StartTrans;
     resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
     If resSQL=0 Then Begin
       MIDASConnection1.AppServer.CommitTrans;
       CDS_jur.Delete
     end
     Else Begin
        MIDASConnection1.AppServer.BackTrans;
        If resSQL>0 Then MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0)
            Else MessageDlg('Нельзя удалить используюемый номер !!!', mtWarning, [mbOk], 0)
     end;
  end;
end;

procedure Tfr_ClientAdm.bt_ins_predClick(Sender: TObject);
begin
  diagnos_tbl[0]:=1;
  ed_pred_nam.SetFocus;
  bt_ins_pred.Enabled:=false;
  bt_ed_pred.Enabled:=false;
  bt_del_pred.Enabled:=false;
end;

procedure Tfr_ClientAdm.bt_ed_predClick(Sender: TObject);
begin
  diagnos_tbl[0]:=2;
  ed_pred_nam.text:=CDS_jur.FieldByName('name').AsString;
  ed_pred_nam.SetFocus;
  ed_pred_tar.text:=FloatToStr(CDS_jur.FieldByName('tarif').Value);
  bt_ins_pred.Enabled:=false;
  bt_ed_pred.Enabled:=false;
  bt_del_pred.Enabled:=false;
end;

procedure Tfr_ClientAdm.bt_del_predClick(Sender: TObject);
var
  ind : longint;
  resSQL : integer;
  parametry : Variant;
begin
  If MessageDlg('Вы действительно хотите удалить название группы номеров?',
  mtConfirmation, [mbYes, mbNo], 0) = mrYes then Begin
     parametry:=VarArrayCreate([0, 5], varVariant);
     ind:=CDS_jur.FieldByName('Kod_pred').AsInteger;
     parametry[0]:=117;
     parametry[1]:=kod_adm;
     parametry[2]:=1;
     parametry[3]:=VarArrayOf([IntToStr(ind)]);
     parametry[4]:=VarArrayOf([3]);
     parametry[5]:=0;
     resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
     If resSQL=0 Then CDS_jur.Delete
     Else If resSQL>0 Then MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0)
            Else MessageDlg('Нельзя удалить используемый предмет !!!', mtWarning, [mbOk], 0)
  end;
end;

procedure Tfr_ClientAdm.bt_sav_predClick(Sender: TObject);
var
  ind : longint;
  str : string;
  resSQL : integer;
  parametry : Variant;
  reanom : real;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  Case diagnos_tbl[0] of
    1 : If (ed_pred_nam.Text > '') and (ed_pred_tar.Text > '') Then Begin
          Val(ed_pred_tar.Text,reanom,resSQL);
          If resSQL<>0 Then Begin
            ed_pred_tar.SetFocus;
            MessageDlg('Ошибка при вводе тарифа !', mtWarning, [mbOk], 0);
            Exit;
          end;
          ind:=NextID(114);
          str:='('+IntToStr(ind)+','+#39+ed_pred_nam.Text+#39+','+ed_pred_tar.Text+');';
          parametry[0]:=115;
          parametry[1]:=kod_adm;
          parametry[2]:=1;
          parametry[3]:=VarArrayOf([str]);
          parametry[4]:=VarArrayOf([2]);
          parametry[5]:=0;
          MIDASConnection1.AppServer.StartTrans;
          resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
          reanom:=StrToFloat(ed_pred_tar.Text);
          If resSQL=0 Then Begin
              MIDASConnection1.AppServer.CommitTrans;
              CDS_jur.InsertRecord([ind,ed_pred_nam.Text,reanom])
          end
          Else Begin
            MIDASConnection1.AppServer.BackTrans;
            If resSQL>0 Then MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0)
               Else ShowMessage('Ошибка. Повторите операцию. При повторе ошибки сообщите производителю.')
          end;
        end;
    2 : If ed_pred_nam.Text > '' Then Begin
          Val(ed_pred_tar.Text,reanom,resSQL);
          If resSQL<>0 Then Begin
            ed_pred_tar.SetFocus;
            MessageDlg('Ошибка при вводе тарифа !', mtWarning, [mbOk], 0);
            Exit;
          end;
          ind:=CDS_jur.FieldByName('Kod_pred').AsInteger;
          str:=#39+ed_pred_nam.Text+#39;
          parametry[0]:=116;
          parametry[1]:=kod_adm;
          parametry[2]:=3;
          parametry[3]:=VarArrayOf([str,ed_pred_tar.Text,IntToStr(ind)]);
          parametry[4]:=VarArrayOf([2,4,7]);
          parametry[5]:=0;
          MIDASConnection1.AppServer.StartTrans;
          resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
          If resSQL=0 Then Begin
             MIDASConnection1.AppServer.CommitTrans;
             CDS_jur.Edit;
             CDS_jur.FieldByName('name').Value:=ed_pred_nam.Text;
             reanom:=StrToFloat(ed_pred_tar.Text);
             CDS_jur.FieldByName('tarif').Value:=reanom;
             CDS_jur.Post;
          end
          Else Begin
             MIDASConnection1.AppServer.BackTrans;
             If resSQL>0 Then MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0)
               Else ShowMessage('Ошибка. Повторите операцию. При повторе ошибки сообщите производителю.')
          end
        end;
  end;
  ed_pred_nam.Text:='';
  ed_pred_tar.Text:='0';
  bt_ins_pred.Enabled:=true;
  bt_ed_pred.Enabled:=true;
  bt_del_pred.Enabled:=true;
  grd_predm.SetFocus;
end;

procedure Tfr_ClientAdm.bt_cnsl_predClick(Sender: TObject);
begin
  diagnos_tbl[0]:=0;
  ed_pred_nam.Text:='';
  ed_pred_tar.Text:='0';
  bt_ins_pred.Enabled:=true;
  bt_ed_pred.Enabled:=true;
  bt_del_pred.Enabled:=true;
  grd_predm.SetFocus;
end;

procedure Tfr_ClientAdm.ts_predmEnter(Sender: TObject);
var
 resSQL : integer;
 parametry : Variant;
begin
   If lastpages = 3 Then Exit;
   lastpages:=3;
   Cleaner;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=113;
   parametry[1]:=kod_adm;
   parametry[2]:=0;
   parametry[3]:=VarArrayOf(['']);
   parametry[4]:=VarArrayOf([-1]);
   parametry[5]:=1;
   resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL=0 Then Begin
     CDS_jur.IndexFieldNames:='name';
     CDS_jur.Open;
   end
   else
     If resSQL=1 Then MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
end;

procedure Tfr_ClientAdm.ed_nom_nomKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 Then ed_nom_mest.SetFocus;
end;

procedure Tfr_ClientAdm.ed_nom_mestKeyPress(Sender: TObject;
  var Key: Char);
begin
  If key = #13 Then ed_nom_klas.SetFocus;
end;

procedure Tfr_ClientAdm.ed_nom_klasKeyPress(Sender: TObject;
  var Key: Char);
begin
  If key = #13 Then ed_nom_grp.SetFocus;
end;

procedure Tfr_ClientAdm.ed_nom_grpKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 Then ed_nom_flo.SetFocus;
end;

procedure Tfr_ClientAdm.ed_nom_floKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 Then bt_sav_nom.SetFocus;
end;

procedure Tfr_ClientAdm.grd_nomersKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 Then bt_ins_nom.SetFocus;
end;

procedure Tfr_ClientAdm.grd_predmKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 Then ed_pred_nam.SetFocus;
end;

procedure Tfr_ClientAdm.ed_pred_namKeyPress(Sender: TObject;
  var Key: Char);
begin
  If key = #13 Then ed_pred_tar.SetFocus;
end;

procedure Tfr_ClientAdm.ed_pred_tarKeyPress(Sender: TObject;
  var Key: Char);
begin
  If key = #13 Then bt_sav_pred.SetFocus;
end;

procedure Tfr_ClientAdm.ts_osnastEnter(Sender: TObject);
var
 resSQL, resSQL2, resSQL3 : integer;
 parametry, parametry2 : Variant;
begin
   If lastpages = 4 Then Exit;
   Screen.Cursor:=crHourGlass;
   lastpages:=4;
   Cleaner;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=118;
   parametry[1]:=kod_adm;
   parametry[2]:=0;
   parametry[3]:=VarArrayOf(['']);
   parametry[4]:=VarArrayOf([-1]);
   parametry[5]:=2;
   resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL=0 Then Begin
     parametry2:=VarArrayCreate([0, 5], varVariant);
     parametry2[0]:=119;
     parametry2[1]:=kod_adm;
     parametry2[2]:=0;
     parametry2[3]:=VarArrayOf(['']);
     parametry2[4]:=VarArrayOf([-1]);
     parametry2[5]:=1;
     resSQL2:=MIDASConnection1.AppServer.RunSQL(parametry2);
     parametry:=VarArrayCreate([0, 5], varVariant);
     parametry[0]:=120;
     parametry[1]:=kod_adm;
     parametry[2]:=0;
     parametry[3]:=VarArrayOf(['']);
     parametry[4]:=VarArrayOf([-1]);
     parametry[5]:=3;
     resSQL3:=MIDASConnection1.AppServer.RunSQL(parametry);
     If (resSQL2=0)and(resSQL3=0) Then Begin
       CDS_sp1.Open;
       CDS_sp2.IndexFieldNames:='nomer';
       CDS_sp2.MasterSource:=ds_sp1;
       CDS_sp2.MasterFields:='nomer';
       CDS_sp2.Open;
     end
     else Begin
       MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
       Screen.Cursor:=crDefault;
       Exit;
     end;
     CDS_jur.IndexFieldNames:='nom';
     CDS_jur.MasterSource:=ds_sp1;
     CDS_jur.MasterFields:='nomer';
     CDS_jur.Open;
   end
   else
     MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
   Screen.Cursor:=crDefault;
end;

procedure Tfr_ClientAdm.bt_add_predClick(Sender: TObject);
var
 resSQL : integer;
 parametry : Variant;
 str : string;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  str:='('+IntToStr(CDS_sp1.FieldByName('nomer').AsInteger)+','
        +IntToStr(CDS_sp2.FieldByName('kod_pred').AsInteger)+');';
  parametry[0]:=121;
  parametry[1]:=kod_adm;
  parametry[2]:=1;
  parametry[3]:=VarArrayOf([str]);
  parametry[4]:=VarArrayOf([2]);
  parametry[5]:=0;
  MIDASConnection1.AppServer.StartTrans;
  resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL=0 Then Begin
    MIDASConnection1.AppServer.CommitTrans;
    CDS_jur.InsertRecord([CDS_sp1.FieldByName('nomer').AsInteger,
                          CDS_sp2.FieldByName('kod_pred').AsInteger,
                          CDS_sp2.FieldByName('name').AsString]);
    CDS_sp2.Delete;
  end
  Else Begin
    MIDASConnection1.AppServer.BackTrans;
    MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
  end;
end;

procedure Tfr_ClientAdm.bt_setout_predClick(Sender: TObject);
var
 resSQL : integer;
 parametry : Variant;
begin
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=122;
  parametry[1]:=kod_adm;
  parametry[2]:=2;
  parametry[3]:=VarArrayOf([IntToStr(CDS_sp1.FieldByName('nomer').AsInteger),
                            IntToStr(CDS_jur.FieldByName('predmet').AsInteger)]);
  parametry[4]:=VarArrayOf([3,6]);
  parametry[5]:=0;
  MIDASConnection1.AppServer.StartTrans;
  resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
  If resSQL=0 Then Begin
    MIDASConnection1.AppServer.CommitTrans;
    CDS_sp2.InsertRecord([CDS_sp1.FieldByName('nomer').AsInteger,
                          CDS_jur.FieldByName('predmet').AsInteger,
                          CDS_jur.FieldByName('name').AsString]);
    CDS_jur.Delete;
  end
  Else Begin
    MIDASConnection1.AppServer.BackTrans;
    MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
  end;
end;

procedure Tfr_ClientAdm.ts_tarifsEnter(Sender: TObject);
var
 resSQL, resSQL2 : integer;
 parametry, parametry2 : Variant;
begin
   If lastpages = 5 Then Exit;
   Screen.Cursor:=crHourGlass;
   lastpages:=5;
   Cleaner;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=109;
   parametry[1]:=kod_adm;
   parametry[2]:=0;
   parametry[3]:=VarArrayOf(['']);
   parametry[4]:=VarArrayOf([-1]);
   parametry[5]:=1;
   resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL=0 Then Begin
     parametry2:=VarArrayCreate([0, 5], varVariant);
     parametry2[0]:=131;
     parametry2[1]:=kod_adm;
     parametry2[2]:=0;
     parametry2[3]:=VarArrayOf(['']);
     parametry2[4]:=VarArrayOf([-1]);
     parametry2[5]:=2;
     resSQL2:=MIDASConnection1.AppServer.RunSQL(parametry2);
     If resSQL2=0 Then Begin
       dbt_nomer_trf.DataField:='nomer';
       dbt_grup_trf.DataField:='name_group';
       CDS_jur.IndexFieldNames:='nomer';
       CDS_jur.Open;
       CDS_sp1.IndexFieldNames:='nomer; date_ism';
       CDS_sp1.MasterSource:=ds_jur;
       CDS_sp1.MasterFields:='nomer';
       CDS_sp1.Open;
       CDS_sp1.Last;
       parametry2[0]:=130;
       parametry2[1]:=kod_adm;
       parametry2[2]:=0;
       parametry2[3]:=VarArrayOf([0]);
       parametry2[4]:=VarArrayOf([0]);
       parametry2[5]:=5;
       MIDASConnection1.AppServer.RunSQL(parametry2);
       CDS_work.IndexFieldNames:='nomer; date_ism; name_land';
       CDS_work.MasterSource:=ds_sp1;
       CDS_work.MasterFields:='nomer; date_ism';
       CDS_work.Open;
     end
     else Begin
       MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
       Screen.Cursor:=crDefault;
       Exit;
     end;
   end
   else
     MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
   Screen.Cursor:=crDefault;
end;

procedure Tfr_ClientAdm.bt_auto_tarifClick(Sender: TObject);
var
 resSQL, resSQL2 : integer;
 parametry, parametry2 : Variant;
begin
  //Exit;

  Screen.Cursor:=crHourGlass;
  Cleaner;
  lastpages:=0;
  parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=109;
   parametry[1]:=kod_adm;
   parametry[2]:=0;
   parametry[3]:=VarArrayOf(['']);
   parametry[4]:=VarArrayOf([-1]);
   parametry[5]:=1;
   resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL=0 Then Begin
     parametry2:=VarArrayCreate([0, 5], varVariant);
     parametry2[0]:=130;
     parametry2[1]:=kod_adm;
     parametry2[2]:=0;
     parametry2[3]:=VarArrayOf(['']);
     parametry2[4]:=VarArrayOf([-1]);
     parametry2[5]:=2;
     resSQL2:=MIDASConnection1.AppServer.RunSQL(parametry2);
     If resSQL2=0 Then Begin
       dbt_nomer_trf.DataField:='nomer';
       dbt_grup_trf.DataField:='name_group';
       CDS_jur.IndexFieldNames:='nomer';
       CDS_jur.Open;
       CDS_sp1.IndexFieldNames:='nomer';
       CDS_sp1.MasterSource:=ds_jur;
       CDS_sp1.MasterFields:='nomer';
       CDS_sp1.Open;
     end
     else Begin
       MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
       ts_tarifsEnter(Sender);
       Exit;
     end;
   end
   else
     MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
  Screen.Cursor:=crDefault;
  fr_auto_tarif.StartAutoTar;
  ts_tarifsEnter(Sender);
end;

procedure Tfr_ClientAdm.bt_update_tarifClick(Sender: TObject);
begin
  EditTarif;
end;

procedure Tfr_ClientAdm.bt_poselenieClick(Sender: TObject);
begin
  If rb_simpl_poselen.Checked Then Poselen_prost(0);{Простое поселение}
  {if rb_grup_poselen.Checked Then групповое поселение};
  If rb_predp_poselen.Checked Then Bn_poselenie; {по заявкам предприятия};
  If rb_ch_z_poselen.Checked Then Poselen_prost(1);{по заявкам частного лица}
  If rb_fix_sum .Checked Then Poselen_prost(2){фиксированая сумма};
end;

procedure Tfr_ClientAdm.ts_workEnter(Sender: TObject);
begin
   If lastpages = 20 Then Exit;
   lastpages:=20;
   Cleaner;
end;

procedure Tfr_ClientAdm.bt_vozvratClick(Sender: TObject);
var
 vv : variant;
begin
  {Возврат}
  vv:=null;
  If rb_simpl_poselen.Checked or rb_ch_z_poselen.Checked or rb_fix_sum.Checked
        Then vv:=Do_rebay(0,0,0);  {Простое поселение}
  {if rb_grup_poselen.Checked Then групповое поселение};
  {If rb_predp_poselen.Checked Then Bn_poselenie; {по заявкам предприятия};
  If (not  VarIsNull(vv))and(vv[1]>0) Then
     ShowMessage('Полный возврат по счету составит: '+FloatToStr(vv[1])+' руб.');
  If rb_predp_poselen.Checked Then Begin
  
  end;
end;

procedure Tfr_ClientAdm.bt_prodlenieClick(Sender: TObject);
begin
  If rb_simpl_poselen.Checked or rb_ch_z_poselen.Checked or rb_fix_sum.Checked
        Then Prodlen_nal(1);{Простое поселение}
  {if rb_grup_poselen.Checked Then групповое поселение};
  If rb_predp_poselen.Checked Then Begin
     Prodlen_beznal; {по заявкам предприятия};
     //Prod_bn_lst;
  end;
end;

procedure Tfr_ClientAdm.bt_perevodClick(Sender: TObject);
begin
   If rb_simpl_poselen.Checked or rb_ch_z_poselen.Checked or rb_fix_sum.Checked
        Then Move_nal(0);  {Простое поселение}
  {if rb_grup_poselen.Checked Then групповое поселение};
   If rb_predp_poselen.Checked Then Move_bznal; {по заявкам предприятия};
end;

procedure Tfr_ClientAdm.bt_viselenieClick(Sender: TObject);
begin
   If rb_simpl_poselen.Checked or rb_ch_z_poselen.Checked or rb_fix_sum.Checked
        Then Close_schet_nal;  {Простое поселение}
  {if rb_grup_poselen.Checked Then групповое поселение};
  {If rb_predp_poselen.Checked Then Bn_poselenie; {по заявкам предприятия};
end;

procedure Tfr_ClientAdm.bt_tek_otchetsClick(Sender: TObject);
var
 parametry : variant;
 resSQL : integer;
begin
  bt_tek_otchets.Enabled:=false;
  If Print_otchet_schets(kod_smen) Then
     If Print_otch_vozvr(kod_smen) Then {
        If Print_otchet_schdel(kod_smen) Then } Begin
           parametry:=VarArrayCreate([0, 5], varVariant);
           parametry[0]:=194;
           parametry[1]:=fr_ClientAdm.kod_adm;
           parametry[2]:=1;
           parametry[3]:=VarArrayOf([IntToStr(kod_smen)]);
           parametry[4]:=VarArrayOf(['smena']);
           parametry[5]:=0;
           MIDASConnection1.AppServer.StartTrans;
           resSQL:=MIDASConnection1.AppServer.RunSQL(parametry);
           //resSQL:=0;
           If resSQL=0 Then Begin
             MIDASConnection1.AppServer.CommitTrans;
             ShowMessage('Смена успешно закрыта !!!!!');
             fr_ClientAdm.Close;
             Exit;
           end
           Else MIDASConnection1.AppServer.BackTrans;
        end;
  MessageDlg('Смена не закрыта ! Попробуйте еще раз !', mtWarning, [mbOk], 0);
end;

procedure Tfr_ClientAdm.Timer1Timer(Sender: TObject);
var
  time_serv : TDateTime;
  sys_date : TSystemTime;
  ch_mail : integer;
begin
  Timer1.Enabled:=false;
  try
  if MIDASConnection1.Connected then Begin
      time_serv:=MIDASConnection1.AppServer.Idle;
      settings[8]:=MIDASConnection1.AppServer.GetRiteExtra;
      If (Trunc(date)<>Trunc(time_serv))and(settings[6][0]=0) Then Begin
         time_serv:=IncHour(time_serv,-1*settings[7][0]);
         DateTimeToSystemTime(time_serv,sys_date);
         SetSystemTime(sys_date);
      end;
      If test_post Then Begin
         test_post:=false;
         ch_mail:=MIDASConnection1.AppServer.CheckNewMessages;
         If ch_mail>0 Then Begin
            ShowMessage(IntToStr(ch_mail)+' новых писем!!  Проверьте почту!!');
         end;
         test_post:=true;
      end;
  end;
  finally
    Timer1.Enabled:=true;
  end;
end;

procedure Tfr_ClientAdm.bt_cash_checkClick(Sender: TObject);
var
  par, rs : variant;
  cash_in, cash_out{, cash_res} : real;
  bad_schets, sch_kvo : integer;
begin
   cash_in:=0;
   cash_out:=0;
   //If fr_ClientAdm.settings[8]<>0 Then Exit;
   //cash_res:=0;
   par:=VarArrayCreate([0, 2], varVariant);
   par[0]:=3;{получаем число испорченных счетов}
   par[1]:=VarArrayOf([IntToStr(kod_smen),'not','X']); //$$$$$
   par[2]:=VarArrayOf(['smen','not','ser']);
   rs:=GetTehParam(200,par);
   bad_schets:=0;
   If not VarIsNull(rs[1]) Then bad_schets:=rs[1];
   rs:=GetTehParam(202,par);
   If not VarIsNull(rs[1]) Then cash_in:=rs[1];
   rs:=GetTehParam(201,par);
   par[0]:=1;
   par[1]:=VarArrayOf([IntToStr(kod_smen)]);
   par[2]:=VarArrayOf(['smena']);
   If not VarIsNull(rs[1]) Then cash_out:=rs[1];
   rs:=GetTehParam(249,par);
   sch_kvo:=0;
   If not VarIsNull(rs[1]) Then sch_kvo:=rs[1];
   ShowMessage('Суммы: '+FloatToStr(cash_in)+'-'+FloatToStr(cash_out)+'='
       +FloatToStr(cash_in-cash_out)+'  Испорчено '+IntToStr(bad_schets)+
       '   при к= '+IntToStr(sch_kvo));
end;

procedure Tfr_ClientAdm.bt_find_gostClick(Sender: TObject);
begin
  GetGostKod(false);
end;

procedure Tfr_ClientAdm.bt_sost_nomClick(Sender: TObject);
begin
   Sostoian_nom;
end;

procedure Tfr_ClientAdm.n_korrectClick(Sender: TObject);
begin
  {********************}
  // Correcter;
end;

procedure Tfr_ClientAdm.bt_calc_besnalClick(Sender: TObject);
begin
   Calc_besnals;
end;

procedure Tfr_ClientAdm.N_postClick(Sender: TObject);
begin
   test_post:=false;
   StartPost;
   test_post:=true;
end;

procedure Tfr_ClientAdm.bt_reset_tarClick(Sender: TObject);
var
  resSQL : integer;
begin
  StartProgress;
  fr_progress.DeclarateConstProgress('Выполняется актуализация тарифов.'+#13+'Это можетзанять несколько минут...',2,1);
  fr_progress.SetStepNext;
  resSQL:=MIDASConnection1.AppServer.ResetTarifs;
  fr_progress.SetStepNext;
  CloseProgress;
  If resSQL<>0 Then Begin
     ShowMessage('Ошибка или нет прав на операцию!');
     Exit;
  end;
  bt_reset_tar.Enabled:=false;
end;

procedure Tfr_ClientAdm.bt_lock_resetClick(Sender: TObject);
begin
  bt_reset_tar.Enabled:=not bt_reset_tar.Enabled;
end;

procedure Tfr_ClientAdm.bt_lock_otchetClick(Sender: TObject);
begin
   bt_tek_otchets.Enabled:=not bt_tek_otchets.Enabled;
end;

procedure Tfr_ClientAdm.rb_grup_poselenClick(Sender: TObject);
begin
  bt_grup_sch.Enabled:=true;
  bt_poselenie.Enabled:=false;
  bt_prodlenie.Enabled:=false;
  bt_perevod.Enabled:=false;
  bt_viselenie.Enabled:=false;
  bt_vozvrat.Enabled:=false;
end;

Procedure Tfr_ClientAdm.Re;
Begin
  bt_grup_sch.Enabled:=false;
  bt_poselenie.Enabled:=true;
  bt_prodlenie.Enabled:=true;
  bt_perevod.Enabled:=true;
  bt_viselenie.Enabled:=true;
  bt_vozvrat.Enabled:=true;
end;

procedure Tfr_ClientAdm.rb_simpl_poselenClick(Sender: TObject);
begin
  Re;
end;

procedure Tfr_ClientAdm.bt_grup_schClick(Sender: TObject);
begin
  Start_group_schet;
end;

procedure Tfr_ClientAdm.bt_kvo_ingostClick(Sender: TObject);
begin
  Get_count_gost;
end;

procedure Tfr_ClientAdm.bt_sng_lstClick(Sender: TObject);
var
  dss, ddd : TDate;
  rs : boolean;
begin
  dss:=DATE;
  rs:=Get_Date('Выбор даты','Выберите дату начала периода',dss);
  If rs Then Begin
     If dss < (DATE-14) Then Exit;
     ddd:=DATE;
     rs:=Get_Date('Выбор даты','Выберите дату окончания периода',ddd);
     If rs Then Begin
        If ddd<dss Then Exit;
        MessageDlg('Печать списка гостей СНГ с даты '+DateToStr(dss)+' по дату '+DateToStr(ddd), mtInformation, [mbOk], 0);
        MessageDlg('Для печати списка гостей СНГ вставьте большие листы в принтер!', mtInformation, [mbOk], 0);
        Snggosts_prn(dss, ddd);
     end;
  end;
end;

procedure Tfr_ClientAdm.bt_ingos_lstClick(Sender: TObject);
var
  dss, ddd : TDate;
  rs : boolean;
begin
  dss:=DATE;
  rs:=Get_Date('Выбор даты','Выберите дату начала периода',dss);
  If rs Then Begin
     If dss < (DATE-14) Then Exit;
     ddd:=DATE;
     rs:=Get_Date('Выбор даты','Выберите дату окончания периода',ddd);
     If rs Then Begin
        If ddd<dss Then Exit;
        MessageDlg('Печать списка иностранных гостей с даты '+DateToStr(dss)+' по дату '+DateToStr(ddd), mtInformation, [mbOk], 0);
        MessageDlg('Для печати списка иностранных гостей вставьте большие листы в принтер!', mtInformation, [mbOk], 0);
        Ingosts_prn(dss, ddd);
     end;
  end;
end;

procedure Tfr_ClientAdm.bt_dpschClick(Sender: TObject);
begin
  StartDupSch;
end;

procedure Tfr_ClientAdm.bt_gr_schetsClick(Sender: TObject);
begin
  StartGroup;
end;

procedure Tfr_ClientAdm.Timer2Timer(Sender: TObject);
var
  rkvo : integer;
  ii : integer;
  param, otvet : Variant;
  strsql : string;
begin
  Randomize;
  //If Timer2.Interval>60000 Then Timer2.Interval:=60000;
  if not MIDASConnection1.Connected then Exit;
  If numch<=0 Then Begin
    numch:=Round(Random(15))+6;
    rkvo:=Round(Random(2))+1;
    param:=VarArrayCreate([0, 2], varVariant);
    strsql:='select GEN_ID(INC_COD_SCHET,1) from sys_option';
    For ii:=0 To rkvo Do Begin
      param[0]:=2;
      param[1]:=VarArrayOf(['',strsql]);
      param[2]:=VarArrayOf([1,0]);
      otvet:=GetTehParam(125, param);
    end;
  end;
  {If otvet[1] > 0 Then
     ShowMessage('Следующий номер счета: '+IntToStr(otvet[1]+1));  }
end;

procedure Tfr_ClientAdm.bt_fr_optionsClick(Sender: TObject);
begin
  If settings[9][0] <> 1 Then Exit;
  if VarIsNull(DrvFR) Then Exit;
  try
    DrvFR.ShowProperties;
  except
  end;
end;

procedure Tfr_ClientAdm.bt_fr_z_reportClick(Sender: TObject);
begin
  If settings[9][0] <> 1 Then Exit;
  if VarIsNull(DrvFR) Then Exit;
  try
    InitKKM(port_kkm);
    if MessageDlg('напечатать отчет с гашением?',mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
    DrvFR.PrintReportWithCleaning;
    If DrvFR.ResultCode<>0 Then Begin
       MessageDlg(DrvFR.ResultCodeDescription, mtError,[mbOk], 0);
       MessageDlg('Необходимо вмешательсво кассового мастера!', mtInformation,[mbOk], 0);
       MessageDlg('Фискальный регистратор отключён (касса отключена)!', mtInformation,[mbOk], 0);
       CancelFR;
       Exit;
    end
    Else InitKKM(port_kkm);
  except
  end;
end;

procedure Tfr_ClientAdm.bt_fr_x_reportClick(Sender: TObject);
begin
  If settings[9][0] <> 1 Then Exit;
  if VarIsNull(DrvFR) Then Exit;
  try
  try
    DrvFR.Password:=30;
    DrvFR.PrintReportWithoutCleaning;
    If DrvFR.ResultCode<>0 Then Begin
       MessageDlg(DrvFR.ResultCodeDescription, mtError,[mbOk], 0);
    end;
  finally
    DrvFR.Password:=kkmpsw;
  end;
  except
  end;
end;

procedure Tfr_ClientAdm.bt_fr_printClick(Sender: TObject);
begin
  If settings[9][0] <> 1 Then Exit;
  if VarIsNull(DrvFR) Then Exit;
  try
    if DrvFR.ECRAdvancedMode<>3 Then Begin
       MessageDlg('Нет документов ФР лдя печати!', mtError,[mbOk], 0);
       Exit;
    end;
    DrvFR.ContinuePrint;
    {If DrvFR.ResultCode<>0 Then Begin
       MessageDlg(DrvFR.ResultCodeDescription, mtError,[mbOk], 0);
    end;}
  except
  end;
end;

end.
