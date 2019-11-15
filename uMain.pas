unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.AppEvnts;

type
  TShareInfo = record
    Actived: array [1 .. 4] of boolean;
  end;

  PShareInfo = ^TShareInfo;

  TForm1 = class(TForm)
    Memo1: TMemo;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    btnEnum: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEnumClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// =========================================================
procedure MyGetDesktopName(number: Integer; var name: string);
begin
  if number = 1 then
    name := 'Default'
  else
    name := 'NewDesktop' + inttostr(number);
end;

function MyOpenDeskTop(name: string): HDESK;
var
  si: STARTUPINFO;
begin

  ZeroMemory(@si, sizeof(STARTUPINFO));
  si.cb := sizeof(STARTUPINFO);
  si.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
  si.wShowWindow := SW_SHOW;
  si.lpDesktop := PChar(Name);

  Result := OpenDesktop(PChar(Name), DF_ALLOWOTHERACCOUNTHOOK, true,
    DESKTOP_CREATEMENU or DESKTOP_CREATEWINDOW or DESKTOP_ENUMERATE or
    DESKTOP_HOOKCONTROL or DESKTOP_JOURNALPLAYBACK or DESKTOP_JOURNALRECORD or
    DESKTOP_READOBJECTS or DESKTOP_SWITCHDESKTOP or DESKTOP_WRITEOBJECTS);

end;

procedure MySwitchDesktop(number: Integer);
var
  name: string;
  DsktpHandle: HDESK;
  SysPath: array [1 .. MAX_PATH] of char;
  PPath: PChar;
  StrPath: string;
  len: Integer;
  pi: PROCESS_INFORMATION;
  si: STARTUPINFO;
begin
  MyGetDesktopName(number, name);
  DsktpHandle := MyOpenDeskTop(name);

  if DsktpHandle = 0 then // desktop dos not exist
  begin

    DsktpHandle := CreateDesktop(PChar(Name), nil, nil,
      DF_ALLOWOTHERACCOUNTHOOK, DESKTOP_CREATEMENU or DESKTOP_CREATEWINDOW or
      DESKTOP_ENUMERATE or DESKTOP_HOOKCONTROL or DESKTOP_JOURNALPLAYBACK or
      DESKTOP_JOURNALRECORD or DESKTOP_READOBJECTS or DESKTOP_SWITCHDESKTOP or
      DESKTOP_WRITEOBJECTS, nil);

    if DsktpHandle = 0 then
    begin
      ShowMessage('CreateDesktop FAILED! ' + SysErrorMessage(GetLastError));
      exit;
    end;

    PPath := @SysPath;
    len := GetWindowsDirectory(@SysPath, MAX_PATH);
    SetString(StrPath, PPath, len);
//    StrPath := StrPath + '\explorer.exe'; // StrPath 有反斜線！？

    StrPath := 'r:\SwitchWin10Desktop.exe';

    if not (CreateProcess(PChar(StrPath), nil, nil, nil, true, 0, nil, nil, si, pi)) then
    begin
      ShowMessage('CreateProcess FAILED! ' + SysErrorMessage(GetLastError));
      CloseDeskTop(DsktpHandle);
      exit;
    end;

  end;

   SwitchDesktop(DsktpHandle);
end;

function MyCheckDesktop(number: Integer): boolean;
var
  name: string;
  DsktpHandle: HDESK;
  list: TStringList;

  function EnumDesktopProc(DesktopName: LPTSTR; Param: LParam)
    : boolean; stdcall;
  begin
    TStringList(Param).Add(DesktopName); // Tony !!
    Result := true;
  end;

begin
  list := TStringList.Create;
  MyGetDesktopName(number, name);
  EnumDesktops(GetProcessWindowStation, @EnumDesktopProc, Integer(list));

  if list.IndexOf(name) >= 0 then
    Result := true
  else
    Result := false;

  list.DisposeOf();
end;

procedure MyCloseDesktop();
var
  DsktpHandle: HDESK;
begin
  DsktpHandle := GetThreadDesktop(GetCurrentThreadId);
  CloseDeskTop(DsktpHandle);
  // Tony : 關不掉目前的
end;

// ================================================
procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := 2 to 4 do
    if MyCheckDesktop(i) then
      Memo1.Lines.Add('Desktop' + i.ToString + ' exits');

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MyCloseDesktop();
  MySwitchDesktop(1);
end;

procedure TForm1.btnEnumClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 2 to 4 do
    if MyCheckDesktop(i) then
      Memo1.Lines.Add('Desktop' + i.ToString + ' exits');
end;

procedure TForm1.ButtonClick(Sender: TObject);
begin
  MySwitchDesktop(TButton(Sender).Tag);
end;

end.
