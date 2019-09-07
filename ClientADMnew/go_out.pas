unit go_out;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, DBCtrls, Grids, DBGrids, StdCtrls, Spin, ComCtrls, ExtCtrls,
  Ask_dlg, Vozvr_nal, DateUtil;

type
  Tfr_go_out = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    ed_nom_komn: TSpinEdit;
    bt_gost: TButton;
    tb_gost: TDBGrid;
    Label3: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    bt_go_out: TBitBtn;
    bt_cancel: TBitBtn;
    Bevel1: TBevel;
    Label2: TLabel;
    DBText3: TDBText;
    DBText4: TDBText;
    ch_first_sut: TCheckBox;
    procedure bt_gostClick(Sender: TObject);
    procedure bt_cancelClick(Sender: TObject);
    procedure bt_go_outClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tb_gostCellClick(Column: TColumn);
    procedure tb_gostKeyPress(Sender: TObject; var Key: Char);
  private
    work_dat : TDate;
    work_time : TTime;
    dolg : integer;
    sutt : real;
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Close_schet_nal;

var
  fr_go_out: Tfr_go_out;

implementation

uses MainADM;

{$R *.DFM}

Procedure Close_schet_nal;
Begin
  try
    try
      fr_go_out:=Tfr_go_out.Create(Application);
      fr_go_out.ShowModal;
    finally
      fr_go_out.free;
    end;
  except
  end;
end;

procedure Tfr_go_out.bt_gostClick(Sender: TObject);
var
 parametry : variant;
 resSQL,res_op : integer;
begin
  dolg:=0;
  If ed_nom_komn.text>'' Then Begin
     tb_gost.Enabled:=true;
     bt_go_out.Enabled:=false;
     fr_ClientAdm.CDS_work.Active:=false;
     {StatusBar1.Panels[0].Text:='Статус:';}
     fr_ClientAdm.CDS_sp1.Active:=false;
     parametry:=VarArrayCreate([0, 5], varVariant);
     parametry[0]:=157;
     parametry[1]:=fr_ClientAdm.kod_adm;
     parametry[2]:=3;
     parametry[3]:=VarArrayOf([IntToStr(ed_nom_komn.Value),'','']);
     parametry[4]:=VarArrayOf([5,10,11]);
     parametry[5]:=5;
     resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
     res_op:=0;
     If resSQL=0 Then Begin
       fr_ClientAdm.CDS_work.Active:=true;
       res_op:=fr_ClientAdm.CDS_work.RecordCount;
     end
     Else Begin
       MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
       If sutt=1 Then ch_first_sut.Enabled:=false;
       Exit;
     end;
     If res_op > 0 Then Begin
       sutt:=fr_ClientAdm.CDS_work.FieldByName('sutok').AsFloat;
       If sutt=1 Then ch_first_sut.Enabled:=true
       Else ch_first_sut.Enabled:=false;
       tb_gost.SetFocus;
       bt_go_out.Enabled:=true;
       bt_go_out.SetFocus;
     end
     Else Begin
       MessageDlg('В номере нет гостей с наличным расчетом!', mtWarning, [mbOk], 0);
       tb_gost.Enabled:=false;
       ed_nom_komn.SetFocus;
     end;
  end;
end;

procedure Tfr_go_out.bt_cancelClick(Sender: TObject);
begin
  fr_ClientAdm.CDS_work.Active:=false;
  fr_go_out.Close;
end;


procedure Tfr_go_out.bt_go_outClick(Sender: TObject);
var
  dat_out : TDate;
  nomer, gost, mest, resSQL, schet : integer;
  rr, parametry : variant;
  swt : string;
  tim_out : string[8];
  time_in : TTime;
  do_it : boolean;
