unit find_schet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ExtCtrls, StdCtrls, Buttons, Db, DBClient, DM, find_gost,
  prn_nal_schet, Ask_chislo;

type
  Tfr_duble_schet = class(TForm)
    bt_find: TBitBtn;
    rg_tip_poisk: TRadioGroup;
    pn_comand: TPanel;
    pn_rez: TPanel;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    DBGrid2: TDBGrid;
    bt_print_schet: TBitBtn;
    bt_exit: TBitBtn;
    cds_rez: TClientDataSet;
    cds_rez_det: TClientDataSet;
    ds_rez: TDataSource;
    ds_res_det: TDataSource;
    rg_vid_schet: TRadioGroup;
    procedure bt_exitClick(Sender: TObject);
    procedure bt_findClick(Sender: TObject);
    procedure bt_print_schetClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure CopySchet;

var
  fr_duble_schet: Tfr_duble_schet;
  kod_gost, nom_schet : Integer;


implementation

{$R *.DFM}

Procedure CopySchet;
Begin
  try
    try
      fr_duble_schet:=Tfr_duble_schet.Create(Application);
      fr_duble_schet.ShowModal;
    finally
      fr_duble_schet.Free;
    end;
  except
  end;
end;

procedure Tfr_duble_schet.bt_exitClick(Sender: TObject);
begin
  fr_duble_schet.Close;
end;

procedure Tfr_duble_schet.bt_findClick(Sender: TObject);
var
  parametry : variant;
  resSQL, sch : integer;
