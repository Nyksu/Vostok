unit dubSch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, Db, DBClient;

type
  Tduble_schet = class(TForm)
    Label1: TLabel;
    ed_famil: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    ed_im: TEdit;
    ed_ot: TEdit;
    Label4: TLabel;
    pn_result: TPanel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    bt_search: TBitBtn;
    DBGrid3: TDBGrid;
    DBGrid4: TDBGrid;
    bt_print_schet: TBitBtn;
    bt_exit: TBitBtn;
    cds_find: TClientDataSet;
    cds_plat: TClientDataSet;
    ds_find: TDataSource;
    ds_plat: TDataSource;
    procedure bt_exitClick(Sender: TObject);
    procedure bt_searchClick(Sender: TObject);
    procedure ds_findDataChange(Sender: TObject; Field: TField);
    procedure bt_print_schetClick(Sender: TObject);
  private
    { Private declarations }
    procedure findGost;
    procedure ShowPyes;
    procedure PrintSchet;
  public
    { Public declarations }
  end;

Procedure StartDupSch;

var
  duble_schet: Tduble_schet;

implementation

{$R *.DFM}

Uses MainADM, prn_nal_schet;

Procedure StartDupSch;
Begin
  try
    try
      duble_schet:=Tduble_schet.Create(Application);
      duble_schet.ShowModal;
    finally
      duble_schet.free;
      duble_schet:=nil;
    end;
  except
  end;
end;

procedure Tduble_schet.findGost;
var
  fam, im, ot : string;
  par, rs : variant;
Begin
  fam:=ed_famil.Text;
  im:=ed_im.Text;
  ot:=ed_ot.Text;
  cds_find.active:=false;
  If (fam='')and(im='')and(ot='') Then Exit;
  par:=VarArrayCreate([0, 2], varVariant);
  par[0]:=4;
  par[1]:=VarArrayOf([IntToStr(fr_ClientAdm.kod_smen),fam,im,ot]);
  par[2]:=VarArrayOf(['sm','fam','i','o']);
  rs:=null;
  rs:=fr_ClientAdm.GetData(267,par);
  If VarIsNull(rs) Then Exit;
  cds_find.Data:=rs;
end;

procedure Tduble_schet.ShowPyes;
var
  par, rs : variant;
Begin
  cds_plat.active:=false;
  If cds_find.Active Then Begin
    If cds_find.RecordCount=0 Then Exit;
    par:=VarArrayCreate([0, 2], varVariant);
    par[0]:=1;
    par[1]:=VarArrayOf([cds_find.FieldByName('nom_schet').AsString]);
    par[2]:=VarArrayOf(['schet']);
    rs:=null;
    rs:=fr_ClientAdm.GetData(268,par);
    If VarIsNull(rs) Then Exit;
    cds_plat.Data:=rs;
  end;
end;

procedure Tduble_schet.PrintSchet;
var
  tip, ii, nomer, schet : integer;
  sutki, stoimost, lgot, br, prost, itog, summa : real;
  sser, s_mest, fam, io : string;
  dat_out, dat_in : TDate;
  lst, lst1 : TStringList;
  time_in : string[8];
  v_schet, sch_pr : variant;
Begin
  If cds_find.Active Then Begin
     If cds_find.RecordCount=0 Then Exit;
     If cds_plat.RecordCount=0 Then Exit;
     cds_plat.First;
     itog:=0;
     lgot:=0;
     prost:=0;
     br:=0;
     While not cds_plat.Eof Do Begin
       tip:=cds_plat.FieldByName('tip').AsInteger;
       Case tip of
        1 : itog:=cds_plat.FieldByName('summa').AsFloat;
        2 : lgot:=cds_plat.FieldByName('summa').AsFloat;
        3 : prost:=cds_plat.FieldByName('summa').AsFloat;
        4 : br:=cds_plat.FieldByName('summa').AsFloat;
       end;
       cds_plat.Next;
     end;
     nomer:=cds_find.FieldByName('nomer').AsInteger;
     schet:=cds_find.FieldByName('nom_schet').AsInteger;
     sser:=cds_find.FieldByName('seria').AsString;
     fam:=cds_find.FieldByName('famil').AsString;
     io:=cds_find.FieldByName('io').AsString;
     summa:=cds_find.FieldByName('Summa').AsFloat;
     //dat_out:=cds_find.FieldByName('date_out').Value;
     dat_in:=cds_find.FieldByName('date_in').Value;
     sutki:=cds_find.FieldByName('sutok').AsFloat;
     dat_out:=dat_in+Round(sutki);
     stoimost:=cds_find.FieldByName('sum_sut').AsFloat;
     time_in:=cds_find.FieldByName('time_in').AsString;
     s_mest:=cds_find.FieldByName('mests').AsString;
     v_schet:=VarArrayCreate([0, 7], varVariant);
     v_schet[0]:=7;
     v_schet[1]:=VarArrayOf(['Стоимость проживания 1 суток :',stoimost]);
     v_schet[2]:=VarArrayOf(['Итого проживание в номере :',itog,1]);
     v_schet[3]:=VarArrayOf(['Льгота :',lgot,2]);
     v_schet[4]:=VarArrayOf(['Простой :',prost,3]);
     v_schet[5]:=VarArrayOf(['Бронь :',br,4]);
     v_schet[6]:=VarArrayOf(['Завтрак на 1 сут. :',0]);
     v_schet[7]:=VarArrayOf(['ИТОГО к оплате :',summa]);
     lst1:=TStringList.Create;
     lst1.Add('Ф.И.О.  '+fam+' '+io);
     lst1.Add('');
     lst1.Add(v_schet[1][0]+' '+FloatToStr(v_schet[1][1])+' руб.');
     lst1.Add('Срок проживания : '+FloatToStr(sutki)+' сут.');
     lst1.Add('--------------------------------------------');
     ii:=2;
     While ii < 6 Do Begin
      lst1.Add(v_schet[ii][0]+' '+FloatToStr(v_schet[ii][1])+' руб.');
      Inc(ii);
     end;
     lst:=TStringList.Create;
     sch_pr:=VarArrayCreate([0, 5], varVariant);
     sch_pr[0]:=IntToStr(schet);
     sch_pr[1]:=v_schet[7][1];
     lst.Add('Дата заезда: '+DateToStr(dat_in)+'г.');
     lst.Add('№ '+IntToStr(nomer)+'; мест: '+s_mest);
     sch_pr[2]:=lst.Text;
     lst.Clear;
     lst.Add('Время заезда: '+time_in);
     lst.Add('Выезд: '+DateToStr(dat_out)+'г.');
     lst.Add('ДУБЛИКАТ');
     sch_pr[3]:=lst.Text;
     lst1.Add('--------------------------------------------');
     lst1.Add(v_schet[7][0]+' '+FloatToStr(v_schet[7][1])+' руб.');
     sch_pr[4]:=lst1.Text;
     lst.free;
     lst1.Free;
     sch_pr[5]:=sser;
     MessageDlg('Вставте бланк для печати счета! Нажмите <Ок>', mtConfirmation, [mbOk], 0);
     Prn_schet_nal(sch_pr);
  end;
end;

procedure Tduble_schet.bt_exitClick(Sender: TObject);
begin
   Close;
end;

procedure Tduble_schet.bt_searchClick(Sender: TObject);
begin
  findGost;
  ShowPyes;
end;

procedure Tduble_schet.ds_findDataChange(Sender: TObject; Field: TField);
begin
  ShowPyes;
end;

procedure Tduble_schet.bt_print_schetClick(Sender: TObject);
begin
  PrintSchet;
end;

end.
