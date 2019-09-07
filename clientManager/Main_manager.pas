unit Main_manager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, RxGrdCpt, ComCtrls, Password, DM, find_gost, find_schet, nom_sost,
  prn_kalkulat, Talon_dlg, Othc_nach_rasm, Post, List_gost, Rsch_bron,
  Kvo_gosts, Zn_nom_prc, gen_ubor, List_grup, StdCtrls, Last_general,
  filtr_gost, Db, DBClient, Grids, DBGrids, Mask, ToolEdit, CurrEdit, StrUtils;

type
  Tfr_main_manager = class(TForm)
    RxGradientCaption1: TRxGradientCaption;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    StatusBar1: TStatusBar;
    n_dubl_schet: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    n_find_gost: TMenuItem;
    n_sost_nom: TMenuItem;
    n_calc_cen: TMenuItem;
    n_prn_talons: TMenuItem;
    n_otch_nach_razm: TMenuItem;
    N_post: TMenuItem;
    n_gost_lst: TMenuItem;
    n_bn_rsch: TMenuItem;
    n_count_gosts: TMenuItem;
    n_zn_noms: TMenuItem;
    n_gen: TMenuItem;
    N_group_schets: TMenuItem;
    N_dat: TMenuItem;
    ed_dat_kor: TDateTimePicker;
    bt_dat_ok: TButton;
    n_last_general: TMenuItem;
    n_gost_list: TMenuItem;
    ed_sql_code: TMemo;
    DBGrid1: TDBGrid;
    ds_res_sql: TDataSource;
    cds_res_sql: TClientDataSet;
    ed_nom_sch: TEdit;
    bt_del_sch: TButton;
    ADM1: TMenuItem;
    Deleteaccount1: TMenuItem;
    SQL1: TMenuItem;
    bt_commit: TButton;
    bt_rolback: TButton;
    bt_start_sql: TButton;
    N_zavtrac_cost: TMenuItem;
    ed_zvtrk: TRxCalcEdit;
    bt_sav_zvtrk: TButton;
    mem_fields: TMemo;
    procedure N7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure n_find_gostClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure n_dubl_schetClick(Sender: TObject);
    procedure n_sost_nomClick(Sender: TObject);
    procedure n_calc_cenClick(Sender: TObject);
    procedure n_prn_talonsClick(Sender: TObject);
    procedure n_otch_nach_razmClick(Sender: TObject);
    procedure N_postClick(Sender: TObject);
    procedure n_gost_lstClick(Sender: TObject);
    procedure n_bn_rschClick(Sender: TObject);
    procedure n_count_gostsClick(Sender: TObject);
    procedure n_zn_nomsClick(Sender: TObject);
    procedure n_genClick(Sender: TObject);
    procedure N_group_schetsClick(Sender: TObject);
    procedure N_datClick(Sender: TObject);
    procedure bt_dat_okClick(Sender: TObject);
    procedure n_last_generalClick(Sender: TObject);
    procedure n_gost_listClick(Sender: TObject);
    procedure bt_del_schClick(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure Deleteaccount1Click(Sender: TObject);
    procedure N_zavtrac_costClick(Sender: TObject);
    procedure bt_sav_zvtrkClick(Sender: TObject);
    procedure bt_start_sqlClick(Sender: TObject);
    procedure bt_commitClick(Sender: TObject);
    procedure bt_rolbackClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1ColExit(Sender: TObject);
  private
    pr : integer;
    memtxt : string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fr_main_manager: Tfr_main_manager;

implementation

{$R *.DFM}

procedure Tfr_main_manager.N7Click(Sender: TObject);
begin
   DataModuls.SockToVostok.Connected:=false;
   fr_main_manager.Close;
end;

procedure Tfr_main_manager.FormCreate(Sender: TObject);
begin
  If not CreateDM Then Begin
     MessageDlg('Непреодолимая ошибка!', mtError, [mbOk], 0);
     fr_main_manager.Close;
     Exit;
  end;
  If ConnectToVostok<>0 Then Begin
     fr_main_manager.Close;
     Exit;
  end;
  pr:=DataModuls.SockToVostok.AppServer.IsSys;
  If pr=4 Then Begin
    ADM1.Enabled:=true;
    bt_start_sql.Visible:=true;
    ed_sql_code.Visible:=true;
    DBGrid1.Visible:=true;
    bt_commit.Visible:=true;
    bt_rolback.Visible:=true;
    
  end;
end;

procedure Tfr_main_manager.n_find_gostClick(Sender: TObject);
begin
  GetGostKod;
end;

procedure Tfr_main_manager.FormActivate(Sender: TObject);
begin
  If not DataModuls.SockToVostok.Connected Then fr_main_manager.Close;
  ActivateKeyboardLayout(rus,0);
end;

procedure Tfr_main_manager.n_dubl_schetClick(Sender: TObject);
begin
  CopySchet;
end;

procedure Tfr_main_manager.n_sost_nomClick(Sender: TObject);
begin
  Sostoian_nom;
end;

procedure Tfr_main_manager.n_calc_cenClick(Sender: TObject);
begin
   ShowMessage('Калькуляция займет несколько минут... Для продолжения нажмите <Ok>!');
   Kalkulate;
end;

procedure Tfr_main_manager.n_prn_talonsClick(Sender: TObject);
begin
  PrnTal;
end;

procedure Tfr_main_manager.n_otch_nach_razmClick(Sender: TObject);
begin
   Start_smen_nach;
end;

procedure Tfr_main_manager.N_postClick(Sender: TObject);
begin
  DataModuls.test_mail:=false;
  StartPost;
  DataModuls.test_mail:=true;
end;

procedure Tfr_main_manager.n_gost_lstClick(Sender: TObject);
begin
   Start_gost_lst;
end;

procedure Tfr_main_manager.n_bn_rschClick(Sender: TObject);
begin
   Bn_Rsch;
end;

procedure Tfr_main_manager.n_count_gostsClick(Sender: TObject);
begin
   Get_count_gost;
end;

procedure Tfr_main_manager.n_zn_nomsClick(Sender: TObject);
begin
  StartStatGraf;
end;

procedure Tfr_main_manager.n_genClick(Sender: TObject);
begin
  Start_genUbor;
end;

procedure Tfr_main_manager.N_group_schetsClick(Sender: TObject);
begin
   StartGroup;
end;

procedure Tfr_main_manager.N_datClick(Sender: TObject);
begin
  If pr<>4 Then Exit;
  ed_dat_kor.Date:=date+1;
  ed_dat_kor.Visible:=true;
  bt_dat_ok.Visible:=true;
end;

procedure Tfr_main_manager.bt_dat_okClick(Sender: TObject);
var
  parametry : variant;
  resSQL : integer;
  rr : real;
begin
  rr:=ed_dat_kor.Date*Pi;
  parametry:=VarArrayCreate([0, 5], varVariant);
  parametry[0]:=262;
  parametry[1]:=DataModuls.kod_adm;
  parametry[2]:=1;
  parametry[3]:=VarArrayOf([FloatToStr(rr)]);
  parametry[4]:=VarArrayOf(['value']);
  parametry[5]:=0;
  DataModuls.SockToVostok.AppServer.StartTrans;
  resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
  If resSQL<>0 Then Begin
    ShowMessage('Ошибка!!!!!!!!');
    DataModuls.SockToVostok.AppServer.BackTrans;
  end
  Else DataModuls.SockToVostok.AppServer.CommitTrans;
  ed_dat_kor.Visible:=false;
  bt_dat_ok.Visible:=false;
end;

procedure Tfr_main_manager.n_last_generalClick(Sender: TObject);
begin
  Get_last_generals;
end;

procedure Tfr_main_manager.n_gost_listClick(Sender: TObject);
begin
   Create_Filter;
end;

procedure Tfr_main_manager.bt_del_schClick(Sender: TObject);
var
  parametry : variant;
  resSQL : integer;
  n_sch : integer;
begin
  If ed_nom_sch.Text>'' Then Begin
    parametry:=VarArrayCreate([0, 5], varVariant);
    parametry[0]:=146;
    parametry[1]:=DataModuls.kod_adm;
    parametry[2]:=1;
    parametry[3]:=VarArrayOf([ed_nom_sch.Text]);
    parametry[4]:=VarArrayOf([3]);
    parametry[5]:=0;
    DataModuls.SockToVostok.AppServer.StartTrans;
    resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
    If resSQL<>0 Then Begin
      ShowMessage('Ошибка!!!!!!!!');
      DataModuls.SockToVostok.AppServer.BackTrans;
    end
    Else DataModuls.SockToVostok.AppServer.CommitTrans;
    ed_nom_sch.Visible:=false;
    bt_del_sch.Visible:=false;
  end;
end;

procedure Tfr_main_manager.N10Click(Sender: TObject);
var
  pr : integer;
begin
  pr:=DataModuls.SockToVostok.AppServer.IsSys;
  If pr<>4 Then Exit;
  
end;

procedure Tfr_main_manager.Deleteaccount1Click(Sender: TObject);
begin
  Deleteaccount1.Checked:=not Deleteaccount1.Checked;
  ed_nom_sch.Visible:=Deleteaccount1.Checked;
  bt_del_sch.Visible:=Deleteaccount1.Checked;
end;

procedure Tfr_main_manager.N_zavtrac_costClick(Sender: TObject);
var
  parametry,rrs : variant;
  resSQL : integer;
begin
  N_zavtrac_cost.Checked:=not N_zavtrac_cost.Checked;
  ed_zvtrk.Visible:=N_zavtrac_cost.Checked;
  bt_sav_zvtrk.Visible:=N_zavtrac_cost.Checked;
  If N_zavtrac_cost.Checked Then Begin
    parametry:=VarArrayCreate([0, 2], varVariant);
    parametry[0]:=0;
    parametry[1]:=VarArrayOf(['']);
    parametry[2]:=VarArrayOf([0]);
    rrs:=DataModuls.GetTehParam(145,parametry);
    If not VarIsNull(rrs) Then
             ed_zvtrk.Value:=rrs[1];
  end;
end;

procedure Tfr_main_manager.bt_sav_zvtrkClick(Sender: TObject);
var
  parametry,rrs : variant;
  resSQL : integer;
begin
  if MessageDlg('Вы действительно хотите изменить стоимость завтраков?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    parametry:=VarArrayCreate([0, 5], varVariant);
    parametry[0]:=146;
    parametry[1]:=DataModuls.kod_adm;
    parametry[2]:=4;
    parametry[3]:=VarArrayOf(['Update sp_uslugi','set tarif = ',FloatToStr(ed_zvtrk.Value),'where kod_uslug = 1']);
    parametry[4]:=VarArrayOf([0,1,2,3]);
    parametry[5]:=0;
    If DataModuls.SockToVostok.AppServer.Get_State_DB=0 Then
       DataModuls.SockToVostok.AppServer.StartTrans;
    resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
    If resSQL<>0 Then Begin
      ShowMessage('Ошибка!!!!!!!!');
      DataModuls.SockToVostok.AppServer.BackTrans;
    end
    Else DataModuls.SockToVostok.AppServer.CommitTrans;
  end;
end;

procedure Tfr_main_manager.bt_start_sqlClick(Sender: TObject);
var
  parametry,rrs : variant;
  resSQL : integer;
  pr : integer;
  stt : string;
begin
  pr:=DataModuls.SockToVostok.AppServer.IsSys;
  If pr<>4 Then Exit;
  Screen.Cursor:=crHourGlass;
  cds_res_sql.Active:=false;
  stt:=ed_sql_code.Lines.text;
  stt:=DelBSpace(stt);
  stt:=DelESpace(stt);
  bt_commit.Enabled:=false;
  bt_rolback.Enabled:=false;
  if Length(stt)>16 then
  begin
    parametry:=VarArrayCreate([0, 5], varVariant);
    parametry[0]:=234;
    parametry[1]:=DataModuls.kod_adm;
    parametry[2]:=1;
    parametry[3]:=VarArrayOf([stt]);
    parametry[4]:=VarArrayOf([0]);
    If (stt[1]='S')or(stt[1]='s') Then begin
      parametry[5]:=1;
      resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
      If resSQL<>0 Then Begin
         Screen.Cursor:=crDefault;
         ShowMessage('Ошибка!!!!!!!!');
      end
      Else cds_res_sql.Active:=true;
      Screen.Cursor:=crDefault;
    end
    Else Begin
      parametry[5]:=0;
      If DataModuls.SockToVostok.AppServer.Get_State_DB=0 Then
       DataModuls.SockToVostok.AppServer.StartTrans;
      resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
      If resSQL<>0 Then Begin
        Screen.Cursor:=crDefault;
        ShowMessage('Ошибка!!!!!!!!');
        DataModuls.SockToVostok.AppServer.BackTrans;
      end
      Else Begin
        bt_commit.Enabled:=true;
        bt_rolback.Enabled:=true;
      end;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

procedure Tfr_main_manager.bt_commitClick(Sender: TObject);
begin
  If DataModuls.SockToVostok.AppServer.Get_State_DB=0 Then
             DataModuls.SockToVostok.AppServer.CommitTrans;
  bt_commit.Enabled:=false;
  bt_rolback.Enabled:=false;
end;

procedure Tfr_main_manager.bt_rolbackClick(Sender: TObject);
begin
   If DataModuls.SockToVostok.AppServer.Get_State_DB=0 Then
                DataModuls.SockToVostok.AppServer.BackTrans;
   bt_commit.Enabled:=false;
   bt_rolback.Enabled:=false;
end;

procedure Tfr_main_manager.DBGrid1DblClick(Sender: TObject);
begin
  if DBGrid1.SelectedField.DataType=ftMemo Then Begin
     memtxt:=cds_res_sql.FieldByName(DBGrid1.SelectedField.FieldName).Value;
     mem_fields.Lines.Text:=memtxt;
     mem_fields.Visible:=true;
  end;
end;

procedure Tfr_main_manager.DBGrid1ColExit(Sender: TObject);
begin
   If mem_fields.Visible Then Begin
      mem_fields.Visible:=false;
      if mem_fields.Lines.Text<>memtxt Then
        if MessageDlg('Значение поля '+DBGrid1.SelectedField.FieldName+' было изменино. Сохранить изменения в базу?',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes then Begin
          if cds_res_sql.State<>dsEdit Then cds_res_sql.Edit;
          cds_res_sql.FieldByName(DBGrid1.SelectedField.FieldName).Value:=mem_fields.Lines.Text;
          cds_res_sql.Post;
          cds_res_sql.ApplyUpdates(-1);
          cds_res_sql.RefreshRecord;
        end;
   end;
end;

end.
