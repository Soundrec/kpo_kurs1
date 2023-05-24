unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.ExtCtrls,  TurboJPEGDynamic,
  System.Win.ScktComp, Vcl.StdCtrls, JPEG;

  var
  applyfilter : bool;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


Type
  Tcamera = class(TThread)
  private
//    stClientSocket: TClientSocket;
//    stSockStream: TWinSocketStream;
//    FRequestString: ansistring;
//    stMemStream: TstMemStreamoryStream;
//    JPG: TJPEGImage;
//    f, FActive: boolean;
//    FData: ansistring;
//    st: integer;
          tmpbmp2: TBitmap;
    procedure TryConnect;
    procedure ShowResult;
  protected
    procedure Execute; override;
  public
    filtered : bool;
    stClientSocket: TClientSocket;
    stSockStream: TWinSocketStream;
    FRequestString: ansistring;
    stMemStream: TMemoryStream;
    JPG: TJPEGImage;
    f, FActive: boolean;
    FData: ansistring;
    st: integer;
    stPanel: TPanel;
    stImage:Timage;
    host: string;
    port: integer;
    DisplayBitmap: TBitmap;
    constructor Create;
    destructor Destroy; override;

  end;


implementation

uses Unit6, Unit1;

constructor Tcamera.Create;
begin
  inherited Create(true);
  FreeOnTerminate := true;
  stClientSocket := TClientSocket.Create(nil);
  stClientSocket.ClientType := ctBlocking;
  stMemStream := TMemoryStream.Create;
  JPG := TJPEGImage.Create;
  port := 80;
  filtered:= false;
  stPanel := TPanel.Create(Form6);
  stImage := TImage.Create(Form6);
  stImage.Stretch:=true;
  stImage.Proportional:=true;
 stImage.Center:=true;
 tmpbmp2 := TBitmap.Create;
end;

destructor Tcamera.Destroy;
begin
  self.Suspend;

  stImage.Free;
  stClientSocket.Free;
  FreeAndNil(stMemStream);
  FreeAndNil(JPG);
  inherited;
end;

procedure Tcamera.TryConnect;
begin
  stClientSocket.host := host;
  stClientSocket.port := port;
  stClientSocket.Open;

  stSockStream := TWinSocketStream.Create(stClientSocket.Socket, 10000);
  if stClientSocket.Socket.Connected then
  begin
    FRequestString := 'GET /axis-cgi/mjpg/video.cgi HTTP/1.1' + #13 + #10 + #13
      + #10 + #13 + #10;
    stSockStream.Write(FRequestString[1], Length(FRequestString));
    FActive := true;
  end;
end;

procedure Tcamera.ShowResult;
begin
    if (tmpbmp2 <> nil) then
    begin
      stImage.Picture.Bitmap.Assign(tmpbmp2);
     end;
end;

procedure Tcamera.Execute;
begin

  Self.TryConnect;
  while not Terminated do

    if stClientSocket.Active and FActive then
    BEGIN

      try
        FData := stClientSocket.Socket.ReceiveText;
      except
        /// ќбработка ошибок
      end;

      if FActive and (FData <> '') then
      BEGIn
        st := pos('€Ў€', FData);
        if st > 0 then
        begin
          if stMemStream.Size > 0 then
          Begin
            stMemStream.Write(FData[1], st - 1);
            stMemStream.Position := 0;
            JPG.LoadFromStream(stMemStream);
            tmpbmp2.Assign(JPG);

            if filtered then
//              showmessage('works');
//    PluginsHolder.ApplyPluginIMG2IMG
//      (cmptFl.Items.Strings[cmptFl.ItemIndex],
//      cmptImg.Picture.Bitmap, cmptImg.Picture.Bitmap);
//    PluginsHolder.ApplyPluginIMG2IMG
//      (cmptFl.Items.Strings[cmptFl.ItemIndex],
//      cmptImg.Picture.Bitmap, cmptImg.Picture.Bitmap);



              Unit6.PluginsHolder.ApplyPluginIMG2IMG(
              Form6.ListBox2.Items.Strings[Form6.ListBox2.ItemIndex], tmpbmp2, tmpbmp2);
//            cmptlbl.Caption := 'Time: ' + FormatFloat('0.0000',
//            PluginsHolder.Time * 1000) + ' ms.';

             /////          обработку сюда
             ///

             ///
             ///
            Synchronize(ShowResult);
            stMemStream.Clear;
          end;
          delete(FData, 1, st - 1);
          stMemStream.Write(FData[1], Length(FData));
          f := true;
        end
        else if f then
          stMemStream.Write(FData[1], Length(FData));
      ENd;
    END;
end;
end.

