unit FindWindow2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, CommCtrl, VirtualTrees, JvComponent, JvDockControlForm,
  JvExComCtrls, JvListView, JvDotNetControls, Misc;

type
  TfrmFindWindow2 = class(TForm)
    JvDockClient1: TJvDockClient;
    lvwResult: TJvDotNetListView;
    procedure lvwResultCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvwResultDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddResult(FileName: String; Line: Integer; Snipset: String);
    function GetSubItemRect(const Item: TListItem; const SubItem: integer; Code: TDisplayCode = drBounds): TRect;
  end;

var
  frmFindWindow2: TfrmFindWindow2;

implementation

uses Main;

{$R *.dfm}

procedure TfrmFindWindow2.AddResult(FileName: String; Line: Integer; Snipset: String);
var
  pListitem: TListItem;
begin
  pListitem := lvwResult.Items.Add;
  pListitem.Caption := FileName;
  pListitem.SubItems.Add(IntToStr(Line));
  pListitem.SubItems.Add(Snipset);
end;

function TfrmFindWindow2.GetSubItemRect(const Item: TListItem; const SubItem: integer; Code: TDisplayCode = drBounds): TRect;
var
  ARect: TRect;
const
  Codes: array[TDisplayCode] of Longint = (LVIR_BOUNDS, LVIR_ICON, LVIR_LABEL, LVIR_SELECTBOUNDS);
begin
  // Win32 macro defined in commctrl.pas (Retreive the boundary of a sub item in a given listview)
  ListView_GetSubItemRect(Item.ListView.Handle, Item.Index, SubItem, Codes[Code], @ARect);
  Result := ARect;
end;

procedure TfrmFindWindow2.lvwResultCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  pRect, pOutRect, pPrevOutRect: TRect;
  sSnipset, sOut: String;
  pTemp: array[0..5120] of Char;
  StrPos: Integer;
  IsFirst: Boolean;
