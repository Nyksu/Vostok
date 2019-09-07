unit Rsch_bron;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Grids, DBGrids, Db, DBClient, Buttons, Spin, ComCtrls,
  DBCtrls;

type
  Tfr_bn_rsch = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    rg_tip: TRadioGroup;
    Panel2: TPanel;
    lb_result: TLabel;
    cds_bn_schet: TClientDataSet;
    ds_bn_schet: TDataSource;
    bt_exit: TBitBtn;
    BitBtn1: TBitBtn;
    ed_dat_s: TDateTimePicker;
    ed_dat_po: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    ed_sum: TSpinEdit;
    Label4: TLabel;
    ed_kod_s: TSpinEdit;
    ed_kod_po: TSpinEdit;
    Label5: TLabel;
    Label6: TLabel;
    cds_bn_plat: TClientDataSet;
    ds_bn_plat: TDataSource;
    ed_plat: TDBLookupComboBox;
    Label7: TLabel;
    ch_complex: TCheckBox;
    ch_per_rsch: TCheckBox;
    ch_per_in: TCheckBox;
    ch_kod_z: TCheckBox;
    ch_sum_z: TCheckBox;
    ch_plat: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure bt_exitClick(Sender: TObject);
    procedure rg_tipClick(Sender: TObject);
    procedure ch_complexClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    resss : boolean;
    procedure Set_filter;
    { Private declarations }
  public
    { Public declarations }
  end;


Procedure Bn_Rsch;

var
  fr_bn_rsch: Tfr_bn_rsch;

implementation

Uses DM;

{$R *.DFM}

Procedure Bn_Rsch;
Begin
  try
    try
      fr_bn_rsch:=Tfr_bn_rsch.Create(Application);
      fr_bn_rsch.ShowModal;
    finally
      fr_bn_rsch.Free;
    end;
  except
  end;
end;

procedure Tfr_bn_rsch.Set_filter;
var
  fir : boolean;
  su_l, su_b : real;
