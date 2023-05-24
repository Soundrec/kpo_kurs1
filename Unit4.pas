unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TForm4 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
Tcamera = class
  constructor Create();

  private
  stsomeparam: string;

  public
  a : Integer;
  b : integer;
  procedure ab();

end;


var
  Form4: TForm4;

implementation

{$R *.dfm}



implementation

uses Unit6, Unit1;


constructor Tcamera.Create();
begin
  stClientSocket := TClientSocket.Create(Form6);
  stMemStream := TMemoryStream.Create;
  stBmp := TBitmap.Create;
  stf := false;
  stImage := TImage.Create(Form6);

 stClientSocket.OnConnect := ClientSocketConnect;
 stClientSocket.OnRead := ClientSocketRead;
end;

procedure Tcamera.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  ShowMessage('Connected');
end;


procedure Tcamera.ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  s: ansistring;
  start: integer;
  i : integer;
begin
  Application.ProcessMessages;
  s := Socket.ReceiveText; // принятая порция данных
  //showmessage(s);
  start :=  pos('яШя', s); // Поиск начала кадра JPEG в строке (FFD8)
  if start > 0 then
  begin

    if stMemStream.Size > 0 then
    Begin
        stMemStream.Position := 0;
        TurboJPEG_LoadStreamImage(stMemStream,stBmp);
        stMemStream.Clear;
        stImage.Canvas.Lock;
        try
          stImage.Picture.Bitmap.assign(stBmp);
          stImage.Stretch := true;
        finally
          stImage.Canvas.Unlock;
        end;
    end;
    delete(s, 1, start - 1);
    stMemStream.Write(s[1], length(s));
    stf := true;
  end
  else if stf then
    stMemStream.Write(s[1], length(s));
end;







end.
