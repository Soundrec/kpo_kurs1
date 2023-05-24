unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.ExtCtrls,  TurboJPEGDynamic,
  System.Win.ScktComp, Vcl.StdCtrls, JPEG, Vcl.Buttons, pngimage, PluginBase,
  Vcl.DBCtrls, Vcl.CheckLst, Vcl.ExtDlgs, PythonEngine;

  type
    TForm6 = class(TForm)
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    N11: TMenuItem;
    Panel2: TPanel;
    Button1: TButton;
    Panel_cameras: TScrollBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    RadioGroup1: TRadioGroup;
    GridPanel1: TGridPanel;
    GridPanel2: TGridPanel;
    ScrollBox1: TScrollBox;
    PopupMenu1: TPopupMenu;
    pause1: TMenuItem;
    continue1: TMenuItem;
    frame1: TMenuItem;
    ListBox1: TListBox;
    ScrollBox2: TScrollBox;
    ListBox2: TListBox;
    CheckBox1: TCheckBox;
    Panel_filters: TPanel;
    Button2: TButton;
    PluginsMenu: TMenuItem;
    N1: TMenuItem;
    PythonEngine1: TPythonEngine;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
     procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ImgClick(Sender: TObject);
    procedure DelTab(Sender: TObject);
    procedure SaveImg(Sender: TObject);
    procedure FunctionListClick(Sender: TObject);
    procedure ApplyFilter(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure pause1Click(Sender: TObject);
    procedure PopupMenu1Change(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure continue1Click(Sender: TObject);
    procedure frame1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
//    procedure PageControl2Change(Sender: TObject);
//    procedure N12Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    cameras_quantity: integer;

  end;

var
  Form6: TForm6;
  indent: integer;
  rows: Integer;
  columns: Integer;
  PluginsHolder: TPlugin;
  mouseX : integer;
  mouseY : integer;

implementation

{$R *.dfm}

uses Unit1, Unit3;
   var
  cameras_array : Array[0..30] of Tcamera;


procedure TForm6.Button1Click(Sender: TObject);
var
  i: Integer;
  c : integer;
  cam_width : Integer;
  cam_height : Integer;
  tmpButton : TButton;
  tmpLabel : TLabel;
begin
  c := 0;

  DataModule1.Q_get_cameras.Open;
  cameras_quantity := DataModule1.Q_get_cameras.RecordCount;
  DataModule1.Q_get_cameras.Close;

  columns := 3;
  rows := cameras_quantity div columns;
  if cameras_quantity mod columns > 0 then
    rows := rows + 1;

  indent := trunc(Form6.Panel_cameras.width div columns * 0.1);
  cam_width := trunc(0.85 * Form6.Panel_cameras.width / columns);
  cam_height := trunc(cam_width div columns * 2);

  GridPanel1.Align := alTop;
  GridPanel1.Width := GridPanel1.Parent.Width;


  GridPanel1.RowCollection.BeginUpdate;
  GridPanel1.ColumnCollection.BeginUpdate;

  for i := 0 to -1 + GridPanel1.ControlCount do
    GridPanel1.Controls[0].Free;

  GridPanel1.RowCollection.Clear;
  GridPanel1.ColumnCollection.Clear;

    for i := 1 to columns do
    with GridPanel1.ColumnCollection.Add do
    begin
      SizeStyle := ssPercent;
      Value := 100 / columns;
    end;

   for i := 1 to rows do
    with GridPanel1.RowCollection.Add do
    begin
      SizeStyle := ssPercent;
      Value := GridPanel1.Width / columns / 3 * 2;
    end;

  for i := 0 to cameras_quantity do
  begin
    if c < cameras_quantity then
      begin
      cameras_array[c] := Tcamera.Create;
      cameras_array[c].stPanel.Parent := GridPanel1;
      cameras_array[c].stPanel.BorderWidth := 0;
      cameras_array[c].stPanel.Align := alClient;
      cameras_array[c].stPanel.AlignWithMargins := true;
      cameras_array[c].stImage.Parent := cameras_array[c].stPanel;
      cameras_array[c].stImage.Align := alClient;
      cameras_array[c].stImage.OnClick := ImgClick;

      inc(c);

      end
      else
      break
  end;


  GridPanel1.RowCollection.EndUpdate;
  GridPanel1.ColumnCollection.EndUpdate;

  c := 0;
  DataModule1.Q_get_cameras.Open;
  while not DataModule1.Q_get_cameras.EOF do
  begin
    cameras_array[c].Host := DataModule1.Q_get_cameras.FieldByName('address').Value;
    cameras_array[c].Port := 80;
    cameras_array[c].Suspended:=false;
    inc(c);
    DataModule1.Q_get_cameras.Next;
  end;
  DataModule1.Q_get_cameras.Close;

  DataModule1.Q_get_cameras.Open;
  while not DataModule1.Q_get_cameras.EOF do
  begin
    RadioGroup1.Height := cameras_quantity * 24;
    RadioGroup1.Items.Add(DataModule1.Q_get_cameras.FieldByName('address').AsString);
    DataModule1.Q_get_cameras.Next;
  end;
  DataModule1.Q_get_cameras.Close;
end;


procedure TForm6.Button2Click(Sender: TObject);
begin
Panel_filters.Visible := false;
end;

procedure TForm6.Button3Click(Sender: TObject);
var
i : integer;
cam:integer;
begin
  Unit3.applyfilter :=true;
  for i := 0 to RadioGroup1.Items.Count - 1 do
    if RadioGroup1.Itemindex = 0 then
    for cam := 0 to cameras_quantity - 1 do
      cameras_array[cam].filtered := true
    else
      cameras_array[RadioGroup1.ItemIndex - 1].filtered := true;


  end;



procedure TForm6.CheckBox1Click(Sender: TObject);
var
i : integer;
cam : integer;
begin
    Unit3.applyfilter := CheckBox1.Checked;

    if Unit3.applyfilter = True then
    for i := 0 to RadioGroup1.Items.Count - 1 do
      if RadioGroup1.Itemindex = 0 then
      for cam := 0 to cameras_quantity - 1 do
        cameras_array[cam].filtered := true
      else
        cameras_array[RadioGroup1.ItemIndex - 1].filtered := true
    else
      for cam := 0 to cameras_quantity - 1 do
        cameras_array[cam].filtered := false;


end;

procedure TForm6.continue1Click(Sender: TObject);
var
  i : integer;
  top : integer;
  bottom : integer;
  left : integer;
  right : integer;
begin
  for i := 0 to cameras_quantity - 1 do
    begin
    top := cameras_array[i].stPanel.Top;
    left := cameras_array[i].stPanel.Left;
    right := cameras_array[i].stPanel.Left + cameras_array[i].stPanel.Width;
    bottom := cameras_array[i].stPanel.Top + cameras_array[i].stPanel.Height;
      if (top <= mouseY) and (mouseY <= bottom) then
        if (left <= mouseX) and (mouseX <= right) then
          begin
             cameras_array[i].Suspended := false;
            break
          end;
    end;
  end;

procedure TForm6.FormClose(Sender: TObject; var Action: TCloseAction);
begin
FreeTurboJPEGLibrary;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
InitTurboJPEGLibrary;
end;

procedure TForm6.ApplyFilter(Sender: TObject);
var
senderbutton:TButton;
cmptFl : TListBox;
cmptImg: TImage;
cmptLbl: TLabel;
begin
  cmptFl := Form6.FindComponent('fl' + IntToStr(PageControl2.ActivePageIndex+1)) as TListBox;
  cmptImg := Form6.FindComponent('newImg' + IntToStr(PageControl2.ActivePageIndex+1)) as TImage;
  cmptLbl := Form6.FindComponent('lbl' + IntToStr(PageControl2.ActivePageIndex+1)) as TLabel;

  if cmptFl.ItemIndex >= 0 then
  begin
    PluginsHolder.ApplyPluginIMG2IMG
      (cmptFl.Items.Strings[cmptFl.ItemIndex],
      cmptImg.Picture.Bitmap, cmptImg.Picture.Bitmap);
    cmptlbl.Caption := 'Time: ' + FormatFloat('0.0000',
      PluginsHolder.Time * 1000) + ' ms.';
  end;
end;

procedure TForm6.FormShow(Sender: TObject);
var
i : integer;
//PluginsMenu : TMenuItem;
//SettingsField : TScrollBox;


  c : integer;
  cam_width : Integer;
  cam_height : Integer;
  tmpButton : TButton;
  tmpLabel : TLabel;
begin
  c := 0;

  DataModule1.Q_get_cameras.Open;
  cameras_quantity := DataModule1.Q_get_cameras.RecordCount;
  DataModule1.Q_get_cameras.Close;

  columns := 3;
  rows := cameras_quantity div columns;
  if cameras_quantity mod columns > 0 then
    rows := rows + 1;

  indent := trunc(Form6.Panel_cameras.width div columns * 0.1);
  cam_width := trunc(0.85 * Form6.Panel_cameras.width / columns);
  cam_height := trunc(cam_width div columns * 2);

  GridPanel1.Align := alTop;
  GridPanel1.Width := GridPanel1.Parent.Width;


  GridPanel1.RowCollection.BeginUpdate;
  GridPanel1.ColumnCollection.BeginUpdate;

  for i := 0 to -1 + GridPanel1.ControlCount do
    GridPanel1.Controls[0].Free;

  GridPanel1.RowCollection.Clear;
  GridPanel1.ColumnCollection.Clear;

    for i := 1 to columns do
    with GridPanel1.ColumnCollection.Add do
    begin
      SizeStyle := ssPercent;
      Value := 100 / columns;
    end;

   for i := 1 to rows do
    with GridPanel1.RowCollection.Add do
    begin
      SizeStyle := ssPercent;
      Value := GridPanel1.Width / columns / 3 * 2;
    end;

  for i := 0 to cameras_quantity do
  begin
    if c < cameras_quantity then
      begin
      cameras_array[c] := Tcamera.Create;
      cameras_array[c].stPanel.Parent := GridPanel1;
      cameras_array[c].stPanel.BorderWidth := 0;
      cameras_array[c].stPanel.Align := alClient;
      cameras_array[c].stPanel.AlignWithMargins := true;
      cameras_array[c].stImage.Parent := cameras_array[c].stPanel;
      cameras_array[c].stImage.Align := alClient;
      cameras_array[c].stImage.OnClick := ImgClick;

      inc(c);

      end
      else
      break
  end;


  GridPanel1.RowCollection.EndUpdate;
  GridPanel1.ColumnCollection.EndUpdate;

  c := 0;
  DataModule1.Q_get_cameras.Open;
  while not DataModule1.Q_get_cameras.EOF do
  begin

//    if DataModule1.Q_get_cameras.FieldByName('address').Value = '84.82.29.229' then
//      cameras_array[c].Port := 8080;


    cameras_array[c].Host := DataModule1.Q_get_cameras.FieldByName('address').Value;
    cameras_array[c].Port := StrToInt(DataModule1.Q_get_cameras.FieldByName('port').Value);
    cameras_array[c].Suspended:=false;
    inc(c);
    DataModule1.Q_get_cameras.Next;
  end;
  DataModule1.Q_get_cameras.Close;

  DataModule1.Q_get_cameras.Open;
  while not DataModule1.Q_get_cameras.EOF do
  begin
    RadioGroup1.Height := cameras_quantity * 24;
    RadioGroup1.Items.Add(DataModule1.Q_get_cameras.FieldByName('address').AsString);
    DataModule1.Q_get_cameras.Next;
  end;
  DataModule1.Q_get_cameras.Close;

       ///
       ///  ///
       ///
       ///
       ///

  ListBox2.OnClick := FunctionListClick;
  ListPluginFileDir(ExtractFilePath(application.ExeName), '*.dll', ListBox1.Items);
  PluginsHolder := TPlugin.Create;
  PluginsHolder.SettingsField := ScrollBox2;
  PluginsHolder.FaListBox := ListBox2;
  PluginsHolder.PluginsMenu := PluginsMenu;
  for i := 0 to ListBox1.Items.Count - 1 do
    PluginsHolder.LoadPluginFunction(ListBox1.Items.Strings[i]);





end;


procedure TForm6.frame1Click(Sender: TObject);
var
  i : integer;
  top : integer;
  bottom : integer;
  left : integer;
  right : integer;
begin
  for i := 0 to cameras_quantity - 1 do
    begin
    top := cameras_array[i].stPanel.Top;
    left := cameras_array[i].stPanel.Left;
    right := cameras_array[i].stPanel.Left + cameras_array[i].stPanel.Width;
    bottom := cameras_array[i].stPanel.Top + cameras_array[i].stPanel.Height;
      if (top <= mouseY) and (mouseY <= bottom) then
        if (left <= mouseX) and (mouseX <= right) then
          begin
             ImgClick(cameras_array[i].stImage);
            break
          end;
    end;
end;

procedure TForm6.FunctionListClick(Sender: TObject);
var
fl:TListBox;
begin
  fl := Sender as TListBox;
  if fl.ItemIndex >= 0 then
    PluginsHolder.CreatePluginFunctionSettings
      (fl.Items.Strings[fl.ItemIndex]);
end;

procedure TForm6.ImgClick(Sender: TObject);
var
  newTab: TTabSheet;
  newImg : TImage;
  oldImg : TImage;
  newDelButton : TButton;
  newSaveButton : TButton;
  i: integer;
  FileListBox : TListBox;
  SettingsField: TScrollBox;
  FunctionList: TListBox;
  PluginsMenu: TMenuItem;
  dllPanel : TPanel;
  PanelRight : TPanel;
  newApplyButton : TButton;
  newLabel : TLabel;

begin
  with PageControl2 do
  begin
    newtab := TTabSheet.Create(Self);
    newtab.PageControl := PageControl2;
    newtab.Caption:= 'Page ' +IntToStr(PageCount);
  end;

  dllPanel := TPanel.Create(Self);
  dllPanel.Parent := newTab;
  dllPanel.Align := alLeft;
  dllPanel.Width := 300;

  PanelRight := TPanel.Create(Self);
  PanelRight.Parent := newTab;
  PanelRight.Align := alClient;

  FileListBox := TListBox.Create(Self);
  SettingsField := TScrollBox.Create(Self);
  FunctionList := TListBox.Create(Self);
  PluginsMenu := TMenuItem.Create(Self);

  SettingsField.Parent := dllPanel;
  FileListBox.Parent := dllPanel;
  FunctionList.Parent := dllPanel;

  FunctionList.Name := 'fl' + IntToStr(PageControl2.PageCount);

  SettingsField.Height := 100;
  SettingsField.Align := alTop;
  FileListBox.Align := alTop;
  FunctionList.Align := alTop;

  FunctionList.OnClick := FunctionListClick;

  ListPluginFileDir(ExtractFilePath(application.ExeName), '*.dll', FileListBox.Items);
  PluginsHolder := TPlugin.Create;
  PluginsHolder.SettingsField := SettingsField;
  PluginsHolder.FaListBox := FunctionList;
  PluginsHolder.PluginsMenu := PluginsMenu;
  for i := 0 to FileListBox.Items.Count - 1 do
    PluginsHolder.LoadPluginFunction(FileListBox.Items.Strings[i]);

  newLabel := TLabel.Create(Self);
  newLabel.Parent := dllPanel;
  newLabel.Name := 'lbl' + IntToStr(PageControl2.PageCount);
  newLabel.Align := alBottom;

  newImg := TImage.Create(Self);
  newImg.Name := 'newImg' + IntToStr(PageControl2.PageCount);
  newImg.Parent := PanelRight;
  newImg.Align:=alClient;
  oldImg := Sender as TImage;
  newImg.Picture.Assign(oldImg.Picture);

  newDelButton := TButton.Create(Self);
  newDelButton.Parent := newTab;
  newDelButton.Height := 32;
  newDelButton.Caption := 'Close';
  newDelButton.Top := 0;
  newDelButton.Left := newTab.Width - newDelButton.Width - 12;
  newDelButton.OnClick := DelTab;

  Form6.PageControl2.ActivePage := newtab;
  newSaveButton := TButton.Create(Self);
  newSaveButton.Parent := newTab;
  newSaveButton.Height := 32;
  newSaveButton.Caption := 'Save img';
  newSaveButton.Top := 44;
  newSaveButton.Left := newTab.Width - newDelButton.Width - 12;
  newSaveButton.OnClick := SaveImg;

  newApplyButton := TButton.Create(Self);
  newApplyButton.Parent := dllPanel;
  newApplyButton.Height := 32;
  newApplyButton.Caption := 'Apply Filter';
  newApplyButton.Top := 300;
  newApplyButton.Left := 0;
  newApplyButton.OnClick := ApplyFilter;
end;

procedure TForm6.N11Click(Sender: TObject);
begin

  Panel_filters.Visible := true;

end;

procedure TForm6.N1Click(Sender: TObject);
var
i: integer;
  selectedFile: string;
  dlg: TOpenDialog;
begin
  selectedFile := '';
  dlg := TOpenDialog.Create(nil);
  try
    dlg.InitialDir := 'C:\';
    dlg.Filter := 'Dll-פאיכû (*.dll)|*.dll';
    if dlg.Execute(Handle) then
      selectedFile := dlg.FileName;
  finally
    dlg.Free;
  end;

  if selectedFile <> '' then

    showmessage(selectedFile);
    ListBox1.Items.Add(selectedFile);

  for i := ListBox1.Items.Count - 1 to ListBox1.Items.Count - 1 do
    PluginsHolder.LoadPluginFunction(ListBox1.Items.Strings[i]);




end;


procedure TForm6.SaveImg(Sender: TObject);
var
fname : string;
dt: string;
fs: TFormatSettings;
l : integer;
cmpt : TImage;
begin
  fs:= TFormatSettings.Create;
  fs.TimeSeparator:= '/';
  dt := DateTimeToStr(Now);
  for l := 0 to length(dt) do
    begin
    if dt[l] = ':' then dt[l] := '-';
    if dt[l] = '.' then dt[l] := '-';
    if dt[l] = ' ' then dt[l] := '_';
  end;
  fname := './cameras/camera-manual-save-DateTime-' + dt + '.bmp';
  cmpt := Form6.FindComponent('newImg'+IntToStr(PageControl2.ActivePageIndex+1)) as TImage;
  cmpt.Picture.SaveToFile(fname);
end;

procedure TForm6.DelTab(Sender: TObject);
begin
if (Form6.PageControl2.PageCount > 1) and (Form6.PageControl2.ActivePageIndex > 0) then
  begin
  Form6.PageControl2.ActivePage.Destroy;
  end;
end;

procedure TForm6.PopupMenu1Change(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
var
  pt : tPoint;
begin
  pt := Mouse.CursorPos;
  pt := ScreenToClient(pt);
  mouseX := pt.x - GridPanel1.Parent.Left;
  mouseY := pt.y - GridPanel1.Parent.Top;
end;

procedure TForm6.pause1Click(Sender: TObject);
var
  i : integer;
  top : integer;
  bottom : integer;
  left : integer;
  right : integer;
begin
  for i := 0 to cameras_quantity - 1 do
    begin
    top := cameras_array[i].stPanel.Top;
    left := cameras_array[i].stPanel.Left;
    right := cameras_array[i].stPanel.Left + cameras_array[i].stPanel.Width;
    bottom := cameras_array[i].stPanel.Top + cameras_array[i].stPanel.Height;
      if (top <= mouseY) and (mouseY <= bottom) then
        if (left <= mouseX) and (mouseX <= right) then
          begin
             cameras_array[i].Suspended := true;
            break
          end;
    end;
  end;

procedure TForm6.Action1Execute(Sender: TObject);
var
  i : integer;
  c : integer;
  cq : integer;
begin

  columns := 3;
  c := 0;

  for cq := 0 to cameras_quantity-1 do
  begin
    cameras_array[cq].stPanel.Parent := Panel_cameras;
  end;


  if RadioGroup1.Items[RadioGroup1.ItemIndex] = 'All' then
  begin
    GridPanel2.Parent.Height := 20;
    GridPanel2.Parent.Visible:=false;
    GridPanel1.Align := alClient;
    GridPanel1.Height := GridPanel1.Parent.Height;

    GridPanel1.RowCollection.BeginUpdate;
    GridPanel1.ColumnCollection.BeginUpdate;

    for i := 0 to -1 + GridPanel1.ControlCount do
      GridPanel1.Controls[0].Free;

    GridPanel1.RowCollection.Clear;
    GridPanel1.ColumnCollection.Clear;

    for i := 1 to columns do
    with GridPanel1.ColumnCollection.Add do
    begin
      SizeStyle := ssPercent;
      Value := 100 / columns;
    end;

   for i := 1 to rows do
    with GridPanel1.RowCollection.Add do
    begin
      SizeStyle := ssPercent;
      Value := GridPanel1.Width / columns / 3 * 2;
    end;

  for i := 0 to cameras_quantity do
  begin
    if c < cameras_quantity then
      begin
      cameras_array[c].stPanel.Parent := GridPanel1;
      inc(c);
      end
      else
      break
  end;

  GridPanel1.RowCollection.EndUpdate;
  GridPanel1.ColumnCollection.EndUpdate;
  end


  else if RadioGroup1.ItemIndex in [1..cameras_quantity] then
  begin

  GridPanel2.Parent.Visible := true;
  GridPanel2.Parent.Height := trunc(Panel_cameras.Height*0.25);
  GridPanel1.Align := alClient;
  GridPanel2.Width := Panel_cameras.Width;
  GridPanel1.Parent.Width := Panel_cameras.Width;
  GridPanel1.Width := Panel_cameras.Width;
  GridPanel1.Height := trunc(Panel_cameras.Height*0.75);
  GridPanel2.UseRightToLeftScrollBar;

    GridPanel2.RowCollection.BeginUpdate;
    GridPanel2.ColumnCollection.BeginUpdate;
    for i := 0 to -1 + GridPanel2.ControlCount do
      GridPanel2.Controls[0].Free;

    GridPanel2.RowCollection.Clear;
    GridPanel2.ColumnCollection.Clear;

    for i := 1 to cameras_quantity do
      with GridPanel2.ColumnCollection.Add do
      begin
        SizeStyle := ssAbsolute;
        Value :=
        GridPanel2.Height / 2 * 3;
      end;

  GridPanel2.Width := trunc((cameras_quantity - 1 ) * GridPanel2.Height/2*3);

    for i := 1 to 1 do
      with GridPanel2.RowCollection.Add do
      begin
        SizeStyle := ssPercent;
        Value := 100;
      end;

    for i := 0 to cameras_quantity - 1 do
    begin
      if i <> RadioGroup1.ItemIndex-1 then
      begin
        cameras_array[i].stPanel.Parent := GridPanel2;
        cameras_array[i].stPanel.Align := alClient;
      end;
    end;

    GridPanel2.RowCollection.EndUpdate;
    GridPanel2.ColumnCollection.EndUpdate;


  GridPanel1.RowCollection.BeginUpdate;
  GridPanel1.ColumnCollection.BeginUpdate;

  for i := 0 to -1 + GridPanel1.ControlCount do
    GridPanel1.Controls[0].Free;

  GridPanel1.RowCollection.Clear;
  GridPanel1.ColumnCollection.Clear;

  with GridPanel1.ColumnCollection.Add do
  begin
    SizeStyle := ssPercent;
    Value := 100;
  end;

  with GridPanel1.RowCollection.Add do
  begin
    SizeStyle := ssPercent;
    Value := 100;
  end;

  cameras_array[RadioGroup1.ItemIndex-1].stPanel.Parent := GridPanel1;
  cameras_array[RadioGroup1.ItemIndex-1].stPanel.Align := alClient;

  GridPanel1.RowCollection.EndUpdate;
  GridPanel1.ColumnCollection.EndUpdate;
  end;
end;

procedure TForm6.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex in [0..cameras_quantity] then
    Action1Execute(RadioGroup1);

end;

procedure TForm6.SpeedButton1Click(Sender: TObject);
var
i: integer;
j: integer;
c : integer;
fname : string;
dt: string;
fs: TFormatSettings;

l : integer;
begin
  fs:= TFormatSettings.Create;
  fs.TimeSeparator:= '/';

  c := 0;
    for i := 0 to rows - 1 do
    begin
      for j := 0 to columns - 1 do
      begin
          if c < cameras_quantity then
          begin
          dt := DateTimeToStr(Now);

          for l := 0 to length(dt) do
            begin
            if dt[l] = ':' then dt[l] := '-';
            if dt[l] = '.' then dt[l] := '-';
            if dt[l] = ' ' then dt[l] := '_';
          end;
          fname := './cameras/camera' + IntToStr(c) + '-DateTime-' + dt + '.bmp';
          cameras_array[c].stClientSocket.Close;
          inc(c);
          end
          else
          break
      end;
  end;
end;

procedure TForm6.SpeedButton2Click(Sender: TObject);
var
i: integer;
j: integer;
c : integer;

begin
c := 0;
    for i := 0 to rows - 1 do
    begin
      for j := 0 to columns - 1 do
      begin
          if c < cameras_quantity then
          begin
            cameras_array[c].stClientSocket.Open;
            inc(c);
          end
          else
          break
      end;
  end;
end;

end.
