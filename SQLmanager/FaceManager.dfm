�
 TFORM1 0�  TPF0TForm1Form1Left� Top� BorderIconsbiSystemMenu
biMinimize BorderStylebsSingleCaptionSQL Vostok managerClientHeight�ClientWidth�Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrder	PositionpoScreenCenterPixelsPerInch`
TextHeight TPageControlPageControl1LeftLTop Width\Height�
ActivePage	TabSheet1AlignalRightTabOrder  	TTabSheet	TabSheet1Caption���� SQL TMemoMemo1Left Top WidthTHeightAlignalTop
ScrollBars
ssVerticalTabOrder   TRadioGroupRadioGroup1Left TopWidthTHeight(AlignalTopCaption��� ������� :Columns	ItemIndex Items.StringsSQLDML TabOrder  TButtonButton4Left�Top� Width� HeightCaption��������� ������TabOrderOnClickButton4Click  TDBGridDBGrid1Left Top� WidthTHeight� AlignalClient
DataSourceDataSource1TabOrderTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style    	TTabSheet	TabSheet2Caption
Stored SQL TLabelLabel2Left�Top� WidthEHeightCaption	��� SQL :Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel3LeftTop� WidthUHeightCaption����� SQL :Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TPanelPanel1Left Top WidthTHeight� AlignalTop
BevelOuter	bvLoweredTabOrder  TDBNavigatorDBNavigator1LeftTopxWidthRHeight
DataSourceDataSource2VisibleButtonsnbFirstnbPriornbNextnbLastnbInsertnbDeletenbPostnbCancel AlignalBottomHints.Strings������
����������	���������	��������������������������������	������������������������� ParentShowHintShowHint	TabOrder   TButtonButton1LeftTopWidthKHeightCaption�������TabOrderOnClickButton1Click  TButtonButton2LeftTopWidthKHeightCaption�������TabOrderOnClickButton2Click  TButtonButton3Left� TopXWidth� HeightCaption��������� ���������TabOrderOnClickButton3Click  TDBLookupComboBoxDBLookupComboBox1Left� Top Width� HeightKeyFieldKOD_SQL	ListFieldKOD_SQL
ListSourceDataSource2TabOrder   TDBMemoDBMemo1Left Top� WidthTHeight� AlignalBottom	DataFieldSQL_TXT
DataSourceDataSource2
ScrollBars
ssVerticalTabOrder  TDBEditDBEdit1Left�Top� WidthSHeight	DataFieldKOD_SQL
DataSourceDataSource2TabOrder  TDBMemoDBMemo2Left Top\WidthTHeight3AlignalBottom	DataFieldKOMENT
DataSourceDataSource2
ScrollBars
ssVerticalTabOrder  TPanelPanel2Left TopBWidthTHeightAlignalBottom
BevelOuterbvNoneTabOrder TLabelLabel1LeftTopWidthcHeightCaption���������� :Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont    	TTabSheet	TabSheet3CaptionSp_oper TDBGridDBGrid2Left Top WidthTHeight#TabStopAlignalTop
DataSourceDataSource3OptionsdgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgAlwaysShowSelectiondgConfirmDeletedgCancelOnExit TabOrder TitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style 
OnDblClickDBGrid2DblClick  TDBNavigatorDBNavigator2LeftToplWidth� Height
DataSourceDataSource3TabOrder  TDBEditDBEdit2LeftLTop&Width� Height	DataFieldNAME_OP
DataSourceDataSource3TabOrder
OnKeyPressDBEdit2KeyPress  TDBEditDBEdit3LeftTop&WidthAHeight	DataFieldPRAVO
DataSourceDataSource3TabOrder
OnKeyPressDBEdit3KeyPress  TDBEditDBEdit4LeftJTop&WidthAHeight	DataFieldNOM_SQL
DataSourceDataSource3TabOrder
OnKeyPressDBEdit4KeyPress  TDBEditDBEdit5LeftTop&Width3HeightTabStop	DataFieldTIP_OP
DataSourceDataSource3TabOrder    	TDatabase	Database1	AliasNameVostok	Connected	DatabaseNameGostinParams.StringsUSER NAME=srv_vostok SessionName
Session1_1LeftTop  TSessionSession1Active	AutoSessionName	Left,Top  TQueryQuery1DatabaseNameGostinSessionName
Session1_1LeftTop2  TDataSourceDataSource1DataSetQuery1Left,Top2  TDataSourceDataSource2DataSetClientDataSet1LeftTop\  TClientDataSetClientDataSet1
Aggregates IndexFieldNameskod_sqlParams ProviderName	Provider1AfterInsertClientDataSet1AfterInsert	AfterEditClientDataSet1AfterEditLeft(Top\  	TProvider	Provider1DataSetQuery1LeftTop�   TTableTable1Active	AfterInsertTable1AfterInsert	AfterEditTable1AfterEditDatabaseNameGostinSessionName
Session1_1	TableNameSP_OPERLeftTop�   TDataSourceDataSource3AutoEditDataSetTable1Left$Top�   TQueryQuery2DatabaseNameGostinSessionName
Session1_1SQL.StringsSelect Max(tip_op) from sp_operwhere
tip_op<200 LeftTop�    