unit info;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, LCLIntf, EditBtn, Buttons,
  history;

type

  { TForm2 }

  TForm2 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    historyWindow: TForm3;
    StaticText1: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.Image1Click(Sender: TObject);
begin
  openDocument('http://www.ubuntu.com/');
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  historyWindow := TForm3.Create(nil);
  historyWindow.Memo1.Width := historyWindow.Width;
  historyWindow.Memo1.Height := historyWindow.Height;
end;

procedure TForm2.Image2Click(Sender: TObject);
begin
  openDocument('http://www.lazarus.freepascal.org/');
end;

procedure TForm2.Image3Click(Sender: TObject);
begin
  openDocument('docs/Dokumentation.pdf');   // MS-Win
  openDocument('docs\Dokumentation.pdf');   // Unix
end;

procedure TForm2.Label3Click(Sender: TObject);
begin
  historyWindow.Visible := True;
end;

procedure TForm2.StaticText1Click(Sender: TObject);
begin

end;


end.
