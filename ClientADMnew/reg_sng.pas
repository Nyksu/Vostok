unit reg_sng;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  Tfr_sng_reg = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ed_land_name: TEdit;
    ed_passport: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label10: TLabel;
    ed_dr: TDateTimePicker;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ed_drChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private  
    dr : TDateTime;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fr_sng_reg : Tfr_sng_reg;
  ggost : integer;
  rrs : boolean;

function Set_ext_sng_dats(kod_gost : integer; year : integer) : boolean;

implementation

{$R *.DFM}

Uses MainADM;

function Set_ext_sng_dats(kod_gost : integer; year : integer) : boolean;
Begin
  rrs:=false;
  ggost:=kod_gost;
  try
     try
       fr_sng_reg:=Tfr_sng_reg.Create(Application);
       fr_sng_reg.dr:=StrToDate('01.01.'+IntToStr(year));
       fr_sng_reg.ShowModal;
     finally
       fr_sng_reg.Free;
       Result:=rrs;
     end;
  except
  end;
end;

procedure Tfr_sng_reg.BitBtn2Click(Sender: TObject);
begin
  fr_sng_reg.Close;
end;

procedure Tfr_sng_reg.BitBtn1Click(Sender: TObject);
var
 resSQL : integer;
 parametry : Variant;
begin
   If ed_land_name.text='' Then Begin
      ShowMessage('Введите полное наименование страны !!');
      ed_land_name.SetFocus;
      Exit;
   end;
   If ed_passport.text='' Then Begin
      ShowMessage('Введите паспортные данные гражданина СНГ !!');
      ed_passport.SetFocus;
      Exit;
   end;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=233;{Дополнительные сведения о гр. СНГ}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=3;
   parametry[3]:=VarArrayOf([IntToStr(ggost),ed_land_name.text,ed_passport.text]);
   parametry[4]:=VarArrayOf(['gost','land','pasp']);
   parametry[5]:=0;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL <>0 Then Begin
      MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
      Exit;
   end;
   parametry[0]:=269;{Дополнительные сведения о иностр. гражданах}
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=3;
   parametry[3]:=VarArrayOf([DateToStr(dr),'',IntToStr(ggost)]);
   parametry[4]:=VarArrayOf(['dr','pls','id']);
   parametry[5]:=0;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL <>0 Then Begin
      MessageDlg('Отказ в доступе!', mtWarning, [mbOk], 0);
      Exit;
   end;
   rrs:=true;
   fr_sng_reg.Close;
end;

procedure Tfr_sng_reg.ed_drChange(Sender: TObject);
begin
  dr:=ed_dr.DateTime;
end;

procedure Tfr_sng_reg.FormShow(Sender: TObject);
begin
  ed_dr.DateTime:=dr;
end;

end.
