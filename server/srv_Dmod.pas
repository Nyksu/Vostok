unit srv_Dmod;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComServ, ComObj, VCLCom, StdVcl, BdeProv, ActiveX, DataBkr, Vostok1srv_TLB,
  Provider, Db, DBTables, srv_face, UnxCrypt, x_prov, dbclient;
const
  erUserNotLogged='Нет доступа.';

type
  Tvostok1 = class(TDataModule, Ivostok1)
    DB1: TDatabase;
    qr_exec: TQuery;
    Prov_exec: TProvider;
    qr_work: TQuery;
    Prov_work: TProvider;
    qr_teh: TQuery;
    Prov_teh: TProvider;
    q_jurnal: TQuery;
    q_spr1: TQuery;
    q_spr2: TQuery;
    q_spr3: TQuery;
    pr_jurnal: TProvider;
    pr_spr1: TProvider;
    pr_spr2: TProvider;
    pr_spr3: TProvider;
    qr_SQLTXT: TQuery;
    qPlats: TQuery;
    qPlatsKOD_PLAT: TIntegerField;
    qPlatsNAM_PLAT: TStringField;
    qPlatsREKVISIT: TStringField;
    qPlatsTIP_PLAT: TIntegerField;
    qPlatsKOMENT: TStringField;
    spGetNextID: TStoredProc;
    pPlats: TxProvider;
    qRequest: TxQuery;
    qRequestCOD_BRON: TIntegerField;
    qRequestPLAT: TIntegerField;
    qRequestSTART_DATE: TDateTimeField;
    qRequestEND_DATE: TDateTimeField;
    qRequestNAM_PLAT: TStringField;
    qRequestCOMENT: TMemoField;
    dsRequest: TDataSource;
    qNomerInRequest: TxQuery;
    fNomCodBron: TIntegerField;
    qNomerInRequestNOMER: TIntegerField;
    qNomerInRequestMEST: TIntegerField;
    qRequestUSED: TSmallintField;
    pRequest: TxProvider;
    qNomerInRequestMEST_USED: TIntegerField;
    qFirstRooms: TQuery;
    pFirstRooms: TxProvider;
    qFirstRoomsOCHERED: TIntegerField;
    qFirstRoomsNOMER: TIntegerField;
    qFirstRoomsMESTS: TIntegerField;
    qFirstRoomsKLASS: TIntegerField;
    qFirstRoomsFLOOR: TIntegerField;
    Session1: TSession;
    qRequestPAY_TYPE: TSmallintField;
    qNomerInRequestID: TIntegerField;
    qNomerInRequestFAM: TStringField;
    qNomerInRequestNAME: TStringField;
    qNomerInRequestNAME2: TStringField;
    qNomerInRequestSEX: TStringField;
    pBlackList: TxProvider;
    qBlackList: TQuery;
    qBlackListKOD_MEN: TIntegerField;
    qBlackListFAMIL: TStringField;
    qBlackListIO: TStringField;
    qBlackListDR: TDateTimeField;
    qBlackListPRIMETS: TStringField;
    qBlackListREKVISITS: TStringField;
    qBlackListKOMENTS: TMemoField;
    qBlackListSTATE: TIntegerField;
    qBlackListPOL: TStringField;
    spFillPayHistory: TStoredProc;
    qMail: TQuery;
    pMail: TxProvider;
    qMailID: TIntegerField;
    qMailFROM_ADM: TIntegerField;
    qMailTO_ADM: TIntegerField;
    qMailSEND_DATE: TDateTimeField;
    qMailRECEIVE_DATE: TDateTimeField;
    qMailMESSAGE_TEXT: TMemoField;
    qMailSENDER: TStringField;
    pMail_out: TxProvider;
    qMail_out: TQuery;
    qMail_outID: TIntegerField;
    qMail_outFROM_ADM: TIntegerField;
    qMail_outTO_ADM: TIntegerField;
    qMail_outSEND_DATE: TDateTimeField;
    qMail_outRECEIVE_DATE: TDateTimeField;
    qMail_outMESSAGE_TEXT: TMemoField;
    qMail_outREADER: TStringField;
    spResetTarifs: TStoredProc;
    qGornich: TQuery;
    qGornichID: TIntegerField;
    qGornichFIO: TStringField;
    qGornichBRIGADA: TIntegerField;
    qGornichSMENA: TIntegerField;
    pGornich: TxProvider;
    qGenClear: TQuery;
    qGenClearVAHTA_ID: TIntegerField;
    qGenClearGORNICH_ID: TIntegerField;
    qGenClearNOMER: TIntegerField;
    qGenClearOCENKA: TIntegerField;
    pGenClear: TxProvider;
    qGenClearMESTS: TIntegerField;
    qNomerInRequestKOD_LAND: TIntegerField;
    procedure vostok1Create(Sender: TObject);
    procedure vostok1Destroy(Sender: TObject);
    function pRequestDataRequest(Sender: TObject;
      Input: OleVariant): OleVariant;
    procedure pRequestBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);
    procedure CheckIsUserLogged(DataSet: TDataSet);
    procedure LogExecutedSQL(ModifySQL: String);
    procedure qMailBeforeOpen(DataSet: TDataSet);
    procedure pMailBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet;
      DeltaDS: TClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);
    procedure pMail_outBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);
    procedure qMail_outBeforeOpen(DataSet: TDataSet);
    procedure pGornichBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);
  private
    log_sav : Variant;
    name_log : Variant;
    prov_nom : integer;
    WasLogin:Boolean;
    KodAdm : Integer;
    function TestPrav(nom_funct,adm_kod : integer) : boolean;
    procedure SaveOper(kod_sql,cod_adm : integer; sv_sql : boolean);
    function InsertParam(sql_txt,param_nam,param_str : string) : string;
    procedure LogString(txt:string);
    function IsUserLogged(RaiseIfNotLogin:boolean=False):boolean;
    { Private declarations }
  public
    { Public declarations }
    procedure InternalExecSQL(SQL_ID:integer;ParamVal,ParamName:OleVariant);
  protected
    function Get_Prov_work: IProvider; safecall;
    function Get_Prov_exec: IProvider; safecall;
    function Get_Prov_teh: IProvider; safecall;
    procedure StartTrans; safecall;
    procedure CommitTrans; safecall;
    function Get_pr_jurnal: IProvider; safecall;
    function Get_pr_spr1: IProvider; safecall;
    function Get_pr_spr2: IProvider; safecall;
    function Get_pr_spr3: IProvider; safecall;
    function RunSQL(in_param: OleVariant): Integer;
      safecall;
    function Reception(logi: OleVariant): Integer; safecall;
    procedure BackTrans; safecall;
    function GetNextID: Integer; safecall;
    function Get_pPlats: IProvider; safecall;
    function Get_pRequest: IProvider; safecall;
    function Get_State_DB: Integer; safecall;
    function ChangeZMN(StartDate, EndDate: TDateTime; Prichina, Mest,
      Nomer: Integer): Integer; safecall;
    function Get_pFirstRooms: IProvider; safecall;
    procedure MoveBron(StartDate, EndDate: TDateTime; Nomer: Integer);
      safecall;
    function Idle : TDateTime; safecall;
    function Get_pBlackList: IProvider; safecall;
    procedure FillGostPayHistory(KodGost: Integer); safecall;
    function Get_pMail: IProvider; safecall;
    function CheckNewMessages: Integer; safecall;
    function Get_pMail_out: IProvider; safecall;
    Function ResetTarifs : Integer; safecall;
    function Get_pGornich: IProvider; safecall;
    function Get_pGenClear: IProvider; safecall;
    function GetRiteExtra: Integer; safecall;
    function IsSys: Integer; safecall;
  end;

