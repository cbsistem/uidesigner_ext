{ 
This is the extended version of fpGUI uidesigner.
With window list, undo feature, integration into IDE, editor launcher,...
Fred van Stappen
fiens@hotmail.com
}
{
    fpGUI  -  Free Pascal GUI Toolkit

    Copyright (C) 2006 - 2014 See the file AUTHORS.txt, included in this
    distribution, for details of the copyright.

    See the file COPYING.modifiedLGPL, included in this distribution,
    for details about redistributing fpGUI.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Description:
      Essential classes used by the fpGUI Designer
}


unit frm_main_designer;

{$mode objfpc}{$H+}

interface

uses
  RunOnce_PostIt,
  frm_colorwheel,
  frm_imageconvert,
  SysUtils,
  Classes,
  fpg_base,
  fpg_main,
  fpg_widget,
  fpg_form,
  fpg_label,
  fpg_button,
  fpg_edit,
  fpg_listbox,
  fpg_panel,
  fpg_memo,
  fpg_combobox,
  fpg_menu,
  fpg_mru,
  fpg_hyperlink,
  vfd_widgetclass,
  vfd_widgets;

type

  TwgPaletteButton = class(TfpgButton)
  public
    VFDWidget: TVFDWidgetClass;
  end;
  

  TwgPalette = class(TfpgWidget)
  protected
    procedure HandlePaint; override;
  end;
  

  TfrmMainDesigner = class(TfpgForm)
  private
    FFileOpenRecent: TfpgMenuItem;
    FlistUndo: TfpgMenuItem;
    procedure   FormShow(Sender: TObject);
    procedure   PaletteBarResized(Sender: TObject);
    procedure   miHelpAboutClick(Sender: TObject);
    procedure   miHelpAboutGUI(Sender: TObject);
    procedure   micolorwheel(Sender: TObject);
    procedure   miimageconv(Sender: TObject);
    procedure   miMRUClick(Sender: TObject; const FileName: string);
    procedure   BuildThemePreviewMenu;
    procedure   ToggleDesignerGrid(Sender: TObject);

  public
    {@VFD_HEAD_BEGIN: frmMainDesigner}
    MainMenu: TfpgMenuBar;
    btnNewForm: TfpgButton;
    btnOpen: TfpgButton;
    btnSave: TfpgButton;
    btnToFront: TfpgButton;
    wgpalette: TwgPalette;
    chlPalette: TfpgComboBox;
    filemenu: TfpgPopupMenu;
    undomenu: TfpgPopupMenu;
    listundomenu: TfpgPopupMenu;
    formmenu: TfpgPopupMenu;
    setmenu: TfpgPopupMenu;
    miOpenRecentMenu: TfpgPopupMenu;
    helpmenu: TfpgPopupMenu;
    toolsmenu: TfpgPopupMenu;
    windowmenu: TfpgPopupMenu;
    previewmenu: TfpgPopupMenu;
    btnGrid: TfpgButton;
    PanelMove: TfpgPanel;
    {@VFD_HEAD_END: frmMainDesigner}
    mru: TfpgMRU;
    constructor Create(AOwner: TComponent); override;
    procedure   MainCloseQueryEvent(Sender: TObject; var CanClose: boolean);
    function    GetSelectedWidget: TVFDWidgetClass;
    procedure   SetSelectedWidget(wgc: TVFDWidgetClass);
    procedure   AfterCreate; override;
    procedure   BeforeDestruction; override;
    procedure   OnPaletteClick(Sender: TObject);
    property    SelectedWidget: TVFDWidgetClass read GetSelectedWidget write SetSelectedWidget;
    procedure   onhideclick(Sender: TObject);
    procedure   onshowclick(Sender: TObject);
    procedure   Onalwaystofront(Sender: TObject);
    procedure   Onnevertofront(Sender: TObject);
    procedure   OnLoadUndo(Sender: TObject);
    procedure   OnIndexUndo(Sender: TObject);
    procedure   OnIndexRedo(Sender: TObject);
    procedure   OnObjInspect(Sender: TObject);
    procedure   ToFrontClick(Sender: TObject);
    procedure   OnFormDesignShow(Sender: TObject);
    procedure   LoadIDEparameters(ide :integer) ;
    procedure   onMessagePost;
    procedure   OnStyleChange(Sender: TObject);
    procedure   onClickDownPanel(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
    procedure   onClickUpPanel(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
    procedure   onMoveMovePanel(Sender: TObject; AShift: TShiftState; const AMousePos: TPoint);
   end;

  TPropertyList = class(TObject)
  private
    FList: TList;
    function    GetCount: integer;
  public
    Widget: TfpgWidget;
    constructor Create;
    destructor  Destroy; override;
    procedure   Clear;
    property    Count: integer read GetCount;
    procedure   AddItem(aProp: TVFDWidgetProperty);
    function    GetItem(index: integer): TVFDWidgetProperty;
  end;


  TwgPropertyList = class(TfpgListBox)
  protected
    procedure   DrawItem(num: integer; rect: TfpgRect; flags: integer); override;
    procedure   HandleMouseMove(x, y: integer; btnstate: word; shiftstate: TShiftState); override;
    procedure   HandleLMouseDown(x, y: integer; shiftstate: TShiftState); override;
    procedure   HandleLMouseUp(x, y: integer; shiftstate: TShiftState); override;
    procedure   HandleMouseScroll(x, y: integer; shiftstate: TShiftState; delta: smallint); override;
    procedure   HandleSetFocus; override;
    procedure   HandleKillFocus; override;
    procedure   OnRowChange(Sender: TObject);
    procedure   OnScrolling(Sender: TObject);
    procedure   OnUpdateProperty(Sender: TObject);
  public
    Props: TPropertyList;
    NameWidth: integer;
    editor: TVFDPropertyEditor;
    NameDrag: boolean;
    NameDragPos: integer;
    constructor Create(AOwner: TComponent); override;
    procedure   ReleaseEditor;
    procedure   AllocateEditor;
    function    ItemCount: integer; override;
    function    RowHeight: integer; override;
    procedure   RealignEditor;
  end;


  TfrmProperties = class(TfpgForm)
  protected
    procedure HandleKeyPress(var keycode: word; var shiftstate: TShiftState; var consumed: boolean); override;
  public
    l1, l2, l3, l4, l5, l6, l7, l8: TfpgLabel;
    lbClass: TfpgLabel;
    edName: TfpgEdit;
    edOther: TfpgMemo;
    btnTop, btnLeft, btnWidth, btnHeight: TfpgButton;
    btnAnLeft, btnAnTop, btnAnRight, btnAnBottom: TfpgButton;
    lstProps: TwgPropertyList;
    procedure   AfterCreate; override;
    procedure   BeforeDestruction; override;
  end;

  TfrmAbout = class(TfpgForm)
   private
     {@VFD_HEAD_BEGIN: frmAbout}
     lblAppName: TfpgLabel;
     lblVersion: TfpgLabel;
     FImage: TfpgImage;
     btnClose: TfpgButton;
     lblWrittenBy: TfpgLabel;
     lblExtBy: TfpgLabel;
     lblURL: TfpgHyperlink;
     lblCompiled: TfpgLabel;
     {@VFD_HEAD_END: frmAbout}
     procedure   SetupCaptions;
     procedure   FormShow(Sender: TObject);
     procedure FormPaint(Sender: TObject);
   public
     procedure   AfterCreate; override;
     class procedure Execute;

   end;

{@VFD_NEWFORM_DECL}

const
 ext_version : string = '1.4' ;

var
  frmProperties: TfrmProperties;
  frmMainDesigner: TfrmMainDesigner;
  ifonlyone : boolean;
  PropList: TPropertyList;
  oriMousePos: TPoint;
  idetemp, maxundo, indexundo : integer;
  enableundo : boolean;
  numstyle : integer;

implementation

uses
  fpg_iniutils,
  fpg_dialogs,
  fpg_constants,
  fpg_stylemanager,
  vfd_main,
  vfd_constants;

// Anchor images
{$I anchors.inc}

// logo images
{$I fpgui_logo.inc}

{@VFD_NEWFORM_IMPL}

procedure TfrmAbout.SetupCaptions;
begin
  //lblVersion.Text := Format(rsVersion, [cAppVersion]);
  lblVersion.Text := 'Version: ' +  ext_version ;
  lblURL.URL := fpGUIWebsite;
  lblURL.Text := fpGUIWebsite;
  lblCompiled.Text := Format(rsCompiledOn, [{$I %date%} + ' ' + {$I %time%}]);
  btnClose.Text := rsClose;
end;

procedure TfrmAbout.FormShow(Sender: TObject);
begin
  SetupCaptions;
  lblURL.HotTrackColor := clBlue;
  lblURL.TextColor := clRoyalBlue;
end;

procedure TfrmAbout.FormPaint(Sender: TObject);
begin
  Canvas.DrawImage(16, 10, FImage);
end;

procedure TfrmAbout.AfterCreate;
begin
  {%region 'Auto-generated GUI code' -fold}



    OnPaint := @FormPaint;

   {@VFD_BODY_BEGIN: frmAbout}
  Name := 'frmAbout';
  SetPosition(378, 267, 276, 330);
  WindowTitle := 'About Designer_ext';
  Hint := '';
  WindowPosition := wpScreenCenter;
  Sizeable := False;
  BackgroundColor:= clwhite;
  OnShow := @FormShow;

  lblAppName := TfpgLabel.Create(self);
  with lblAppName do
  begin
    Name := 'lblAppName';
    SetPosition(32, 190, 255, 35);
    FontDesc := 'Arial-20';
    Hint := '';
     textcolor := clgreen;
    Text := 'designer_ext';
  end;

  lblVersion := TfpgLabel.Create(self);
  with lblVersion do
  begin
    Name := 'lblVersion';
    SetPosition(62, 220, 195, 24);
    Alignment := taRightJustify;
    FontDesc := '#Label2';
    Hint := '';
     textcolor := clgreen;
    Text := 'Version:  %s';
  end;

  btnClose := TfpgButton.Create(self);
  with btnClose do
  begin
    Name := 'btnClose';
    SetPosition(194, 298, 75, 24);
    Anchors := [anRight,anBottom];
    Text := 'Close';
    FontDesc := '#Label1';
    Hint := '';
    ImageName := 'stdimg.close';
    ModalResult := mrOK;
    TabOrder := 2;
  end;

  lblWrittenBy := TfpgLabel.Create(self);
  with lblWrittenBy do
  begin
    Name := 'lblWrittenBy';
    SetPosition(12, 250, 241, 14);
    FontDesc := 'Arial-9';
    Hint := '';
    Text := 'UIdesigner written by Graeme Geldenhuys';
  end;

  lblURL := TfpgHyperlink.Create(self);
  with lblURL do
  begin
    Name := 'lblURL';
    SetPosition(12, 266, 246, 14);
    FontDesc := 'Arial-9:underline';
    Hint := '';
    HotTrackColor := clBlue;
    HotTrackFont := 'Arial-9:underline';
    Text := 'http://fpgui.sourceforge.net';
    TextColor := clRoyalBlue;
    URL := 'http://fpgui.sourceforge.net';
  end;

  lblCompiled := TfpgLabel.Create(self);
  with lblCompiled do
  begin
    Name := 'lblCompiled';
    SetPosition(12, 287, 180, 13);
    FontDesc := 'Arial-8';
    Hint := '';
    Text := 'Compiled on:  %s';
  end;

  lblExtBy := TfpgLabel.Create(self);
  with lblExtBy do
  begin
    Name := 'lblExtBy';
    SetPosition(22, 302, 150, 14);
    FontDesc := 'Arial-9';
    Hint := '';
    textcolor := clgreen;
    Text := '_ext => Fred van Stappen';
  end;
  {@VFD_BODY_END: frmAbout}
  {%endregion}
 FImage :=  fpgImages.AddBMP(
    'fpgui_logo1', @extimg_fpgui_logo1,
    sizeof(extimg_fpgui_logo1));

   RePaint;

end;

class procedure TfrmAbout.Execute;
var
  frm: TfrmAbout;
begin
  frm := TfrmAbout.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure   TfrmMainDesigner.MainCloseQueryEvent(Sender: TObject; var CanClose: boolean);
  var
  x : integer;
  begin
    if (IsRunningIDE('typhon') = false) and (IsRunningIDE('lazarus') = false)
   then
   begin
     CanClose := true;
     end else
   begin
      CanClose := false;
    if gINI.ReadInteger('Options', 'IDE', 0) > 0
     then begin
   x := 0 ;
   while x < length(ArrayFormDesign)  do
    begin
    ArrayFormDesign[x].Form.close;
     inc(x);
     end;
    frmProperties.close;
     frmMainDesigner.hide;
    end else
    begin
    CanClose := true;
    end;
    end;
    end;

procedure TfrmMainDesigner.LoadIDEparameters(ide :integer) ;
var
f : textfile ;
dataf, dataf2 : string ;
fmbegin, fmend : integer ;
begin
   fpgapplication.ProcessMessages;
////////

  btnOpen.Visible:=false;
  btnSave.Left:= btnOpen.Left ;
  btnSave.UpdateWindowPosition;


 filemenu.MenuItem(0).Visible:=false;
 filemenu.MenuItem(1).Visible:=false;
 filemenu.MenuItem(2).Visible:=false;
 //filemenu.MenuItem(9).Visible:=false;
 //filemenu.MenuItem(8).Visible:=false;

 if ide = 2 then
  begin
{$if defined(cpu64)}
{$IFDEF Windows}
 dataf := copy(GetAppConfigDir(false),1,pos('Local\designer_ext',GetAppConfigDir(false))-1)
           +  'Roaming\typhon64\environmentoptions.xml';
  {$ENDIF}
{$IFDEF unix}
dataf := GetUserDir +'.typhon64/environmentoptions.xml' ;
{$ENDIF}

{$else}
{$IFDEF Windows}
dataf := copy(GetAppConfigDir(false),1,pos('Local\designer_ext',GetAppConfigDir(false))-1)
           +  'Roaming\typhon32\environmentoptions.xml';
  {$ENDIF}
{$IFDEF unix}
dataf := GetUserDir +'.typhon32/environmentoptions.xml' ;
{$ENDIF}
{$endif}

  end;

 if ide = 1 then
    begin
{$IFDEF Windows}
dataf := copy(GetAppConfigDir(false),1,pos('designer_ext',GetAppConfigDir(false))-1)
          +  'lazarus\environmentoptions.xml';
 {$ENDIF}
{$IFDEF unix}
dataf := GetUserDir +'.lazarus/environmentoptions.xml' ;
{$ENDIF}

end;
///////

if fileexists(pchar(dataf)) then
                begin
   AssignFile(f,pchar(dataf));
   Reset(F);
   dataf := '' ;
   dataf2 := '' ;
   fmbegin := 0 ;
   fmend := 0;

     while fmend = 0 do
     begin
       Readln(F, dataf);
       if   Pos('<MainIDE>',dataf) > 0 then fmbegin := 1;
       if   Pos('</MainIDE>',dataf) > 0 then fmend := 1;

       if fmbegin = 1 then dataf2 := dataf2 + dataf;
                ;
                end;

    if ide = 1 then begin

          if   Pos('WindowState Value="Maximized"',dataf2) > 0 then
         begin
        width := fpgApplication.ScreenWidth  - 190 ;
          left := 190 ;
             top := 43 ;
         {$IFDEF Windows}
            top := 41 ;
            width := fpgApplication.ScreenWidth  - 198 ;
            {$ENDIF}
      end else  if   Pos('WindowState Value="Normal"',dataf2) > 0 then
               begin
               if   Pos('Left="',dataf2) > 0 then
                    begin
                       dataf := copy(dataf2,Pos('Left="',dataf2)+6,6) ;
            left := strtoint(copy(dataf,1 ,Pos('"',dataf)-1)) + 190 ;
                        end else left := 190 ;
            {$IFDEF Windows}
            left := left + 8 ;
            {$ENDIF}

           if   Pos('Top="',dataf2) > 0 then
                   begin
                  dataf := copy(dataf2,Pos('Top="',dataf2)+5,6) ;
            top := strtoint(copy(dataf,1 ,Pos('"',dataf)-1)) ;
            end

             {$IFDEF windows}
             else top :=  0 ;
              top := top + 50;
            {$else}
             else top :=  0 ;
             top := top + 52;
            {$ENDIF}

            if   Pos('Width="',dataf2) > 0 then
              begin
                  dataf := copy(dataf2,Pos('Width="',dataf2)+7,6) ;
            width := strtoint(copy(dataf,1 ,Pos('"',dataf)-1)) - 190 ;
             {$IFDEF Windows}
            width := width - 8 ;
            {$ENDIF}
          end else
          begin
          width := fpgApplication.ScreenWidth - 190 ;
            {$IFDEF Windows}
            width := width - 8 ;
            {$ENDIF}
          end;
              end;

         ////

{$IFDEF Windows}
       if  gINI.ReadBool('Options', 'AlwaystoFront', false) = true then
         begin
      left := left - 5 ;
      width := width + 5 ;
        end;
{$else}

       if  gINI.ReadBool('Options', 'AlwaystoFront', false) = true then
                left := left + 1 ;
{$ENDIF}
     end;

    if ide = 2 then begin

    if Pos('WindowState Value="Maximized"',dataf2) > 0 then
         begin
        width := fpgApplication.ScreenWidth ;
          left := 0 ;
          top :=72 ;
           {$IFDEF Windows}
        top := 66
            {$ENDIF}
      end else  if   Pos('WindowState Value="Normal"',dataf2) > 0 then
               begin
               if   Pos('Left="',dataf2) > 0 then
                    begin
                       dataf := copy(dataf2,Pos('Left="',dataf2)+6,6) ;
         left := strtoint(copy(dataf,1 ,Pos('"',dataf)-1))  ;
                end else left :=0 ;

               if   Pos('Top="',dataf2) > 0 then
                   begin
                  dataf := copy(dataf2,Pos('Top="',dataf2)+5,6) ;
         top := strtoint(copy(dataf,1 ,Pos('"',dataf)-1)) + 69 ;
            end  else top :=69 ;

            if   Pos('Width="',dataf2) > 0 then
              begin
                  dataf := copy(dataf2,Pos('Width="',dataf2)+7,6) ;
            width := strtoint(copy(dataf,1 ,Pos('"',dataf)-1)) ;
          end else width := fpgApplication.ScreenWidth ; ;
             ////
   {$IFDEF Windows}

     if  gINI.ReadBool('Options', 'AlwaystoFront', false) = true then
                left := left + 8 ;
{$ENDIF}

{$IFDEF unix}

     if  gINI.ReadBool('Options', 'AlwaystoFront', false) = true then
                left := left + 2 ;
{$ENDIF}
 end;
   end;
      CloseFile(f);
       UpdateWindowPosition;
         end;
 end;

procedure TfrmMainDesigner.onMessagePost;
begin
if theMessage = 'quit' then
 close else
if (FileExists(theMessage)) or (theMessage = 'closeall') then
  begin
  maindsgn.EditedFileName := theMessage;
  maindsgn.OnLoadFile(maindsgn);
   end;
BringToFront;
end;

procedure TfrmMainDesigner.OnLoadUndo(Sender: TObject);
 begin
    if Sender is TfpgMenuItem then begin
 maindsgn.loadundo(TfpgMenuItem(Sender).Tag) ;
      end;
  end;

procedure TfrmMainDesigner.OnIndexUndo(Sender: TObject);
 begin
 frmMainDesigner.undomenu.MenuItem(1).Enabled := true;
if indexundo < length(ArrayUndo) -1  then
begin
inc(indexundo);
maindsgn.loadundo(indexundo) ;

end else  frmMainDesigner.undomenu.MenuItem(0).Enabled := false;

 end;

procedure TfrmMainDesigner.OnIndexRedo(Sender: TObject);
 begin
  frmMainDesigner.undomenu.MenuItem(0).Enabled := true;
if indexundo > 0 then
begin
dec(indexundo);
maindsgn.loadundo(indexundo) ;
end else  frmMainDesigner.undomenu.MenuItem(1).Enabled := false;
 end;


procedure TfrmMainDesigner.AfterCreate;
var
  n, x, y , wscreen: integer;
  wgc: TVFDWidgetClass;
  btn: TwgPaletteButton;
  mi: TfpgMenuItem;

begin
  {%region 'Auto-generated GUI code' -fold}



  maxundo := gINI.ReadInteger('Options', 'MaxUndo', 10);
  enableundo := gINI.ReadBool('Options', 'EnableUndo', True);

  wscreen := fpgApplication.ScreenWidth;
  {@VFD_BODY_BEGIN: frmMainDesigner}
  Name := 'frmMain';
 // SetPosition(96, 118, 800, 92);
  SetPosition(338, 140, 800, 92);
  WindowTitle := 'frmMain';
  Hint := '';
  ShowHint := True;
  WindowPosition := wpUser;
  MinHeight := 82;
  MinWidth := 315;
  OnCloseQuery:= @MainCloseQueryEvent;

  MainMenu := TfpgMenuBar.Create(self);
  with MainMenu do
  begin
    Name := 'MainMenu';
    SetPosition(0, 0, 753, 24);
    Align := alTop;
  end;

  btnNewForm := TfpgButton.Create(self);
  with btnNewForm do
  begin
    Name := 'btnNewForm';
    SetPosition(16, 33, 25, 24);
    Text := '';
    FontDesc := '#Label1';
    Hint := 'Add New Form to Unit';
    ImageMargin := -1;
    ImageName := 'vfd.newform';
    ImageSpacing := 0;
    TabOrder := 1;
    Focusable := False;
    OnClick   := @(maindsgn.OnNewForm);
  end;

  btnOpen := TfpgButton.Create(self);
  with btnOpen do
  begin
    Name := 'btnOpen';
    SetPosition(42, 33, 25, 24);
    Text := '';
    FontDesc := '#Label1';
    Hint := 'Open a file';
    ImageMargin := -1;
    ImageName := 'stdimg.open';
    ImageSpacing := 0;
    TabOrder := 2;
    Focusable := False;
    OnClick   := @(maindsgn.OnLoadFile);
  end;

  btnSave := TfpgButton.Create(self);
  with btnSave do
  begin
    Name := 'btnSave';
    SetPosition(68, 33, 25, 24);
    Text := '';
    FontDesc := '#Label1';
    Hint := 'Save the current form design';
    ImageMargin := -1;
    ImageName := 'stdimg.save';
    ImageSpacing := 0;
    TabOrder := 3;
    Focusable := False;
    Tag := 10;
    OnClick   := @(maindsgn.OnSaveFile);
  end;

  btnGrid := TfpgButton.Create(self);
 with btnGrid do
 begin
 Name := 'btnGrid';
 SetPosition(96, 33, 25, 24);
 Text := '';
 AllowAllUp := True;
 FontDesc := '#Label1';
 GroupIndex := 1;
 Hint := 'Toggle designer grid';
 ImageMargin := -1;
 ImageName := 'vfd.grid';
 ImageSpacing := 0;
 TabOrder := 13;
 Focusable := False;
 AllowDown := True;
 OnClick := @ToggleDesignerGrid;
 end;

  btnToFront := TfpgButton.Create(self);
  with btnToFront do
  begin
    Name := 'btnToFront';
    SetPosition(123, 33, 25, 24);
    Text := '';
    FontDesc := '#Label1';
    Hint := 'Switch Designer Always-To-Front <> Normal';
    ImageMargin := -1;
    ImageName := 'vfd.tofront';
    ImageSpacing := 0;
    TabOrder := 3;
    // ImageName := 'objectedit.bmp';
    Focusable := False;
    Tag := 0;
    OnClick   := @ToFrontClick;
    hide;
  end;

  wgpalette := TwgPalette.Create(self);
  with wgpalette do
  begin
    Name := 'wgpalette';
    SetPosition(152, 28, 600, 62);
    Anchors := [anLeft,anRight,anTop,anBottom];
     Width := self.Width - 150;
    Focusable := False;
    OnResize := @PaletteBarResized;
  end;

  chlPalette := TfpgComboBox.Create(self);
  with chlPalette do
  begin
    Name := 'chlPalette';
    SetPosition(16, 64, 132, 22);
   //     SetPosition(4, 67, 144, 22);
    Anchors := [anLeft,anBottom];
    ExtraHint := '';
    FontDesc := '#List';
    Hint := '';
    Items.Add('-');
    FocusItem := 0;
    TabOrder := 5;
  end;

  filemenu := TfpgPopupMenu.Create(self);
  with filemenu do
  begin
    Name := 'filemenu';
    SetPosition(464, 64, 120, 20);
    AddMenuItem('Create New File...', 'Ctrl+N', @(maindsgn.OnNewFile));
    AddMenuItem('Open...', 'Ctrl+O', @(maindsgn.OnLoadFile));
    FFileOpenRecent := AddMenuItem('Open Recent...', '', nil);
    AddMenuItem('-', '', nil);
    mi := AddMenuItem('Save', 'Ctrl+S', @(maindsgn.OnSaveFile));
    mi.Tag := 10;
    AddMenuItem('Save As New Template Unit...', 'Ctrl+Shift+S', @(maindsgn.OnSaveFile));
    AddMenuItem('-', '', nil);
    AddMenuItem('Add New Form to Unit...', '', @(maindsgn.OnNewForm));
    AddMenuItem('-', '', nil);
    AddMenuItem('Exit', 'Ctrl+Q', @(maindsgn.OnExit));
  end;

  formmenu := TfpgPopupMenu.Create(self);
  with formmenu do
  begin
    Name := 'formmenu';
    SetPosition(464, 48, 120, 20);
    AddMenuItem('Widget Order...', '', @(maindsgn.OnEditWidgetOrder));
    AddMenuItem('Tab Order...', '', @(maindsgn.OnEditTabOrder));
    AddMenuItem('-', '', nil);
    AddMenuItem('Edit special...', '', nil).Enabled := False; // TODO
   end;

  miOpenRecentMenu := TfpgPopupMenu.Create(self);
  with miOpenRecentMenu do
  begin
    Name := 'miOpenRecentMenu';
    SetPosition(336, 68, 128, 20);
  end;

    setmenu := TfpgPopupMenu.Create(self);
  with setmenu do
  begin
    Name := 'setmenu';
     SetPosition(464, 48, 120, 20);
      AddMenuItem('General Settings', '', @(maindsgn.OnOptionsClick));
     end;

   undomenu := TfpgPopupMenu.Create(self);
  with undomenu do
  begin
    Name := 'undomenu';
     SetPosition(464, 48, 120, 20);

    AddMenuItem('Undo', 'Ctrl+Z',@OnIndexUndo);
    AddMenuItem('ReDo', 'Ctrl+Maj+Z',@OnIndexRedo);
    AddMenuItem('-', '', nil);
    FlistUndo := AddMenuItem('Undo List...', '',nil);

  MenuItem(0).Enabled:=false;
  MenuItem(1).Enabled:=false;
  MenuItem(3).Enabled:=false;
  end;

   toolsmenu := TfpgPopupMenu.Create(self);
  with toolsmenu do
  begin
    Name := 'toolsmenu';
    SetPosition(328, 52, 120, 20);
    AddMenuItem('Color Wheel', '', @micolorwheel);
    AddMenuItem('Image Convertor', '', @miimageconv);
   end;

  helpmenu := TfpgPopupMenu.Create(self);
  with helpmenu do
  begin
    Name := 'helpmenu';
    SetPosition(448, 52, 120, 20);
    AddMenuItem('About fpGUI Toolkit...', '', @miHelpAboutGUI);
    AddMenuItem('About Designer_ext...', '', @miHelpAboutClick);
   end;



  listundomenu := TfpgPopupMenu.Create(self);
  x := 0;
   with listundomenu do
  begin
    Name := 'listundomenu';
    SetPosition(328, 52, 120, 20);

    while x < 100 do
    begin
     AddMenuItem('', '',@OnLoadUndo);
     MenuItem(x).Visible:=false;
     MenuItem(x).Tag:=x;
    inc(x);
    end;

  end;

  windowmenu := TfpgPopupMenu.Create(self);
  with windowmenu do
  begin
    Name := 'windowmenu';
    SetPosition(328, 52, 120, 20);
    AddMenuItem('Object Inspector', '', @OnObjInspect);
    AddMenuItem('-', '', nil) ;
    MenuItem(1).Visible:=false;
    AddMenuItem('', '',@frmMainDesigner.OnFormDesignShow);
    MenuItem(2).Visible:=false;
    AddMenuItem('', '',@frmMainDesigner.OnFormDesignShow);
    MenuItem(3).Visible:=false;
    AddMenuItem('', '',@frmMainDesigner.OnFormDesignShow);
    MenuItem(4).Visible:=false;
    AddMenuItem('', '',@frmMainDesigner.OnFormDesignShow);
    MenuItem(5).Visible:=false;
    AddMenuItem('', '',@frmMainDesigner.OnFormDesignShow);
    MenuItem(6).Visible:=false;
    AddMenuItem('', '',@frmMainDesigner.OnFormDesignShow);
    MenuItem(7).Visible:=false;
    AddMenuItem('', '',@frmMainDesigner.OnFormDesignShow);
    MenuItem(8).Visible:=false;
    AddMenuItem('', '',@frmMainDesigner.OnFormDesignShow);
    MenuItem(9).Visible:=false;
    AddMenuItem('', '',@frmMainDesigner.OnFormDesignShow);
    MenuItem(10).Visible:=false;
    AddMenuItem('', '',@frmMainDesigner.OnFormDesignShow);
    MenuItem(11).Visible:=false;
    MenuItem(2).Tag:=0;
    MenuItem(3).Tag:=1;
    MenuItem(4).Tag:=2;
    MenuItem(5).Tag:=3;
    MenuItem(6).Tag:=4;
    MenuItem(7).Tag:=5;
    MenuItem(8).Tag:=6;
    MenuItem(9).Tag:=7;
    MenuItem(10).Tag:=8;
    MenuItem(11).Tag:=9;
  end;

  previewmenu := TfpgPopupMenu.Create(self);
  with previewmenu do
  begin
    Name := 'previewmenu';
    SetPosition(324, 36, 120, 20);
  end;

  PanelMove := TfpgPanel.Create(self);
  with PanelMove do
  begin
    Name := 'PanelMove';
    SetPosition(0, 0, 13, 92);
    Align := alLeft;
    FontDesc := '#Label1';
    Hint := 'Hold click to move palette...';
    Style := bsFlat;
    Text := '';
    tag := 0 ;
    BackgroundColor:=clmoneygreen;
    OnMouseMove:= @onMovemovepanel ;
    OnMouseDown := @onClickDownPanel ;
    OnMouseUp := @onClickUpPanel ;
   end;

  {@VFD_BODY_END: frmMainDesigner}
  {%endregion}

  { Build component palette }

  x := 0;
  y := 0;
 
  for n := 0 to VFDWidgetCount-1 do
  begin
    wgc           := VFDWidget(n);
    btn           := TwgPaletteButton.Create(wgpalette);
    btn.VFDWidget := wgc;
    btn.SetPosition(x, y, 30, 28);
    btn.ImageName := wgc.WidgetIconName;
    btn.ImageMargin := -1;
    btn.Text      := '';
    btn.Hint      := wgc.WidgetClass.ClassName;
    btn.Focusable := False;
    btn.OnClick   := @OnPaletteClick;
    btn.AllowDown := True;
    btn.AllowAllUp := True;
    chlPalette.Items.AddObject(wgc.WidgetClass.ClassName, wgc);

    Inc(x, 32);
    if (x+30) >= wgpalette.Width  then
    begin
      x := 0;
      Inc(y, 30);
    end;
  end;


 BuildThemePreviewMenu;

  chlPalette.Items.Sort;
 
  MainMenu.AddMenuItem('&File', nil).SubMenu     := filemenu;
    MainMenu.AddMenuItem('&Undo', nil).SubMenu     := undomenu;
  MainMenu.AddMenuItem('Selected Fo&rm', nil).SubMenu     := formmenu;
  MainMenu.AddMenuItem('&Settings', nil).SubMenu := setmenu;
   MainMenu.AddMenuItem('&Preview', nil).SubMenu  := previewmenu;
   MainMenu.AddMenuItem('&Window', nil).SubMenu  := windowmenu;
   MainMenu.AddMenuItem('&Tools', nil).SubMenu     := toolsmenu;
   MainMenu.AddMenuItem('&Help', nil).SubMenu     := helpmenu;
  MainMenu.AddMenuItem('', nil) ;

    if enableundo = true then MainMenu.MenuItem(1).Visible:= true else
    MainMenu.MenuItem(1).Visible:= false ;

  FFileOpenRecent.SubMenu := miOpenRecentMenu;
  FlistUndo.SubMenu := listundomenu;

  mru := TfpgMRU.Create(self);
  mru.ParentMenuItem  := miOpenRecentMenu;
  mru.OnClick         := @miMRUClick;
  mru.MaxItems        := gINI.ReadInteger('Options', 'MRUFileCount', 4);
  mru.ShowFullPath    := gINI.ReadBool('Options', 'ShowFullPath', True);
  mru.LoadMRU;

        if  gINI.ReadBool('Options', 'AlwaysToFront', false) = FALSE then
      begin
     windowType := wtwindow ;
     MainMenu.MenuItem(8).Visible:=false;
    // btnToFront.Text:= 'toF' ;
   btnToFront.tag:=0;
      end
      else
       begin
     MainMenu.MenuItem(8).Visible:=true;
    MainMenu.MenuItem(8).Text:= WindowTitle;
    //btnToFront.Text:='toN';
   btnToFront.tag:=1;
     windowType := wtpopup ;
       end;

    x := gINI.ReadInteger('Options', 'IDE', 0);
   idetemp := x ;
if x = 0 then
begin

  btnOpen.Visible:=true;
  btnSave.Left:= 69 ;
  btnSave.UpdateWindowPosition;

 filemenu.MenuItem(0).Visible:=true;
 filemenu.MenuItem(1).Visible:=true;
 filemenu.MenuItem(8).Visible:=true;

indexundo := 0 ;

   if  gINI.ReadBool('frmMainState', 'FirstLoad', true) = false  then
          gINI.ReadFormState(self)
         else
         gINI.WriteBool('frmMainState', 'FirstLoad', false);
  end else  LoadIDEparameters(x) ;

 if ifonlyone = true then
 begin
  InitMessage ;
  StartMessage(@onMessagePost, 1000);
 end;
 PaletteBarResized(self);
end;

procedure TfrmMainDesigner.ToggleDesignerGrid(Sender: TObject);
begin
 maindsgn.ShowGrid := btnGrid.Down;
end;

procedure TfrmMainDesigner.FormShow(Sender: TObject);
begin
gINI.ReadFormState(self);
UpdateWindowPosition;
end;

constructor TfrmMainDesigner.Create(AOwner: TComponent);
begin
inherited Create(AOwner);
fpgImages.AddMaskedBMP( 'vfd.grid', @vfd_grid,
sizeof(vfd_grid), 0, 0);

fpgImages.AddMaskedBMP('vfd.tofront', @vfd_tofront,
sizeof(vfd_tofront), 0, 0);



OnShow := @FormShow;
end;

procedure TfrmMainDesigner.BeforeDestruction;
begin
  gINI.WriteFormState(self);
  gINI.WriteInteger('Options', 'IDE', idetemp);

  inherited BeforeDestruction;
end;

procedure TfrmMainDesigner.OnPaletteClick(Sender: TObject);
var
  s: string;
  i: integer;
begin
  i := -1;
  if TwgPaletteButton(Sender).Down then
  begin
    s := TwgPaletteButton(Sender).VFDWidget.WidgetClass.ClassName;
    i := chlPalette.Items.IndexOf(s);
  end;
  if i = -1 then
    i := 0; // select the '-' item
  chlPalette.FocusItem := i;
end;

procedure TfrmMainDesigner.onClickDownPanel(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
 begin
 oriMousePos := AMousePos;
 PanelMove.Tag:=1;
  end;

procedure TfrmMainDesigner.onClickUpPanel(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
 begin
  PanelMove.Tag:=0;
  end;

procedure TfrmMainDesigner.onMoveMovePanel(Sender: TObject; AShift: TShiftState; const AMousePos: TPoint) ;
 begin
  if PanelMove.Tag = 1 then
  begin
  fpgapplication.ProcessMessages;
  top := top + ( AMousePos.Y- oriMousePos.y);
  left := left + (AMousePos.x-oriMousePos.X );
  UpdateWindowPosition;
  end;
 end;

procedure  TfrmMainDesigner.ToFrontClick(Sender: TObject);
 begin
   if  btnToFront.Tag = 0 then Onalwaystofront(sender)
   else OnNevertofront(sender) ;
 end;

procedure TfrmMainDesigner.OnAlwaysToFront(Sender: TObject);
begin
   hide;
    fpgapplication.ProcessMessages;
    WindowType := wtpopup ;
    MainMenu.MenuItem(7).Visible:=true;
   MainMenu.MenuItem(7).Text:=  'Current file : ' + p + s + '     fpGUI Designer_ext v' +  ext_version;    ;
   // btnToFront.Text:='toN';
   btnToFront.tag:=1;
 if idetemp = 1 then
  begin
    {$IFDEF Windows}
      // left := left - 5 ;
     width := width + 8 ;
       {$ENDIF}
    {$IFDEF unix}
      left := left + 1 ;
    {$ENDIF}
   end;

  if  idetemp = 2 then
  begin
    {$IFDEF unix}
      left := left + 2 ;
    {$ENDIF}
    {$IFDEF windows}
   left := left + 8 ;
     {$ENDIF}
     end;

UpdateWindowPosition;
       show;
    frmProperties.hide;
   fpgapplication.ProcessMessages;
   frmProperties.Show;
   end;

procedure TfrmMainDesigner.OnNeverToFront(Sender: TObject);
begin
   hide;
     fpgapplication.ProcessMessages;
      MainMenu.MenuItem(7).Text:= '';
      MainMenu.MenuItem(7).Visible:=false;
     //   btnToFront.Text:='toF';
   btnToFront.tag:=0;
  WindowType := wtwindow ;  // with borders, not on front.
  WindowAttributes := [];

     if idetemp = 1 then
  begin
   {$IFDEF Windows}
     //  left := left + 5 ;
     width := width - 8 ;
      {$ENDIF}
 {$IFDEF unix}
      left := left - 1 ;
  {$ENDIF}
   end;

  if  idetemp = 2 then
  begin
   {$IFDEF unix}
      left := left - 2 ;
    {$ENDIF}
   {$IFDEF windows}
   left := left - 8 ;
     {$ENDIF}
     end;
   UpdateWindowPosition;

   show;
   frmProperties.hide;
   fpgapplication.ProcessMessages;
   frmProperties.Show;
  end;

procedure TfrmMainDesigner.OnHideClick(Sender: TObject);

begin
   hide;

 WindowAttributes := [waBorderless];
 MainMenu.MenuItem(7).Text:= 'Current file : ' + p + s + '     Designer_ext'  ;

 show;

end;

procedure TfrmMainDesigner.OnShowClick(Sender: TObject);

begin
    hide;
  MainMenu.MenuItem(7).Text:= '';
  WindowAttributes := [];
   Show;

end;

procedure TfrmMainDesigner.OnObjInspect(Sender: TObject);
begin
   frmProperties.hide;
   fpgapplication.ProcessMessages;
   frmProperties.Show;
 end;

procedure TfrmMainDesigner.OnFormDesignShow(Sender: TObject);
begin
  if Sender is TfpgMenuItem then begin
  ArrayFormDesign[TfpgMenuItem(Sender).Tag].Form.Hide;
 ArrayFormDesign[TfpgMenuItem(Sender).Tag].Form.show;
  end;
end;


{ TfrmProperties }

procedure TfrmProperties.AfterCreate;
var
  x, x2, w, y, gap: integer;
begin
  {%region 'Auto-generated GUI code' -fold}

  inherited;
  Name := 'frmProperties';
  WindowTitle := 'Properties';
  SetPosition(100, 240, 250, 450);
 // WindowPosition := wpUser;

    if  gINI.ReadBool('frmPropertiesState', 'FirstLoad', true) = false  then
  begin
                    gINI.ReadFormState(self) ;
                    UpdateWindowPosition;
                      end else
    gINI.WriteBool('frmPropertiesState', 'FirstLoad', false);


    fpgImages.AddMaskedBMP(
    'vfd.anchorleft', @vfd_anchorleft,
    sizeof(vfd_anchorleft), 0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.anchorright', @vfd_anchorright,
    sizeof(vfd_anchorright), 0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.anchortop', @vfd_anchortop,
    sizeof(vfd_anchortop), 0, 0);

  fpgImages.AddMaskedBMP(
    'vfd.anchorbottom', @vfd_anchorbottom,
    sizeof(vfd_anchorbottom), 0, 0);

  x     := 3;
  x2    := x + 50;
  gap   := 20;
  w     := Width - x2;
  y     := 3;

  l1      := CreateLabel(self, 0, y, 'Class:');
  lbClass := CreateLabel(self, x2, y, 'CLASS');
  lbClass.Width := w;
  lbClass.FontDesc := '#Label2';
  lbClass.Anchors := [anLeft, anRight, anTop];
  Inc(y, gap);

  l2           := CreateLabel(self, 0, y + 1, 'Name:');
  edName       := CreateEdit(self, x2, y, w, 0);
  edName.Text  := 'NAME';
  edName.Anchors := [anLeft, anRight, anTop];
  edName.OnChange := @(maindsgn.OnPropNameChange);

  Inc(y, gap + 5);

  lstProps         := TwgPropertyList.Create(self);
  lstProps.SetPosition(0, y, Width, self.Height - y - 220);
  lstProps.Anchors := AllAnchors;
  lstProps.Props   := PropList;
  lstProps.Props.Widget := edName;

  y := lstProps.Bottom + 5;

  //inc(y, gap+5);

  l3         := CreateLabel(self, 3, y + 1, 'Left:');
  l3.Anchors := [anLeft, anBottom];
  btnLeft    := CreateButton(self, 50, y - 2, 48, '1234', @(maindsgn.OnPropPosEdit));
  with btnLeft do
  begin
    Height        := 22;
    Anchors       := [anLeft, anBottom];
    Focusable     := False;
  end;
  l4 := CreateLabel(self, 110, y, 'Top:');
  l4.Anchors := [anLeft, anBottom];
  btnTop     := CreateButton(self, 160, y - 2, 48, '45', @(maindsgn.OnPropPosEdit));
  with btnTop do
  begin
    Height        := 22;
    Anchors       := [anLeft, anBottom];
    Focusable     := False;
  end;
  Inc(y, gap + 5);
  l5         := CreateLabel(self, 3, y + 1, 'Width:');
  l5.Anchors := [anLeft, anBottom];
  btnWidth   := CreateButton(self, 50, y - 2, 48, '1234', @(maindsgn.OnPropPosEdit));
  with btnWidth do
  begin
    Height        := 22;
    Anchors       := [anLeft, anBottom];
    Focusable     := False;
  end;
  l6 := CreateLabel(self, 110, y, 'Height:');
  l6.Anchors := [anLeft, anBottom];
  btnHeight  := CreateButton(self, 160, y - 2, 48, '45', @(maindsgn.OnPropPosEdit));
  with btnHeight do
  begin
    Height        := 22;
    Anchors       := [anLeft, anBottom];
    Focusable     := False;
  end;
  Inc(y, gap + 5);

  l8         := CreateLabel(self, 3, y + 1, 'Anchors:');
  l8.Anchors := [anLeft, anBottom];

  x := 64;

  btnAnLeft := CreateButton(self, x, y - 2, 28, '', nil);
  with btnAnLeft do
  begin
    ImageName  := 'vfd.anchorleft';
    ShowImage  := True;
    AllowAllUp := True;
    GroupIndex := 1;
    Focusable  := False;
    Anchors    := [anLeft, anBottom];
    OnClick    := @(maindsgn.OnAnchorChange);
  end;

  Inc(x, 30);
  btnAnTop := CreateButton(self, x, y - 2, 26, '', nil);
  with btnAnTop do
  begin
    ImageName  := 'vfd.anchortop';
    ShowImage  := True;
    AllowAllUp := True;
    GroupIndex := 2;
    Focusable  := False;
    Anchors    := [anLeft, anBottom];
    OnClick    := @(maindsgn.OnAnchorChange);
  end;

  Inc(x, 30);
  btnAnBottom := CreateButton(self, x, y - 2, 26, '', nil);
  with btnAnBottom do
  begin
    ImageName  := 'vfd.anchorbottom';
    ShowImage  := True;
    AllowAllUp := True;
    GroupIndex := 3;
    Focusable  := False;
    Anchors    := [anLeft, anBottom];
    OnClick    := @(maindsgn.OnAnchorChange);
  end;

  Inc(x, 30);
  btnAnRight := CreateButton(self, x, y - 2, 26, '', nil);
  with btnAnRight do
  begin
    ImageName  := 'vfd.anchorright';
    ShowImage  := True;
    AllowAllUp := True;
    GroupIndex := 4;
    Focusable  := False;
    Anchors    := [anLeft, anBottom];
    OnClick    := @(maindsgn.OnAnchorChange);
  end;

  y := btnAnRight.Bottom + 5;

  l7         := CreateLabel(self, 0, y, 'Unknown lines:');
  l7.Anchors := [anLeft, anBottom];
  Inc(y, 16);

  edOther          := TfpgMemo.Create(self);
  edOther.SetPosition(0, y, self.Width, self.Height - y);
  edOther.Anchors  := [anLeft, anRight, anBottom];
  edOther.FontDesc := '#Edit2';
  edOther.OnChange := @(maindsgn.OnOtherChange);
  {%endregion}


end;

procedure TfrmProperties.BeforeDestruction;
begin
  gINI.WriteFormState(self);
  inherited BeforeDestruction;
end;

procedure TfrmProperties.HandleKeyPress(var keycode: word; var shiftstate: TShiftState; var consumed: boolean);
begin
  if keycode = keyF11 then
  begin
    if maindsgn.selectedform <> nil then
    begin
      maindsgn.selectedform.Form.SetFocus;
      maindsgn.selectedform.Form.ActivateWindow;
    end;
    consumed := True;
  end;
  inherited;
end;

{ TPropertyList }

procedure TPropertyList.AddItem(aProp: TVFDWidgetProperty);
begin
  FList.Add(aProp);
end;

procedure TPropertyList.Clear;
begin
  FList.Clear;
  Widget := nil;
end;

constructor TPropertyList.Create;
begin
  FList  := TList.Create;
  Widget := nil;
end;

destructor TPropertyList.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TPropertyList.GetCount: integer;
begin
  Result := FList.Count;
end;

function TPropertyList.GetItem(index: integer): TVFDWidgetProperty;
begin
  if (index < 0) or (index > Count-1) then
    Result := nil
  else
    Result := TVFDWidgetProperty(FList[index]);
end;

{ TwgPropertyList }

constructor TwgPropertyList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  NameWidth       := 80;
  editor          := nil;
  OnChange        := @OnRowChange;
  OnScroll        := @OnScrolling;
  BackgroundColor := clWindowBackground;
  NameDrag        := False;
  //FontName := 'arial-10:antialias=false';
end;

procedure TwgPropertyList.OnRowChange(Sender: TObject);
begin
  AllocateEditor;
end;

procedure TwgPropertyList.OnScrolling(Sender: TObject);
begin
  AllocateEditor;
end;

procedure TwgPropertyList.DrawItem(num: integer; rect: TfpgRect; flags: integer);
var
  x,
  y,
  fy: integer;
  s: string;
  prop: TVFDWidgetProperty;
  r: TfpgRect;
begin
  prop := Props.GetItem(num);
  if prop = nil then
    Exit; //==>

  x  := rect.left;
  y  := rect.top;
  fy := y + rect.Height div 2 - FFont.Height div 2;

  s := prop.Name;
  Canvas.DrawString(x + 1, fy, s);

  Inc(x, NameWidth);
  Canvas.SetColor(clShadow1);
  Canvas.DrawLine(x, rect.top, x, rect.bottom);
  Inc(x);
  // Drawing the contents
  r.SetRect(x, y, rect.right - x, rect.Height);
  Canvas.SetColor(BackgroundColor);
  Canvas.FillRectangle(r);
  Canvas.SetTextColor(clText1);
  Inc(r.left, 2);
  Dec(r.Width, 2);
  prop.DrawValue(props.Widget, Canvas, r, flags);

  Canvas.SetColor(clShadow1);
  Canvas.DrawLine(0, rect.bottom, rect.right, rect.bottom);
end;

function TwgPropertyList.ItemCount: integer;
begin
  Result := Props.Count;
end;

function TwgPropertyList.RowHeight: integer;
begin
  Result := 23;
end;

procedure TwgPropertyList.OnUpdateProperty(Sender: TObject);
begin
  editor.StoreValue(props.Widget);
end;

procedure TwgPropertyList.HandleMouseMove(x, y: integer; btnstate: word; shiftstate: TShiftState);
begin
  if not NameDrag then
  begin
    if (x >= FMargin + NameWidth - 2) and (x <= FMargin + NameWidth + 2) then
      MouseCursor := mcSizeEW
    else
      MouseCursor := mcDefault;
  end
  else
  begin
    NameWidth := x - FMargin;
    ReAlignEditor;
    RePaint;
  end;
  inherited;
end;

procedure TwgPropertyList.HandleLMouseDown(x, y: integer; shiftstate: TShiftState);
begin
  if MouseCursor = mcSizeEW then
    NameDrag := True
    //NameDragPos := x;
  else
    inherited;
end;

procedure TwgPropertyList.HandleLMouseUp(x, y: integer; shiftstate: TShiftState);
begin
  if NameDrag then
    NameDrag := False
  else
    inherited;
  if (Editor <> nil) and (Editor.Visible) then
    Editor.SetFocus;
end;

procedure TwgPropertyList.HandleMouseScroll(x, y: integer;
  shiftstate: TShiftState; delta: smallint);
begin
  inherited HandleMouseScroll(x, y, shiftstate, delta);
  AllocateEditor;
end;

procedure TwgPropertyList.HandleSetFocus;
begin
  inherited HandleSetFocus;
  if Editor <> nil then
    Editor.Visible := True
  else
    AllocateEditor;
end;

procedure TwgPropertyList.HandleKillFocus;
begin
  inherited HandleKillFocus;
  if Editor <> nil then
    Editor.Visible := True;
end;

procedure TwgPropertyList.RealignEditor;
var
  x: integer;
begin
  if editor = nil then
    Exit;
  x := 3 + NameWidth;
  editor.SetPosition(x, editor.Top, Width - ScrollBarWidth - x, editor.Height);
end;

procedure TfrmMainDesigner.PaletteBarResized(Sender: TObject);
var
  btn: TwgPaletteButton;
  x, y, n: integer;
begin
  x := 0;
  y := 0;
  wgpalette.Width := width - 160;
  for n := 0 to wgPalette.ComponentCount-1 do
  begin
    btn := wgPalette.Components[n] as TwgPaletteButton;
    btn.SetPosition(x, y, 30, 28);
    btn.ImageMargin   := -1;
    btn.ImageSpacing  := 0;
    Inc(x, 32);
    if (x+30) >= wgpalette.Width then
    begin
      x := 0;
      Inc(y, 30);
    end;
  end;
 end;

procedure TfrmMainDesigner.OnStyleChange(Sender: TObject);
var
  x : integer;
begin
  if Sender is TfpgMenuItem then begin
   if fpgstyleManager.setstyle(TfpgMenuItem(Sender).Text) then
   begin

 for x := 0 to numstyle-1 do
 previewmenu.MenuItem(x).Checked:=false;

TfpgMenuItem(Sender).Checked:= true;
     fpgstyle := fpgstyleManager.Style;

     hide;
     show;

     for x := 2 to 11 do
     if windowmenu.MenuItem(x).Visible = true then
  begin
  ArrayFormDesign[x-2].Form.hide ;
  ArrayFormDesign[x-2].Form.Show ;
  end;

   frmProperties.hide;
   fpgapplication.ProcessMessages;
   frmProperties.Show;
     end;
 end;

end;

procedure TfrmMainDesigner.BuildThemePreviewMenu;
var
  sl: TStringList;
  i : integer;
begin
  sl := TStringList.Create;
  fpgStyleManager.AssignStyleTypes(sl);
  sl.Sort;
  numstyle := sl.Count-1 ;
  for i := 0 to sl.Count-1 do
  begin
    if sl[i] = 'auto' then
      continue;
    previewmenu.AddMenuItem(sl[i], '', @OnStyleChange).Enabled := true;

  end;

   for i := 0 to numstyle-1 do
   if previewmenu.MenuItem(i).Text = 'Flat-Hoover silver' then
 previewmenu.MenuItem(i).Checked:=true;

  sl.Free;

end;

procedure TfrmMainDesigner.miHelpAboutClick(Sender: TObject);
begin
  TfrmAbout.Execute;
end;

procedure TfrmMainDesigner.miHelpAboutGUI(Sender: TObject);
begin
TfpgMessageDialog.AboutFPGui;
end;

procedure TfrmMainDesigner.micolorwheel(Sender: TObject);
var
  frm: TWheelColorForm;
begin
  frm := TWheelColorForm.Create(nil);
  frm.Show;
end;

procedure TfrmMainDesigner.miimageconv(Sender: TObject);
var
  frm: TImageConvert;
begin
  frm := TImageConvert.Create(nil);
  frm.Show;
end;


procedure TfrmMainDesigner.miMRUClick(Sender: TObject; const FileName: string);
begin
  maindsgn.EditedFileName := FileName;
  maindsgn.OnLoadFile(maindsgn);
end;


function TfrmMainDesigner.GetSelectedWidget: TVFDWidgetClass;
begin
  if chlPalette.FocusItem > 0 then
    Result := TVFDWidgetClass(chlPalette.Items.Objects[chlPalette.FocusItem])
  else
    Result := nil;
end;

procedure TfrmMainDesigner.SetSelectedWidget(wgc: TVFDWidgetClass);
var
  n: integer;
begin
  if wgc = nil then
  begin
    chlPalette.FocusItem := 0;
    for n := 0 to wgpalette.ComponentCount - 1 do
      if wgpalette.Components[n] is TwgPaletteButton then
        TwgPaletteButton(wgpalette.Components[n]).Down := False;
  end;
end;

procedure TwgPropertyList.ReleaseEditor;
begin
  self.ActiveWidget := nil;
  if editor <> nil then
    editor.Free;
  editor := nil;
end;

procedure TwgPropertyList.AllocateEditor;
var
  x, y: integer;
  prop: TVFDWidgetProperty;
begin
  prop := Props.GetItem(FFocusItem);
  if prop = nil then
    Exit;

  self.ActiveWidget := nil;
  if editor <> nil then
    editor.Free;

  editor := prop.CreateEditor(Self);
  x      := 3 + NameWidth;
  y      := FMargin + ((FFocusItem - FFirstItem) * RowHeight);
  editor.SetPosition(x, y, Width - FMargin - ScrollBarWidth - x, RowHeight-1); // last -1 is so cell border lines are still visible
  editor.CreateLayout;
  editor.OnUpdate := @OnUpdateProperty;
  editor.LoadValue(Props.Widget);
  editor.Visible := True;

  self.ActiveWidget := editor;
end;

{ TwgPalette }

procedure TwgPalette.HandlePaint;
begin
  Canvas.Clear(clWindowBackground);

end;


end.
