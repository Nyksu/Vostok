unit GetDataDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
  Tfr_get_date = class(TForm)
    ed_date: TMonthCalendar;
    lb_top: TLabel;
    bt_Ok: TBitBtn;
    bt_cancel: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure bt_OkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function Get_Date(title,coment : string; var dt : TDate) : boolean;

var
  fr_get_date: Tfr_get_date;

implementation

{$R *.DFM}

var
  tit,comm : string;
  rs : boolean;
  dtch : TDate;

Function Get_Date(title,coment : string; var dt : TDate) : boolean;
Begin
  tit:=title;
  comm:=coment;
  rs:=false;
  Result:=false;
  dtch:=dt;
  try
    try
      fr_get_date:=Tfr_get_date.Create(Application);
      fr_get_date.ShowModal;
    finally
      Result:=rs;
      dt:=dtch;
    end;
  except
  end;
end;

procedure Tfr_get_date.FormCreate(Sender: TObject);
begin
  Caption:=tit;
  lb_top.Caption:=comm;
  ed_date.Date:=dtch;
end;

procedure Tfr_get_date.bt_OkClick(Sender: TObject);
begin
  rs:=true;
  dtch:=ed_date.Date;
end;

end.
