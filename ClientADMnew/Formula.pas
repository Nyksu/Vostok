unit Formula;

interface

function SumToStr(ssum : string; kp : boolean): string;

function DatToStr(ddtt : TDateTime): string;

implementation

uses SysUtils;


Function GetStrCh(Chi : char; por : byte; firb, tis : boolean) : string;
Var
  stt : string;
Begin
  stt:='';
  Case por of
    0 : Case Chi of
       '1': If firb Then If not tis Then stt:='���� '
            Else stt:='���� ' Else If not tis Then stt:='���� '
            Else stt:='���� ';
       '2': If firb Then If not tis Then stt:='��� '
            Else stt:='��� ' Else If not tis Then stt:='��� '
            Else stt:='��� ';
       '3': If firb Then stt:='��� ' Else stt:='��� ';
       '4': If firb Then stt:='������ ' Else stt:='������ ';
       '5': If firb Then stt:='���� ' Else stt:='���� ';
       '6': If firb Then stt:='����� ' Else stt:='����� ';
       '7': If firb Then stt:='���� ' Else stt:='���� ';
       '8': If firb Then stt:='������ ' Else stt:='������ ';
       '9': If firb Then stt:='������ ' Else stt:='������ ';
        end;
    1 : Case Chi of
         '0': If firb Then stt:='������ ' Else stt:='������ ';
         '1': If firb Then stt:='����������� ' Else stt:='����������� ';
         '2': If firb Then stt:='���������� ' Else stt:='���������� ';
         '3': If firb Then stt:='���������� ' Else stt:='���������� ';
         '4': If firb Then stt:='������������ ' Else stt:='������������ ';
         '5': If firb Then stt:='���������� ' Else stt:='���������� ';
         '6': If firb Then stt:='����������� ' Else stt:='����������� ';
         '7': If firb Then stt:='���������� ' Else stt:='���������� ';
         '8': If firb Then stt:='������������ ' Else stt:='������������ ';
         '9': If firb Then stt:='������������ ' Else stt:='������������ ';
        end;
    2 : Case Chi of
         '2': If firb Then stt:='�������� ' Else stt:='�������� ';
         '3': If firb Then stt:='�������� ' Else stt:='�������� ';
         '4': If firb Then stt:='����� ' Else stt:='����� ';
         '5': If firb Then stt:='��������� ' Else stt:='��������� ';
         '6': If firb Then stt:='���������� ' Else stt:='���������� ';
         '7': If firb Then stt:='��������� ' Else stt:='��������� ';
         '8': If firb Then stt:='����������� ' Else stt:='����������� ';
         '9': If firb Then stt:='��������� ' Else stt:='��������� ';
        end;
    3 : Case Chi of
         '1': If firb Then stt:='��� ' Else stt:='��� ';
         '2': If firb Then stt:='������ ' Else stt:='������ ';
         '3': If firb Then stt:='������ ' Else stt:='������ ';
         '4': If firb Then stt:='��������� ' Else stt:='��������� ';
         '5': If firb Then stt:='������� ' Else stt:='������� ';
         '6': If firb Then stt:='�������� ' Else stt:='�������� ';
         '7': If firb Then stt:='������� ' Else stt:='������� ';
         '8': If firb Then stt:='��������� ' Else stt:='��������� ';
         '9': If firb Then stt:='��������� ' Else stt:='��������� ';
        end;
    end;
    GetStrCh:=stt;
end;


{******************************************************}


Function StartStr(million:string): string;
var
 ii,posl_ch,poz : integer;
 ss,chislo,mil,mrd,tsch : string;
 chary : char;
 des : boolean;
