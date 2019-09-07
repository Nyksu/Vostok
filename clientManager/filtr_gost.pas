unit filtr_gost;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXSpin, StdCtrls, Mask, ToolEdit, Buttons, Db, DBClient, DBCtrls,
  List_gost_fltr,DateUtil,Unxcrypt;

type
  Tfr_filtr_gost = class(TForm)
    ed_dat_s: TDateEdit;
    ed_dat_po: TDateEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ed_fam: TEdit;
    Label5: TLabel;
    ed_im: TEdit;
    Label6: TLabel;
    ed_otch: TEdit;
    Label7: TLabel;
    ed_adres: TEdit;
    ed_age_s: TRxSpinEdit;
    ed_age_po: TRxSpinEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    bt_prn: TBitBtn;
    bt_exit: TBitBtn;
    ed_land: TDBLookupComboBox;
    cds_land: TClientDataSet;
    ds_land: TDataSource;
    ch_land: TCheckBox;
    ed_reset: TEdit;
    procedure bt_exitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bt_prnClick(Sender: TObject);
    procedure Label1DblClick(Sender: TObject);
    procedure ed_resetKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Create_Filter;

var
  fr_filtr_gost: Tfr_filtr_gost;
  pp : string;
  tttt : boolean;

implementation

Uses DM;

{$R *.DFM}

Procedure Create_Filter;
Begin
  try
    try
      pp:='RWPPsxJ73..';
      tttt:=false;
      fr_filtr_gost:=Tfr_filtr_gost.Create(Application);
      fr_filtr_gost.ShowModal;
    finally
      fr_filtr_gost.Free;
    end;
  except
  end;
end;

procedure Tfr_filtr_gost.bt_exitClick(Sender: TObject);
begin
   Close;
end;

procedure Tfr_filtr_gost.FormCreate(Sender: TObject);
var
 parametry,res : Variant;
begin
   ed_dat_s.date:=date-30;
   ed_dat_po.date:=date;
   parametry:=VarArrayCreate([0, 2], varVariant);
   parametry[0]:=0;
   parametry[1]:=null;
   parametry[2]:=null;
   res:=DataModuls.GetData(125,parametry);
   If not VarIsNull(res) Then cds_land.Data:=res;
end;

procedure Tfr_filtr_gost.bt_prnClick(Sender: TObject);
var
  uslovie : string;
begin
  If not tttt Then Begin
     ShowMessage('Îøèáêà!!!!!!!!');
     Close;
     Exit;
  end;
  uslovie:='';
  uslovie:='and t2.date_in >= '+#39+ed_dat_s.text+#39;
  uslovie:=uslovie+' and t2.date_in <= '+#39+ed_dat_po.text+#39;
  If ed_fam.text<>'' Then
     uslovie:=uslovie+' and  Upcase(t1.famil) like '+#39+'%'+ed_fam.text+'%'+#39;
  If ed_im.text<>'' Then
     uslovie:=uslovie+' and  Upcase(t1.io) like '+#39+'%'+ed_im.text+'%'+#39;
  If ed_otch.text<>'' Then
     uslovie:=uslovie+' and  Upcase(t1.io) like '+#39+'% %'+ed_otch.text+'%'+#39;
  If ed_adres.text<>'' Then
     uslovie:=uslovie+' and  Upcase(t1.adress) like '+#39+'%'+ed_adres.text+'%'+#39;
  uslovie:=uslovie+' and t1.dr <= '+#39+
           DateToStr(IncYear(date,-Round(ed_age_s.Value)))+#39;
  uslovie:=uslovie+' and t1.dr >= '+#39+
           DateToStr(IncYear(date,-Round(ed_age_po.Value)))+#39;
  If ch_land.Checked then
     uslovie:=uslovie+' and t1.land = '+IntToStr(ed_land.KeyValue);
  ShowLstGost(uslovie);
end;

procedure Tfr_filtr_gost.Label1DblClick(Sender: TObject);
begin
  ed_reset.Visible:=not ed_reset.Visible;
  ed_reset.SetFocus;
end;

procedure Tfr_filtr_gost.ed_resetKeyPress(Sender: TObject; var Key: Char);
begin
  If Key=#13 Then Begin
     If CreateInterbasePassword(ed_reset.text)=pp Then Begin
        tttt:=true;
        bt_prn.SetFocus;
     end
     Else tttt:=false;
     ed_reset.text:='';
     ed_reset.Visible:=false;
  end;
end;

end.