var
  vostok1: Tvostok1;
  prv : integer;

implementation

{$R *.DFM}



function Tvostok1.Get_Prov_work: IProvider;
begin
  Result := Prov_work.Provider;
end;

function Tvostok1.InsertParam(sql_txt,param_nam,param_str : string) : string;
var
 SubStr,r_str : string;
 posic,l_nam : integer;
Begin
  SubStr:=':'+param_nam+':';
  l_nam:=Length(SubStr);
  r_str:=sql_txt;
  posic:=Pos(SubStr,sql_txt);
  Delete(r_str,posic,l_nam);
  Insert(param_str,r_str,posic);
  Result:=r_str;
end;

function Tvostok1.TestPrav(nom_funct,adm_kod : integer) : boolean;
var
paramsql : Variant;
OldSQL : Variant;
i2 : integer;
begin
  If adm_kod=log_sav[0][1] Then Begin
    Result:=true;    {Если запрашивает система, то не проверять права}
    Exit;
  end;
  OldSQL:=qr_teh.SQL.Text; {сохранение старого текста из таблицы}
  paramsql:=VarArrayCreate([0,5], varVariant);
  paramsql[0]:=101;  {Запрос, выдающий по известному № SQL права на ее испол.}
  paramsql[1]:=log_sav[0][1];
  paramsql[2]:=1;
  paramsql[3]:=VarArrayOf([IntToStr(nom_funct)]);
  paramsql[4]:=VarArrayOf([3]);
  paramsql[5]:=6; {запрос помесщается в qr_teh}
  RunSQL(paramsql);
  qr_teh.Active:=true;
  i2:=qr_teh.FieldByName('pravo').AsInteger;
  prv:=i2;
  qr_teh.Close;
  qr_teh.SQL.Text:=OldSQL; {возвращаем старый текст SQL}
  If i2>name_log[1] Then
       Result:=false  {право на операцию должно быть меньше или = правам адм.}
  Else Result:=true;
end;

procedure Tvostok1.LogString(txt:string);
begin
 Save_Sql(name_log[0],txt);
end;