begin
  nomer:=fr_ClientAdm.CDS_work.FieldByName('nomer').AsInteger;
  gost:=fr_ClientAdm.CDS_work.FieldByName('kod_gost').AsInteger;
  dat_out:=fr_ClientAdm.CDS_work.FieldByName('date_out').AsDateTime;
  schet:=fr_ClientAdm.CDS_work.FieldByName('schet').AsInteger;
  dolg:=fr_ClientAdm.CDS_work.FieldByName('dolg').AsInteger;
  tim_out:=fr_ClientAdm.CDS_work.FieldByName('time_out').AsString;
  time_in:=fr_ClientAdm.CDS_work.FieldByName('time_in').AsDateTime;
  swt:=TimeToStr(work_time);
  do_it:=false;
  If Length(swt)<8 Then swt:='0'+swt;
  If (Trunc(dat_out)<Trunc(work_dat))or
         ((Trunc(dat_out)=Trunc(work_dat))and
         ((tim_out<'18:00:00')and(swt>'18:00:00'))) Then
    If Get_Answer('Внимание !!!','Гость ДОЛЖНИК!'+#13+'Перед выселением продлите номер!!'
                    +#13+'Для продления нажмите <ДА>'+#13+
                    'Если гость выехал нерасплатившись нажмите <Нет>',true)
    Then Begin
      fr_go_out.Close;
      Exit;
    end;
  If (Trunc(dat_out)>Trunc(work_dat)) and (not ch_first_sut.Checked) Then Begin
    If Get_Answer('Внимание !!!','Досрочный выезд? <ДА>/<Нет>',true) Then
     If Get_Answer('Внимание !!!','Производить возврат? <ДА>/<Нет>',true) Then Begin
      rr:=Do_rebay(1,nomer,gost);
      if rr[1]<=0 Then Begin
             If fr_ClientAdm.MIDASConnection1.AppServer.Get_State_DB = 1 Then
                fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
             MessageDlg('Отказ от выселения!', mtWarning, [mbOk], 0);
             Exit;
      end;
     end
     Else do_it:=true
    Else Exit;
  end
  Else If IncHour(time_in,2)>work_time Then
           If Get_Answer('Внимание !!!','По правилам необходимо сделать полный возврат!!'+
                          #13+'Выселить без возврата? <ДА>/<Нет>',false) Then do_it:=true
           Else Begin
              ShowMessage('Сделайте полный возврат с помощью кнопки <Ошибка оформления>!');
              Exit;
           end
       Else do_it:=true;
  If do_it Then Begin
    fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
    mest:=fr_ClientAdm.CDS_work.FieldByName('mests').AsInteger;
    parametry:=VarArrayCreate([0, 5], varVariant);
    If dolg>0 Then Begin
       fr_ClientAdm.MIDASConnection1.AppServer.ChangeZMN(dat_out+1,work_dat,8,-mest,nomer);
       dolg:=Round(work_dat-dat_out);
       parametry[0]:=195;  {Изменение к-ва долга}
       parametry[1]:=fr_ClientAdm.kod_adm;
       parametry[2]:=3;
       parametry[3]:=VarArrayOf([IntToStr(dolg),IntToStr(nomer),IntToStr(gost)]);
       parametry[4]:=VarArrayOf(['dolg','nomer','gost']);
       parametry[5]:=0;
       resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
       If resSQL<0 Then Begin
         MessageDlg('Ошибка долга гостя! Попробуйте снова.', mtWarning, [mbOk], 0);
         fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
         Exit;
       end;
    end
    Else {Удаляем занятые места}
    fr_ClientAdm.MIDASConnection1.AppServer.ChangeZMN(work_dat,dat_out,1,-mest,nomer);
    {изменяем таблицу миграции гостя}
    parametry[0]:=170;
    parametry[1]:=fr_ClientAdm.kod_adm;
    parametry[2]:=5;
    parametry[3]:=VarArrayOf([DateToStr(work_dat),TimeToStr(work_time),
                              IntToStr(gost),'1',IntToStr(nomer)]);
    parametry[4]:=VarArrayOf(['d_out','tm_out','gost','stat','nomer']);
    parametry[5]:=0;
    resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
    If resSQL<0 Then Begin
      MessageDlg('Ошибка миграции гостя! Попробуйте снова.', mtWarning, [mbOk], 0);
      fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
      Exit;
    end;
    parametry[0]:=165; {Изменение состояния счета}
    parametry[1]:=fr_ClientAdm.kod_adm;
    parametry[2]:=2;{сост. счета: 0-открыт,1-закрыт,2-возврат,3-удален}
    parametry[3]:=VarArrayOf(['1',IntToStr(schet)]);
    parametry[4]:=VarArrayOf([2,5]);
    parametry[5]:=0;
    resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
    If resSQL<0 Then Begin
      MessageDlg('Ошибка закрытия счета! Попробуйте снова.', mtWarning, [mbOk], 0);
      fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
      Exit;
    end;
    If fr_ClientAdm.settings[1][0]=0 Then Begin
    {Помечаем места как "грязные"}
      fr_ClientAdm.MIDASConnection1.AppServer.ChangeZMN(date,date,4,mest,nomer);

      fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
    end;
  end;
  MessageDlg('Гость удачно выехал!', mtConfirmation, [mbOk], 0);
  If fr_ClientAdm.MIDASConnection1.AppServer.Get_State_DB = 1 Then
                     fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
  fr_ClientAdm.CDS_work.Active:=false;
  fr_go_out.Close;
end;

procedure Tfr_go_out.FormCreate(Sender: TObject);
begin
  work_dat:=date;
  work_time:=time;
end;

procedure Tfr_go_out.tb_gostCellClick(Column: TColumn);
begin
  sutt:=fr_ClientAdm.CDS_work.FieldByName('sutok').AsFloat;
  If sutt=1 Then ch_first_sut.Enabled:=true
       Else Begin
         ch_first_sut.Enabled:=false;
         ch_first_sut.Checked:=false;
       end;
end;

procedure Tfr_go_out.tb_gostKeyPress(Sender: TObject; var Key: Char);
begin
   sutt:=fr_ClientAdm.CDS_work.FieldByName('sutok').AsFloat;
   If sutt=1 Then ch_first_sut.Enabled:=true
       Else Begin
         ch_first_sut.Enabled:=false;
         ch_first_sut.Checked:=false;
       end;
end;

end.