begin
  DefaultDraw := True;

  // Only for the third column (code snipset)
  if ((SubItem = 2) and (not Item.Selected)) then
  begin
    IsFirst := True;
    DefaultDraw := False;
    pRect := GetSubItemRect(Item, SubItem);
    lvwResult.Canvas.FillRect(pRect);
    pRect.Left := pRect.Left + 4;
    pRect.Right := pRect.Right - 10;
    StrPCopy(pTemp, Item.SubItems[SubItem - 1]);
    sSnipset := pTemp;
    pOutRect := Rect(0, 0, 0, 0);
    pPrevOutRect := Rect(0, 0, 0, 0);
    DrawText(lvwResult.Canvas.Handle, pTemp, Length(sSnipset), pRect, DT_END_ELLIPSIS or DT_SINGLELINE or DT_VCENTER or DT_LEFT or DT_MODIFYSTRING);
    sSnipset := pTemp;

    // Extract one by one the
    while sSnipset <> '' do
    begin
      StrPos := Pos(frmMain.sSearchInFilesString, sSnipset);
      if StrPos = 0 then
      begin
        // Retreive the rest of the string
        sOut := sSnipset;
        sSnipset := '';

        // Reset font style and color
        lvwResult.Canvas.Font.Style := [];

        // Calculate text dimensions
        SelectObject(lvwResult.Canvas.Handle, lvwResult.Canvas.Font.Handle);
        DrawText(lvwResult.Canvas.Handle, PChar(sOut), Length(sOut), pOutRect, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_CALCRECT);

        // Offset new calculated rect with previous one if required
        if not IsFirst then
        begin
          pOutRect.Right := pOutRect.Right + pPrevOutRect.Right;
          pOutRect.Left := pPrevOutRect.Right;
          pOutRect.Top := pRect.Top;
          pOutRect.Bottom := pRect.Bottom;
        end
        else
        begin
          pOutRect.Right := pOutRect.Right + pRect.Left;
          pOutRect.Left := pOutRect.Left + pRect.Left;
          pOutRect.Top := pRect.Top;
          pOutRect.Bottom := pRect.Bottom;
        end;

        // Output the non bold part of string
        SelectObject(lvwResult.Canvas.Handle, lvwResult.Canvas.Font.Handle);
        DrawText(lvwResult.Canvas.Handle, PChar(sOut), Length(sOut), pOutRect, DT_VCENTER or DT_LEFT or DT_SINGLELINE);
        pPrevOutRect := pOutRect;
        pOutRect := Rect(0, 0, 0, 0);
        IsFirst := False;
      end
      else
      begin
        if StrPos <> 1 then
        begin
          // Retreive non bold part of string
          sOut := Copy(sSnipset, 1, StrPos - 1);
          sSnipset := Copy(sSnipset, StrPos, Length(sSnipset) - StrPos + 1);

          // Reset font style and color
          lvwResult.Canvas.Font.Style := [];

          // Calculate text dimensions
          SelectObject(lvwResult.Canvas.Handle, lvwResult.Canvas.Font.Handle);
          DrawText(lvwResult.Canvas.Handle, PChar(sOut), Length(sOut), pOutRect, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_CALCRECT);

          // Offset new calculated rect with previous one if required
          if not IsFirst then
          begin
            pOutRect.Right := pOutRect.Right + pPrevOutRect.Right;
            pOutRect.Left := pPrevOutRect.Right;
            pOutRect.Top := pRect.Top;
            pOutRect.Bottom := pRect.Bottom;
          end
          else
          begin
            pOutRect.Right := pOutRect.Right + pRect.Left;
            pOutRect.Left := pOutRect.Left + pRect.Left;
            pOutRect.Top := pRect.Top;
            pOutRect.Bottom := pRect.Bottom;
          end;

          // Output the non bold part of string
          SelectObject(lvwResult.Canvas.Handle, lvwResult.Canvas.Font.Handle);
          DrawText(lvwResult.Canvas.Handle, PChar(sOut), Length(sOut), pOutRect, DT_VCENTER or DT_LEFT or DT_SINGLELINE);
          IsFirst := False;
          pPrevOutRect := pOutRect;
          pOutRect := Rect(0, 0, 0, 0);
        end;

        // Retreive bold part of string
        sOut := frmMain.sSearchInFilesString;
        sSnipset := Copy(sSnipset, Length(sOut) + 1, Length(sSnipset) - Length(sOut) + 1);

        // Reset font style and color
        lvwResult.Canvas.Font.Style := [fsBold];

        // Calculate text dimensions
        SelectObject(lvwResult.Canvas.Handle, lvwResult.Canvas.Font.Handle);
        DrawText(lvwResult.Canvas.Handle, PChar(sOut), Length(sOut), pOutRect, DT_VCENTER or DT_LEFT or DT_SINGLELINE or DT_CALCRECT);
        
        // Offset new calculated rect with previous one if required
        if not IsFirst then
        begin
          pOutRect.Right := pOutRect.Right + pPrevOutRect.Right;
          pOutRect.Left := pPrevOutRect.Right;
          pOutRect.Top := pRect.Top;
          pOutRect.Bottom := pRect.Bottom;
        end
        else
        begin
          pOutRect.Right := pOutRect.Right + pRect.Left;
          pOutRect.Left := pOutRect.Left + pRect.Left;
          pOutRect.Top := pRect.Top;
          pOutRect.Bottom := pRect.Bottom;
        end;

        // Output the non bold part of string
        SelectObject(lvwResult.Canvas.Handle, lvwResult.Canvas.Font.Handle);
        DrawText(lvwResult.Canvas.Handle, PChar(sOut), Length(sOut), pOutRect, DT_VCENTER or DT_LEFT or DT_SINGLELINE);
        pPrevOutRect := pOutRect;
        pOutRect := Rect(0, 0, 0, 0);
        IsFirst := False;
      end;
    end;
  end;
end;

procedure TfrmFindWindow2.lvwResultDblClick(Sender: TObject);
begin
  // Bring the file in the editor and go directly to the line where it's defined
  if Assigned(lvwResult.Selected) then
    frmMain.PopUpUnitToScreen(lvwResult.Selected.Caption, StrToInt(lvwResult.Selected.SubItems[0]), False, HIGHLIGHT_STACK);
end;

end.
