unit progress_window;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls;

type
  Tfr_progress = class(TForm)
    proress_process: TProgressBar;
    txt_soobschen: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure DeclarateConstProgress(txt : string; diapason, stp: integer);
    procedure SetStepNext;
    procedure SetPositionProgress(pos : integer);
    procedure NewMessage(txt : string);
    { Public declarations }
  end;

Procedure StartProgress;

Procedure CloseProgress;

var
  fr_progress: Tfr_progress;
  state_progress : boolean;

implementation

Procedure StartProgress;
Begin
  try
     Screen.Cursor:=crHourGlass;
     fr_progress:=Tfr_progress.Create(Application);
     fr_progress.Show;
     Application.ProcessMessages;
     state_progress:=true;
  except
     state_progress:=false;
     Screen.Cursor:=crDefault;
     fr_progress.Free;
  end;
end;

Procedure CloseProgress;
Begin
  try
    Screen.Cursor:=crDefault;
    If state_progress Then Begin
      state_progress:=false;
      fr_progress.Close;
      fr_progress.Free;
    end;
  except
  end;
end;
{$R *.DFM}


procedure Tfr_progress.DeclarateConstProgress(txt : string; diapason, stp: integer);
Begin
   proress_process.max:=diapason;
   proress_process.Step:=stp;
   proress_process.min:=0;
   proress_process.Position:=0;
   txt_soobschen.Visible:=false;
   txt_soobschen.Caption:=txt;
   txt_soobschen.Show;
   Application.ProcessMessages;
end;

procedure Tfr_progress.SetStepNext;
Begin
   proress_process.StepIt;
end;

procedure Tfr_progress.SetPositionProgress(pos : integer);
Begin
   proress_process.Position:=pos;
end;

procedure Tfr_progress.NewMessage(txt : string);
Begin
   txt_soobschen.Visible:=false;
   txt_soobschen.Caption:=txt;
   txt_soobschen.Show;
   Application.ProcessMessages;
end;

procedure Tfr_progress.FormCreate(Sender: TObject);
begin
  txt_soobschen.Visible:=false;
  txt_soobschen.Caption:='Система занята на операцию...';
  txt_soobschen.Show;
  Application.ProcessMessages;
end;

end.
