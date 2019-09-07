unit autitarif;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, Spin, DBCtrls, Db, DBClient,
  Grids, DBGrids;

type
  Tfr_auto_tarif = class(TForm)
    GroupBox1: TGroupBox;
    RadioGroup1: TRadioGroup;
    Panel1: TPanel;
    bt_first_tarif: TButton;
    ProgressBar1: TProgressBar;
    DateNewTarif: TDateTimePicker;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    grd_tarif_farif: TDBGrid;
    CDS_lok_tarifs: TClientDataSet;
    ds_lok_tarifs: TDataSource;
    DBLookupListBox1: TDBLookupListBox;
    lb_sposob: TLabel;
    SpinEdit1: TSpinEdit;
    bt_start_auto: TBitBtn;
    CDS_lok_tarifsKOD_LAND: TIntegerField;
    CDS_lok_tarifsNAME_LAND: TStringField;
    CDS_lok_tarifstarif: TFloatField;
    dblb_klass: TDBText;
    lbdb_mests: TDBText;
    lbdb_grup: TDBText;
    Shape1: TShape;
    lb1: TLabel;
    lb2: TLabel;
    lb3: TLabel;
    ed_nom_po: TSpinEdit;
    lb_noms: TLabel;
    lb_nompo: TLabel;
    procedure bt_first_tarifClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure bt_start_autoClick(Sender: TObject);
    procedure CDS_lok_tarifsAfterInsert(DataSet: TDataSet);
    procedure DBLookupListBox1DblClick(Sender: TObject);
    procedure DBLookupListBox1KeyPress(Sender: TObject; var Key: Char);
  private
    procedure LoockAtNomer;
    { Private declarations }
  public
    Procedure StartAutoTar;
    { Public declarations }
  end;

var
  fr_auto_tarif: Tfr_auto_tarif;

implementation

uses MainADM;

{$R *.DFM}

Procedure Tfr_auto_tarif.StartAutoTar;
Begin
  screen.cursor:=crHourGlass;
  try
   fr_auto_tarif:=Tfr_auto_tarif.Create(Application);
   try
      screen.cursor:=crDefault;
      fr_auto_tarif.ShowModal;
   finally
      fr_auto_tarif.Free;
   end;
 finally
   screen.cursor:=crDefault;
 end;
end;

procedure Tfr_auto_tarif.bt_first_tarifClick(Sender: TObject);
var
 colvo_lands : integer;
 resultat,parametry,par : Variant;
begin
  parametry:=VarArrayCreate([0, 2], varVariant);
  parametry[0]:=0;{количество параметров в sql}
  parametry[1]:=VarArrayOf(['']);{параметры sql}
  parametry[2]:=VarArrayOf([0]);{номера строк параметров sql}
  resultat:=fr_ClientAdm.GetTehParam(124,parametry);
  If not VarIsNull(resultat[1]) Then colvo_lands:=resultat[1]
  Else colvo_lands:=0;
  If colvo_lands <= 0 Then Begin
     ShowMessage('Необходимо заполнить справочник стран !!!');
     Screen.Cursor:=crDefault;
     Exit;
  end;
  Screen.Cursor:=crHourGlass;
  par:=VarArrayCreate([0, 5], varVariant);
  par[0]:=198;
  par[1]:=fr_ClientAdm.kod_adm;
  par[2]:=1;
  par[3]:=VarArrayOf([DateToStr(DateNewTarif.Date)]);
  par[4]:=VarArrayOf(['dat_s']);
  par[5]:=0;
  fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
  If fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(par)=0 Then
               fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans
  Else Begin
     fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
     ShowMessage('Ошибка!! Попробуйте снова!!');
  end;
  ProgressBar1.Position:=0;
  Screen.Cursor:=crDefault;
end;

procedure Tfr_auto_tarif.BitBtn1Click(Sender: TObject);
begin
  fr_auto_tarif.Close;
end;

procedure Tfr_auto_tarif.FormActivate(Sender: TObject);
begin
   DateNewTarif.Date:=Date;
   RadioGroup1.SetFocus;
end;

