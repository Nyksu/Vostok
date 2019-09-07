unit gen_ubor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, prn_gen_ubor, ComCtrls;

type
  Tfr_genubor_dlg = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    bt_print: TBitBtn;
    bt_exit: TBitBtn;
    ed_ds: TDateTimePicker;
    ed_po: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    procedure bt_exitClick(Sender: TObject);
    procedure bt_printClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure Start_genUbor;


var
  fr_genubor_dlg: Tfr_genubor_dlg;

implementation

{$R *.DFM}

Procedure Start_genUbor;
Begin
  try
     try
       fr_genubor_dlg:=Tfr_genubor_dlg.Create(Application);
       fr_genubor_dlg.ShowModal;
     finally
       fr_genubor_dlg.Free;
     end
  except
  end;
end;

procedure Tfr_genubor_dlg.bt_exitClick(Sender: TObject);
begin
   fr_genubor_dlg.Close;
end;

procedure Tfr_genubor_dlg.bt_printClick(Sender: TObject);
begin
   Gen_list_genubor(ed_ds.Date,ed_po.Date);
end;

procedure Tfr_genubor_dlg.FormCreate(Sender: TObject);
begin
  ed_ds.Date:=date-30;
  ed_po.Date:=date;
end;

end.
