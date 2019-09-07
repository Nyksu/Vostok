unit srv_face;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MIDASCon, ExtCtrls, inifiles, Db, DBTables;

type
  Tfrm_serv_face = class(TForm)
    bt_shutdown: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    lb_countClients: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    DB_face: TDatabase;
    qr_last_dat: TQuery;
    qr_ask: TQuery;
    qr_update: TQuery;
    timer_start: TTimer;
    Timer_looking: TTimer;
    lb_dat: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure bt_shutdownClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure timer_startTimer(Sender: TObject);
    procedure Timer_lookingTimer(Sender: TObject);
  private
    FClientCount: Integer;
    inifil : TIniFile;
    log_path : string;
    log_ext : string;
    { Private declarations }
  public
     Errorstate : boolean;
     procedure CalcClientsConnects(in_out : integer);
    { Public declarations }
  end;

Procedure Save_Sql(name_cl,sql_txt : string);

var
  frm_serv_face: Tfrm_serv_face;
  logfile : TextFile;
  can_write, log_is : boolean;
  last_date, work_date : TDate;

implementation

{$R *.DFM}

procedure Tfrm_serv_face.FormCreate(Sender: TObject);
var
 file_name, exe_name : string;
 ddd : TDateTime;
 Year, Month, Day: word;
 ps : integer;
