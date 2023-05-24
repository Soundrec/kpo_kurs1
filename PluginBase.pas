unit PluginBase;

interface

uses
  Windows, Classes, Graphics, SysUtils, Controls, ComCtrls, Forms, StdCtrls,
  dialogs, menus, Generics.Collections;

type
  TByteArray = array of Byte;
  TIMG_info_plugin = function(): PAnsiChar; cdecl;
  TIMG_dscf_plugin = function(Fname: PAnsiChar): PAnsiChar; cdecl;
  TIMG_proc_plugin = function(Inmas, Outmas: pointer; width: integer;
    height: integer; cfg: pointer): double; cdecl;

  TPluginFDetails = class
    PluginFileName: Ansistring;
    PluginFunctionName: Ansistring;
    PluginName: Ansistring;
    PluginFDescription: Ansistring;
    PluginType: Ansistring;
    PluginCFG: Ansistring;
  end;

  TPlugin = class(TObject)
  private
    // параметры для проверки построителем интерфейса
    fPFParamCNT: integer;
    fPrewPluginFunctionName: Ansistring;
    // Параметры для вещественных значений в трекбарах
    Offcets: TDictionary<string, integer>;
    Divizors: TDictionary<string, integer>;
    /// Перечень функций из плагинов
    FPluginsList: TDictionary<string, TPluginFDetails>;
//    FPluginsList { 'plugin1' : TPluginDetails( 'c://',  )  }
//                FPluginsList['plugin1'] = TPL///


    /// Создание интерфейса
    procedure CreateSettingsField(cfg: Ansistring);
    /// Очистка интерфейса
    procedure ClearSettingsField;
    /// Сбор параметров с интерфейса
    function ParseSettings(): Ansistring;
  public
    // Поле для построение интерфейса (можно переделать на пенель и т.п. это не имеет значение
    SettingsField: TScrollBox;
    // Перечень функций для обработки картинок
    FaListBox: TListBox;
    // Место где будут добавлятся элементы меню
    PluginsMenu: TMenuItem;
    // Время выполнения обработки изображения ms.
    Time:double;
    Constructor Create;
    /// Загрузка функций плагинов
    procedure LoadPluginFunction(Filename: string);
    /// Построитель интерфей
    procedure CreatePluginFunctionSettings(fPluginName: Ansistring);
    // для перерисовки трекбара
    procedure TracbarPos(Sender: TObject);
    // для применения плагина обработки картинки
    procedure ApplyPluginIMG2IMG(fPluginName: Ansistring;
      inbitmap, outbitmap: Tbitmap);
    // для применения плагина тестового собщения
    procedure ApplyPluginMSGBox(fPluginName: Ansistring);
    // Для вызова функций типа  MSGBox
    procedure MSGBoxClick(Sender: TObject);
  end;

  /// / Вспомогательные функции (объявление)
procedure ListPluginFileDir(Path, mask: string; FileList: TStrings);
function VerifyPluginFile(Filename: string): boolean;

implementation

/// / Вспомогательные функции


//uses Unit6;
function VerifyPluginFile(Filename: string): boolean;
var
  thLib: THandle;
  res: boolean;
begin
  res := false;
  thLib := 0;
  if thLib = 0 then
    thLib := SafeLoadLibrary(Filename);
  if thLib <> 0 then
  begin
    if GetProcAddress(thLib, PChar('PluginFunctions')) <> nil then
      res := true;
  end;
  if thLib <> 0 then
    FreeLibrary(thLib);
  thLib := 0;
  VerifyPluginFile := res;
end;

procedure ListPluginFileDir(Path, mask: string; FileList: TStrings);
var
  SR: TSearchRec;
begin
  if FindFirst(Path + mask, faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr <> faDirectory) then
      begin
      try
        if VerifyPluginFile(Path + SR.Name) then
          FileList.Add(SR.Name);
      except

      end;
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

/// Методы класса плагинов

constructor TPlugin.Create;
begin
  // Execute the parent (TObject) constructor first
  inherited; // Call the parent Create method
  Offcets := TDictionary<String, integer>.Create;
  Divizors := TDictionary<String, integer>.Create;
  FPluginsList := TDictionary<String, TPluginFDetails>.Create;
end;

// Загрузка всех функций
procedure TPlugin.LoadPluginFunction(Filename: string);
var
  thLib: THandle;
  GetFunctions: TIMG_info_plugin;
  GFPN: TIMG_dscf_plugin;
  FunctionList: TStringList;
  func, pfd: Ansistring;
  fFunctionsCount, i: integer;
  PFItem: TPluginFDetails;
  // Для интеграции меню
  elm: TMenuItem;
  e: TMethod;
