object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'Form6'
  ClientHeight = 463
  ClientWidth = 757
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl2: TPageControl
    Left = 0
    Top = 0
    Width = 757
    Height = 463
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 0
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 749
        Height = 435
        Align = alClient
        TabOrder = 0
        object Panel2: TPanel
          Left = 1
          Top = 1
          Width = 208
          Height = 433
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          Color = clSilver
          ParentBackground = False
          TabOrder = 0
          object SpeedButton1: TSpeedButton
            Left = -1
            Top = 399
            Width = 174
            Height = 33
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alCustom
            Glyph.Data = {
              B6000000424DB6000000000000003E000000280000001E0000001E0000000100
              01000000000078000000C40E0000C40E0000020000000000000000000000FFFF
              FF00FFC007FCFF0001FCFC00007CF81FF03CF07FFC1CE1FFFE0CC3FFFF0CC381
              0384878103C08F8103C08F8103E00F8103E00F8103E01F8103E01F8103F01F81
              03F01F8103E00F8103E00F8103E08F8103E0878103C0C7810384C3810384E1FF
              FF0CE0FFFC0CF03FF83CF807C03CFE0000FCFF0001FCFFE00FFC}
            Layout = blGlyphTop
            Margin = 0
            Visible = False
            OnClick = SpeedButton1Click
          end
          object SpeedButton2: TSpeedButton
            Left = 14
            Top = 386
            Width = 132
            Height = 33
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alCustom
            Glyph.Data = {
              B2000000424DB2000000000000003E000000280000001E0000001D0000000100
              01000000000074000000C40E0000C40E0000020000000000000000000000FFFF
              FF00FF8003FCFE0000FCF807C07CF03FF83CE0FFFC1CE1FFFF0CC3C7FF8487C1
              FF8487C0FFC08FC03FE00FC00FE00FC003E01FC000E01FC000601FC000201FC0
              00E00FC001E00FC00FE08FC01FE08FC07FC087C1FF84C3C7FF84E1CFFF0CE0FF
              FE1CF03FF81CF80FE03CFC0000FCFF0003FCFFE00FFC}
            Layout = blGlyphTop
            Margin = 0
            Visible = False
            OnClick = SpeedButton2Click
          end
          object Button1: TButton
            Left = 112
            Top = 8
            Width = 75
            Height = 25
            Caption = 'start'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Visible = False
            OnClick = Button1Click
          end
          object RadioGroup1: TRadioGroup
            Left = 8
            Top = 0
            Width = 194
            Height = 182
            Caption = 'Cameras'
            ItemIndex = 0
            Items.Strings = (
              'All')
            TabOrder = 1
            OnClick = RadioGroup1Click
          end
          object Panel_filters: TPanel
            Left = 1
            Top = 188
            Width = 206
            Height = 244
            Align = alBottom
            TabOrder = 2
            object Button2: TButton
              Left = 181
              Top = 4
              Width = 20
              Height = 20
              Align = alCustom
              Anchors = [akTop, akRight]
              Caption = 'X'
              TabOrder = 0
              OnClick = Button2Click
            end
            object ListBox1: TListBox
              Left = 7
              Top = 208
              Width = 156
              Height = 25
              ItemHeight = 13
              TabOrder = 1
              Visible = False
            end
            object ListBox2: TListBox
              Left = 7
              Top = 121
              Width = 194
              Height = 114
              ItemHeight = 13
              TabOrder = 2
            end
            object ScrollBox2: TScrollBox
              Left = 10
              Top = 30
              Width = 194
              Height = 85
              TabOrder = 3
            end
            object CheckBox1: TCheckBox
              Left = 7
              Top = 7
              Width = 97
              Height = 17
              Caption = 'ApplyFilter'
              TabOrder = 4
              OnClick = CheckBox1Click
            end
          end
        end
        object Panel_cameras: TScrollBox
          Left = 209
          Top = 1
          Width = 539
          Height = 433
          Align = alClient
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object GridPanel1: TGridPanel
            Left = 0
            Top = 0
            Width = 539
            Height = 336
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alClient
            Caption = 'GridPanel1'
            Color = clMenuBar
            ColumnCollection = <
              item
                Value = 50.000000000000000000
              end
              item
                Value = 50.000000000000000000
              end>
            ControlCollection = <>
            ParentBackground = False
            PopupMenu = PopupMenu1
            RowCollection = <
              item
                Value = 50.000000000000000000
              end
              item
                Value = 50.000000000000000000
              end>
            TabOrder = 0
          end
          object ScrollBox1: TScrollBox
            Left = 0
            Top = 336
            Width = 539
            Height = 97
            Align = alBottom
            BorderStyle = bsNone
            TabOrder = 1
            Visible = False
            object GridPanel2: TGridPanel
              Left = 0
              Top = 0
              Width = 137
              Height = 97
              Align = alLeft
              Caption = 'GridPanel2'
              ColumnCollection = <
                item
                  Value = 50.000000000000000000
                end
                item
                  Value = 50.000000000000000000
                end>
              ControlCollection = <>
              ExpandStyle = emAddColumns
              RowCollection = <
                item
                  Value = 100.000000000000000000
                end>
              TabOrder = 0
            end
          end
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 704
    object N11: TMenuItem
      Caption = #1060#1080#1083#1100#1090#1088#1099
      OnClick = N11Click
    end
    object PluginsMenu: TMenuItem
      Caption = #1055#1083#1072#1075#1080#1085#1099
      object N1: TMenuItem
        Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100' '#1085#1086#1074#1099#1081
        OnClick = N1Click
      end
    end
  end
  object PopupMenu1: TPopupMenu
    OnChange = PopupMenu1Change
    Left = 333
    Top = 249
    object pause1: TMenuItem
      Caption = 'pause'
      OnClick = pause1Click
    end
    object continue1: TMenuItem
      Caption = 'continue'
      OnClick = continue1Click
    end
    object frame1: TMenuItem
      Caption = 'frame'
      OnClick = frame1Click
    end
  end
  object PythonEngine1: TPythonEngine
    Left = 445
    Top = 209
  end
end
