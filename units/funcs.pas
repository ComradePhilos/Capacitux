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
#####################################################################################}

{
 Enthält alle sonstigen Hilfs-Funktionen, die ich in der Main-Unit nicht
 unterbringen wollte, weil sie zu viel Platz benötigen...
 und/oder nicht schön zu lesen sind.

 Die Kommentierung der Funktionen entspricht XML-Notation, manche Plugins für
 IDEs zeigen diese Informationen an, wenn man die Maus über eine bestimmte Funktion
 fahren lässt. Delphi z.b. nutzt dies standardmäßig in der Version XE5, bzw. das
 CN-Pack für Delphi XE5.

  Todo:
  - Eine Methode, die Eingaben in der Tabelle sowohl mit Einheit als auch ohne Einheit
    in ein Float konvertiert und zurückgibt
}

unit funcs;

interface

uses Classes, Forms, SysUtils, Graphics, ExtCtrls, CheckLst, Grids, Math, StrUtils,
  Capacitor;

/// <summary>
/// Füllt eine Text-Liste mit den Namen von Kondensatoren aus einer
/// Kondensatorliste und nummeriert diese durch. Zudem wird das Häkchen
/// gesetzt oder gelöscht, je nach dem, welcher Wert gespeichert íst.
/// </summary>
/// <param name="checkListBox">Die CheckBox-Liste, die aktualisiert werden soll</param>
/// <param name="capacitorList">Liste der Kondensatoren, aus der die Namen gelesen werden</param>
procedure updateListBox(checkListBox: TCheckListBox; capacitorList: TCapacitorList);

/// <summary>
/// Aktualisiert die Tabelle mit den Werten der Kond.
/// </summary>
/// <param name="AStringGrid">Die Tabelle, die aktualisiert werden soll</param>
/// <param name="capacitorList">Liste der Kondensatoren, aus der die Namen gelesen werden</param>
procedure updateStringGrid(AGrid: TStringGrid; capacitorList: TCapacitorList);

/// <summary>
/// Zeichnet angepasst an die Größe der PaintBox die
/// Koordinatenachsen für ein Diagramm
/// </summary>
/// <param name="APaintBox">Die PaintBox, in die gezeichnet werden soll</param>
/// <param name="offset">Abstand in Pixeln zum Rand der PaintBox</param>
procedure drawAxesToPaintBox(APaintBox: TPaintBox; offset: integer);

/// <summary>
/// Fügt in eine PaintBox die Beschriftung und das Raster ein
/// </summary>
/// <param name="APaintBox">Die PaintBox, in die gezeichnet werden soll</param>
/// <param name="offset">Abstand in Pixeln zum Rand der PaintBox</param>
/// <param name="steplength">Abstand in Pixeln zwischen den Raster-Linien</param>
procedure labelPaintBox(APaintBox: TPaintBox; capacitorList: TCapacitorList;
  offset, stepLength: integer; maxVal, maxTime: double; curveSelection: integer);

/// <summary>
/// Konvertiert einen zu kleinen oder zu großen Wert in einen Präfix-behafteten Text
/// </summary>
/// <param name="val">Der Zahlenwert</param>
/// <param name="unitLabel">Benutzte Einheit ohne Präfix</param>
/// <returns>Präfix-behafteter Text</returns>
function convertToPrefixedString(val: double; unitLabel: string): string;

/// <summary>
///  Bringt einen Zahlenwert MIT Präfix auf einen unifizierten, präfixlosen Zahlenwert
/// </summary>
/// <param name="AValue">z.b. Kommazahl</param>
/// <param name="APrefix">Das Präfix als 1 stelliger String/Char</param>
/// <returns>präfixloser, unifizierter Zahlenwert</returns>
function unifyParameter(AValue: Double; APrefix: String): Double;

/// <summary>
///  Bringt einen Zahlenwert MIT Präfix auf einen unifizierten, präfixlosen Zahlenwert
/// </summary>
/// <param name="AValue">z.b. Kommazahl</param>
/// <param name="APrefix">Item-Index einer Einheiten-ComboBox aus Main.pas</param>
/// <returns>präfixloser, unifizierter Zahlenwert</returns>
function unifyParameter(AValue: Double; APrefix: Integer): Double;  overload;