procedure Tvostok1.SaveOper(kod_sql,cod_adm : integer;sv_sql : boolean);
var          {процедура заполнения журнал операций}
paramsql : Variant;
OldSQL : Variant;
ii, i2 : integer;
ss : string;
trans : boolean;
begin
  If sv_sql Then Save_Sql(name_log[0],qr_exec.SQL.Text);
  If kod_sql>999 Then Case prov_nom of
     1 : Save_Sql(name_log[0],q_jurnal.SQL.Text);
     2 : Save_Sql(name_log[0],q_spr1.SQL.Text);
     3 : Save_Sql(name_log[0],q_spr2.SQL.Text);
     4 : Save_Sql(name_log[0],q_spr3.SQL.Text);
     5 : Save_Sql(name_log[0],qr_work.SQL.Text);
     6 : Save_Sql(name_log[0],qr_teh.SQL.Text);
  end;
  OldSQL:=qr_teh.SQL.Text;
  paramsql:=VarArrayCreate([0,5], varVariant);
  paramsql[0]:=102; {запрос возвращает тип операции по № SQL}
  paramsql[1]:=log_sav[0][1];
  paramsql[2]:=1;
  paramsql[3]:=VarArrayOf([IntToStr(kod_sql)]);
  paramsql[4]:=VarArrayOf([3]);
  paramsql[5]:=6;
  RunSQL(paramsql);
  qr_teh.Active:=true;
  If cod_adm = log_sav[0][1] Then i2:=log_sav[0][0]
  else i2:=log_sav[1][0];
  ii:=qr_teh.FieldByName('tip_op').AsInteger;
  ss:='(Gen_ID(Inc_Cod_oper,1),'+IntToStr(ii)+
            ','+#39+'now'+#39+','+IntToStr(i2)+')';
  qr_teh.Close;
  qr_teh.SQL.Text:=OldSQL;
  paramsql[0]:=103; {Запрос на Вставку записи в журнал операций}
  paramsql[1]:=log_sav[0][1];
  paramsql[2]:=1;
  paramsql[3]:=VarArrayOf([ss]);
  paramsql[4]:=VarArrayOf([2]);
  paramsql[5]:=0;
  trans:=false;
  If not DB1.InTransaction Then Begin
     trans:=true;
     StartTrans;
  end;
  RunSQL(paramsql);
  If trans Then CommitTrans;
end;

function Tvostok1.IsUserLogged(RaiseIfNotLogin:boolean=False):boolean;
begin
Result:=WasLogin;
if not WasLogin then Save_Sql('','Несанкционированный вызов');
if (not WasLogin)and RaiseIfNotLogin then raise Exception.Create(erUserNotLogged);
end;

procedure Tvostok1.vostok1Create(Sender: TObject);
var
 nom : integer;
 str_ppp : string;
begin
{  Session.Active:=False;
  Session.AutoSessionName:=True;
  DB1.SessionName:=Session.SessionName;
  Session.Active:=True;}
  WasLogin:=False;
  str_ppp:='etey';
  frm_serv_face.CalcClientsConnects(1);
  log_sav:=VarArrayCreate([0,1], varVariant);
  str_ppp:='prom'+str_ppp;
  Randomize;
  nom:=Round(2+Random(10000));
  log_sav[0]:=VarArrayOf([0,nom]);
  log_sav[1]:=VarArrayOf([-1,0]);
  name_log:=VarArrayOf(['',-1]);
  DB1.Params.Strings[1]:='PASSWORD='+str_ppp;
  Try
    DB1.Connected:=true;
  except
  end;
end;

procedure Tvostok1.vostok1Destroy(Sender: TObject);
var
 st : integer;
begin
  frm_serv_face.CalcClientsConnects(-1);
  st:=frm_serv_face.ListBox1.Items.IndexOf(name_log[0]);
  frm_serv_face.ListBox1.Items.Delete(st);
end;

function Tvostok1.Get_Prov_exec: IProvider;
begin
  Result := Prov_exec.Provider;
end;

function Tvostok1.Get_Prov_teh: IProvider;
begin
  Result := Prov_teh.Provider;
end;

procedure Tvostok1.StartTrans;
begin
  DB1.StartTransaction;
end;

procedure Tvostok1.CommitTrans;
begin
  DB1.Commit;
end;

function Tvostok1.Get_pr_jurnal: IProvider;
begin
  Result := pr_jurnal.Provider;
end;

function Tvostok1.Get_pr_spr1: IProvider;
begin
  Result := pr_spr1.Provider;
end;

function Tvostok1.Get_pr_spr2: IProvider;
begin
  Result := pr_spr2.Provider;
end;

function Tvostok1.Get_pr_spr3: IProvider;
begin
  Result := pr_spr3.Provider;
end;

function Tvostok1.RunSQL(in_param: OleVariant): Integer;
var
 masarray : variant;
 ii : integer;
 need_sv_sql : boolean;