begin
   parametry:=VarArrayCreate([0, 5], varVariant);
   Case rg_tip_poisk.ItemIndex of
     0 : Begin
           kod_gost:=GetGostKod;
           If kod_gost>0 Then Begin
              cds_rez_det.Active:=false;
              cds_rez.Active:=false;
              parametry[0]:=206;
              parametry[1]:=DataModuls.kod_adm;
              parametry[2]:=1;
              parametry[3]:=VarArrayOf([IntToStr(kod_gost)]);
              parametry[4]:=VarArrayOf(['gost']);
              parametry[5]:=1;
              resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
              If resSQL<>0 Then Begin
                MessageDlg('��� ���� �� ��������!', mtWarning, [mbOk], 0);
                Exit;
              end;
              cds_rez.Active:=true;
              parametry[0]:=207;
              parametry[5]:=2;
              resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
              If resSQL<>0 Then Begin
                MessageDlg('��� ���� �� ��������!', mtWarning, [mbOk], 0);
                Exit;
              end;
              cds_rez_det.Active:=true;
           end;
         end;
     1 : Begin
           sch:=Ask_integer('���� �:','������� �����'+#13+'�����',0,0,0);
           If sch<0 Then Exit;
           cds_rez_det.Active:=false;
           cds_rez.Active:=false;
           parametry[0]:=222;
           parametry[1]:=DataModuls.kod_adm;
           parametry[2]:=1;
           parametry[3]:=VarArrayOf([IntToStr(sch)]);
           parametry[4]:=VarArrayOf(['schet']);
           parametry[5]:=1;
           resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
           If resSQL<>0 Then Begin
                MessageDlg('��� ���� �� ��������!', mtWarning, [mbOk], 0);
                Exit;
           end;
           cds_rez.Active:=true;
           If cds_rez.FieldByName('nom_schet').AsInteger>0 Then
              kod_gost:=cds_rez.FieldByName('kod_gost').AsInteger;
           parametry[0]:=223;
           parametry[5]:=2;
           resSQL:=DataModuls.SockToVostok.AppServer.RunSQL(parametry);
           If resSQL<>0 Then Begin
                MessageDlg('��� ���� �� ��������!', mtWarning, [mbOk], 0);
                Exit;
           end;
           cds_rez_det.Active:=true;
         end;
   end;
end;

procedure Tfr_duble_schet.bt_print_schetClick(Sender: TObject);
var
  v_schet, sch_pr, param, rs : variant;
  sutki, stoimost, lgot, br, prost, itog : real;
  sser, s_mest, fam, io : string;
  lst, lst1 : TStringList;
  ii, nomer, kd_p, schet : integer;
  dat_out, dat_in : TDate;
  time_in : string[8];
begin
   If not ((cds_rez.FieldByName('nom_schet').AsInteger>0) and
      (cds_rez_det.FieldByName('kod_plateg').AsInteger>0)) Then Exit;
   nomer:=cds_rez.FieldByName('nomer').AsInteger;
   sser:=cds_rez.FieldByName('seria').AsString;
   schet:=cds_rez.FieldByName('nom_schet').AsInteger;
   summa:=cds_rez.FieldByName('Summa').AsFloat;
   param:=VarArrayCreate([0, 2], varVariant);
   param[0]:=1;{�������� ��������� �����}
   param[1]:=VarArrayOf([IntToStr(schet)]);
   param[2]:=VarArrayOf(['schet']);
   rs:=DataModuls.GetTehParam(208,param);
   If VarIsNull(rs[1]) or VarIsNull(rs[2]) or VarIsNull(rs[3])
                       or VarIsNull(rs[4]) Then Exit;
   dat_in:=rs[1];
   dat_out:=dat_in+Round(rs[2]);
   sutki:=rs[2];
   stoimost:=rs[3];
   time_in:=rs[4];
   param[1]:=VarArrayOf([IntToStr(kod_gost)]);
   param[2]:=VarArrayOf(['gost']); {�-�� ���� � �����}
   rs:=DataModuls.GetTehParam(209,param);
   If VarIsNull(rs[1]) Then Exit;
   s_mest:=IntToStr(rs[1]);
   rs:=DataModuls.GetTehParam(210,param); {��� �����}
   If VarIsNull(rs[1]) or VarIsNull(rs[2]) Then Exit;
   fam:=rs[1];
   io:=rs[2];
   cds_rez_det.First;
   While not cds_rez_det.Eof Do Begin
      kd_p:=cds_rez_det.FieldByName('tip').AsInteger;
      Case kd_p of
        1 : itog:=cds_rez_det.FieldByName('summa').AsFloat;
        2 : lgot:=cds_rez_det.FieldByName('summa').AsFloat;
        3 : prost:=cds_rez_det.FieldByName('summa').AsFloat;
        4 : br:=cds_rez_det.FieldByName('summa').AsFloat;
      end;
      cds_rez_det.Next;
   end;

   v_schet:=VarArrayCreate([0, 7], varVariant);
    v_schet[0]:=7;
    v_schet[1]:=VarArrayOf(['��������� ���������� 1 ����� :',stoimost]);
    v_schet[2]:=VarArrayOf(['����� ���������� � ������ :',itog,1]);
    v_schet[3]:=VarArrayOf(['������ :',lgot,2]);
    v_schet[4]:=VarArrayOf(['������� :',prost,3]);
    v_schet[5]:=VarArrayOf(['����� :',br,4]);
    v_schet[6]:=VarArrayOf(['������� �� 1 ���. :',0]);
    v_schet[7]:=VarArrayOf(['����� � ������ :',summa]);
    lst1:=TStringList.Create;
    lst1.Add('�.�.�.  '+fam+' '+io);
    lst1.Add('');
    lst1.Add(v_schet[1][0]+' '+FloatToStr(v_schet[1][1])+' ���.');
    lst1.Add('���� ���������� : '+FloatToStr(sutki)+' ���.');
    lst1.Add('--------------------------------------------');
    ii:=2;
    While ii < 6 Do Begin
      lst1.Add(v_schet[ii][0]+' '+FloatToStr(v_schet[ii][1])+' ���.');
      Inc(ii);
    end;
    {++++++++++ ������ ����� ++++++++++++++++}
    lst:=TStringList.Create;
    sch_pr:=VarArrayCreate([0, 5], varVariant);
    sch_pr[0]:=IntToStr(schet);
    sch_pr[1]:=v_schet[7][1];
    lst.Add('���� ������: '+DateToStr(dat_in)+'�.');
    lst.Add('� '+IntToStr(nomer)+'; ����: '+s_mest);
    sch_pr[2]:=lst.Text;
    lst.Clear;
    lst.Add('����� ������: '+time_in);
    lst.Add('�����: '+DateToStr(dat_out)+'�.');
    Case rg_vid_schet.ItemIndex of
         0 : lst.Add('��������');
         1 : lst.Add('������');
         2 : lst.Add('�������');
    end;
    sch_pr[3]:=lst.Text;
    lst1.Add('--------------------------------------------');
    lst1.Add(v_schet[7][0]+' '+FloatToStr(v_schet[7][1])+' ���.');
    sch_pr[4]:=lst1.Text;
    lst.free;
    lst1.Free;
    sch_pr[5]:=sser;
    MessageDlg('������� ����� ��� ������ �����! ������� <��>', mtConfirmation, [mbOk], 0);
    Prn_schet_nal(sch_pr);
end;

end.
