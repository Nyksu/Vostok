unit Read_text_post;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, ExtCtrls;

type
  Tfr_text_message = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    m_text_mes: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure StartReadMsq(s_dat, s_avtor, txt : string);

var
  fr_text_message: Tfr_text_message;

implementation

{$R *.DFM}

Uses Post;


Procedure StartReadMsq(s_dat, s_avtor, txt : string);
Begin
   try
     try
       fr_text_message:=Tfr_text_message.Create(Application);
       fr_text_message.Caption:=s_avtor;
       fr_text_message.Panel2.Caption:='Письмо от '+s_dat;
       fr_text_message.m_text_mes.Lines.Text:=txt;
       fr_text_message.ShowModal;
     finally
       fr_text_message.Free;
     end;
   except
   end;
end;

procedure Tfr_text_message.Button1Click(Sender: TObject);
begin
  fr_text_message.Close;
end;

end.
