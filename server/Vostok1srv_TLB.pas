unit Vostok1srv_TLB;

// ************************************************************************ //
// WARNING                                                                  //
// -------                                                                  //
// The types declared in this file were generated from data read from a     //
// Type Library. If this type library is explicitly or indirectly (via      //
// another type library referring to this type library) re-imported, or the //
// 'Refresh' command of the Type Library Editor activated while editing the //
// Type Library, the contents of this file will be regenerated and all      //
// manual modifications will be lost.                                       //
// ************************************************************************ //

// PASTLWTR : $Revision:   1.11.1.75  $
// File generated on 03.10.1999 14:27:50 from Type Library described below.

// ************************************************************************ //
// Type Lib: C:\Borland\Rab\Vostok\server\Vostok1srv.tlb
// IID\LCID: {7F577EE0-683D-11D2-87E0-006008562FB1}\0
// Helpfile: 
// HelpString: Vostok1srv Library
// Version:    1.0
// ************************************************************************ //

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:      //
//   Type Libraries     : LIBID_xxxx                                    //
//   CoClasses          : CLASS_xxxx                                    //
//   DISPInterfaces     : DIID_xxxx                                     //
//   Non-DISP interfaces: IID_xxxx                                      //
// *********************************************************************//
const
  LIBID_Vostok1srv: TGUID = '{7F577EE0-683D-11D2-87E0-006008562FB1}';
  IID_Ivostok1: TGUID = '{7F577EE1-683D-11D2-87E0-006008562FB1}';
  CLASS_vostok1: TGUID = '{7F577EE2-683D-11D2-87E0-006008562FB1}';
type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  Ivostok1 = interface;
  Ivostok1Disp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  vostok1 = Ivostok1;


// *********************************************************************//
// Interface: Ivostok1
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {7F577EE1-683D-11D2-87E0-006008562FB1}
// *********************************************************************//
  Ivostok1 = interface(IDataBroker)
    ['{7F577EE1-683D-11D2-87E0-006008562FB1}']
    procedure StartTrans; safecall;
    procedure CommitTrans; safecall;
    function RunSQL(in_params: OleVariant): Integer; safecall;
    function Reception(login: OleVariant): Integer; safecall;
    function Get_Prov_work: IProvider; safecall;
    function Get_Prov_exec: IProvider; safecall;
    function Get_Prov_teh: IProvider; safecall;
    function Get_pr_jurnal: IProvider; safecall;
    function Get_pr_spr1: IProvider; safecall;
    function Get_pr_spr2: IProvider; safecall;
    function Get_pr_spr3: IProvider; safecall;
    procedure BackTrans; safecall;
    function GetNextID: Integer; safecall;
    function Get_pPlats: IProvider; safecall;
    function Get_pRequest: IProvider; safecall;
    function Get_State_DB: Integer; safecall;
    function ChangeZMN(StartDate: TDateTime; EndDate: TDateTime; Prichina: Integer; Mest: Integer; 
                       Nomer: Integer): Integer; safecall;
    function Get_pFirstRooms: IProvider; safecall;
    procedure MoveBron(StartDate: TDateTime; EndDate: TDateTime; Nomer: Integer); safecall;
    function Idle: TDateTime; safecall;
    function Get_pBlackList: IProvider; safecall;
    procedure FillGostPayHistory(KodGost: Integer); safecall;
    function Get_pMail: IProvider; safecall;
    function CheckNewMessages: Integer; safecall;
    function Get_pMail_out: IProvider; safecall;
    function ResetTarifs: Integer; safecall;
    function Get_pGornich: IProvider; safecall;
    function Get_pGenClear: IProvider; safecall;
    function GetRiteExtra: Integer; safecall;
    function IsSys: Integer; safecall;
    property Prov_work: IProvider read Get_Prov_work;
    property Prov_exec: IProvider read Get_Prov_exec;
    property Prov_teh: IProvider read Get_Prov_teh;
    property pr_jurnal: IProvider read Get_pr_jurnal;
    property pr_spr1: IProvider read Get_pr_spr1;
    property pr_spr2: IProvider read Get_pr_spr2;
    property pr_spr3: IProvider read Get_pr_spr3;
    property pPlats: IProvider read Get_pPlats;
    property pRequest: IProvider read Get_pRequest;
    property pFirstRooms: IProvider read Get_pFirstRooms;
    property pBlackList: IProvider read Get_pBlackList;
    property pMail: IProvider read Get_pMail;
    property pMail_out: IProvider read Get_pMail_out;
    property pGornich: IProvider read Get_pGornich;
    property pGenClear: IProvider read Get_pGenClear;
  end;

// *********************************************************************//
// DispIntf:  Ivostok1Disp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {7F577EE1-683D-11D2-87E0-006008562FB1}
// *********************************************************************//
  Ivostok1Disp = dispinterface
    ['{7F577EE1-683D-11D2-87E0-006008562FB1}']
    procedure StartTrans; dispid 12;
    procedure CommitTrans; dispid 13;
    function RunSQL(in_params: OleVariant): Integer; dispid 1;
    function Reception(login: OleVariant): Integer; dispid 4;
    property Prov_work: IProvider readonly dispid 2;
    property Prov_exec: IProvider readonly dispid 3;
    property Prov_teh: IProvider readonly dispid 5;
    property pr_jurnal: IProvider readonly dispid 6;
    property pr_spr1: IProvider readonly dispid 7;
    property pr_spr2: IProvider readonly dispid 9;
    property pr_spr3: IProvider readonly dispid 10;
    procedure BackTrans; dispid 8;
    function GetNextID: Integer; dispid 15;
    property pPlats: IProvider readonly dispid 11;
    property pRequest: IProvider readonly dispid 14;
    function Get_State_DB: Integer; dispid 16;
    function ChangeZMN(StartDate: TDateTime; EndDate: TDateTime; Prichina: Integer; Mest: Integer; 
                       Nomer: Integer): Integer; dispid 17;
    property pFirstRooms: IProvider readonly dispid 18;
    procedure MoveBron(StartDate: TDateTime; EndDate: TDateTime; Nomer: Integer); dispid 19;
    function Idle: TDateTime; dispid 20;
    property pBlackList: IProvider readonly dispid 22;
    procedure FillGostPayHistory(KodGost: Integer); dispid 21;
    property pMail: IProvider readonly dispid 23;
    function CheckNewMessages: Integer; dispid 24;
    property pMail_out: IProvider readonly dispid 25;
    function ResetTarifs: Integer; dispid 26;
    property pGornich: IProvider readonly dispid 27;
    property pGenClear: IProvider readonly dispid 28;
    function GetRiteExtra: Integer; dispid 29;
    function IsSys: Integer; dispid 30;
    function GetProviderNames: OleVariant; dispid 22929905;
  end;

  Covostok1 = class
    class function Create: Ivostok1;
    class function CreateRemote(const MachineName: string): Ivostok1;
  end;

implementation

uses ComObj;

class function Covostok1.Create: Ivostok1;
begin
  Result := CreateComObject(CLASS_vostok1) as Ivostok1;
end;

class function Covostok1.CreateRemote(const MachineName: string): Ivostok1;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_vostok1) as Ivostok1;
end;

end.