begin
  can_write:=true;
  Errorstate:=false;
  exe_name:=application.ExeName;
  ps:=Length(exe_name)-13;
  Delete(exe_name,ps,14);
  inifil:= TIniFile.Create(exe_name+'srv.ini');
  log_path:=inifil.ReadString('LOG','log_path','c:\srv_log\');
  log_ext:=inifil.ReadString('LOG','log_ext','log');
  If inifil.ReadString('LOG','enabled','0')='1' Then log_is:=true
       Else log_is:=false;
  ddd:=date;
  DecodeDate(ddd, Year, Month, Day);
  file_name:=log_path+IntToStr(Day)+'_'+IntToStr(Month)+'_'
             +IntToStr(Year)+'.'+log_ext;
  AssignFile(logfile,file_name);
  {$I-}
  If FileExists(file_name) Then Append(logfile)
  Else Begin
     MkDir(log_path);
     Rewrite(logfile);
  end;
  WriteLn(logfile,'+++ Time '+TimeToStr(time)+' +++');
  CloseFile(logfile);
  {$I+}
  timer_start.Enabled:=true;
end;

Procedure Save_Sql(name_cl,sql_txt : string);
Begin
  If (not log_is) and (not frm_serv_face.Errorstate) Then Exit;
  While not can_write Do Begin end;
  try
    can_write:=false;
    try
     Append(logfile);
     WriteLn(logfile,'******** ',DateTimeToStr(now),' ***** Operator = ',name_cl);
     WriteLn(logfile,sql_txt);
     WriteLn(logfile,'---- END SQL -----');
     CloseFile(logfile);
    finally
     can_write:=true;
    end;
  except
  end;
end;

procedure Tfrm_serv_face.CalcClientsConnects(in_out : integer);
Begin
  FClientCount := FClientCount + In_out;
  lb_countClients.Caption := IntToStr(FClientCount);
end;

procedure Tfrm_serv_face.bt_shutdownClick(Sender: TObject);
begin
  frm_serv_face.Close;
end;

procedure Tfrm_serv_face.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Timer_looking.Enabled:=false;
  timer_start.Enabled:=false;
  DB_face.Connected:=false;
end;

procedure Tfrm_serv_face.timer_startTimer(Sender: TObject);
begin
  timer_start.Enabled:=false;
  Try
    DB_face.Connected:=true;
  except
    timer_start.Enabled:=true;
    Exit;
  end;
  try
   qr_last_dat.Active:=true;
  except
  end;
  work_date:=date;
  If (qr_last_dat.Active)and(not qr_last_dat.EOF) Then Begin
     last_date:=qr_last_dat.FieldByName('dat').AsDateTime;
     last_date:=StrToDate(DateToStr(last_date));
     If date>last_date Then work_date:=last_date;
  end;
  qr_last_dat.Active:=false;
  Timer_looking.Enabled:=true;
end;

procedure Tfrm_serv_face.Timer_lookingTimer(Sender: TObject);
const
  Updat_sys_date='Update SYS_OPTION SET date_last_look=''%s''';
  Updat_zmn_4='Update J_zmn SET date_=''%s'' WHERE prichina=4 and date_>=''%s''';
  Del_logs='Delete from j_oper where date_op<=''%s''';
  Remove_bron='Insert into j_move_zm '+
              'Select t1.date_, t1.nomer, 0, t1.mests from j_zmn t1 '+
              'where t1.prichina=0 and t1.date_=''%s'' '+
              'and exists (Select * from j_zmn t2 where '+
              't2.date_=t1.date_-1 and t1.nomer=t2.nomer and ((t2.prichina=3)or(t2.prichina=6)))';
  Del_for_rem='Delete from j_zmn t1 where t1.date_=''%s'' '+
              'and exists (Select t2.nomer from j_zmn t2 where '+
              't2.date_=t1.date_-1 and t1.nomer=t2.nomer and ((t2.prichina=3)or(t2.prichina=6)or(t1.prichina=2)))';
  Ins_remont='Insert into j_zmn '+
              'Select t1.date_+1, t1.nomer, prichina, t1.mests from j_zmn t1 '+
              'where t1.date_=''%s''-1 and ((t1.prichina=3)or(t1.prichina=6)or(t1.prichina=2))';
  Del_proc='Delete from J_procent_zmn';
  Insert_proc='Insert into J_procent_zmn '+
              'Select nom, proc_zn from GET_PROC_ZN(''%s'',''%s'')';
  Clear_gluk='Delete from J_schet_nal '+
             'where seria like ''%X'' and state > 0';
  Sost='Select * from SYS_OPTION';
  Clear_2gluk='Delete from schets_in_group t1 '+
              'where Exists (Select distinct n1.nomer from J_schet_nal n1 '+
              'where n1.seria like ''%X'' and n1.state > 0 and n1.nom_schet=t1.nom_schets)';
var
  date_now : TDate;
  ch : real;
  ss,ssr : string;
begin
  Timer_looking.Enabled:=false;
  date_now:=date;
  If Trunc(date_now-work_date)>0 Then Begin
     DB_face.StartTransaction;
     qr_update.SQL.text:=Format(Updat_sys_date,[DateToStr(date_now)]);
     try
       qr_update.ExecSQL;
     except
     end;
     qr_update.SQL.text:=Del_proc;
     try
       qr_update.ExecSQL;
     except
     end;
     qr_update.SQL.text:=Format(Insert_proc,[DateToStr(date_now-30),DateToStr(date_now)]);
     try
       qr_update.ExecSQL;
     except
     end;
     If Trunc(date_now-work_date)=1 Then Begin
       qr_update.SQL.text:=Format(Updat_zmn_4,[DateToStr(date_now),DateToStr(work_date)]);
       try
         qr_update.ExecSQL;
       except
       end;
       try
         If DB_face.InTransaction Then DB_face.Commit;
       except
         If DB_face.InTransaction Then DB_face.Rollback;
       end;

       If not DB_face.InTransaction Then DB_face.StartTransaction;
       qr_update.SQL.text:=Format(Remove_bron,[DateToStr(date_now)]);
       try
         qr_update.ExecSQL;
       except
       end;
       qr_update.SQL.text:=Format(Del_for_rem,[DateToStr(date_now)]);
       try
         qr_update.ExecSQL;
       except
       end;
       qr_update.SQL.text:=Format(Ins_remont,[DateToStr(date_now)]);
       try
         qr_update.ExecSQL;
       except
       end;
     end;
     try
         If DB_face.InTransaction Then DB_face.Commit;
     except
         If DB_face.InTransaction Then DB_face.Rollback;
     end;

     If not DB_face.InTransaction Then DB_face.StartTransaction;
     qr_update.SQL.text:=Format(Del_logs,[DateToStr(date_now-5)]);
     try
       qr_update.ExecSQL;
       If DB_face.InTransaction Then DB_face.Commit;
     except
       If DB_face.InTransaction Then DB_face.Rollback;
     end;

     qr_update.SQL.text:=Sost;
     qr_update.Open;
     ch:=qr_update.Fields[1].asFloat;
     ch:=ch/Pi;
     ss:=DateToStr(ch);
     ssr:=DateToStr(date-7);
     qr_update.Active:=false;
     If StrToDate(ssr)>StrToDate(ss) Then Begin
       If not DB_face.InTransaction Then DB_face.StartTransaction;
       try
         qr_update.SQL.text:=Clear_2gluk;
         qr_update.ExecSQL;
         qr_update.SQL.text:=Clear_gluk;
         qr_update.ExecSQL;
         If DB_face.InTransaction Then DB_face.Commit;
       except
         If DB_face.InTransaction Then DB_face.Rollback;
       end;
     end;

     lb_dat.Caption:=DateToStr(date_now);
  end;
  work_date:=date_now;
  Timer_looking.Enabled:=true;
end;

end.