begin
  thLib := 0;

  if thLib = 0 then
    thLib := SafeLoadLibrary(Filename);
  if thLib <> 0 then
  begin
    GetFunctions := GetProcAddress(thLib, PChar('PluginFunctions'));
    if @GetFunctions <> nil then
    begin
      func := GetFunctions();
      FunctionList := TStringList.Create;
      FunctionList.Delimiter := ' ';
      FunctionList.DelimitedText := func;
    end;
    fFunctionsCount := FunctionList.Count;
    for i := 0 to fFunctionsCount - 1 do
    begin
      PFItem := TPluginFDetails.Create;
      PFItem.PluginFileName := Filename;
      PFItem.PluginFunctionName := FunctionList.Strings[i];
      GFPN := GetProcAddress(thLib, PChar('PluginLabName'));
      PFItem.PluginName := GFPN(PAnsiChar(PFItem.PluginFunctionName));
      GFPN := GetProcAddress(thLib, PChar('GetPluginType'));
      PFItem.PluginType := GFPN(PAnsiChar(PFItem.PluginFunctionName));
      GFPN := GetProcAddress(thLib, PChar('PluginCFG'));
      PFItem.PluginCFG := GFPN(PAnsiChar(PFItem.PluginFunctionName));
      GFPN := GetProcAddress(thLib, PChar('PluginDescriptions'));
      PFItem.PluginFDescription := GFPN(PAnsiChar(PFItem.PluginFunctionName));

      try
      FPluginsList.Add(PFItem.PluginName, PFItem);
      if PFItem.PluginType = 'IMG2IMG' then
        FaListBox.Items.Add(PFItem.PluginName);

      if PFItem.PluginType = 'MSGBox' then
      begin
        elm := TMenuItem.Create(PluginsMenu);
        elm.Name := PFItem.PluginFunctionName;
        elm.Caption := PFItem.PluginName;
        elm.OnClick := MSGBoxClick;
        PluginsMenu.Add(elm);
      end;
      except
        showmessage('dup');
      end;
    end;
  end;
  if thLib <> 0 then
    FreeLibrary(thLib);
  thLib := 0;

end;

procedure TPlugin.CreatePluginFunctionSettings(fPluginName: Ansistring);
var
  PFItem: TPluginFDetails;
begin
  if (SettingsField <> nil) then
    if (FPluginsList.TryGetValue(fPluginName, PFItem) = true) then
    begin
      if fPrewPluginFunctionName <> PFItem.PluginFunctionName then
        if Length(PFItem.PluginCFG) > 10 then
          CreateSettingsField(PFItem.PluginCFG);
      fPrewPluginFunctionName := PFItem.PluginFunctionName;
    end;
end;

procedure TPlugin.ApplyPluginIMG2IMG(fPluginName: Ansistring;
  inbitmap, outbitmap: Tbitmap);
var
  thLib: THandle;
  TMPBitmap: Tbitmap;
  setting: Ansistring;
  PPointer1, PPointer2: pointer;
  PluginF: TIMG_proc_plugin;
  PFItem: TPluginFDetails;
begin
  if (FPluginsList.TryGetValue(fPluginName, PFItem) = true) then
  begin
//  showmessage('true');
    setting := ParseSettings();
    thLib := 0;
    TMPBitmap := Tbitmap.Create;
    inbitmap.PixelFormat := pf32bit;
    TMPBitmap.Assign(inbitmap);
    PPointer1 := inbitmap.ScanLine[inbitmap.height - 1];
    PPointer2 := TMPBitmap.ScanLine[inbitmap.height - 1];
    if thLib = 0 then
      thLib := SafeLoadLibrary(PFItem.PluginFileName);
    if thLib <> 0 then
    begin
      try
//        showmessage('plugin');
        PluginF := GetProcAddress(thLib, PAnsiChar(PFItem.PluginFunctionName));
        time:=PluginF(PPointer1, PPointer2, inbitmap.width, inbitmap.height,
          @setting[1]);
        Application.ProcessMessages();
//        showmessage('plugin');
      finally
        outbitmap.Assign(TMPBitmap);


//        showmessage('assign');






        FreeAndNil(TMPBitmap);
        FreeLibrary(thLib)
      end;
    end;
  end;
end;

procedure TPlugin.TracbarPos(Sender: TObject);
Var
  comp: TComponent;
  cnam: string;
  offset: integer;
  divisor: integer;
begin
  with Sender as TTrackbar do
  begin
    cnam := 'LB' + Name;
    comp := SettingsField.FindComponent(cnam);
    if comp <> nil then
    begin
      offset := Offcets[Name];
      divisor := Divizors[Name];
      TLabel(comp).Caption := floattostr(Position / divisor - offset);
    end;
  end;
end;

procedure TPlugin.ClearSettingsField;
var
  i: integer;
  Item: TControl;
begin
  for i := (SettingsField.ControlCount - 1) downto 0 do
  begin
    Item := SettingsField.Controls[i];
    Item.Free;
  end;
end;

procedure TPlugin.CreateSettingsField(cfg: Ansistring);
var
  List1: TStringList;
  List2: TStringList;
  LB: TLabel;
  ED: TEdit;
  TB: TTrackbar;
  CB: TCheckBox;
  str: string;
  i: integer;