/// <summary>
/// Berechnet für die Länge eine Koordinaten-Achse den Wert, den
/// 1 Pixel repräsentiert.
/// </summary>
/// <param name="l">Länge der Achse in Pixeln</param>
/// <param name="maxValue">der Maximalwert, der am Ende der Achse liegen soll</param>
/// <param name="stepLength">Abstand in Pixeln zwischen den Gitter-Linien</param>
/// <returns></returns>
function calcPixelEquivalence(l: integer; MaxValue: double; stepLength: integer): double;

/// <summary>
///  Verändert den eingegebenen String und liefert als Ergebnis den reinen Zahlenwert
/// </summary>
/// <param name="AInput">Eingegebener String</param>
/// <returns>Zahlenwert</returns>
//function convertGridInput(AInput: String): Double;

/// <summary>
///  Gibt den Index-Wert eines Einheiten-Präfixes aus
/// </summary>
/// <param name="APrefix">Präfix als Text</param>
/// <returns>Indext</returns>
function getIndexOfPrefix(APrefix: String): Integer;


{--------------------------- Globale Variablen --------------------------------------}
var
    PenWidth: Integer;        // Breite der Linien
    UseAntialising: Boolean;


{------------------------------   Konstanten   ---------------------------------------}
const
  // Präfix-Strings für die Einheiten
  cPrefixes: array[0..8] of string = ('p', 'n', 'µ', 'm', '', 'k', 'M', 'G', 'T');


implementation


procedure updateListBox(checkListBox: TCheckListBox; capacitorList: TCapacitorList);
var
  I: integer;
begin
  checkListBox.Clear;
  for I := 0 to capacitorList.Count - 1 do
  begin
    checkListBox.Items.add(IntToStr(I + 1) + ' - ' + capacitorList[I].Name);
    checkListBox.Checked[I] := capacitorList[I].ShowGraph;
  end;
end;

procedure updateStringGrid(AGrid: TStringGrid; capacitorList: TCapacitorList);
var
  I: integer;
begin
  AGrid.Clear;

  AGrid.RowCount := capacitorList.Count + 1;
  AGrid.ColCount := 6;
  AGrid.Cells[0, 0] := 'Name';
  AGrid.Cells[1, 0] := 'Kapazität C';
  AGrid.Cells[2, 0] := 'Widerstand Rc';
  AGrid.Cells[3, 0] := 'Spannung U';
  AGrid.Cells[4, 0] := 'Zeitkonst. T';
  AGrid.Cells[5, 0] := 'Aufladezeit';

  for I := 0 to capacitorList.Count - 1 do
  begin
    AGrid.Cells[0, I + 1] := capacitorList.Items[I].Name;
    AGrid.Cells[1, I + 1] := convertToPrefixedString(
      capacitorList.Items[I].Capacity, 'F');
    AGrid.Cells[2, I + 1] := convertToPrefixedString(
      capacitorList.Items[I].Resistance, 'Ω');
    AGrid.Cells[3, I + 1] := convertToPrefixedString(
      capacitorList.Items[I].Voltage, 'V');
    AGrid.Cells[4, I + 1] := convertToPrefixedString(capacitorList.Items[I].Tau, 's');
    AGrid.Cells[5, I + 1] := convertToPrefixedString(capacitorList.Items[I].Tau*5, 's');
  end;
end;


procedure drawAxesToPaintBox(APaintBox: TPaintBox; offset: integer);
var
  Width, Height: integer;
  P1, P2, P3: TPoint;
  arrowWidth: integer;
begin

  arrowWidth := 6;

  Width := APaintBox.Width;
  Height := APaintBox.Height;


  APaintBox.Canvas.Pen.Color := clBlack;

  // Y-Achse
  APaintBox.Canvas.Line(offset, offset, offset, Height - offset);
  // X-Achse
  APaintBox.Canvas.Line(offset, Height - offset, Width - round(offset / 2),
    Height - offset);

  APaintBox.Canvas.Brush.Color := clBlack;

  // Pfeil - Y-Achse
  P1.x := offset - arrowWidth;
  P1.y := offset;
  P2.x := offset + arrowWidth;
  P2.y := offset;
  P3.x := offset;
  P3.y := offset - 12;
  APaintBox.Canvas.Polygon([P1, P2, P3]);

  // Pfeil - X-Achse
  P1.x := Width - round(offset / 2);
  P1.y := Height - offset - arrowWidth;
  P2.x := Width - round(offset / 2);
  P2.y := Height - offset + arrowWidth;
  P3.x := Width - round(offset / 2) + 12;
  P3.y := Height - offset;
  APaintBox.Canvas.Polygon([P1, P2, P3]);

  APaintBox.Canvas.Brush.Color := clWhite;
