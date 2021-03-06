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
  Klasse für die Kondensatoren
  Enthält alle wichtigen Parameter und Funktionen, 
  die für die Berechnung der Kurven notwendig sind.
}

unit Capacitor;

interface

uses Classes, SysUtils, Graphics, fgl, Forms, Math;

type

  TCapacitor = class

  private

    // Programminterne Werte
    FName: String;           // Name des Konendsators -> von Nutzer wählbar
    FColor: TColor;         // Farbe, mit der der Graph dargestellt werden soll
    FShowGraph: Boolean;     // Graphen anzeigen

    // Physikalische Werte
    FTau: Extended;         // Zeitkonstante Tau = R*c
    FResistance: Extended;  // Widerstand der Schaltung auf der Ebene des Kond.
    FCapacity: Extended;    // Kapazität des Kondensators
    FVoltage: Extended;     // Spannung, die am Kond. anliegt

  public
  /// <summary>
    /// Setzt alle Werte zurück
    /// </summary>
    procedure Clear();
    /// <summary>
    /// Standard-Konstruktor. Falls kein Name angegeben wird, wird er mit "Kondensator" belegt.
    /// </summary>
    constructor Create(name: String = 'Kondensator');

    /// <summary>
    /// Berechnet die Zeitkonstante TAU für den Kondensator
    /// </summary>
    procedure CalcValues;

    /// <summary>
    /// Berechnet für einen Wert t die Entlade-Kurve eines Kondensators
    /// </summary>
    /// <param name="t">Zeit in Sekunden</param>
    /// <param name="ACapacitor">ein Kondensator</param>
    /// <returns>Ergebnis in Volt</returns>
    function calcVoltageDischarging(t: double): double;

    /// <summary>
    /// Berechnet für einen Wert t die Lade-Kurve eines Kondensators
    /// </summary>
    /// <param name="t">Zeit in Sekunden</param>
    /// <param name="ACapacitor">ein Kondensator</param>
    /// <returns>Ergebnis in Volt</returns>
    function calcVoltageCharging(t: double): double;

    property Name: String read FName write FName;
    property Color: TColor read FColor write FColor;
    property Tau: Extended read FTau write FTau;
    property Capacity: Extended read FCapacity write FCapacity;
    property Resistance: Extended read FResistance write FResistance;
    property Voltage: Extended read FVoltage write FVoltage;
    property ShowGraph: Boolean read FShowGraph write FShowGraph;

  end;


TCapacitorList = specialize TFPGObjectList<TCapacitor>;

const
  cEuler = 2.7182818284590452353602874713527;     // Eulersche Zahl

implementation

procedure TCapacitor.Clear();
begin
  FTau := 0.0;
  FResistance := 0.0;
  FCapacity := 0.0;
  FVoltage := 0.0;
  FColor := clBlack;
  FShowGraph := True;
end;

constructor TCapacitor.Create(name: String = 'Kondensator');
begin
     FName := name;
     FShowGraph := True;
     FCapacity := 0.00002;
     FResistance := 100000;
     FVoltage := 10;
end;

procedure TCapacitor.CalcValues;
begin
     // Die Funktion ist kleiner geworden als anfangs gedacht ;)
     // mehr Berechnungen unter "funcs.pas"
     FTau := FResistance * FCapacity;
end;


function TCapacitor.calcVoltageCharging(t: double): double;
var
  exp: double;
begin

  if (FTau > 0) then
  begin
    exp := 0 - (t / FTau);
    Result := FVoltage * (1 - cEuler ** exp);
  end
  else
  begin
    Result := 0;
  end;

end;


function TCapacitor.calcVoltageDischarging(t: double): double;
var
  exp: double;
begin

  if (FTau > 0) then
  begin
    exp := -(t / FTau);
    Result := FVoltage * (cEuler ** exp);
  end
  else
  begin
    Result := 0;
  end;

end;

end.