begin
  need_sv_sql:=false;
  masarray:=VarArrayCreate([0,5], varVariant);
  masarray:=in_param;
  If masarray[1]<=0 Then Begin
    Result:=1;    {Код адм. должен быть больше нуля}
    Exit;
  end;
  If (masarray[1]<>log_sav[0][1]) and (masarray[1]<>log_sav[1][1]) Then Begin
    Result:=1;    {код адм должен быть зарегистрирован сервером}
    Exit;
  end;
  If log_sav[0][1]<>masarray[1] Then
    If not TestPrav(masarray[0],masarray[1]) Then Begin
      Result:=1;     {прав адм должно хватать на эту операцию}
      Exit;
    end;
  Result:=0;
  prov_nom:=masarray[5];
  If masarray[5]=0 Then Begin
     qr_exec.Active:=false;   {DML executable}
     qr_SQLTXT.Params[0].AsInteger:=masarray[0];
     qr_SQLTXT.Open;
     qr_exec.SQL.text:=qr_SQLTXT.FieldByName('sql_txt').Value;
     qr_SQLTXT.Close;
     If masarray[2]>0 Then If VarType(masarray[4][0])<4 Then
       For ii:=0 To masarray[2]-1 Do Begin
         qr_exec.SQL.Strings[masarray[4][ii]]:=masarray[3][ii];
       end
     Else For ii:=0 To masarray[2]-1 Do Begin
        qr_exec.SQL.text:=InsertParam(qr_exec.SQL.text,masarray[4][ii],masarray[3][ii]);
     end;
     try
       {DB1.StartTransaction;}
       qr_exec.ExecSQL;
     except
       frm_serv_face.Errorstate:=true;
       LogString(qr_exec.SQL.text);
       Result:=-1; {при неудачном запуске процедура вернет -1}
       frm_serv_face.Errorstate:=false;
       {DB1.Commit;}
     end;
     {DB1.Commit;}
     If masarray[1]<>log_sav[0][1] Then need_sv_sql:=true;
  end;
  If masarray[5]=1 Then Begin
     q_jurnal.Active:=false;   {SQL запрос в q_jurnal}
     qr_SQLTXT.Params[0].AsInteger:=masarray[0];
     qr_SQLTXT.Open;
     q_jurnal.SQL.text:=qr_SQLTXT.FieldByName('sql_txt').Value;
     qr_SQLTXT.Close;
     If masarray[2]>0 Then If VarType(masarray[4][0])<4 Then
       For ii:=0 To masarray[2]-1 Do Begin
         q_jurnal.SQL.Strings[masarray[4][ii]]:=masarray[3][ii];
       end
     Else For ii:=0 To masarray[2]-1 Do Begin
        q_jurnal.SQL.text:=InsertParam(q_jurnal.SQL.text,masarray[4][ii],masarray[3][ii]);
     end;
  end;
  If masarray[5]=2 Then Begin
     q_spr1.Active:=false;  {SQL запрос в q_spr1}
     qr_SQLTXT.Params[0].AsInteger:=masarray[0];
     qr_SQLTXT.Open;
     q_spr1.SQL.text:=qr_SQLTXT.FieldByName('sql_txt').Value;
     qr_SQLTXT.Close;
     If masarray[2]>0 Then If VarType(masarray[4][0])<4 Then
       For ii:=0 To masarray[2]-1 Do Begin
         q_spr1.SQL.Strings[masarray[4][ii]]:=masarray[3][ii];
       end
     Else For ii:=0 To masarray[2]-1 Do Begin
        q_spr1.SQL.text:=InsertParam(q_spr1.SQL.text,masarray[4][ii],masarray[3][ii]);
     end;
  end;
  If masarray[5]=3 Then Begin
     q_spr2.Active:=false;  {SQL запрос в q_spr2}
     qr_SQLTXT.Params[0].AsInteger:=masarray[0];
     qr_SQLTXT.Open;
     q_spr2.SQL.text:=qr_SQLTXT.FieldByName('sql_txt').Value;
     qr_SQLTXT.Close;
     If masarray[2]>0 Then If VarType(masarray[4][0])<4 Then
       For ii:=0 To masarray[2]-1 Do Begin
         q_spr2.SQL.Strings[masarray[4][ii]]:=masarray[3][ii];
       end
     Else For ii:=0 To masarray[2]-1 Do Begin
        q_spr2.SQL.text:=InsertParam(q_spr2.SQL.text,masarray[4][ii],masarray[3][ii]);
     end;
  end;
  If masarray[5]=4 Then Begin
     q_spr3.Active:=false;   {SQL запрос в q_spr3}
     qr_SQLTXT.Params[0].AsInteger:=masarray[0];
     qr_SQLTXT.Open;
     q_spr3.SQL.text:=qr_SQLTXT.FieldByName('sql_txt').Value;
     qr_SQLTXT.Close;
     If masarray[2]>0 Then If VarType(masarray[4][0])<4 Then
       For ii:=0 To masarray[2]-1 Do Begin
         q_spr3.SQL.Strings[masarray[4][ii]]:=masarray[3][ii];
       end
     Else For ii:=0 To masarray[2]-1 Do Begin
        q_spr3.SQL.text:=InsertParam(q_spr3.SQL.text,masarray[4][ii],masarray[3][ii]);
     end;
  end;
  If masarray[5]=5 Then Begin
     qr_work.Active:=false;  {SQL запрос в qr_work}
     qr_SQLTXT.Params[0].AsInteger:=masarray[0];
     qr_SQLTXT.Open;
     qr_work.SQL.text:=qr_SQLTXT.FieldByName('sql_txt').Value;
     qr_SQLTXT.Close;
     If masarray[2]>0 Then If VarType(masarray[4][0])<4 Then
       For ii:=0 To masarray[2]-1 Do Begin
         qr_work.SQL.Strings[masarray[4][ii]]:=masarray[3][ii];
       end
     Else For ii:=0 To masarray[2]-1 Do Begin
        qr_work.SQL.text:=InsertParam(qr_work.SQL.text,masarray[4][ii],masarray[3][ii]);
     end;
  end;
  If masarray[5]=6 Then Begin
     qr_teh.Active:=false;  {SQL запрос в qr_teh}
     qr_SQLTXT.Params[0].AsInteger:=masarray[0];
     qr_SQLTXT.Open;
     qr_teh.SQL.text:=qr_SQLTXT.FieldByName('sql_txt').Value;
     qr_SQLTXT.Close;
     If masarray[2]>0 Then If VarType(masarray[4][0])<4 Then
       For ii:=0 To masarray[2]-1 Do Begin
         qr_teh.SQL.Strings[masarray[4][ii]]:=masarray[3][ii];
       end
     Else For ii:=0 To masarray[2]-1 Do Begin
        qr_teh.SQL.text:=InsertParam(qr_teh.SQL.text,masarray[4][ii],masarray[3][ii]);
     end;
  end;
  If (masarray[1]<>log_sav[0][1])and(prv>0) Then
                           SaveOper(masarray[0],masarray[1],need_sv_sql);
