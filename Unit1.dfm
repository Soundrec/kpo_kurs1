object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 459
  Width = 579
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSDASQL.1;Persist Security Info=False;User ID=root;Exte' +
      'nded Properties="Driver=MySQL ODBC 8.0 Unicode Driver;SERVER=loc' +
      'alhost;UID=root;DATABASE=kpodb;PORT=3306;CHARSET=utf8mb4;COLUMN_' +
      'SIZE_S32=1";Initial Catalog=kpodb'
    Left = 40
    Top = 16
  end
  object T_cameras: TADOTable
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'cameras'
    Left = 40
    Top = 112
  end
  object DS_T_cameras: TDataSource
    DataSet = T_cameras
    Left = 112
    Top = 112
  end
  object Q_get_cameras: TADOQuery
    Active = True
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM cameras'
      '')
    Left = 40
    Top = 200
  end
  object DS_Q_cameras: TDataSource
    DataSet = Q_cameras
    Left = 112
    Top = 272
  end
  object Q_cameras: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT address FROM cameras'
      '')
    Left = 32
    Top = 272
  end
end
