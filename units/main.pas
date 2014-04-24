  {#####################################################################################
  #                                                                                    #
  #                                                                                    #
  #             Projektarbeit - Laden und Entladen von Kondensatoren                   #
  #                                                                                    #
  #                       Andreas Anklam & Philip Märksch                              #
  #                                                                                    #
  #                                                                                    #
  #                             BS-Technik Rostock                                     #
  #                                    2014                                            #
  #                                                                                    #
  ######################################################################################


  Der Code enthält aus didaktischen Gründen viele Kommentare, die ein "echter Programmierer"
  eventuell überflüssig finden könnte.
}

{
  Capacitux is free software created in the hope of being useful. You are free to distribute,
  and change the software, as long as you name the Developers! This applies to both, the
  software package as a whole and parts of the software.
}


unit main;

{$mode objfpc}{$H+}

interface

uses
  { Standard-Komponenten/Libraries}
  Classes, SysUtils, FileUtil, Forms,
  Controls, Graphics, Dialogs, Menus, StdCtrls, ComCtrls,
  Buttons, LCLIntf, IntfGraphics, ActnList, ExtCtrls, Grids,
  CheckLst, EditBtn, types, simpleipc, Translations, LCLType,
  { Eigene Units }
  Capacitor, funcs, info, history;


{ TForm1 }
type

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    CheckListBox1: TCheckListBox;
    ColorButton1: TColorButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    saveImageDialog: TSaveDialog;
    StringGrid2: TStringGrid;
    TabSheet1: TTabSheet;

    infowindow: TForm2;
    historyWindow: TForm3;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;

    procedure AddCapacitor(Sender: TObject);
    procedure AbortButtonClick(Sender: TObject);
    procedure AddFromFile(Sender: TObject);
    procedure selectCapacitor(Sender: TObject);
    procedure selectionChanged(Sender: TObject);
    procedure zoomInAtY(Sender: TObject);
    procedure zoomOutAtY(Sender: TObject);
    procedure zoomInAtX(Sender: TObject);
    procedure zoomOutAtX(Sender: TObject);
    procedure openManual(Sender: TObject);
    procedure resetMaxValues(Sender: TObject);
    procedure Calculate(Sender: TObject);
    procedure setZoomArea(Sender: TObject);
    procedure ExportGraph(Sender: TObject);
    procedure CheckCapacitor(Sender: TObject);
    procedure DeleteCapacitor(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure loadFromFile(Sender: TObject; clearPrevious: boolean = True);
    procedure switchThickLines(Sender: TObject);
    procedure saveToFile(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem21Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure takeScreenshot(Sender: TObject);
    procedure selectAllCapacitors(Sender: TObject);
    procedure showVersionHistory(Sender: TObject);
    procedure switchVisibilityClick(Sender: TObject; AIndex: Integer);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuOpenProjectSource(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure MenuAddCapacitorClick(Sender: TObject);
    procedure MenuDeleteCapacitorClick(Sender: TObject);
    procedure DeleteAllCapacitors(Sender: TObject);
    procedure MenuOpenDocumentation(Sender: TObject);
    procedure MenuOpenWebLink(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure setParameters(Sender: TObject);
    procedure unselectAllCapacitors(Sender: TObject);

    // Alle Eingabefelder löschen/freigeben/sperren
    procedure ClearAllFields;
    procedure EnableAllFields;
    procedure DisableAllFields;


  private
    FProgrammName: string;              // Programm- / Projektname
    FVersionNr: string;                 // Programmversion
    FVersionDate: string;               // Versionsdatum
    FOSName: string;
    FCapacitorList: TCapacitorList;     // Kondensatorenliste
    FOffset: integer;                   // Rand, Abstand des Diagramms zur PageControl
    FGridSize: integer;
    // Abstand in Pixeln zwischen den Grid-Linien des Diagramms

    FMaxValue: double;                  // Maximalwerte der beiden Achsen
    FMaxTime: double;

  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}


{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Versionen A.B.C.D
  // A - Haupt-Version  0 = Entwicklungsphase 1 = Release-fähig
  // B - Änderungen an Unterfunktionalitäten
  // C - z.b. Detail-Verbesserungen, Layout
  // D - einzelne Änderungen/Bugfixes/Code-Säuberung etc...


  // Compiler-Anweisungen: damit kann man z.b. Code situationsabhängig
  // ins Programm einbinden. Hier wird das OS ermittelt, mit dem kompiliert wird
  // Wird zur Kompilier-Zeit ausgewertet, nicht zur Laufzeit!
  FOSName := 'unbekannt';
  {$ifdef mswindows}
  FOSName := 'Windows';
  {$endif}
  {$ifdef linux}
  FOSName := 'Linux';      // Diese Zeile würde im Windowsprogramm nicht mehr vorkommen
  {$endif}

  // Programm-Variablen
  FProgrammName := 'Capacitux';
  FVersionNr := '1.1.6.0';
  FVersionDate := '08.04.2014';
  FOffset := 30;
  FGridSize := 40;
  Caption := FProgrammName + ' ' + FVersionNr;
  FCapacitorList := TCapacitorList.Create;
  infowindow := TForm2.Create(nil);
  infowindow.label1.Caption := FProgrammName;
  infowindow.label3.Caption := 'Version: ' + FVersionNr + ' (' + FOSName + ')';
  infowindow.label4.Caption := 'vom: ' + FVersionDate;
  historyWindow := TForm3.Create(nil);

  // Alle Eingabefelder anfangs löschen und sperren
  ClearAllFields;
  DisableAllFields;
  Edit6.Text := '1';

  FMaxTime := 0;
  FMaxValue := 0;

  PaintBox1.Width := TabSheet1.Width;
  PaintBox1.Height := TabSheet1.Height;

  MenuItem10.Caption := 'Über "' + FProgrammName + '"';

  // Fensterdialoge übersetzen
  try
    if (FOSName = 'Windows') then
      TranslateUnitResourceStrings('LCLStrConsts',
        'C:\lazarus\lcl\languages\lclstrconsts.de.po');  // MS-Win

    if (FOSName = 'Linux') then
      TranslateUnitResourceStrings('LCLStrConsts',
        '/usr/share/lazarus/1.0.14/lcl/languages/lclstrconsts.de.po'); // UNIX
  except
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  infowindow.Free;
  historywindow.Free;
  FCapacitorList.Free;
end;

procedure TForm1.loadFromFile(Sender: TObject; clearPrevious: boolean = True);
var
  I: integer;
  locLines: TStringList;
  locCount: integer;
  locName, locV, locR, locC, LocColor: string;
  locDialog: TOpenDialog;
  C: Integer;
begin
  locLines := TStringList.Create;
  locDialog := TOpenDialog.Create(nil);
    locDialog.InitialDir := extractFilepath(application.ExeName) + '/saves';

  try
    if locDialog.Execute then
    begin
      locLines.LoadFromFile(locDialog.FileName);

      if (locLines.Count > 0) then
      begin
        if (locLines[0] <> 'capacitux file') then
        begin
          application.MessageBox(PChar('Datei ' + locDialog.FileName +
            ' konnte nicht geladen werden, da es sich um keine gültige Capacitux-Datei handelt!'),
            'Fehler', 0);
          exit;
        end
        else
        begin

          if clearPrevious then
          begin
            FCapacitorList.Clear;
            ClearAllFields;
          end;
          DisableAllFields;
          locCount := StrToInt(locLines[1]);
          C := FCapacitorList.Count;

          for I := 0 to locCount - 1 do
          begin
            locName := locLines[2 + (I * 5)];
            locC := locLines[3 + (I * 5)];
            locR := locLines[4 + (I * 5)];
            locV := locLines[5 + (I * 5)];
            locColor := locLines[6 + (I * 5)];

            FCapacitorList.Add(TCapacitor.Create(locName));

            // Je nach eingestellter Sprache kann ein Float ein Komma oder
            // einen Punkt als Delimiter enthalten. Einen Fehler beim Laden
            // kann man also z.b. wie folgt verhindern. Weitere Formatierungen
            // werden nicht unterstützt!
            try
              try
                FCapacitorList.Items[C+I].Capacity :=
                  StrToFloat(StringReplace(locC, ',', '.', [rfReplaceAll]));
              except
                on e:Exception do
                begin
                  FCapacitorList.Items[C+I].Capacity :=
                    StrToFloat(StringReplace(locC, '.', ',', [rfReplaceAll]));
                end;
              end;
              try
                FCapacitorList.Items[C+I].Resistance :=
                  StrToFloat(StringReplace(locR, ',', '.', [rfReplaceAll]));
              except
                on e:Exception do
                begin
                  FCapacitorList.Items[C+I].Resistance :=
                    StrToFloat(StringReplace(locR, '.', ',', [rfReplaceAll]));
                end;
              end;
              try
                FCapacitorList.Items[C+I].Voltage :=
                  StrToFloat(StringReplace(locV, ',', '.', [rfReplaceAll]));
              except
              on e:Exception do
                begin
                  FCapacitorList.Items[C+I].Voltage :=
                    StrToFloat(StringReplace(locV, '.', ',', [rfReplaceAll]));
                end;
              end;

              FCapacitorList.Items[C+I].Color := StrToInt(locColor);
            except
              application.MessageBox(PChar('Fehler beim Laden eines Kommawertes in Datei "' +
                locDialog.FileName + '"!'), 'Lese-Fehler', 0);
              FCapacitorList.Delete(FCapacitorList.Count-1);
            end;
          end; { for I := 0 to locCount ... }
        end;  { else if loclines[0] <> .... }
      end;  { if locLinesCount.... }
    end;  { if Dialog.Excute ... }
  finally { try ...}
    locDialog.Free;
    locLines.Free;
    calculate(nil);
  end;

end;

procedure TForm1.saveToFile(Sender: TObject);
var
  I: integer;
  locLines: TStringList;
begin
  if (FCapacitorList.Count > 0) then
  begin
    try
      locLines := TStringList.Create;

      saveDialog1.FileName := 'Kondensatorliste';
      saveDialog1.InitialDir := extractFilepath(application.ExeName) + '/saves';
      saveDialog1.DefaultExt := 'sav';

      if saveDialog1.Execute then
      begin
        locLines.Add('capacitux file');
        locLines.Add(IntToStr(FCapacitorList.Count));

        for I := 0 to FCapacitorList.Count - 1 do
        begin
          locLines.Add(FCapacitorList.Items[I].Name);
          locLines.Add(FloatToStr(FCapacitorList.Items[I].Capacity));
          locLines.Add(FloatToStr(FCapacitorList.Items[I].Resistance));
          locLines.Add(FloatToStr(FCapacitorList.Items[I].Voltage));
          locLines.Add(IntToStr(FCapacitorList.Items[I].Color));
        end;
        locLines.SaveToFile(saveDialog1.FileName);
      end;

    finally
      locLines.Free;
    end;
  end
  else
  begin
    application.MessageBox('Eine leere Liste kann nicht gespeichert werden!',
      'Hinweis', 0);
  end;

end;


procedure TForm1.selectCapacitor(Sender: TObject);
var
  Index: integer;
  locTxt: string;
begin
  if (CheckListBox1.ItemIndex >= 0) then
  begin
    Index := CheckListBox1.ItemIndex;
    EnableAllFields;
    Edit1.Text := FCapacitorList.Items[Index].Name;
    ColorButton1.ButtonColor := FCapacitorList.Items[Index].Color;

    Edit2.Text := FloatToStr(FCapacitorList.Items[Index].Capacity);
    Edit3.Text := FloatToStr(FCapacitorList.Items[Index].Resistance);
    Edit4.Text := FloatToStr(FCapacitorList.Items[Index].Voltage);

    {      klappt nicht, da das "µ" irgendwie nicht richtig codiert wird
    locTxt := ConvertToPrefixedString(FCapacitorList.Items[Index].Capacity, 'F');       // Einheiten-Präfixe der Combobox anpassen
    Edit2.Text := trim(LeftStr( locTxt, length(locTxt) - 2 ));
    ComboBox2.ItemIndex := getIndexOfPrefix( LeftStr( RightStr(locTxt,2), 1 ));

    }
  end
  else
  begin
    Edit1.Text := '';
    DisableAllFields;
  end;

end;

procedure TForm1.AddCapacitor(Sender: TObject);
var
  I: integer;
begin
  try
    if (StrToInt(Edit6.Text) > 0) then
    begin
      for I := 0 to StrToInt(Edit6.Text) - 1 do
      begin
        FCapacitorList.add(TCapacitor.Create());
        if (FCapacitorList.Count = 11) then       // Warnung ausgeben
        begin
          application.MessageBox(
            'Bei zu vielen Kondensatoren kann das Programm sehr langsam und instabil werden. Daher werden mehr als 10 nicht empfohlen! Zudem vermindern viele Kurven die Ablesbarkeit des Diagramms.',
            'Warnung', 0);
        end;
        DisableAllFields;
      end;
      updateListbox(CheckListBox1, FCapacitorList);
      updateStringGrid(StringGrid2, FCapacitorList);
    end;
  except
  end;
  Edit6.Text := '1';
  Calculate(nil);
  PaintBox1Paint(nil);
end;

procedure TForm1.Calculate(Sender: TObject);
var
  I: integer;
begin

  FMaxTime := 0;
  FMaxValue := 0;
  // Werte der Kondensatoren werden berechnet. Die Maximalwerte
  // der Achsen werden ermittelt, um die Darstellung richtig
  // zu skalieren

  if (FCapacitorList.Count > 0) then
  begin
  for I := 0 to FCapacitorList.Count - 1 do
  begin
    if FCapacitorList.Items[I].ShowGraph then
    begin
      FCapacitorList.Items[I].CalcValues;
      if (FCapacitorList.Items[I].Tau >= FMaxTime) then
      begin
        FMaxTime := FCapacitorList.Items[I].Tau;
      end;

      if (FCapacitorList.Items[I].Voltage >= FMaxValue) then
      begin
        FMaxValue := FCapacitorList.Items[I].Voltage;
      end;
    end;
  end;

  end;
  FMaxTime := FMaxTime * 5;
  Edit7.Text := FloatToStr(FMaxValue);
  Edit5.Text := FloatToStr(FMaxTime);

  updateStringGrid(StringGrid2, FCapacitorList);
  updateListBox(CheckListBox1, FCapacitorList);
  PaintBox1Paint(nil);
end;

procedure TForm1.ExportGraph(Sender: TObject);
var
  Picture: TBitmap;
  CopyRange: TRect;
begin
  Picture := TBitmap.Create;
  saveImageDialog.FileName := 'bild.bmp';
  saveImageDialog.DoFolderChange;
  Picture.Width := Paintbox1.Width;
  Picture.Height := Paintbox1.Height;
  CopyRange := Rect(0, 0, Picture.Width, Picture.Height);
  Picture.Canvas.CopyRect(CopyRange, PaintBox1.Canvas, CopyRange);

  // Capacitux - Namen ins Bild schreiben, falls es ein Diagramm ist
  if (PageControl1.ActivePage = TabSheet1) then
  begin
    Picture.Canvas.TextRect(CopyRange, Picture.Width - 140, 0, 'Created with Capacitux');
  end;

  if saveImageDialog.Execute then
  begin
    Picture.SaveToFile(saveImageDialog.FileName);
  end;
  Picture.Free;
end;

procedure TForm1.setParameters(Sender: TObject);
var
  I: integer;
begin
  I := 0;
  if (CheckListBox1.ItemIndex >= 0) then
  begin
    I := CheckListBox1.ItemIndex;
    FCapacitorList.Items[I].Name := Edit1.Text;
    FCapacitorList.Items[I].Color := ColorButton1.ButtonColor;

    // Bei fehlerhafter Eingabe nichts tun und Fehler ausgeben
    try
      FCapacitorList.Items[I].Capacity :=
        unifyParameter(StrToFloat(Edit2.Text), ComboBox2.ItemIndex);
      FCapacitorList.Items[I].Resistance := StrToFloat(Edit3.Text);
      FCapacitorList.Items[I].Voltage := StrToFloat(Edit4.Text);

      ComboBox2.ItemIndex := 4;
    except
      on e: Exception do
      begin
        Application.MessageBox(
          PChar('Fehler bei der Eingabe eines Parameters aufgetreten! ' +
          #13#10 + 'Original-Fehlernachricht: ' + e.Message + #13#10 +
          #13#10 + 'Geben Sie bitte einen gültigen Zahlenwert ein!'),
          'Eingabefehler!', 0);
        exit;
      end;
    end;
    CheckListBox1.ItemIndex := -1;
    DisableAllFields;
    ClearAllFields;
    Calculate(nil);
  end;
end;


procedure TForm1.DeleteCapacitor(Sender: TObject);
begin
  if (FCapacitorList.Count > 0) and (CheckListBox1.ItemIndex >= 0) then
  begin
    DisableAllFields;
    ClearAllFields;
    FCapacitorList.Delete(CheckListBox1.ItemIndex);
  end;
  Calculate(nil);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if (MessageDlg('Programm beenden', 'Wollen Sie ' + FProgrammName +
    ' wirklich beenden?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    CanClose := True;
  end
  else
  begin
    CanClose := False;
  end;
end;

procedure TForm1.switchVisibilityClick(Sender: TObject; AIndex: Integer);
begin
  if FCapacitorList.Items[AIndex].ShowGraph then
  begin
    CheckListBox1.Checked[AIndex] := False;
    FCapacitorList.Items[AIndex].ShowGraph := False;
  end
  else
  begin
    CheckListBox1.Checked[AIndex] := True;
    FCapacitorList.Items[AIndex].ShowGraph := True;
  end;
  Calculate(nil);
end;


procedure TForm1.DeleteAllCapacitors(Sender: TObject);
begin
  if (FCapacitorList.Count > 0) then
  begin
    if MessageDlg('Alle Löschen', 'Wirklich alle Bauteile löschen?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FCapacitorList.Clear;
      CheckListBox1.Clear;
      updateStringGrid(StringGrid2, FCapacitorList);
      ClearAllFields;
      DisableAllFields;
    end;
  end;
  resetMaxValues(nil);
  PaintBox1Paint(nil);
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  PaintBox1.Canvas.Clear;
  labelPaintBox(PaintBox1, FCapacitorList, FOffset, FGridSize, FMaxValue,
    FMaxTime, ComboBox1.ItemIndex);
  drawAxesToPaintBox(PaintBox1, FOffset);
  updateStringGrid(StringGrid2, FCapacitorList);
end;

procedure TForm1.ClearAllFields;
begin
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';

  Colorbutton1.Color := clBlack;
end;

procedure TForm1.EnableAllFields;
begin
  Edit1.Enabled := True;
  Edit2.Enabled := True;
  Edit3.Enabled := True;
  Edit4.Enabled := True;

  ColorButton1.Enabled := True;

  BitBtn3.Enabled := True;
  BitBtn4.Enabled := True;

end;

procedure TForm1.DisableAllFields;
begin
  Edit1.Enabled := False;
  Edit2.Enabled := False;
  Edit3.Enabled := False;
  Edit4.Enabled := False;

  ComboBox2.Enabled := False;
  ComboBox3.Enabled := False;
  ComboBox4.Enabled := False;

  ColorButton1.Enabled := False;

  BitBtn3.Enabled := False;
  BitBtn4.Enabled := False;
end;


procedure TForm1.selectAllCapacitors(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to FCapacitorList.Count - 1 do
  begin
    FCapacitorList.Items[I].ShowGraph := True;
  end;
  ClearAllFields;
  DisableAllFields;
  Calculate(nil);
end;


procedure TForm1.unselectAllCapacitors(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to FCapacitorList.Count - 1 do
  begin
    FCapacitorList.Items[I].ShowGraph := False;
  end;
  //UpdateListBox(CheckListBox1, FCapacitorList);
  ClearAllFields;
  DisableAllFields;
  Calculate(nil);
  //PaintBox1Paint(nil);
end;

procedure TForm1.switchThickLines(Sender: TObject);
begin
  if MenuItem26.Checked then
  begin
    PenWidth := 1;
    MenuItem26.Checked := False;
  end
  else
  begin
    PenWidth := 2;
    MenuItem26.Checked := True;
  end;
  PaintBox1Paint(nil);
end;


procedure TForm1.MenuOpenDocumentation(Sender: TObject);
begin
  if (FOSName = 'Windows') then
  begin
    openDocument('docs\Dokumentation.pdf');     // MS-Win
  end
  else
  begin
    openDocument('docs/Dokumentation.pdf');     // UNIX
  end;
end;

procedure TForm1.MenuOpenWebLink(Sender: TObject);
begin
  // klappt auch mit HTML Dokumenten gut ;)
  if (FOSName = 'Windows') then
  begin
    openDocument('http://www.abi-physik.de/buch/das-elektrische-feld/kondensator/');
  end
  else
  begin
    // funktioniert aus irgendeinem Grund so nicht immer. wird wahrscheinlich von einigen
    // Desktopumgebungen nicht unterstützt
    openDocument('http://www.abi-physik.de/buch/das-elektrische-feld/kondensator');

    {  so könnte man es machen
    try
      AProcess := TProcess.Create(nil);
      AProcess.CommandLine := 'firefox http://www.abi-physik.de/buch/das-elektrische-feld/kondensator';
      AProcess.Execute;
    finally
      Aprocess.Free;
    end;  }
  end;
end;

procedure TForm1.MenuOpenProjectSource(Sender: TObject);
begin
  openDocument('Projektarbeit.lpi');  // bei MS-WIN und UNIX gleich
end;

procedure TForm1.openManual(Sender: TObject);
begin
  if (FOSName = 'Windows') then
  begin
    openDocument('docs\Benutzerhandbuch.pdf');
  end
  else
  begin
    openDocument('docs/Benutzerhandbuch.pdf');
  end;
end;


procedure TForm1.MenuAboutClick(Sender: TObject);
begin
  infowindow.Visible := True;
end;

procedure TForm1.MenuAddCapacitorClick(Sender: TObject);
begin
  AddCapacitor(nil);
end;

procedure TForm1.MenuDeleteCapacitorClick(Sender: TObject);
begin
  DeleteCapacitor(nil);
end;

procedure TForm1.ExitButtonClick(Sender: TObject);
begin
  if MessageDlg('Beenden', 'Wollen Sie ' + FProgrammName + ' wirklich beenden?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Application.Terminate;
  end;
end;

procedure TForm1.CheckCapacitor(Sender: TObject);
begin
  SwitchVisibilityClick(nil, CheckListBox1.ItemIndex);
end;

procedure TForm1.showVersionHistory(Sender: TObject);
begin
  historyWindow.Visible := True;
end;


procedure TForm1.AbortButtonClick(Sender: TObject);
begin
  ClearAllFields;
  DisableAllFields;
end;

procedure TForm1.AddFromFile(Sender: TObject);
begin
  loadFromFile(nil, False);
end;


procedure TForm1.selectionChanged(Sender: TObject);
begin
  PaintBox1Paint(nil);
end;

procedure TForm1.zoomInAtY(Sender: TObject);
begin
  if (FCapacitorList.Count > 0) then
  begin
    FMaxValue := (FMaxValue / 3) * 2;
    Edit7.Text := FloatToStr(FMaxValue);
    setZoomArea(nil);
  end;
end;

procedure TForm1.zoomOutAtY(Sender: TObject);
begin
if (FCapacitorList.Count > 0) then
  begin
    FMaxValue := FMaxValue + (FMaxValue / 2);
    Edit7.Text := FloatToStr(FMaxValue);
    setZoomArea(nil);
  end;
end;

procedure TForm1.zoomInAtX(Sender: TObject);
begin
  if (FCapacitorList.Count > 0) then
  begin
    FMaxTime := (FMaxTime / 3) * 2;
    Edit5.Text := FloatToStr(FMaxTime);
    setZoomArea(nil);
  end;
end;

procedure TForm1.zoomOutAtX(Sender: TObject);
begin
  if (FCapacitorList.Count > 0) then
  begin
    FMaxTime := FMaxTime + (FMaxTime / 2);
    Edit5.Text := FloatToStr(FMaxTime);
    setZoomArea(nil);
  end;
end;

procedure TForm1.resetMaxValues(Sender: TObject);
begin
  if (FCapacitorList.Count > 0) then
  begin
    calculate(nil);
    PaintBox1Paint(nil);
    Edit5.Text := FloatToStr(FMaxTime);
    Edit7.Text := FloatToStr(FMaxValue);
  end
  else
  begin
    FMaxTime := 16;
    FMaxValue := 8;
    PaintBox1Paint(nil);
    Edit5.Text := '';
    Edit7.Text := '';
  end;
end;

procedure TForm1.MenuItem20Click(Sender: TObject);
begin
  ComboBox1.ItemIndex := 0;
  selectionChanged(nil);
end;

procedure TForm1.MenuItem21Click(Sender: TObject);
begin
  ComboBox1.ItemIndex := 1;
  selectionChanged(nil);
end;

procedure TForm1.MenuItem22Click(Sender: TObject);
begin
  ComboBox1.ItemIndex := 2;
  selectionChanged(nil);
end;

procedure TForm1.takeScreenshot(Sender: TObject);
var
  Picture: TBitmap;
  ScreenDC: HDC;
begin
  Picture := TBitmap.Create;
  sleep(1000);
  ScreenDC := GetDC(0);
  Picture.LoadFromDevice(ScreenDC);
  ReleaseDC(0, ScreenDC);
  saveImageDialog.FileName := 'screenshot.bmp';

  if saveImageDialog.Execute then
  begin
    Picture.SaveToFile(saveImageDialog.FileName);
  end;

  Picture.Free;
end;


procedure TForm1.setZoomArea(Sender: TObject);
begin
  try
    FMaxTime := StrToFloat(Edit5.Caption);
    FMaxValue := StrToFloat(Edit7.Caption);
  except
  end;
  //calculate(nil);
  PaintBox1Paint(nil);
end;


end.