end;


function Tvostok1.Reception(logi: OleVariant): Integer;
var                     {процедура регистрации}
 masarray, sqlparam : variant;
 ii, i1, i2 : integer;
 des_parol : string;
begin    {logi[0] - login, logi[1] - psw}
  des_parol:=CreateInterbasePassword(logi[1]);
  masarray:=VarArrayCreate([0,1], varVariant);
  masarray:=logi;
  sqlparam:=VarArrayCreate([0,5], varVariant);
  sqlparam[0]:=100; {запрос пароля на известный логин}
  sqlparam[1]:=log_sav[0][1];
  sqlparam[2]:=1;
  sqlparam[3]:=VarArrayOf([#39+logi[0]+#39]);
  sqlparam[4]:=VarArrayOf([3]);
  sqlparam[5]:=5;
  ii:=RunSQL(sqlparam);
  If ii = 0 Then Begin
     qr_work.Active:=true;
     If qr_work.RecordCount<1 Then Begin
        Result:=0;   {пользователя нет в списке}
        qr_work.Active:=false;
        qr_work.SQL.text:='';
        Exit;
     end;
     If qr_work.FieldByName('PSW').AsString <> des_parol Then Begin
        Result:=0;  {пароль пользователя не совпал}
        qr_work.Active:=false;
        qr_work.SQL.text:='';
        Exit;
     end;
     name_log[0]:=logi[0]; {логин}
     name_log[1]:=qr_work.FieldByName('pravo').AsInteger;{право}
     frm_serv_face.ListBox1.Items.Add(name_log[0]);
     i1:=qr_work.FieldByName('kod_adm').AsInteger;
     KodAdm:=i1;
     If i1<>log_sav[0][0] Then Inc(ii);
     Randomize;
     i2:=Round(2+Random(10000));
     {i1 код администратора} {i2 назначаемый временный код адм}
     log_sav[ii]:=VarArrayOf([i1,i2]);
     If log_sav[1][1]=log_sav[0][1] Then
         log_sav[1]:=VarArrayOf([log_sav[1][0],i2+1]);
     Result:=log_sav[ii][1];
     WasLogin:=True;
  end
  Else Result:=0;
  qr_work.Active:=false;
  qr_work.SQL.text:='';
end;

procedure Tvostok1.BackTrans;
begin
  DB1.Rollback;
end;

function Tvostok1.GetNextID: Integer;
begin
IsUserLogged(True);
spGetNextID.ExecProc;
Result:=spGetNextID.Params[0].asInteger;
end;


function Tvostok1.Get_pPlats: IProvider;
begin
  Result := pPlats.Provider;
end;

function Tvostok1.Get_pRequest: IProvider;
begin
  Result := pRequest.Provider;
end;

function Tvostok1.pRequestDataRequest(Sender: TObject;
  Input: OleVariant): OleVariant;
var
s:string;
begin
s:='';
if input[0]>=0 then s:=Format(' and used=%d ',[Integer(input[0])]);
if input[1]<>0 then s:=s+Format(' and start_date>=''%s'' ',[DateToStr(TDateTime(input[1]))]);
qRequest.SQL.Strings[3]:=s;
end;

function Tvostok1.Get_State_DB: Integer;
begin
  If DB1.InTransaction Then Result:=1
  Else Result:=0;
end;

procedure Tvostok1.InternalExecSQL(SQL_ID:integer;ParamVal,ParamName:OleVariant);
var
Params:OleVariant;
begin
Params:=VarArrayCreate([0,5],varVariant);
params[0]:=SQL_ID;
params[1]:=log_sav[1][1];
if VarIsNull(ParamVal) then params[2]:=0
else params[2]:=VarArrayHighBound(ParamVal,1)+1;
params[3]:=ParamVal;
params[4]:=ParamName;
params[5]:=0;
case integer(RunSQL(params)) of
-1:raise Exception.Create('Ошибка выполнения SQL.');
 1:raise exception.Create('Недостаточно прав на операцию.');
end;
end;

procedure Tvostok1.pRequestBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
var
Q:TQuery;
ds,de:TDateTime;
cod_bron,mcount:integer;
begin
if SourceDS<>qNomerInRequest then exit;
q:=TQuery.Create(nil);
q.DatabaseName:='Gostin';
q.SessionName:=DB1.SessionName;
try
   cod_bron:=DeltaDS.FieldByName('COD_BRON').OldValue;
   q.SQL.Add('select start_date,end_date from j_bron where cod_bron='+IntToStr(cod_bron));
   q.Open;
   ds:=q.Fields[0].asDateTime;
   de:=q.Fields[1].asDateTime;
   q.Close;
   if ds<date then ds:=date;
       case UpdateKind of
          ukInsert:begin
                   if not DeltaDS.FieldByName('NOMER').isNull then
                   ChangeZMN(ds,de,0,
                             DeltaDS.FieldByName('MEST').asInteger,
                             DeltaDS.FieldByName('NOMER').asInteger);
                   end;
          ukModify:begin
                      //поселение
                      if not VarIsEmpty(DeltaDS.FieldByName('MEST_USED').NewValue)and
                                      (DeltaDS.FieldByName('MEST_USED').NewValue>0) then begin
                         ChangeZMN(ds,de,0,
                                  DeltaDS.FieldByName('MEST_USED').OldValue-DeltaDS.FieldByName('MEST_USED').NewValue,
                                  DeltaDS.FieldByName('NOMER').OldValue);
                      end;
                      //-------------
                      if VarisNull(DeltaDS.FieldByName('NOMER').NewValue) then begin
                         //отказ или номер не меняли
                         if not VarisNull(DeltaDS.FieldByName('NOMER').OldValue)then //отказ от номера
                             ChangeZMN(ds,de,0,
                                         -1*DeltaDS.FieldByName('MEST').OldValue,
                                         DeltaDS.FieldByName('NOMER').OldValue);
                         exit;
                      end;
                      if VarIsEmpty(DeltaDS.FieldByName('NOMER').NewValue) then begin
                         if not VarisNull(DeltaDS.FieldByName('NOMER').OldValue) and
                            not VarIsEmpty(DeltaDS.FieldByName('MEST').NewValue) then  //сменили кол мест
                                   ChangeZMN(ds,de,0,
                                      DeltaDS.FieldByName('MEST').NewValue-DeltaDS.FieldByName('MEST').OldValue,
                                      DeltaDS.FieldByName('NOMER').OldValue);
                      end
                      else begin

                         if VarisNull(DeltaDS.FieldByName('NOMER').OldValue) then begin
                            //номер задали первый раз
                            mcount:=DeltaDS.FieldByName('MEST').CurValue;
                            if VarIsEmpty(DeltaDS.FieldByName('MEST').NewValue) then
                               mcount:=DeltaDS.FieldByName('MEST').OldValue
                            else mcount:=DeltaDS.FieldByName('MEST').NewValue;

                            ChangeZMN(ds,de,0,mcount,
                                      DeltaDS.FieldByName('NOMER').NewValue);
                         end //if VarisNull(DeltaDS.FieldByName('NOMER').OldVal
                         else begin
                            //старый номер сменили на новый
                            //уберем места для старого
                            ChangeZMN(ds,de,0,
                                      -1*DeltaDS.FieldByName('MEST').OldValue,
                                      DeltaDS.FieldByName('NOMER').OldValue);
                            //меняли ли кол мест
                            if VarisEmpty(DeltaDS.FieldByName('MEST').NewValue) then//не меняли
                               mcount:=DeltaDS.FieldByName('MEST').OldValue
                            else mcount:=DeltaDS.FieldByName('MEST').NewValue; //меняли

                            ChangeZMN(ds,de,0,mcount,
                                      DeltaDS.FieldByName('NOMER').NewValue);
                         end;// else begin  if VarisNull(DeltaDS.FieldByName('NOMER').OldVal

                      end;



  {                    if DeltaDS.FieldByName('MEST').isNull then begin
                         ChangeZMN(ds,de,0,
                                   -1*(DeltaDS.FieldByName('MEST_USED').NewValue-DeltaDS.FieldByName('MEST_USED').OldValue),
                                   DeltaDS.FieldByName('NOMER').OldValue);
                      end
                      else begin
                         ChangeZMN(ds,de,0,
                                   DeltaDS.FieldByName('MEST').NewValue-DeltaDS.FieldByName('MEST').OldValue,
                                   DeltaDS.FieldByName('NOMER').OldValue);
                      end;}
                   end;
          ukDelete:begin
                   if not DeltaDS.FieldByName('NOMER').isNull then
                   ChangeZMN(ds,de,0,
                             -1*DeltaDS.FieldByName('MEST').asInteger,
                             DeltaDS.FieldByName('NOMER').asInteger);
                   end;
       end; //case UpdateKind of
finally
  q.Free;
end;
end;

function Tvostok1.ChangeZMN(StartDate, EndDate: TDateTime; Prichina, Mest,
  Nomer: Integer): Integer;
const
DeleteForDec=  'delete from j_zmn '+
               'where date_>=''%s'' and date_<=''%s'' and '+
               'nomer=%d and mests<=%d and prichina=%d';
UpdateForDec='update j_zmn set mests=mests-%d '+
             'where date_>=''%s'' and date_<=''%s'' and nomer=%d and prichina=%d';

UpdateForInc='update j_zmn set mests=mests+%d '+
             'where  date_>=''%s'' and date_<=''%s'' and prichina=%d and nomer=%d';
InsertForInc='insert into j_zmn(date_,nomer,mests,prichina) '+
             'values(''%s'',%d,%d,%d)';

Var
q:TQuery;
sql:string;
  function Internal(sss:string;ErrCode:Integer):integer;
  begin
        q.SQl.Add(sss);
        try
         q.ExecSQL;
         LogString(sss+#13'-------Ok-------');
         Result:=0;
      except
        on E:Exception do begin
            result:=ErrCode;
            LogString(sss+#13+E.Message)
        end;
      end;
  end;
begin
Result:=0;
if not IsUserLogged then begin
   result:=1;
   exit;
end;
if (Mest=0)or(Nomer=0) then exit;
q:=TQuery.Create(nil);
q.DatabaseName:='Gostin';
q.SessionName:=DB1.SessionName;
try
   if mest>0 then begin  //Увеличение
      sql:=Format(UpdateForInc,[Mest,
                                     DateToStr(StartDate),
                                     DateToStr(EndDate),
                                     Prichina,Nomer]);
      result:=Internal(sql,2);
      if Result<>0 then exit;

      while StartDate<=Enddate do begin
         q.SQL.Clear;
         sql:=Format(InsertForInc,[DateToStr(StartDate),
                                        Nomer,Mest,Prichina]);
         Internal(sql,3); //ошибка может быть норм поведением

         StartDate:=StartDate+1;
      end;
   end
   else begin   //Уменьшение
      sql:=Format(DeleteForDec,[DateToStr(StartDate),
                                     DateToStr(EndDate),
                                     Nomer,-1*Mest,Prichina]);
      result:=Internal(sql,4);
      if Result<>0 then exit;

      q.SQL.Clear;
      sql:=Format(UpdateForDec,[-1*Mest,
                                     DateToStr(StartDate),
                                     DateToStr(EndDate),
                                     Nomer,Prichina]);
      result:=Internal(sql,5);
      if Result<>0 then exit;
   end;
finally
  q.Free;
end;
end;

function Tvostok1.Get_pFirstRooms: IProvider;
begin
  Result := pFirstRooms.Provider;
end;

procedure Tvostok1.MoveBron(StartDate, EndDate: TDateTime; Nomer: Integer);
var
IsPrevTrans:Boolean;
begin
IsUserLogged(True);
IsPrevTrans:=DB1.InTransaction;
if not IsPrevTrans then DB1.StartTransaction;
try
   InternalExecSQL(514,
                  VarArrayOf([DateToStr(StartDate),DateToStr(EndDate),IntToStr(Nomer)]),
                  VarArrayOf(['START_DATE','END_DATE','NOMER']));
   InternalExecSQL(515,
                  VarArrayOf([DateToStr(StartDate),DateToStr(EndDate),IntToStr(Nomer)]),
                  VarArrayOf(['START_DATE','END_DATE','NOMER']));
   if not IsPrevTrans then DB1.Commit;
except
   if not IsPrevTrans then DB1.Rollback;
end;
end;

function Tvostok1.Idle : TDateTime;
begin
  Result:=Now;
end;

procedure Tvostok1.CheckIsUserLogged(DataSet: TDataSet);
begin
IsUserLogged(True);
end;

procedure Tvostok1.LogExecutedSQL(ModifySQL: String);
begin
  LogString(ModifySQL);
end;

function Tvostok1.Get_pBlackList: IProvider;
begin
  Result := pBlackList.Provider;
end;

procedure Tvostok1.FillGostPayHistory(KodGost: Integer);
var
IsPrevTrans:Boolean;
begin
IsUserLogged(True);
IsPrevTrans:=DB1.InTransaction;
if not IsPrevTrans then DB1.StartTransaction;
try
   with spFillPayHistory do begin
      ParamByName('KGOST').asInteger:=KodGost;
      ExecProc;
   end;
   if not IsPrevTrans then DB1.Commit;
except
   if not IsPrevTrans then DB1.Rollback;
end;
end;

function Tvostok1.Get_pMail: IProvider;
begin
  Result := pMail.Provider;
end;

procedure Tvostok1.qMailBeforeOpen(DataSet: TDataSet);
begin
CheckIsUserLogged(nil);
qMail.Params[0].asInteger:=KodAdm;
end;

procedure Tvostok1.pMailBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
begin
  if UpdateKind=ukInsert then begin
     DeltaDS.Edit;
     DeltaDS.FieldByName('FROM_ADM').asInteger:=KodAdm;
     DeltaDS.FieldByName('ID').asInteger:=GetNextID;
     DeltaDS.FieldByName('SEND_DATE').asDateTime:=Now;
     DeltaDS.Post;
  end;
end;

function Tvostok1.CheckNewMessages: Integer;
const
sql='select count(*) from mail where to_adm=%d and receive_date is null';
var
q:TQuery;
begin
IsUserLogged(True);
Result:=0;
q:=TQuery.Create(nil);
q.DatabaseName:='Gostin';
q.SessionName:=DB1.SessionName;
try
   q.SQL.Add(Format(sql,[KodAdm]));
   q.Open;
   Result:=q.Fields[0].asInteger;
finally
   q.Close;
   q.Free;
end;
end;

function Tvostok1.Get_pMail_out: IProvider;
begin
  Result := pMail_out.Provider;
end;

procedure Tvostok1.pMail_outBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
begin
  if UpdateKind=ukInsert then begin
     DeltaDS.Edit;
     DeltaDS.FieldByName('FROM_ADM').asInteger:=KodAdm;
     DeltaDS.FieldByName('ID').asInteger:=GetNextID;
     DeltaDS.FieldByName('SEND_DATE').asDateTime:=Now;
     DeltaDS.Post;
  end;
end;

procedure Tvostok1.qMail_outBeforeOpen(DataSet: TDataSet);
begin
   CheckIsUserLogged(nil);
   qMail_out.Params[0].asInteger:=KodAdm;
end;

Function Tvostok1.ResetTarifs : Integer;
Begin
  IsUserLogged(True);
  If name_log[1]<=1 Then Begin
     Result:=1;
     Exit;
  end;
  Result:=0;
  try
    if not DB1.InTransaction then StartTrans;
    spResetTarifs.ExecProc;
    if DB1.InTransaction then CommitTrans;
    LogString('$$$$$$$$$ ИЗМЕНЕНИЕ ТАРИФОВ $$$$$$$$$$'+#13+'^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
  except
    if DB1.InTransaction then BackTrans;
    Result:=-1;
  end;
end;

procedure Tvostok1.pGornichBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TClientDataSet; UpdateKind: TUpdateKind;
  var Applied: Boolean);
begin
  if UpdateKind=ukInsert then begin
     DeltaDS.Edit;
     DeltaDS.FieldByName('ID').asInteger:=GetNextID;
     DeltaDS.Post;
  end;
end;

function Tvostok1.Get_pGornich: IProvider;
begin
  Result := pGornich.Provider;
end;

function Tvostok1.Get_pGenClear: IProvider;
begin
  Result := pGenClear.Provider;
end;

function Tvostok1.GetRiteExtra: Integer;
const
sql='Select * from SYS_OPTION';
var
q:TQuery;
dd : Tdate;
ss,ssr : string;
ch : real;
begin
IsUserLogged(True);
q:=TQuery.Create(nil);
q.DatabaseName:='Gostin';
q.SessionName:=DB1.SessionName;
Result:=-1;
try
   q.SQL.Add(Format(sql,[KodAdm]));
   q.Open;
   If not VarIsNull(q.Fields[1].Value) Then Begin
     ch:=q.Fields[1].asFloat;
     ch:=ch/Pi;
     ss:=DateToStr(ch);
     ssr:=DateToStr(date);
     If StrToDate(ssr)<=StrToDate(ss) Then Result:=0
     Else Result:=1;
   end;
finally
   q.Close;
   q.Free;
end;
end;

function Tvostok1.IsSys: Integer;
begin
   Result:=name_log[1];
end;

initialization
  TComponentFactory.Create(ComServer, Tvostok1,
    Class_vostok1, ciMultiInstance);
end.
