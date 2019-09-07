unit group_schet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Spin, StdCtrls, Buttons, ComCtrls, prn_group_sch;

type
  Tfr_grup_schet = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ed_fio: TEdit;
    ed_rekvisit: TEdit;
    ed_predpr: TEdit;
    ed_schets: TTreeView;
    bt_add_sch: TBitBtn;
    bt_del_sch: TBitBtn;
    ed_nom_sch: TSpinEdit;
    bt_print: TBitBtn;
    bt_exit: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure bt_exitClick(Sender: TObject);
    procedure bt_add_schClick(Sender: TObject);
    procedure bt_del_schClick(Sender: TObject);
    procedure bt_printClick(Sender: TObject);
  private
    Function FindInTree(str:string) : integer;
    Function FindBase(nom : integer) : boolean;
    Function FindBase2(nom : integer) : boolean;
    Function FindBase3(nom : integer) : boolean;
    Function FindBase4(nom : integer) : boolean;
    { Private declarations }
  public
    { Public declarations }
  end;


Procedure Start_group_schet;

var
  fr_grup_schet: Tfr_grup_schet;

implementation

Uses MainAdm;

{$R *.DFM}

Procedure Start_group_schet;
Begin
  try
     try
       fr_grup_schet:=Tfr_grup_schet.Create(Application);
       fr_grup_schet.ShowModal;
     finally
       fr_grup_schet.Free;
     end;
  except
  end;
end;

procedure Tfr_grup_schet.bt_exitClick(Sender: TObject);
begin
  fr_grup_schet.Close;
end;

Function Tfr_grup_schet.FindInTree(str:string) : integer;
var
  ii, count, ind : integer;
Begin
  count:=ed_schets.Items.Count;
  ind:=-1;
  for ii:=0 to count-1 Do
      If ed_schets.Items[ii].text = str Then Begin
         ind:=ii;
         Break;
      end;
  Result:=ind;
end;

Function Tfr_grup_schet.FindBase(nom : integer) : boolean;
var
  param,re : variant;
Begin
  param:=VarArrayCreate([0, 2], varVariant);
  param[0]:=1;                  //проверка на вхождение в другие группы
  param[1]:=VarArrayOf([IntToStr(nom)]);{параметры sql}
  param[2]:=VarArrayOf(['nom_sch']);{имена параметров sql}
  Screen.Cursor:=crHourGlass;
  re:=fr_ClientAdm.GetTehParam(252,param);
  If (VarIsNull(re)) or (VarIsNull(re[1])) Then Result:=false
  Else Result:=true;
  Screen.Cursor:=crDefault;
end;

Function Tfr_grup_schet.FindBase2(nom : integer) : boolean;
var
  param,re : variant;
Begin
  param:=VarArrayCreate([0, 2], varVariant);
  param[0]:=1;              //проверка на наличие
  param[1]:=VarArrayOf([IntToStr(nom)]);{параметры sql}
  param[2]:=VarArrayOf(['schet']);{имена параметров sql}
  Screen.Cursor:=crHourGlass;
  re:=fr_ClientAdm.GetTehParam(222,param);
  If (VarIsNull(re)) or (VarIsNull(re[1])) Then Result:=false
  Else Result:=true;
  Screen.Cursor:=crDefault;
end;

Function Tfr_grup_schet.FindBase3(nom : integer) : boolean;
var
  param,re : variant;   //проверка на возврат
Begin
  param:=VarArrayCreate([0, 2], varVariant);
  param[0]:=1;
  param[1]:=VarArrayOf([IntToStr(nom)]);{параметры sql}
  param[2]:=VarArrayOf(['s']);{имена параметров sql}
  Screen.Cursor:=crHourGlass;
  re:=fr_ClientAdm.GetTehParam(255,param);
  If (VarIsNull(re)) or (VarIsNull(re[1])) Then Result:=false
  Else Result:=true;
  Screen.Cursor:=crDefault;
end;

Function Tfr_grup_schet.FindBase4(nom : integer) : boolean;
var
  param,re : variant;      //проверка на закрытость
