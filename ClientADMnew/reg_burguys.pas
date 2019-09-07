unit reg_burguys;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, DBCtrls, Db, DBClient;

type
  Tfr_in_men = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    ed_land_name: TEdit;
    ed_passport: TEdit;
    bt_next: TBitBtn;
    bt_exit: TBitBtn;
    ed_dat_gran: TDateTimePicker;
    Label3: TLabel;
    ed_kpp: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    ed_org: TEdit;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    ed_seria: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ed_dat_to_visa: TDateTimePicker;
    ed_kat_visa: TDBLookupComboBox;
    cds_kategor: TClientDataSet;
    ds_kategor: TDataSource;
    ed_path: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    ed_placer: TEdit;
    ed_dr: TDateTimePicker;
    procedure bt_exitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bt_nextClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ed_drChange(Sender: TObject);
  private
    dr : TDateTime;
    { Private declarations }
  public
    { Public declarations }
  end;

function Set_ext_burg_dats(kod_gost : integer; year : integer) : boolean;


var
  fr_in_men : Tfr_in_men;
  igost : integer;
  rrss : boolean;

implementation

{$R *.DFM}

Uses MainADM;

function Set_ext_burg_dats(kod_gost : integer; year : integer) : boolean;
Begin
  rrss:=false;
  igost:=kod_gost;
  try
     try
       fr_in_men:=Tfr_in_men.Create(Application);
       fr_in_men.dr:=StrToDate('01.01.'+IntToStr(year));
       fr_in_men.ShowModal;
     finally
       fr_in_men.Free;
       Result:=rrss;
     end;
  except
  end;
end;

procedure Tfr_in_men.bt_exitClick(Sender: TObject);
begin
   fr_in_men.Close;
end;

procedure Tfr_in_men.FormCreate(Sender: TObject);
var
 resSQL : integer;
 parametry : Variant;
begin
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=234;{Виды виз}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=0;
   parametry[3]:=VarArrayOf(['']);
   parametry[4]:=VarArrayOf(['']);
   parametry[5]:=2;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL <>0 Then Begin
      MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
      Exit;
   end;
   cds_kategor.Active:=true;
   ed_dat_gran.Date:=date;
   ed_dat_to_visa.Date:=date;
end;

procedure Tfr_in_men.bt_nextClick(Sender: TObject);
var
 resSQL, regnom : integer;
 parametry : Variant;
begin
   If ed_land_name.text='' Then Begin
      ShowMessage('Введите полное наименование страны !!');
      ed_land_name.SetFocus;
      Exit;
   end;
   If ed_passport.text='' Then Begin
      ShowMessage('Введите паспортные данные иностранного гражданина !!');
      ed_passport.SetFocus;
      Exit;
   end;
   If ed_kpp.text='' Then Begin
      ShowMessage('Введите наименование КПП !!');
      ed_kpp.SetFocus;
      Exit;
   end;
   If ed_org.text='' Then Begin
      ShowMessage('Введите наименование принимающей гостя организации !!');
      ed_org.SetFocus;
      Exit;
   end;
   If ed_path.text='' Then Begin
      ShowMessage('Введите путь следования гостя !!');
      ed_path.SetFocus;
      Exit;
   end;
   If ed_seria.text='' Then Begin
      ShowMessage('Введите серию и номер визы !!');
      ed_seria.SetFocus;
      Exit;
   end;
   If VarIsNull(ed_kat_visa.KeyValue) Then Begin
      ShowMessage('Выбирите категорию визы !!');
      ed_kat_visa.SetFocus;
      Exit;
   end;
   If ed_placer.Text='' Then Begin
      ShowMessage('Введите место рождения !!');
      ed_placer.SetFocus;
      Exit;
   end;
   regnom:=fr_ClientAdm.NextID(270);
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=235;{Дополнительные сведения о иностр. гражданах}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=10;
   parametry[3]:=VarArrayOf([IntToStr(igost),ed_land_name.text,ed_passport.text,
                             DateToStr(ed_dat_gran.Date),ed_kpp.text,ed_seria.text,
                             IntToStr(ed_kat_visa.KeyValue),DateToStr(ed_dat_to_visa.date),
                             ed_path.text,ed_org.text]);
   parametry[4]:=VarArrayOf(['gost','land','pasp','dt_gran','kpp','visa','visa_tip','dt_visa','path','org']);
   parametry[5]:=0;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL <>0 Then Begin
      MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
      Exit;
   end;
   parametry[0]:=269;{Дополнительные сведения о иностр. гражданах}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=3;
   parametry[3]:=VarArrayOf([DateToStr(dr),ed_placer.text,IntToStr(igost)]);
   parametry[4]:=VarArrayOf(['dr','pls','id']);
   parametry[5]:=0;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL <>0 Then Begin
      MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
      Exit;
   end;
   rrss:=true;
   MessageDlg('Код регистрации иностранного гостя: '+IntToStr(regnom), mtInformation, [mbOk], 0);
   fr_in_men.Close;
end;

procedure Tfr_in_men.FormShow(Sender: TObject);
begin
   ed_dr.DateTime:=dr;
end;

procedure Tfr_in_men.ed_drChange(Sender: TObject);
begin
  dr:=ed_dr.DateTime;
end;

end.
