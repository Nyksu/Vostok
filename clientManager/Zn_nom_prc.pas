unit Zn_nom_prc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, TeEngine, Series, TeeProcs, Chart,
  Spin, DBCtrls, Db, DBClient;

type
  Tfr_proc_zn = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    ed_dat_s: TDateTimePicker;
    Label3: TLabel;
    ed_dat_po: TDateTimePicker;
    bt_exit: TBitBtn;
    Chart1: TChart;
    Series1: TPieSeries;
    rg_tip: TRadioGroup;
    ed_param: TSpinEdit;
    lb_nam_par: TLabel;
    bt_calc: TBitBtn;
    ed_grup: TDBLookupComboBox;
    lb_grup: TLabel;
    cds_grup: TClientDataSet;
    ds_grup: TDataSource;
    procedure bt_exitClick(Sender: TObject);
    procedure rg_tipClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bt_calcClick(Sender: TObject);
  private
    procedure Rescan;
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure StartStatGraf;

var
  fr_proc_zn: Tfr_proc_zn;

implementation

Uses DM;

{$R *.DFM}

Procedure StartStatGraf;
Begin
  try
    try
      fr_proc_zn:=Tfr_proc_zn.Create(Application);
      fr_proc_zn.ShowModal;
    finally
      fr_proc_zn.Free;
      Screen.Cursor:=crDefault;
    end;
  except
  end;
end;

procedure Tfr_proc_zn.Rescan;
var
 nam_field,zn,param : string;
 par,rs : variant;
 p_liv,p_rem,p_ar,p_free : real;
Begin
   Series1.Clear;
   param:=IntToStr(ed_param.Value);
   zn:='=';
   par:=VarArrayCreate([0, 2], varVariant);
   Case rg_tip.ItemIndex of
     0 : Begin
           nam_field:='';
           zn:='';
           param:='';
         end;
     1 : Begin
           nam_field:='and t1.floor';
         end;
     2 : Begin
           nam_field:='and t1.nomer';
         end;
     3 : Begin
           If cds_grup.Active Then Begin
              lb_grup.Visible:=true;
              ed_grup.Visible:=true;
              ed_grup.SetFocus;
              nam_field:='and t1.gruppa';
              param:=IntToStr(ed_grup.KeyValue);
              zn:='=';
           end
           Else Begin
              nam_field:='';
              param:='';
              zn:='';
           end;
         end;
     4 : Begin
           nam_field:='and t1.klass';
         end;
   end;
   par[0]:=6;
   par[1]:=VarArrayOf([nam_field,zn,param,DateToStr(ed_dat_s.Date),
                       DateToStr(ed_dat_po.Date),'1']);
   par[2]:=VarArrayOf(['field','zn','param','dt_s','dt_po','prich']);
   rs:=DataModuls.GetTehParam(247,par);
   If not VarIsNull(rs[1]) Then p_liv:=rs[1]
       Else Exit;

    par[1]:=VarArrayOf([nam_field,zn,param,DateToStr(ed_dat_s.Date),
                       DateToStr(ed_dat_po.Date),'8']);
   rs:=DataModuls.GetTehParam(247,par);
   If not VarIsNull(rs[1]) Then p_liv:=p_liv+rs[1]
       Else Exit;

   par[1]:=VarArrayOf([nam_field,zn,param,DateToStr(ed_dat_s.Date),
                       DateToStr(ed_dat_po.Date),'6']);
   rs:=DataModuls.GetTehParam(247,par);
   If not VarIsNull(rs[1]) Then p_rem:=rs[1]
       Else Exit;

   par[1]:=VarArrayOf([nam_field,zn,param,DateToStr(ed_dat_s.Date),
                       DateToStr(ed_dat_po.Date),'2']);
   rs:=DataModuls.GetTehParam(247,par);
   If not VarIsNull(rs[1]) Then p_ar:=rs[1]
       Else Exit;

   par[1]:=VarArrayOf([nam_field,zn,param,DateToStr(ed_dat_s.Date),
                       DateToStr(ed_dat_po.Date),'3']);
   rs:=DataModuls.GetTehParam(247,par);
   If not VarIsNull(rs[1]) Then p_rem:=p_rem+rs[1]
       Else Exit;

   p_free:=100-(p_liv+p_rem+p_ar);

   With Series1 do
   Begin
    Add(p_ar, 'Аренда',  clBlue ) ;
    Add(p_rem, 'Ремонт' , clRed ) ;
    Add(p_liv, 'Проживание', clYellow ) ;
    Add(p_free, 'Свободные' , clGreen ) ;
   end;
end;

procedure Tfr_proc_zn.bt_exitClick(Sender: TObject);
begin
   fr_proc_zn.Close;
end;

procedure Tfr_proc_zn.rg_tipClick(Sender: TObject);
begin
   lb_nam_par.Caption:='';
   lb_nam_par.Visible:=true;
   ed_param.Enabled:=true;
   lb_grup.Visible:=false;
   ed_grup.Visible:=false;
   Case rg_tip.ItemIndex of
     0 : Begin
           lb_nam_par.Visible:=false;
           ed_param.Enabled:=false;

         end;
     1 : Begin
           lb_nam_par.Caption:='Этаж:';
           ed_param.MinValue:=2;
           ed_param.MaxValue:=8;
           ed_param.Value:=2;
           ed_param.SetFocus;
         end;
     2 : Begin
           lb_nam_par.Caption:='Номер:';
           ed_param.MinValue:=200;
           ed_param.MaxValue:=899;
           ed_param.Value:=200;
           ed_param.SetFocus;
         end;
     3 : Begin
           lb_nam_par.Visible:=false;
           ed_param.Enabled:=false;
           If cds_grup.Active Then Begin
              cds_grup.First;
              lb_grup.Visible:=true;
              ed_grup.Visible:=true;
              ed_grup.SetFocus;
           end;
         end;
     4 : Begin
           lb_nam_par.Caption:='Категория:';
           ed_param.MinValue:=0;
           ed_param.MaxValue:=3;
           ed_param.Value:=0;
           ed_param.SetFocus;
         end;
   end;
end;

procedure Tfr_proc_zn.FormCreate(Sender: TObject);
var
  parametry : variant;
  resSQL : integer;
begin
   ed_dat_s.Date:=date-30;
   ed_dat_po.Date:=date;
   rg_tipClick(Sender);        
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=104;
   parametry[1]:=DataModuls.kod_adm;
   parametry[2]:=0;
   parametry[3]:=VarArrayOf(['']);
   parametry[4]:=VarArrayOf(['']);
   parametry[5]:=2;
   resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
   If resSQL=0 Then Begin
      try
        cds_grup.Active:=true;
      except
      end;
   end;
   Screen.Cursor:=crHourGlass;
   Rescan;
   Screen.Cursor:=crDefault;
end;

procedure Tfr_proc_zn.bt_calcClick(Sender: TObject);
begin
   Screen.Cursor:=crHourGlass;
   Rescan;
   Screen.Cursor:=crDefault;
end;

end.