end;



procedure labelPaintBox(APaintBox: TPaintBox; capacitorList: TCapacitorList;
  offset, stepLength: integer; maxVal, maxTime: double; curveSelection: integer);
var
  Width, Height: integer;
  I, s: integer;
  lineLength: integer;          // Länge einer Koordinaten-Achse
  YAxisLength: integer;         // die gesamte Achse, auch nach dem letzten Strich
  XAxisLength: integer;         // die gesamte Achse, auch nach dem letzten Strich
  onePixel1: double;            // Entsprechung eines Pixels auf den Achsen
  onePixel2: double;
  x, y: integer;                // Koordinaten, auf die die Kurve gemalt wird
  lastX, lastY: integer;        // Koordinaten der letzten Berechnung.
                                // Zum Zeichnen einer Linie zwischen den Graph-Werten
begin

  Width := APaintBox.Width;
  Height := APaintBox.Height;

  lineLength := 6;
  x := 0;
  y := 0;

  // Achsenberechnungen
  // Einheiten anzeigen mit Präfix
  //APaintBox.Canvas.TextOut(0,0, 'U in ' + RightStr(convertToPrefixedString(maxVal,'V'),2));
  //APaintBox.Canvas.TextOut(APaintBox.Width - 60,APaintBox.Height - 55, 't in ' + RightStr(convertToPrefixedString(maxTime,'s'),2));
  APaintBox.Canvas.TextOut(0,0, 'U in V');
  APaintBox.Canvas.TextOut(APaintBox.Width - 60,APaintBox.Height - 55, 't in s');

  YAxisLength := APaintBox.Height - (2 * offset);
  onePixel1 := calcPixelEquivalence(YAxislength, maxVal, stepLength);
  XAxisLength := APaintBox.Width - offset;
  onePixel2 := calcPixelEquivalence(XAxislength, maxTime, stepLength);

  APaintBox.Canvas.Pen.Width := 1;

  // Dunkelgraues Gitter zeichnen
  APaintBox.Canvas.Pen.Color := clSilver;
  APaintBox.Canvas.Brush.Color := clWhite;

  // Dunkelgraues Gitter VERTIKAL
  for I := 1 to round((Width - offset - 12) / stepLength) do
  begin
    APaintBox.Canvas.Line(offset + (I * stepLength), Height - offset,
      offset + (I * stepLength), offset);
  end;

  // Dunkelgraues Gitter HORIZONTAL
  for I := 1 to round((Height - offset - 12) / stepLength) - 1 do
  begin
    APaintBox.Canvas.Line(offset, Height - offset - (I * stepLength),
      Width - round(offset / 2), Height - offset - (I * stepLength));
  end;

  // Markierungsstriche an den Achsen
  APaintBox.Canvas.Pen.Color := clBlack;

  // X-Achse
  for I := 0 to round((Width - offset - 12) / stepLength) do
  begin
    // Wert in Sekunden
    if (capacitorList.Count > 0) then
    begin
    APaintBox.Canvas.TextOut(offset + (I * steplength) - 7, Height - 27,
      FormatFloat('0.0', (I * stepLength * onePixel2)));
    end;
    // Striche an der Achse
    APaintBox.Canvas.Line(offset + (I * stepLength), Height - offset -
      lineLength, offset + (I * stepLength), Height - offset + lineLength);
  end;

  // Y-Achse
  for I := 0 to round((Height - offset - 12) / stepLength) - 1 do
  begin
    // Werte in Volt
    if (capacitorList.Count > 0) then
    begin
      APaintBox.Canvas.TextOut(2, (Height - offset) - (I * steplength) -
      13, FormatFloat('0.0', (I * stepLength * onePixel1)));
    end;
    // Striche an der Achse
    APaintBox.Canvas.Line(offset - lineLength, Height - offset -
      (I * stepLength), offset + lineLength, Height - offset - (I * stepLength));
  end;


  APaintBox.Canvas.Pen.Width := PenWidth;

  for I := 0 to capacitorList.Count - 1 do
  begin
    lastX := 0 + offset;
    lastY := Height - offset;

    // Falls Graph gezeichnet werden soll, dann Kurve berechnen und zeichnen
    if (capacitorList.Items[I].ShowGraph) and (onePixel1 <> 0) then
    begin

      APaintBox.Canvas.Pen.Color := capacitorList.Items[I].Color;
      // Lade-Kurve
      if (curveSelection = 0) or (curveSelection = 2) then
      begin
        for s := 0 to XAxisLength do
        begin
          x := s + offset;
          y := Height - offset -
            round(capacitorList.Items[I].calcVoltageCharging(s * onePixel2) /
            onePixel1);
          if (s > 0) then   // Damit die Kurven nicht hinter/auf den Achsen gemalt werden
            APaintBox.Canvas.Line(x, y, lastX, lastY);
          lastX := x;
          lastY := y;
        end;
      end;

      // Entlade-Kurve
      if (curveSelection >= 1) then
      begin
        lastX := 0 + offset;
        lastY := Height - offset;
        for s := 0 to XAxisLength do
        begin
          x := s + offset;
          y := Height - offset -
            round(capacitorList.Items[I].calcVoltageDischarging(s * onePixel2) /
            onePixel1);
          if (s > 0) then   // Damit die Kurven nicht hinter/auf den Achsen gemalt werden
            APaintBox.Canvas.Line(x, y, lastX, lastY);
          lastX := x;
          lastY := y;
        end;
      end;

    end; { if...}
  end;  { for ... }

