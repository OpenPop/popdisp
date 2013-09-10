object _ALACN_Disp: T_ALACN_Disp
  Left = 193
  Top = 115
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Populous - Displacement (disp0-?.dat)'
  ClientHeight = 306
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object txtPopRec: TLabel
    Left = 8
    Top = 288
    Width = 195
    Height = 13
    Caption = 'http://www.strategyplanet.com/populous'
  end
  object txtALACN: TLabel
    Left = 344
    Top = 288
    Width = 49
    Height = 13
    Caption = 'by ALACN'
  end
  object pnlimg: TPanel
    Left = 8
    Top = 8
    Width = 273
    Height = 273
    TabOrder = 0
    object img: TImage
      Left = 9
      Top = 9
      Width = 256
      Height = 256
    end
  end
  object pnlCtrl: TPanel
    Left = 281
    Top = 8
    Width = 112
    Height = 273
    TabOrder = 1
    object imgLoad: TImage
      Left = 16
      Top = 184
      Width = 33
      Height = 33
      AutoSize = True
      Visible = False
    end
    object btnLoad: TButton
      Left = 16
      Top = 48
      Width = 75
      Height = 25
      Caption = 'Load'
      TabOrder = 0
      OnClick = btnLoadClick
    end
    object btnSave: TButton
      Left = 16
      Top = 80
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 1
      OnClick = btnSaveClick
    end
    object btnImport: TButton
      Left = 16
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Import'
      TabOrder = 2
      OnClick = btnImportClick
    end
    object btnExport: TButton
      Left = 16
      Top = 144
      Width = 75
      Height = 25
      Caption = 'Export'
      TabOrder = 3
      OnClick = btnExportClick
    end
  end
end
