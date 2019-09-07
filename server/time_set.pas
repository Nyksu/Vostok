procedure Tfr_ClientAdm.Timer1Timer(Sender: TObject);
var
  time_serv : TDateTime;
  sys_date : TSystemTime;
begin
  if MIDASConnection1.Connected then Begin
      time_serv:=MIDASConnection1.AppServer.Idle;
      If Trunc(date)<>Trunc(time_serv) Then Begin
         DateTimeToSystemTime(time_serv,sys_date);
         SetSystemTime(sys_date);
      end;
  end;
end;