begin
   ss:='';
   mrd:='';
   des:=false;
   mil:='';
   tsch:='';
   chislo:=million;
   ii:=Length(chislo);
   poz:=ii;
   posl_ch:=0;
   While poz>=1 Do Begin
     Case poz of
       1 : Begin
             chary:=chislo[ii-poz+1];
             If chary >= '0' Then Begin
               If des Then
                  if ss = '' then
                     ss:=GetStrCh(chary,1,true,false)
                    else begin
                     If posl_ch > 9 Then ss:=ss+mrd;
                     If posl_ch > 6 Then ss:=ss+mil;
                     If posl_ch > 3 Then ss:=ss+tsch;
                     ss:=ss+GetStrCh(chary,1,false,false);
                    end
                  Else Begin
                    if ss = '' then
                      ss:=GetStrCh(chary,0,true,false)
                     else begin
                      If posl_ch > 9 Then ss:=ss+mrd;
                      If posl_ch > 6 Then ss:=ss+mil;
                      If posl_ch > 3 Then ss:=ss+tsch;
                      ss:=ss+GetStrCh(chary,0,false,false);
                     end;
                  end;
             end;
           end;
       2 : Begin
             chary:=chislo[ii-poz+1];
             des:=false;
             If chary > '0' Then Begin
               {tsch:='����� ';}
               If chary = '1' Then des:=true;
               If ss = '' Then Begin
                     If not des Then ss:=GetStrCh(chary,2,true,false)
                    end
                    Else Begin
                     If posl_ch > 9 Then ss:=ss+mrd;
                     If posl_ch > 6 Then ss:=ss+mil;
                     If posl_ch > 3 Then ss:=ss+tsch;
                     If not des Then ss:=ss+GetStrCh(chary,2,false,false);
                    end;
               posl_ch:=poz;
             end;
           end;
       3 : Begin
             chary:=chislo[ii-poz+1];
             If chary > '0' Then Begin
               If ss = '' Then
                     ss:=GetStrCh(chary,3,true,false)
                  Else Begin
                     If posl_ch > 9 Then ss:=ss+mrd;
                     If posl_ch > 6 Then ss:=ss+mil;
                     If posl_ch > 3 Then ss:=ss+tsch;
                     ss:=ss+GetStrCh(chary,3,false,false);
                  end;
               posl_ch:=poz;
             end;
           end;
       4 : Begin
             chary:=chislo[ii-poz+1];
             If ((chary >= '0')and(des))or(chary > '0') Then Begin
               tsch:='����� ';
               If des Then
                  if ss = '' then
                     ss:=GetStrCh(chary,1,true,true)
                    else begin
                     If posl_ch > 9 Then ss:=ss+mrd;
                     If posl_ch > 6 Then ss:=ss+mil;
                     ss:=ss+GetStrCh(chary,1,false,true);
                    end
                  Else Begin
                    Case chary of
                       '1' : tsch:='������ ';
                  '2'..'4' : tsch:='������ ';
                    end;
                    if ss = '' then
                      ss:=GetStrCh(chary,0,true,true)
                     else begin
                      If posl_ch > 9 Then ss:=ss+mrd;
                      If posl_ch > 6 Then ss:=ss+mil;
                      ss:=ss+GetStrCh(chary,0,false,true)
                     end;
                  end;
                 posl_ch:=poz;
             end;
           end;
       5 : Begin
             chary:=chislo[ii-poz+1];
             des:=false;
             If chary > '0' Then Begin
               tsch:='����� ';
               If chary = '1' Then des:=true;
               If ss = '' Then Begin
                     If not des Then ss:=GetStrCh(chary,2,true,true)
                    end
                    Else Begin
                     If posl_ch > 9 Then ss:=ss+mrd;
                     If posl_ch > 6 Then ss:=ss+mil;
                     If not des Then ss:=ss+GetStrCh(chary,2,false,true);
                    end;
                 posl_ch:=poz;
             end;
           end;
       6 : Begin
             chary:=chislo[ii-poz+1];
             If chary > '0' Then Begin
               tsch:='����� ';
               If ss = '' Then
                     ss:=GetStrCh(chary,3,true,true)
                  Else Begin
                     If posl_ch > 9 Then ss:=ss+mrd;
                     If posl_ch > 6 Then ss:=ss+mil;
                     ss:=ss+GetStrCh(chary,3,false,true);
                  end;
               posl_ch:=poz;
             end;
           end;
       7 : Begin
             chary:=chislo[ii-poz+1];
             If ((chary >= '0')and(des))or(chary > '0') Then Begin
               mil:='��������� ';
               If des Then
                  if ss = '' then
                     ss:=GetStrCh(chary,1,true,false)
                    else begin
                     If posl_ch > 9 Then ss:=ss+mrd;
                     ss:=ss+GetStrCh(chary,1,false,false);
                    end
                  Else Begin
                    Case chary of
                       '1' : mil:='������� ';
                  '2'..'4' : mil:='�������a ';
                    end;
                    if ss = '' then
                      ss:=GetStrCh(chary,0,true,false)
                     else begin
                      If posl_ch > 9 Then ss:=ss+mrd;
                      ss:=ss+GetStrCh(chary,0,false,false)
                     end;
                  end;
               posl_ch:=poz;
             end;
           end;
       8 : Begin
             chary:=chislo[ii-poz+1];
             des:=false;
             If chary > '0' Then Begin
               mil:='��������� ';
               If chary = '1' Then des:=true;
               If ss = '' Then Begin
                       If not des Then ss:=GetStrCh(chary,2,true,false)
                    end
                    Else Begin
                     If posl_ch > 9 Then ss:=ss+mrd;
                     If not des Then ss:=ss+GetStrCh(chary,2,false,false);
                    end;
                 posl_ch:=poz;
             end;
           end;
       9 : Begin
             chary:=chislo[ii-poz+1];
             If chary > '0' Then Begin
               mil:='��������� ';
               If ss = '' Then
                     ss:=GetStrCh(chary,3,true,false)
                  Else Begin
                     If posl_ch > 9 Then ss:=ss+mrd;
                     ss:=ss+GetStrCh(chary,3,false,false);
                  end;
               posl_ch:=poz;
             end;
           end;
      10 : Begin
             chary:=chislo[ii-poz+1];
             If chary >= '0' Then Begin
               mrd:='���������� ';
               posl_ch:=poz;
               If des Then
                  if ss = '' then
                     ss:=GetStrCh(chary,1,true,false)
                    else
                     ss:=ss+GetStrCh(chary,1,false,false)
                  Else Begin
                    Case chary of
                       '1' : mrd:='�������� ';
                  '2'..'4' : mrd:='��������a ';
                    end;
                    if ss = '' then
                      ss:=GetStrCh(chary,0,true,false)
                     else
                      ss:=ss+GetStrCh(chary,0,false,false)
                  end;
             end;
           end;
      11 : Begin
             chary:=chislo[ii-poz+1];
             des:=false;
             If chary > '0' Then Begin
               mrd:='���������� ';
               posl_ch:=poz;
               If chary = '1' Then des:=true;
               If ss = '' Then Begin
                     If not des Then ss:=GetStrCh(chary,2,true,false)
                    end
                    Else
                     If not des Then ss:=ss+GetStrCh(chary,2,false,false);
             end;
           end;
      12 : Begin
             chary:=chislo[ii-poz+1];
             If chary > '0' Then Begin
                ss:=GetStrCh(chary,3,true,false);
                mrd:='���������� ';
                posl_ch:=poz;
             end;
           end;
     end;
     Dec(poz);
   end;
   StartStr:=ss;
