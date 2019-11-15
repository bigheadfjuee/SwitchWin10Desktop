object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'SwitchDesktop'
  ClientHeight = 184
  ClientWidth = 566
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 232
    Top = 8
    Width = 278
    Height = 129
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 209
    Height = 129
    Caption = 'Switch'
    TabOrder = 1
    object Button1: TButton
      Tag = 1
      Left = 3
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Default'
      TabOrder = 0
      OnClick = ButtonClick
    end
    object Button2: TButton
      Tag = 2
      Left = 104
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Desktop:2'
      TabOrder = 1
      OnClick = ButtonClick
    end
    object Button3: TButton
      Tag = 3
      Left = 104
      Top = 55
      Width = 75
      Height = 25
      Caption = 'Desktop:3'
      TabOrder = 2
      OnClick = ButtonClick
    end
    object Button4: TButton
      Tag = 4
      Left = 104
      Top = 86
      Width = 75
      Height = 25
      Caption = 'Desktop:4'
      TabOrder = 3
      OnClick = ButtonClick
    end
  end
  object btnEnum: TButton
    Left = 232
    Top = 151
    Width = 75
    Height = 25
    Caption = 'Enum'
    TabOrder = 2
    OnClick = btnEnumClick
  end
end