BEGIN
  ClearSettingsField();
  List1 := TStringList.Create();
  List2 := TStringList.Create();
  str := cfg;
  List1.StrictDelimiter := true;
  List1.Delimiter := '!';
  List2.StrictDelimiter := true;
  List2.Delimiter := ';';
  List1.DelimitedText := str;
  if Offcets <> Nil then
    Offcets.Clear;
  if Divizors <> Nil then
    Divizors.Clear;
  // создание на основе схемы из DLL
  for i := 0 to List1.Count - 1 do
  begin
    List2.DelimitedText := List1.Strings[i];
    if List2.Count > 4 then
    begin
      if List2.Strings[0] = 'Label' then
      begin
        // Создание Label'ов
        LB := TLabel.Create(SettingsField);
        LB.Name := List2.Strings[1];
        LB.Parent := SettingsField;
        LB.Left := strtoint(List2.Strings[2]);
        LB.Top := strtoint(List2.Strings[3]);
        LB.Caption := List2.Strings[4];
      end;
      if List2.Strings[0] = 'Edit' then
      begin
        // Создание Edit'ов
        ED := TEdit.Create(SettingsField);
        ED.Name := List2.Strings[1];
        ED.Parent := SettingsField;
        ED.Left := strtoint(List2.Strings[2]);
        ED.Top := strtoint(List2.Strings[3]);
        ED.width := strtoint(List2.Strings[4]);
        ED.Text := List2.Strings[5];
      end;
      if List2.Strings[0] = 'TrackBar' then
      begin
        // Создание TrackBar'ов
        TB := TTrackbar.Create(SettingsField);
        TB.Name := List2.Strings[1];
        TB.Parent := SettingsField;
        TB.Left := strtoint(List2.Strings[2]);
        TB.Top := strtoint(List2.Strings[3]);
        TB.width := strtoint(List2.Strings[4]);
        TB.min := strtoint(List2.Strings[5]);
        TB.Max := strtoint(List2.Strings[6]);
        TB.Position := strtoint(List2.Strings[7]);
        TB.ThumbLength := 15;
        TB.TickMarks := tmBoth;
        Offcets.Add(TB.Name, strtoint(List2.Strings[8]));
        Divizors.Add(TB.Name, strtoint(List2.Strings[9]));
        TB.OnChange := TracbarPos;
      end;
      if List2.Strings[0] = 'CheckBox' then
      begin
        // Создание CheckBox'ов
        CB := TCheckBox.Create(SettingsField);
        CB.Name := List2.Strings[1];
        CB.Parent := SettingsField;
        CB.Left := strtoint(List2.Strings[2]);
        CB.Top := strtoint(List2.Strings[3]);
        CB.width := strtoint(List2.Strings[4]);
        CB.Checked := StrToBool(List2.Strings[5]);
        CB.Caption := List2.Strings[6];
      end;
    end
    else
      fPFParamCNT := strtoint(List2.Strings[0]);
  end;

END;

procedure TPlugin.MSGBoxClick(Sender: TObject);
var
  fn: Ansistring;
  punkt: TMenuItem;
begin
  punkt := (Sender as TMenuItem);
  fn := punkt.Caption;
  ApplyPluginMSGBox(fn);
end;

procedure TPlugin.ApplyPluginMSGBox(fPluginName: Ansistring);
var
  i: integer;
  thLib: THandle;
  PluginF: TIMG_info_plugin;
  msg: Ansistring;
  PFItem: TPluginFDetails;
begin
  if (FPluginsList.TryGetValue(fPluginName, PFItem) = true) then
  begin
    thLib := 0;
    begin
      if thLib = 0 then
        thLib := SafeLoadLibrary(PFItem.PluginFileName);
      if thLib <> 0 then
      begin
        PluginF := GetProcAddress(thLib, PAnsiChar(PFItem.PluginFunctionName));
        msg := PluginF();
        showmessage(msg);
      end;
      if thLib <> 0 then
        FreeLibrary(thLib);
      thLib := 0;
    end;
  end;
end;

function TPlugin.ParseSettings(): Ansistring;
var
  i: integer;
  res: Ansistring;
  comp: TComponent;
Begin
  res := '';
  for i := 1 to fPFParamCNT do
  begin
    comp := SettingsField.FindComponent('INPUT_' + inttostr(i));
    if comp <> nil then
//    showmessage('not nil');
    begin
      if (i > 1) then
        res := res + ' ';

      if (comp is TEdit) then
        res := res + TEdit(comp).Text;
      if (comp is TCheckBox) then
        res := res + booltostr(TCheckBox(comp).Checked);
      if (comp is TTrackbar) then
        res := res + floattostr(TTrackbar(comp).Position / Divizors[comp.Name]
            - Offcets[comp.Name]);

    end;
  end;
  for i := 1 to Length(res) - 1 do
    if res[i] = ',' then
      res[i] := '.';

  ParseSettings := res;
End;

end.