end;

function SumToStr(ssum : string; kp : boolean): string;
var
pz, dl, ddl : integer;
kk : string;
Begin
 If kp Then Begin
   pz:=Pos(',',ssum);
   If pz>0 Then Begin
      ddl:=Length(ssum)-pz;
      dl:=ddl;
      If dl>2 Then dl:=2;
      kk:=Copy(ssum,pz+1,dl);
      Delete(ssum,pz,ddl+1);
   end;
   If (kk = '')or(kk = ' ') Then kk:='00';
   If Length(kk)<2 Then kk:=kk+'0';
   SumToStr:=StartStr(ssum)+'���. ' + kk + '���.';
 end
 Else Begin
   pz:=Pos(',',ssum);
   If pz>0 Then Begin
      ddl:=Length(ssum)-pz;
      {If dl>2 Then dl:=2;}
      Delete(ssum,pz,ddl+1);
   end;
   SumToStr:=StartStr(ssum)+'���.';
 end;
end;

function DatToStr(ddtt : TDateTime): string;
var
 st,sdey,sgod,smes : string;
 imes,idey,igod : word;
Begin
 DecodeDate(ddtt, igod, imes, idey);
 Str(igod,sgod);
 If Length(sgod)<4 Then If sgod > '90' Then sgod:='19'+sgod
                        Else sgod:='20'+sgod;
 Str(idey,sdey);
 Case imes of
   1 : smes:=' ������ ';
   2 : smes:=' ������� ';
   3 : smes:=' ����� ';
   4 : smes:=' ������ ';
   5 : smes:=' ��� ';
   6 : smes:=' ���� ';
   7 : smes:=' ���� ';
   8 : smes:=' ������� ';
   9 : smes:=' �������� ';
  10 : smes:=' ������� ';
  11 : smes:=' ������ ';
  12 : smes:=' ������� ';
 end;
 st:=sdey+smes+sgod+'�.';
 DatToStr:=st;
end;

end.
