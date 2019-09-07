unit DM;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, DateUtil,
  Dialogs, DBTables, DB, DBClient, MConnect, SConnect, ExtCtrls, registry;

type
  TDataModuls = class(TDataModule)
    SockToVostok: TSocketConnection;
    cds_jur: TClientDataSet;
    cds_spr1: TClientDataSet;
    cds_spr2: TClientDataSet;
    cds_spr3: TClientDataSet;
    cds_work: TClientDataSet;
    cds_teh: TClientDataSet;
    Timer1: TTimer;
    procedure DataModulsCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure DataModulsDestroy(Sender: TObject);
  private
    first_mail_test : boolean;
    { Private declarations }
  public
    settings : variant;
    kod_adm : integer;
    nom_adm : integer;
    test_mail : boolean;
    function GetTehParam(nsql : integer; param : variant) : variant;
    function GetData(nsql : integer; param : variant) : variant;
    { Public declarations }
  end;

Function CreateDM : boolean;


var
  DataModuls: TDataModuls;
  rus, lat : HKL;

implementation

{$R *.DFM}

Uses Post;

Function CreateDM : boolean;
Begin
   try
     DataModuls:=TDataModuls.Create(Application);
   except
     Result:=false;
     Exit;
   end;
   Result:=true;
end;


procedure TDataModuls.DataModulsCreate(Sender: TObject);
var
 rr : Tregistry;
 ss : TStringList;
 indss : integer;
begin
  settings:=VarArrayCreate([0, 10], varVariant);
  rus:=LoadKeyboardLayout('00000419', 0);
  lat:=LoadKeyboardLayout('00000409', 0);
  ActivateKeyboardLayout(lat,0);
  ss:=TstringList.Create;
  rr:=Tregistry.Create;
  rr.RootKey:= HKEY_LOCAL_MACHINE;
  rr.OpenKey('SOFTWARE\Vostok\Main_admin',true);
  rr.GetValueNames(ss);
  test_mail:=true;
  first_mail_test:=true;
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
         rr.WriteInteger('Delta_local_time',settings[6][0]);
     end
  end
  Else Begin
    rr.WriteInteger('Delta_local_time',5);
    settings[7]:=VarArrayOf([0,'Разница времени с Гринвичем.']);
  end;

  settings[8]:=1;

  SockToVostok.Host:=settings[5][0];
  Timer1.Enabled:=True;
  ss.Free;
end;

procedure TDataModuls.Timer1Timer(Sender: TObject);
var
  time_serv : TDateTime;
  sys_date : TSystemTime;
  ch_mail : Integer;
begin
  Timer1.Enabled:=false;
  try
  if SockToVostok.Connected then Begin
      time_serv:=SockToVostok.AppServer.Idle;
      If (Trunc(date)<>Trunc(time_serv))and(settings[6][0]=0) Then Begin
         time_serv:=IncHour(time_serv,-1*settings[7][0]);
         DateTimeToSystemTime(time_serv,sys_date);
         SetSystemTime(sys_date);
      end;
      If test_mail Then Begin
       test_mail:=false;
       ch_mail:=SockToVostok.AppServer.CheckNewMessages;
       If ch_mail>0 Then Begin
         ShowMessage(IntToStr(ch_mail)+' новых писем!!');
         If first_mail_test Then Begin
            first_mail_test:=false;
            StartPost;
         end;
       end;
       test_mail:=true;
      end;
      settings[8]:=SockToVostok.AppServer.GetRiteExtra;
  end;
  finally
    Timer1.Enabled:=true;
  end;
end;

function TDataModuls.GetTehParam(nsql : integer; param : variant) : variant;
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
    re:=SockToVostok.AppServer.RunSQL(parametry);
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

function TDataModuls.GetData(nsql : integer; param : variant) : variant;
var
 re : integer;
 parametry : Variant;
Begin
   re:=0;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=nsql;
   parametry[1]:=kod_adm;
   parametry[2]:=param[0];{количество параметров в sql}
   parametry[3]:=param[1];{параметры sql}
   parametry[4]:=param[2];{номера строк параметров sql}
   parametry[5]:=6;
   try
    try
    screen.cursor:=crHourGlass;
    re:=SockToVostok.AppServer.RunSQL(parametry);
    finally
    screen.cursor:=crDefault;
    end;
   except
      Result:=null;
      re:=-1;
      Raise;
   end;
   If re=0 Then Begin
     CDS_teh.Open;
     Result:=CDS_teh.Data;
     CDS_teh.Active:=false;
   end
   else Begin
      Result:=null;
      MessageDlg('Нет прав на операцию!', mtWarning, [mbOk], 0);
   end;
end;

procedure TDataModuls.DataModulsDestroy(Sender: TObject);
begin
  SockToVostok.Connected:=false;
end;

end.