procedure Tfr_auto_tarif.LoockAtNomer;
begin
  lb1.Visible:= not lb1.Visible;
  lb2.Visible:= not lb2.Visible;
  lb3.Visible:= not lb3.Visible;
  dblb_klass.Visible:= not dblb_klass.Visible;
  lbdb_mests.Visible:= not lbdb_mests.Visible;
  lbdb_grup.Visible:= not lbdb_grup.Visible;
  Shape1.Visible:= not Shape1.Visible;
  If lb1.Visible Then Begin
     dblb_klass.DataField:='klass';
     lbdb_mests.DataField:='mests';
  end
  Else Begin
     dblb_klass.DataField:='';
     lbdb_mests.DataField:='';
  end;
end;

procedure Tfr_auto_tarif.RadioGroup1Click(Sender: TObject);
var
 par : Variant;
begin
  bt_first_tarif.Visible:=false;
  bt_start_auto.Visible:=true;
  CDS_lok_tarifs.Active:=false;
  par:=VarArrayCreate([0, 5], varVariant);
  par[0]:=125;
  par[1]:=fr_ClientAdm.kod_adm;
  par[2]:=0;
  par[3]:=VarArrayOf([0]);
  par[4]:=VarArrayOf([-1]);
  par[5]:=5;
  fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(par);
  par[5]:=4;
  CDS_lok_tarifs.Active:=true;
  Case RadioGroup1.ItemIndex of
     0 : Begin
          lb_sposob.Caption:='По категориям :';
          If lb1.Visible Then LoockAtNomer;
          lb_sposob.Visible:=true;
          SpinEdit1.Visible:=true;
          DBLookupListBox1.Visible:=false;
          ed_nom_po.Visible:=false;
          lb_noms.Visible:=false;
          lb_nompo.Visible:=false;
         end;
     1 : Begin
          If lb1.Visible Then LoockAtNomer;
          fr_ClientAdm.Cds_sp3.Active:=false;
          fr_ClientAdm.Cds_sp3.IndexFieldNames:='';
          DBLookupListBox1.ListField:='';
          DBLookupListBox1.KeyField:='';
          lb_sposob.Caption:='По группе номеров :';
          lb_sposob.Visible:=true;
          SpinEdit1.Visible:=false;
          ed_nom_po.Visible:=false;
          lb_noms.Visible:=false;
          lb_nompo.Visible:=false;
          DBLookupListBox1.Visible:=true;
          DBLookupListBox1.Width:=250;
          par[0]:=104;
          fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(par);
          DBLookupListBox1.ListField:='name_group';
          DBLookupListBox1.KeyField:='nom_group';
          fr_ClientAdm.Cds_sp3.IndexFieldNames:='name_group';
          fr_ClientAdm.Cds_sp3.Active:=true;
         end;
     2 : Begin
          If lb1.Visible Then LoockAtNomer;
          lb_sposob.Caption:='По к-ву мест :';
          lb_sposob.Visible:=true;
          SpinEdit1.Visible:=true;
          DBLookupListBox1.Visible:=false;
          ed_nom_po.Visible:=false;
          lb_noms.Visible:=false;
          lb_nompo.Visible:=false;
         end;
     3 : Begin
          fr_ClientAdm.Cds_sp3.Active:=false;
          fr_ClientAdm.Cds_sp3.IndexFieldNames:='';
          If not lb1.Visible Then LoockAtNomer;
          DBLookupListBox1.ListField:='';
          DBLookupListBox1.KeyField:='';
          lb_sposob.Caption:='По отдельному номеру :';
          lb_sposob.Visible:=true;
          ed_nom_po.Visible:=true;
          lb_noms.Visible:=true;
          lb_nompo.Visible:=true;
          SpinEdit1.Visible:=false;
          DBLookupListBox1.Visible:=true;
          DBLookupListBox1.Width:=60;
          par[0]:=109;
          fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(par);
          DBLookupListBox1.ListField:='nomer';
          DBLookupListBox1.KeyField:='nomer';
          fr_ClientAdm.Cds_sp3.IndexFieldNames:='nomer';
          fr_ClientAdm.Cds_sp3.Active:=true;
         end;
  end;
end;

procedure Tfr_auto_tarif.bt_start_autoClick(Sender: TObject);
var
 resSQL : integer;
 par, par2 : Variant;
 s_tar, s_dat, s_land, s_uslov : string;
