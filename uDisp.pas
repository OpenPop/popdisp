unit uDisp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, jpeg;

type
  T_ALACN_Disp = class(TForm)
    pnlimg: TPanel;
    img: TImage;
    pnlCtrl: TPanel;
    btnLoad: TButton;
    btnSave: TButton;
    btnImport: TButton;
    btnExport: TButton;
    txtPopRec: TLabel;
    txtALACN: TLabel;
    imgLoad: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  _ALACN_Disp: T_ALACN_Disp;

const
  SZ_LOAD               = 'Load';
  SZ_SAVE               = 'Save';
  SZ_IMPORT             = 'Import';
  SZ_EXPORT             = 'Export';

  SZ_TITLE              = 'Displacement';
  SZ_OPEN_FAILED        = 'Cannot Open File %s';
  SZ_SAVE_FAILED        = 'Cannot Save File %s';

  SZ_FILTER_DISP        = 'disp0-?.dat|disp0-?.dat|All Files (*.*)|*.*';
  SZ_FILTER_BMP         = '*.bmp|*.bmp|All Files (*.*)|*.*';
  SZ_EXT_DISP           = '*.dat';
  SZ_EXT_BMP            = '*.bmp';

  SIZE_X                = 256;
  SIZE_Y                = 256;

implementation

{$R *.DFM}

procedure T_ALACN_Disp.FormCreate(Sender: TObject);
begin
  SetCurrentDir(ExtractFilePath(Application.ExeName));
end;

procedure T_ALACN_Disp.btnLoadClick(Sender: TObject);
var
  dlg: TOpenDialog;
  h: THandle;
  buf: array [0..SIZE_X - 1] of BYTE;
  dwRW, x, y: DWORD;
begin
  dlg := TOpenDialog.Create(Self);
  with dlg do
  try
    Title := SZ_LOAD;
    InitialDir := GetCurrentDir;
    Filter := SZ_FILTER_DISP;
    Options := Options + [ofPathMustExist, ofFileMustExist];
    if not Execute then Exit;

    h := CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    if h = INVALID_HANDLE_VALUE then
    begin
      MessageBox(_ALACN_Disp.Handle, PChar(Format(SZ_OPEN_FAILED, [ExtractFileName(dlg.FileName)])), SZ_TITLE, MB_ICONHAND);
      Exit;
    end;

    for y := 0 to SIZE_Y - 1 do
    begin
      ReadFile(h, buf, sizeof(buf), dwRW, nil);

      for x := 0 to SIZE_X - 1 do
      begin
        img.Canvas.Pixels[x, y] := buf[x] or (buf[x] shl 8) or (buf[x] shl 16);
      end;
    end;

    CloseHandle(h);
  finally
    dlg.Free;
  end;
end;

procedure T_ALACN_Disp.btnSaveClick(Sender: TObject);
var
  dlg: TSaveDialog;
  h: THandle;
  buf: array [0..SIZE_X - 1] of BYTE;
  dwRW, x, y: DWORD;
begin
  dlg := TSaveDialog.Create(Self);
  with dlg do
  try
    Title := SZ_SAVE;
    InitialDir := GetCurrentDir;
    Filter := SZ_FILTER_DISP;
    DefaultExt := SZ_EXT_DISP;
    Options := Options + [ofOverwritePrompt];
    if not Execute then Exit;

    h := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    if h = INVALID_HANDLE_VALUE then
    begin
      MessageBox(_ALACN_Disp.Handle, PChar(Format(SZ_SAVE_FAILED, [ExtractFileName(dlg.FileName)])), SZ_TITLE, MB_ICONHAND);
      Exit;
    end;

    for y := 0 to SIZE_Y - 1 do
    begin
      for x := 0 to SIZE_X - 1 do
        buf[x] := (img.Canvas.Pixels[x, y] and $FF);

      WriteFile(h, buf, sizeof(buf), dwRW, nil);
    end;

    CloseHandle(h);
  finally
    dlg.Free;
  end;
end;

procedure T_ALACN_Disp.btnImportClick(Sender: TObject);
var
  dlg: TOpenDialog;
  dw: DWORD;
  b: BYTE;
  x, y: integer;
  rc: TRect;
begin
  dlg := TOpenDialog.Create(Self);
  with dlg do
  try
    Title := SZ_IMPORT;
    InitialDir := GetCurrentDir;
    Filter := SZ_FILTER_BMP;
    Options := Options + [ofPathMustExist, ofFileMustExist];
    if not Execute then Exit;

    try
      //img.Picture.Bitmap.LoadFromFile(FileName);
      imgLoad.Picture.LoadFromFile(FileName);
      rc.Top := 0;
      rc.Left := 0;
      rc.Right := SIZE_X;
      rc.Bottom := SIZE_Y;
      img.Canvas.StretchDraw(rc, imgLoad.Picture.Graphic);
    except
      MessageBox(_ALACN_Disp.Handle, PChar(Format(SZ_OPEN_FAILED, [ExtractFileName(dlg.FileName)])), SZ_TITLE, MB_ICONHAND);
      Exit;
    end;

    for y := 0 to img.Height -1 do
    for x := 0 to img.Width - 1 do
    begin
      dw := img.Canvas.Pixels[x, y];
      b := ((dw and $FF) + ((dw shr 8) and $FF) + ((dw shr 16) and $FF)) div 3;
      dw := b or (b shl 8) or (b shl 16);
      img.Canvas.Pixels[x, y] := dw;
    end;
  finally
    dlg.Free;
  end;
end;

procedure T_ALACN_Disp.btnExportClick(Sender: TObject);
var
  dlg: TSaveDialog;
begin
  dlg := TSaveDialog.Create(Self);
  with dlg do
  try
    Title := SZ_EXPORT;
    InitialDir := GetCurrentDir;
    Filter := SZ_FILTER_BMP;
    DefaultExt := SZ_EXT_BMP;
    Options := Options + [ofOverwritePrompt];
    if not Execute then Exit;

    try
      img.Picture.Bitmap.SaveToFile(FileName);
    except
      MessageBox(_ALACN_Disp.Handle, PChar(Format(SZ_SAVE_FAILED, [ExtractFileName(dlg.FileName)])), SZ_TITLE, MB_ICONHAND);
      Exit;
    end;
  finally
    dlg.Free;
  end;
end;

end.
