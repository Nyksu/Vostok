unit Password;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  DateUtil, Buttons, DM, Dialogs;

type
  Tfr_regestrat = class(TForm)
    Label1: TLabel;
    ed_password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    ed_login: TEdit;
    Label2: TLabel;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function ConnectToVostok : integer;

var
  fr_regestrat: Tfr_regestrat;
  res, pings : integer;

implementation

{$R *.DFM}

Function ConnectToVostok : integer;
Begin
  res:=2;
  pings:=3;
  try
    try
      fr_regestrat:=Tfr_regestrat.Create(Application);
      fr_regestrat.ShowModal;
    finally
      Result:=res;
      fr_regestrat.Free;
    end;
  except
  end;
end;

procedure Tfr_regestrat.OKBtnClick(Sender: TObject);
Var
  log : Variant;
  time_serv : TDateTime;
  sys_date : TSystemTime;
begin
  If ed_login.Text='' Then Begin
     MessageDlg('Введите свое имя!', mtWarning, [mbOk], 0);
     ed_login.SetFocus;
     Exit;
  end;
  If ed_password.Text='' Then Begin
     MessageDlg('Введите ваш пароль!', mtWarning, [mbOk], 0);
     ed_password.SetFocus;
     Exit;
  end;
  If pings<0 Then Begin
     MessageDlg('В доступе отказано!', mtError, [mbOk], 0);
     res:=1;
     fr_regestrat.Close;
     Exit;
  end;
  Dec(pings);
  try
    DataModuls.SockToVostok.Connected:=true;
  except
     MessageDlg('Сервер не найден! Компьютер не в сети или проблемы с сервером!', mtError, [mbOk], 0);
     res:=2;
     fr_regestrat.Close;
     Exit;
  end;
  If DataModuls.settings[6][0]=0 Then Begin
     time_serv:=DataModuls.SockToVostok.AppServer.Idle;
     time_serv:=IncHour(time_serv,-1*DataModuls.settings[7][0]);
     DateTimeToSystemTime(time_serv,sys_date);
     SetSystemTime(sys_date);
  end;
  log:=VarArrayCreate([0,1], varVariant);
  log[0]:=ed_login.Text;
  log[1]:=ed_password.Text;
  DataModuls.kod_adm:=DataModuls.SockToVostok.AppServer.Reception(log);
  If DataModuls.kod_adm<=0 Then Begin
    DataModuls.SockToVostok.Connected:=false;
    MessageDlg('Неверные пароль или имя!', mtError, [mbOk], 0);
    res:=1;
    ed_login.SetFocus;
    ed_password.Text:='';
    Exit;
  end;
  res:=0;
  fr_regestrat.Close;
end;

end.

