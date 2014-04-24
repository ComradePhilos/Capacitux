{
  Zur Darstellung der Zahlenwerte im Diagramm etc. Inwiefern diese Unit am Ende genutzt/gebraucht
  wird, ist noch nicht klar. Sie könnte aber helfen, Über- und Unterläufe von Werten zu verhindern
  und das Darstellen der Einheiten bei sehr großen und kleinen Werten mit Präfixen erleichtern.
  -> Wissenschaftliche Schreibweise
}
unit numericValues;

interface

uses Math, Classes, SysUtils;


type
  TNumericValue = class

    private
      FNum: Extended;           // Fließkommabetrag
      FExponent: Integer;       // * (10 **Exponent)
      FUnitLabel: String;       // Einheit
    public

      constructor Create;
      constructor Create(num: Extended = 0; exp: Integer = 0; aunit: String = ''); overload;
      procedure SetTo(ANumeric: TNumericValue);
      procedure Add(Anumeric: TNumericValue);
      procedure Shorten;
      procedure Clear;

      property Num: Extended read FNum write FNum;
      property Exponent: Integer read FExponent write FExponent;
      property UnitLabel: String read FUnitLabel write FUnitLabel;

  end;

implementation

constructor TNumericValue.Create;
begin
  Clear;
end;

constructor TNumericValue.Create(num: Extended = 0; exp: Integer = 0; aunit: String = ''); overload;
begin
  FNum := num;
  FExponent := exp;
  FUnitLabel := aunit;
end;

procedure TNumericValue.Clear;
begin
  Fnum := 0;
  FExponent := 0;
  FUnitLabel := '';
end;

procedure TNumericValue.SetTo(ANumeric: TNumericValue);
begin
  begin
    FNum := ANumeric.Num;
    FExponent := ANumeric.Exponent;
    FUnitLabel := ANumeric.UnitLabel;
  end;
end;

procedure TNumericValue.Shorten;
begin
  while (FNum >= 10) do
  begin
    Inc(FExponent);
    FNum := FNum / 10;
  end;
  while (FNum > 0) and (FNum < 1) do
  begin
    FExponent := FExponent - 1;
    FNum := FNum * 10;
  end;
end;

// Noch falsch
procedure TNumericValue.Add(ANumeric: TNumericValue);
begin
  if (ANumeric.UnitLabel = FUnitLabel) then
  begin
    FNum := FNum + ANumeric.Num;
    FExponent := FExponent;
    Shorten;
  end
  else
  begin
    raise Exception.Create('Unterschiedliche Einheiten "' + FUnitLabel + '" und "' + ANumeric.UnitLabel + '" können nicht addiert werden!"');
  end;
end;

end.