Begin
  param:=VarArrayCreate([0, 2], varVariant);
  param[0]:=1;
  param[1]:=VarArrayOf([IntToStr(nom)]);{параметры sql}
  param[2]:=VarArrayOf(['schet']);{имена параметров sql}
  Screen.Cursor:=crHourGlass;
  re:=fr_ClientAdm.GetTehParam(256,param);
  If (VarIsNull(re)) or (VarIsNull(re[1])) Then Result:=false
  Else Result:=true;
  Screen.Cursor:=crDefault;
end;

procedure Tfr_grup_schet.bt_add_schClick(Sender: TObject);
var
  item_str : string;
begin
   If ed_nom_sch.Value>0 Then Begin
      item_str:=IntToStr(ed_nom_sch.Value);
      If FindBase(ed_nom_sch.Value) Then Begin
        MessageDlg('Этот счет есть в другой группе счетов!', mtWarning, [mbOk], 0);
        Exit;
      end;
      If not FindBase2(ed_nom_sch.Value) Then Begin
        MessageDlg('Такого счета нет в базе!', mtWarning, [mbOk], 0);
        Exit;
      end;
      If FindBase3(ed_nom_sch.Value) Then Begin
        MessageDlg('Не действующий счет! По счету сделан возврат!', mtWarning, [mbOk], 0);
        Exit;
      end;
      If not FindBase4(ed_nom_sch.Value) Then Begin
        MessageDlg('Счет не закрыт! Сначала необходимо выселить гостя!!', mtWarning, [mbOk], 0);
        Exit;
      end;
      While Length(item_str)<10 Do item_str:='0'+item_str;
      If FindInTree(item_str)>=0 Then Exit;
      ed_schets.Items.Add(nil,item_str);
      ed_schets.AlphaSort;
   end;
end;

procedure Tfr_grup_schet.bt_del_schClick(Sender: TObject);
begin
   ed_schets.Items.Delete(ed_schets.Selected);
end;

procedure Tfr_grup_schet.bt_printClick(Sender: TObject);
var
  parametry : variant;
  resSQL,ii,id : integer;
begin
   If (ed_fio.Text='')and(ed_predpr.Text='') Then Exit;
   If ed_schets.Items.Count<=1 Then Begin
     MessageDlg('Слишком мало счетов!', mtWarning, [mbOk], 0);
     Exit;
   end;
   id:=fr_ClientAdm.MIDASConnection1.AppServer.GetNextID;
   parametry:=VarArrayCreate([0, 5], varVariant);
   parametry[0]:=250;
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=4;
   parametry[3]:=VarArrayOf([IntToStr(id),ed_fio.Text,ed_rekvisit.Text,ed_predpr.Text]);
   parametry[4]:=VarArrayOf(['id','fio','rek','bisn']);
   parametry[5]:=0;
   fr_ClientAdm.MIDASConnection1.AppServer.StartTrans;
   Screen.Cursor:=crHourGlass;
   resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
   If resSQL<>0 Then Begin
      fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
      Screen.Cursor:=crDefault;
      MessageDlg('Ошибка регистрации! Попробуйте еще раз!!', mtError, [mbOk], 0);
      Exit;
   end;
   parametry[0]:=251;
   parametry[1]:=fr_ClientAdm.kod_adm;
   parametry[2]:=2;
   parametry[4]:=VarArrayOf(['id','sch']);
   parametry[5]:=0;
   For ii:=0 To ed_schets.Items.Count-1 Do Begin
       parametry[3]:=VarArrayOf([IntToStr(id),ed_schets.Items[ii].text]);
       resSQL:=fr_ClientAdm.MIDASConnection1.AppServer.RunSQL(parametry);
       If resSQL<>0 Then Begin
         fr_ClientAdm.MIDASConnection1.AppServer.BackTrans;
         Screen.Cursor:=crDefault;
         MessageDlg('Ошибка регистрации! Попробуйте еще раз!!', mtError	, [mbOk], 0);
         Exit;
       end;
   end;
   Screen.Cursor:=crDefault;
   fr_ClientAdm.MIDASConnection1.AppServer.CommitTrans;
   MessageDlg('Вставте большие листы для печати счета и нажмите Ok!', mtConfirmation, [mbOk], 0);
   PrintGroup(id);
   fr_grup_schet.Close;
end;

end.
