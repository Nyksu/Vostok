unit Ask_dlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  Tfr_dialog = class(TForm)
    Panel1: TPanel;
    mem_txt: TMemo;
    bt_yes: TBitBtn;
    bt_not: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure bt_yesClick(Sender: TObject);
    procedure bt_notClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function Get_Answer(sap,txt : variant; def : boolean):boolean;

var
  fr_dialog: Tfr_dialog;
  rr, df : boolean;

implementation

{$R *.DFM}

Function Get_Answer(sap,txt : variant; def : boolean):boolean;
Begin
  Try
    try
      rr:=false;
      df:=def;
      fr_dialog:=Tfr_dialog.Create(Application);
      If sap > '' Then fr_dialog.Caption:=sap
         Else fr_dialog.Caption:='Вопрос !';
      fr_dialog.mem_txt.lines.text:=txt;
      fr_dialog.ShowModal;
    finally
      Result:=rr;
      fr_dialog.Free;
    end;
  Except
  end;
end;

procedure Tfr_dialog.FormActivate(Sender: TObject);
begin
    If df Then bt_yes.SetFocus
       Else bt_not.SetFocus;
end;

procedure Tfr_dialog.bt_yesClick(Sender: TObject);
begin
  rr:=true;
  fr_dialog.Close;
end;

procedure Tfr_dialog.bt_notClick(Sender: TObject);
begin
  rr:=false;
  fr_dialog.Close;
end;

end.
