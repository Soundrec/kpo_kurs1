// ********************************************************************************************************************************
// *                                                                                                                              *
// *     Turbo JPEG Dynamic Loader v0.9b  (22.02.2012)                                                                            *
// *     Compatible with libjpeg-turbo 1.1-2.1                                                                                    *
// *                                                                                                                              *
// *     © Aleksandr G. Zotin 2012-2023                                                                                           *
// *                                                                                                                              *
// *     e-mail  zotin.sibsau@yandex.ru                                                                                           *
// *                                                                                                                              *
// ********************************************************************************************************************************

unit TurboJPEGDynamic;

interface

Uses
  Windows,
  SysUtils, Classes,
  Graphics;

function InitTurboJPEGLibrary: Boolean;
function FreeTurboJPEGLibrary: Boolean;
function TurboJPEG_LoadImage(FileName: String; var PicBitmap: TBitmap): Boolean;
function TurboJPEG_LoadStreamImage(ms: tmemorystream;
  var PicBitmap: TBitmap): Boolean;

const
  NAME_TurboJPEGDLL = 'turbojpeg.dll';

  NAME_TurboJPEG_InitDecompress = 'tjInitDecompress';
  NAME_TurboJPEG_DecompressHeader = 'tjDecompressHeader';
  NAME_TurboJPEG_Decompress = 'tjDecompress';
  NAME_TurboJPEG_DecompressDestroy = 'tjDestroy';

type

  t_TurboJPEG_InitDecompress = function: Integer; cdecl;
  t_TurboJPEG_DecompressHeader = function(Dec: Integer; var SrcBuf;
    Size: Integer; out Width, Height: Integer): Integer; cdecl;
  t_TurboJPEG_Decompress = function(Dec: Integer; var SrcBuf; Size: Integer;
    var DstBuf; Width, Pitch, Height, PixelSize, Flags: Integer)
    : Integer; cdecl;
  t_TurboJPEG_DecompressDestroy = function(Dec: Integer): Integer; cdecl;

var
  TurboJPEG_InitDecompress: t_TurboJPEG_InitDecompress;
  TurboJPEG_DecompressHeader: t_TurboJPEG_DecompressHeader;
  TurboJPEG_Decompress: t_TurboJPEG_Decompress;
  TurboJPEG_DecompressDestroy: t_TurboJPEG_DecompressDestroy;

var
  TurboJPEGDLLHandle: THandle = 0;
  TurboJPEGDLLLoaded: Boolean = False;

implementation

function InitTurboJPEGLibrary: Boolean;
begin
  if TurboJPEGDLLHandle = 0 then
  begin
    TurboJPEGDLLHandle := SafeLoadLibrary(NAME_TurboJPEGDLL);
  end;
  Result := TurboJPEGDLLHandle <> 0;
  if Result then
  begin
    TurboJPEG_InitDecompress := GetProcAddress(TurboJPEGDLLHandle,
      PChar(NAME_TurboJPEG_InitDecompress));
    TurboJPEG_DecompressHeader := GetProcAddress(TurboJPEGDLLHandle,
      PChar(NAME_TurboJPEG_DecompressHeader));
    TurboJPEG_Decompress := GetProcAddress(TurboJPEGDLLHandle,
      PChar(NAME_TurboJPEG_Decompress));
    TurboJPEG_DecompressDestroy := GetProcAddress(TurboJPEGDLLHandle,
      PChar(NAME_TurboJPEG_DecompressDestroy));
  end;
  if (@TurboJPEG_InitDecompress = nil) OR (@TurboJPEG_DecompressHeader = nil) OR
    (@TurboJPEG_Decompress = nil) OR (@TurboJPEG_DecompressDestroy = nil) then
    Result := False;
  if Result then
    TurboJPEGDLLLoaded := True;
end;

function FreeTurboJPEGLibrary: Boolean;
begin
  if TurboJPEGDLLHandle <> 0 then
  begin
    Result := FreeLibrary(TurboJPEGDLLHandle);
    if Result then
      TurboJPEGDLLLoaded := False;
  end;
end;

function TurboJPEG_LoadImage(FileName: String; var PicBitmap: TBitmap): Boolean;
var
  Dec, W, H, stride: Integer;
  f: file;
  Buf: AnsiString;
begin
  Result := False;
  try
    Dec := TurboJPEG_InitDecompress;
    AssignFile(f, FileName);
    Reset(f, 1);
    SetLength(Buf, FileSize(f));
    BlockRead(f, Buf[1], Length(Buf));
    CloseFile(f);
    if TurboJPEG_DecompressHeader(Dec, Buf[1], Length(Buf), W, H) = 0 then
    begin
      if NOT Assigned(PicBitmap) then
      begin
        PicBitmap := TBitmap.Create;
      end;
      PicBitmap.PixelFormat := pf24bit;
      PicBitmap.SetSize(W, H);

      stride := W * 3;
      if (stride mod 4) <> 0 then
        stride := stride + (4 - (stride mod 4));

      TurboJPEG_Decompress(Dec, Buf[1], Length(Buf),
        PicBitmap.ScanLine[PicBitmap.Height - 1]^, PicBitmap.Width, stride,
        PicBitmap.Height, 3, 3);
      Result := True;
      TurboJPEG_DecompressDestroy(Dec);
    end;
  except
    // *
  end;
end;

function TurboJPEG_LoadStreamImage(ms: tmemorystream;
  var PicBitmap: TBitmap): Boolean;
var
  Dec, W, H, stride: Integer;
begin
  Result := False;
  try
    Dec := TurboJPEG_InitDecompress;
    ms.Position := 0;
    if TurboJPEG_DecompressHeader(Dec, ms.Memory^, ms.Size, W, H) = 0 then
    begin
      if NOT Assigned(PicBitmap) then
      begin
        PicBitmap := TBitmap.Create;
      end;
      PicBitmap.PixelFormat := pf24bit;
      PicBitmap.SetSize(W, H);

      stride := W * 3;
      if (stride mod 4) <> 0 then
        stride := stride + (4 - (stride mod 4));

      TurboJPEG_Decompress(Dec, ms.Memory^, ms.Size,
        PicBitmap.ScanLine[PicBitmap.Height - 1]^, PicBitmap.Width, stride,
        PicBitmap.Height, 3, 3);
      Result := True;
      TurboJPEG_DecompressDestroy(Dec);
    end;
  except
    // *
  end;
end;

end.
