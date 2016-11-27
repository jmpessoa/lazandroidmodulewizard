unit XWindow;

{$mode objfpc}{$H+}

interface

uses x, xlib, xatom, ctypes;

type
  HWND = TWindow;
  LPARAM = PtrInt;
  WINBOOL = Boolean;
  TEnumWindowsProc = function (_para1: HWND; _para2: LPARAM): WINBOOL; stdcall;

function EnumWindows(lpEnumFunc: TEnumWindowsProc; lParam: LPARAM): WINBOOL;
function GetWindowText(Wnd: HWND; lpText: PChar; nMaxCount: Integer): Integer;
//function GetClassName(hWnd: HWND; lpClassName: PChar; nMaxCount: Integer): Integer;
function GetForegroundWindow: HWND;
function SetForegroundWindow(hWnd: HWND): Boolean;

implementation

var
  dpy: PDisplay;
  atom_NET_WM_NAME: TAtom = TAtom(-1);
  atom_WM_NAME: TAtom = TAtom(-1);

function x11property(dpy: PDisplay; win: TWindow; prop, Atype: TAtom;
  nitems: pculong): Pointer;
var
  type_ret: TAtom;
  format_ret: Integer;
  items_ret, after_ret: culong;
  prop_data: PChar;
begin
  prop_data := nil;

  if (XGetWindowProperty(dpy, win, prop, 0, $7fffffff, False, Atype,
    @type_ret, @format_ret, @items_ret, @after_ret, @prop_data) <> Success)
  then
    Exit(nil);

  if (nitems <> nil) then
    nitems^ := items_ret;

  Result := prop_data;
end;

function EnumWindows(lpEnumFunc: TEnumWindowsProc; lParam: LPARAM): WINBOOL;
var
  atom_client_list: TAtom;
  root: TWindow;
  winlist: PWindow;
  num, i: Integer;
begin
  root := DefaultRootWindow(dpy);
  atom_client_list := XInternAtom(dpy, '_NET_CLIENT_LIST', False);
  winlist := x11property(dpy, root, atom_client_list, XA_WINDOW, @num);
  Result := winlist <> nil;
  if Result then
  begin
    for i := 0 to num - 1 do
      if not lpEnumFunc(winlist[i], lParam) then Break;
    XFree(winlist);
  end;
end;

function GetWindowText(Wnd: HWND; lpText: PChar; nMaxCount: Integer): Integer;
var
  name: PChar;
  l: Integer;
  type_: TAtom;
  size: Integer;
  nitems: culong;
begin
  if dpy = nil then Exit(-1);
  if atom_NET_WM_NAME = TAtom(-1) then
    atom_NET_WM_NAME := XInternAtom(dpy, '_NET_WM_NAME', False);
  if atom_WM_NAME = TAtom(-1) then
    atom_WM_NAME := XInternAtom(dpy, 'WM_NAME', False);

  name := x11property(dpy, Wnd, atom_NET_WM_NAME, AnyPropertyType, @nitems);
  if nitems = 0 then
    name := x11property(dpy, Wnd, atom_WM_NAME, AnyPropertyType, @nitems);

{  XFetchName(dpy, Wnd, @name);}
  l := strlen(name);
  if l > nMaxCount then
    l := nMaxCount;
  Move(name^, lpText^, l);
  if l < nMaxCount then
    lpText[l] := #0;
  Result := l;
  XFree(name);
end;

function GetClassName(hWnd: HWND; lpClassName: PChar; nMaxCount: Integer): Integer;
begin

end;

function GetForegroundWindow: HWND;
var
  winlist: PWindow;
  root: TWindow;
  atom_active_window: TAtom;
begin
  if dpy = nil then Exit(0);
  root := DefaultRootWindow(dpy);
  atom_active_window := XInternAtom(dpy, '_NET_ACTIVE_WINDOW', False);
  winlist := x11property(dpy, root, atom_active_window, XA_WINDOW, nil);
  if (winlist <> nil) then
  begin
    Result := winlist^;
    XFree(winlist);
  end else begin
    Result := None;
  end;
end;

function SetForegroundWindow(hWnd: HWND): Boolean;
begin
  if dpy = nil then Exit(False);
  {raise}
  Result := XRaiseWindow(dpy, hWnd) <> BadWindow;
  {focus}
  if Result then
    Result := XSetInputFocus(dpy, hWnd, RevertToParent, CurrentTime) = 0;
  XFlush(dpy);
end;

initialization
  dpy := XOpenDisplay(nil);

finalization
  XCloseDisplay(dpy);
end.