begin
  If (RadioGroup1.ItemIndex=3) and
    (ed_nom_po.Value<fr_ClientAdm.cds_sp3.FieldByName('nomer').AsInteger)
  Then Begin
     ShowMessage('Ошибка!! Некорректный интервал номеров!!');
     ed_nom_po.SetFocus;
     Exit;
  end;
  If CDS_lok_tarifs.State = dsEdit Then CDS_lok_tarifs.Post;
  CDS_lok_tarifs.First;
  While not CDS_lok_tarifs.EOF Do Begin
    If VarIsNull(CDS_lok_tarifs.FieldByName('tarif').Value) Then
         CDS_lok_tarifs.Delete
    Else CDS_lok_tarifs.Next;
  end;
  CDS_lok_tarifs.First;
  If CDS_lok_tarifs.EOF Then Exit;
  ProgressBar1.Max:=CDS_lok_tarifs.RecordCount*2;
  ProgressBar1.Position:=0;
  par:=VarArrayCreate([0, 5], varVariant);
  par[0]:=128; {insert}
  par[1]:=fr_ClientAdm.kod_adm;
  par[2]:=5;
  par[4]:=VarArrayOf([2,4,7,10,15]);
  par[5]:=0;
  par2:=VarArrayCreate([0, 5], varVariant);
  par2[0]:=129; {Update}
  par2[1]:=fr_ClientAdm.kod_adm;
  par2[2]:=4;
  par2[4]:=VarArrayOf([2,5,7,12]);
  par2[5]:=0;
  s_dat:=#39+DateToStr(DateNewTarif.Date)+#39;
  Case RadioGroup1.ItemIndex of
     0 : Begin
          s_uslov:='t1.klass = '+IntToStr(SpinEdit1.Value);
         end;
     1 : Begin
          s_uslov:='t1.gruppa = '
  +IntToStr(fr_ClientAdm.cds_sp3.FieldByName('nom_group').AsInteger);
         end;
     2 : Begin
          s_uslov:='t1.mests = '+IntToStr(SpinEdit1.Value);
         end;
     3 : Begin
           s_uslov:='t1.nomer >= '+IntToStr(fr_ClientAdm.cds_sp3.FieldByName('nomer').AsInteger)+
           ' and t1.nomer <= '+IntToStr(ed_nom_po.Value);
         end;
  end;
  Screen.Cursor:=crHourGlass;
  fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
  While not CDS_lok_tarifs.EOF Do Begin
    s_land:=IntToStr(CDS_lok_tarifs.FieldByName('kod_land').AsInteger);
    s_tar:=FloatToStr(CDS_lok_tarifs.FieldByName('tarif').AsFloat);
    par2[3]:=VarArrayOf([s_tar,s_dat,s_land,s_uslov]);
    If (s_tar<>'') and (s_tar<>'0') Then Begin
      resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(par2);
      If resSQL<>0 Then Begin
        ShowMessage('Ошибка!! Попробуйте еще раз!!');
        fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
        Exit;
      end;
    end;
    ProgressBar1.StepIt;
    par[3]:=VarArrayOf([s_dat,s_tar,s_uslov,s_land,s_dat]);
    resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(par);
    If resSQL<>0 Then Begin
      ShowMessage('Ошибка!! Попробуйте еще раз!!');
      fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
      Exit;
    end;
    ProgressBar1.StepIt;
    CDS_lok_tarifs.Next;
  end;
  fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
  ProgressBar1.Position:=0;
  Screen.Cursor:=crDefault;
end;

procedure Tfr_auto_tarif.CDS_lok_tarifsAfterInsert(DataSet: TDataSet);
begin
  CDS_lok_tarifs.Cancel;
end;

procedure Tfr_auto_tarif.DBLookupListBox1DblClick(Sender: TObject);
begin
  ed_nom_po.Value:=fr_ClientAdm.cds_sp3.FieldByName('nomer').AsInteger;
  ed_nom_po.SetFocus;
end;

procedure Tfr_auto_tarif.DBLookupListBox1KeyPress(Sender: TObject;
  var Key: Char);
begin
  If Key=#13 Then Begin
    ed_nom_po.Value:=fr_ClientAdm.cds_sp3.FieldByName('nomer').AsInteger;
    ed_nom_po.SetFocus;
  end;
end;

end.