end;


function convertToPrefixedString(val: double; unitLabel: string): string;
var
  I: integer;
begin

  I := 0;

  if (val >= 1000) then
  begin
    while (val >= 1000) and (I < 4) do
    begin
      Inc(I);
      val := val / 1000;
    end;
  end
  else if (val < 1) and (val > 0) then
  begin
    while (val < 1) and (val > 0) and (I > -4) do
    begin
      I := I - 1;
      val := val * 1000;
    end;
  end;

  Result := FloatToStr(val) + ' ' + cPrefixes[I + 4] + unitLabel;
end;


function unifyParameter(AValue: Double; APrefix: String): Double;
var
  I: integer;
begin
  for I := 0 to 8 do
  begin
	if (APrefix = cPrefixes[I]) then
    begin
      Result:= AValue * (10 ** (I-4));
    end;
  end;

end;

function unifyParameter(AValue: Double; APrefix: Integer): Double;
var
  I: Integer;
begin
  APrefix := 4 - APrefix;

  if (APrefix >= 0) then
    AValue := AValue * (1000 ** APrefix);

  if (APrefix < 0) then
    begin
      for I := Aprefix to -1 do
      begin
        AValue := AValue/1000;
      end;
    end;

  Result := AValue;

end;


function calcPixelEquivalence(l: integer; MaxValue: double; stepLength: integer): double;
begin
  // In Object-/ Free-Pascal hat jede function eine vordefinierte Variable Result.
  // Result ist also keine Methodenaufruf, der aus der function in den Call-Stack springen
  // lässt, Result kann also in einer function beliebig oft verändert werden, zurückgegeben
  // wird über den Call-Stack dann der Wert, der als letztes in "Result" drinstand.
  Result := trunc(l / steplength);
  Result := Result * steplength;  // Länge der Achse - bis zum letzten Markierungs-Strich
  Result := MaxValue / Result;    // Wert 1 Pixels auf der Achse ( z.b. in s oder V )
end;


function getIndexOfPrefix( APrefix: String ): Integer;
var
  I: Integer;
begin
  //Result := 4;

  for I := 0 to length(cPrefixes) - 1 do
  begin
    if (cPrefixes[I] = trim(APrefix)) then
    begin
      Result := I;
    end;
  end;

  Result := 8 - Result;
end;

end.