Begin
  If resss and cds_bn_schet.Active Then Begin
     fir:=true;
     cds_bn_schet.Filtered:=false;
     cds_bn_schet.Filter:='';
     If ch_per_rsch.Checked Then Begin
        fir:=false;
        cds_bn_schet.Filter:='date_calc>='''+DateToStr(ed_dat_s.date)+
                      ''' and date_calc<='''+DateToStr(ed_dat_po.date)+'''';
     end;
     If ch_per_in.Checked Then Begin
        If not fir Then cds_bn_schet.Filter:=cds_bn_schet.Filter+' and ';
        cds_bn_schet.Filter:=cds_bn_schet.Filter+
                             'start_date>='''+DateToStr(ed_dat_s.date)+
                      ''' and start_date<='''+DateToStr(ed_dat_po.date)+'''';
        fir:=false;
     end;
     If ch_kod_z.Checked Then Begin
        If not fir Then cds_bn_schet.Filter:=cds_bn_schet.Filter+' and ';
        cds_bn_schet.Filter:=cds_bn_schet.Filter+
                             'cod_bron>='+IntToStr(ed_kod_s.Value)+
                      ' and cod_bron<='+IntToStr(ed_kod_po.Value);
        fir:=false;
     end;
     If ch_sum_z.Checked Then Begin
        If not fir Then cds_bn_schet.Filter:=cds_bn_schet.Filter+' and ';
        cds_bn_schet.Filter:=cds_bn_schet.Filter+
                             '(sum_live+sum_bron)>='+IntToStr(ed_sum.Value);
        fir:=false;
     end;
     If ch_plat.Checked Then Begin
        If not fir Then cds_bn_schet.Filter:=cds_bn_schet.Filter+' and ';
        cds_bn_schet.Filter:=cds_bn_schet.Filter+
                             'nam_plat='''+ed_plat.KeyValue+'''';
        fir:=false;
     end;
     cds_bn_schet.Filtered:=true;
     cds_bn_schet.First;
     su_l:=0;
     su_b:=0;
     While not cds_bn_schet.EOF Do Begin
        su_l:=su_l+cds_bn_schet.FieldValues['sum_live'];
        su_b:=su_b+cds_bn_schet.FieldValues['sum_bron'];
        cds_bn_schet.Next;
     end;
     lb_result.Caption:=FloatToStr(su_b)+'+'+FloatToStr(su_l)+'='+FloatToStr(su_l+su_b);
  end;
end;

procedure Tfr_bn_rsch.FormCreate(Sender: TObject);
var
  parametry : variant;

  resSQL : integer;
begin
   resss:=false;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=240;
   parametry[1]:=DataModuls.kod_adm;
   parametry[2]:=0;
   parametry[3]:=VarArrayOf(['']);
   parametry[4]:=VarArrayOf(['']);
   parametry[5]:=1;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL>0 Then Begin
      MessageDlg('Нет прав на эту операцию!', mtWarning, [mbOk], 0);
      Exit;
   end;
   resss:=true;
   ed_dat_s.date:=date-3;
   ed_dat_po.date:=date;
   parametry[0]:=241;
   parametry[1]:=DataModuls.kod_adm;
   parametry[2]:=0;
   parametry[3]:=VarArrayOf(['']);
   parametry[4]:=VarArrayOf(['']);
   parametry[5]:=2;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL>0 Then Begin
      MessageDlg('Нет прав на эту операцию!', mtWarning, [mbOk], 0);
      resss:=false;
      Exit;
   end;
   cds_bn_plat.Active:=true;
   cds_bn_schet.Active:=true;
   Set_filter;
end;

procedure Tfr_bn_rsch.bt_exitClick(Sender: TObject);
begin
  fr_bn_rsch.Close;
end;

procedure Tfr_bn_rsch.rg_tipClick(Sender: TObject);
begin
   Case rg_tip.ItemIndex of
       0 : Begin
             ed_dat_s.Enabled:=true;
             ed_dat_po.Enabled:=true;
             ed_sum.Enabled:=false;
             ed_kod_s.Enabled:=false;
             ed_kod_po.Enabled:=false;
             ed_plat.Enabled:=false;
             ed_dat_s.SetFocus;
             If not ch_complex.Checked Then Begin
                ch_per_rsch.Checked:=true;
                ch_per_in.Checked:=false;
                ch_kod_z.Checked:=false;
                ch_sum_z.Checked:=false;
                ch_plat.Checked:=false;
             end;
           end;
       1 : Begin
             ed_dat_s.Enabled:=true;
             ed_dat_po.Enabled:=true;
             ed_sum.Enabled:=false;
             ed_kod_s.Enabled:=false;
             ed_kod_po.Enabled:=false;
             ed_plat.Enabled:=false;
             ed_dat_s.SetFocus;
             If not ch_complex.Checked Then Begin
                ch_per_rsch.Checked:=false;
                ch_per_in.Checked:=true;
                ch_kod_z.Checked:=false;
                ch_sum_z.Checked:=false;
                ch_plat.Checked:=false;
             end;
           end;
       2 : Begin
             ed_dat_s.Enabled:=false;
             ed_dat_po.Enabled:=false;
             ed_sum.Enabled:=false;
             ed_kod_s.Enabled:=true;
             ed_kod_po.Enabled:=true;
             ed_plat.Enabled:=false;
             ed_kod_s.SetFocus;
             If not ch_complex.Checked Then Begin
                ch_per_rsch.Checked:=false;
                ch_per_in.Checked:=false;
                ch_kod_z.Checked:=true;
                ch_sum_z.Checked:=false;
                ch_plat.Checked:=false;
             end;
           end;
       3 : Begin
             ed_dat_s.Enabled:=false;
             ed_dat_po.Enabled:=false;
             ed_sum.Enabled:=true;
             ed_kod_s.Enabled:=false;
             ed_kod_po.Enabled:=false;
             ed_plat.Enabled:=false;
             ed_sum.SetFocus;
             If not ch_complex.Checked Then Begin
                ch_per_rsch.Checked:=false;
                ch_per_in.Checked:=false;
                ch_kod_z.Checked:=false;
                ch_sum_z.Checked:=true;
                ch_plat.Checked:=false;
             end;
           end;
       4 : Begin
             ed_dat_s.Enabled:=false;
             ed_dat_po.Enabled:=false;
             ed_sum.Enabled:=false;
             ed_kod_s.Enabled:=false;
             ed_kod_po.Enabled:=false;
             ed_plat.Enabled:=true;
             ed_plat.SetFocus;
             If not ch_complex.Checked Then Begin
                ch_per_rsch.Checked:=false;
                ch_per_in.Checked:=false;
                ch_kod_z.Checked:=false;
                ch_sum_z.Checked:=false;
                ch_plat.Checked:=true;
             end;
           end;
   end;
end;

procedure Tfr_bn_rsch.ch_complexClick(Sender: TObject);
begin
   ch_per_rsch.Enabled:=ch_complex.Checked;
   ch_per_in.Enabled:=ch_complex.Checked;
   ch_kod_z.Enabled:=ch_complex.Checked;
   ch_sum_z.Enabled:=ch_complex.Checked;
   ch_plat.Enabled:=ch_complex.Checked;
   rg_tipClick(Sender);
end;

procedure Tfr_bn_rsch.BitBtn1Click(Sender: TObject);
begin
  Set_filter;
end;

end.
