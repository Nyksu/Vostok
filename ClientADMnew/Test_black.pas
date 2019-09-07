unit Test_black;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, ExtCtrls, Buttons, RxGrdCpt;

type
  Tfr_black_test = class(TForm)
    RxGradientCaption1: TRxGradientCaption;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    dbf_fam: TDBText;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    dbf_io: TDBText;
    dbf_rekv: TDBText;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    dbf_dr: TDBText;
    dbf_prim: TDBMemo;
    dbf_koment: TDBMemo;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function Test_men_black : boolean;


var
  fr_black_test: Tfr_black_test;
  res : boolean;

implementation

Uses MainAdm;

{$R *.DFM}

Function Test_men_black : boolean;
Begin
 res:=false;
 try
   try
     fr_black_test:=Tfr_black_test.Create(Application);
     fr_black_test.ShowModal;
   finally
     Result:=res;
     fr_black_test.Free;
   end;
 except
 end;
end;

procedure Tfr_black_test.FormCreate(Sender: TObject);
begin
   dbf_fam.DataField:='famil';
   dbf_io.DataField:='io';
   dbf_rekv.DataField:='rekvisits';
   dbf_prim.DataField:='primets';
   dbf_koment.DataField:='koments';
end;

procedure Tfr_black_test.BitBtn1Click(Sender: TObject);
begin
  res:=true;
  fr_black_test.Close;
end;

procedure Tfr_black_test.BitBtn2Click(Sender: TObject);
begin
   fr_black_test.Close;
end;

end.
