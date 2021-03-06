unit uData;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles;

Type


  TFirma = Record
    User, Lizenz: String;
  end;

  TKabel = Array[0..7] of String;

  TLizenz = class
    fFirma    : TFirma;
    fPath,
    fFilename : String;
  private
    function GetFirma: TFirma;
    procedure SetFirma(Value: TFirma);
  public
    constructor Create;
    destructor Done;
    property Firma: TFirma read GetFirma write SetFirma;
  end;

  TPlan = class
    fKabel      : array of TKabel;
    fData       : record
      Filename,
      Geraet    : String;
      index     : int64;
      end;
  private
    function    GetKabel : TKabel;
    function    GetFile  : String;
    procedure   SetKabel(Value: TKabel);
    procedure   Setfile(Value: String);
  public
    constructor Create;
    destructor  Done;
    property    Kabel: TKabel read GetKabel write SetKabel;
    property    _File: String read GetFile  write SetFile;
//    property    UpDate
  end;

implementation

{ TLizenz }

constructor TLizenz.Create;
begin
  inherited;
  fFilename:= Format('%s', ['Setting.svp']);
  if FileExists(fFilename) then fFirma:= GetFirma;
end;

Destructor TLizenz.Done;
begin
  inherited;
end;

function TLizenz.GetFirma: TFirma;
var s: String;
begin
  s:= Format('[%s]', ['Lizenznehmer']);
  if FileExists(FPath + fFilename) then begin
    with TIniFile.Create(fFilename) do try
      fFirma.User   := ReadString(s, 'Firma' , ' ');
      fFirma.Lizenz := ReadString(s, 'Lizenz', ' ');
    finally
      Free;
    end;
  end;
  Result:= fFirma;
end;

procedure TLizenz.SetFirma(Value: TFirma);
var s: String;
begin
  s:= Format('[%s]', ['Lizenznehmer']);
  if FileExists(fFilename) then DeleteFile(fFilename);
  with TIniFile.Create(fFilename) do try
    WriteString(s, 'Firma',  Value.User);
    WriteString(s, 'Lizenz', Value.Lizenz);
  finally
    Free;
  end;
end;

{ TPlan }

constructor TPlan.Create;
var Temp : TStringlist;
    i    : Integer;
begin
  inherited;
  if fData.Filename <> '' then begin
     fData.Filename:= Format('%s', [fData.Geraet + '.vpl']);
     if FileExists(fData.Filename) then begin
       Temp:= TStringlist.Create;
       Temp.LoadFromFile(fData.Filename);
       i:= Temp.Capacity div 9;
       SetLength(fKabel, i);
       end;
     end
  else SetLength(fKabel, 10);
end;

destructor TPlan.Done;
begin
  inherited;
end;

function TPlan.GetKabel: TKabel;
begin

end;

function TPlan.GetFile: String;
begin
  result:= fData.Filename;
end;

procedure TPlan.SetKabel(Value: TKabel);
var s: String;
begin
  fData.Filename:= Format('%s', [fData.Geraet + '.vpl']);
  s:= Format('[%s]', ['Verdrahtung']);
  if FileExists(fData.Filename) then DeleteFile(fData.Filename);
  with TIniFile.Create(fData.Filename) do try
    WriteString(s, 'Quelle'              , Value[0]);
    WriteString(s, 'Kontaktart Quelle'   , Value[1]);
    WriteString(s, 'Leitungstyp'         , Value[2]);
    WriteString(s, 'Leitungsquerschnitt' , Value[3]);
    WriteString(s, 'Leitungslänge'       , Value[4]);
    WriteString(s, 'Leitungsfarbe'       , Value[5]);
    WriteString(s, 'Kontaktart Ziel'     , Value[6]);
    WriteString(s, 'Zielkontakt'         , Value[7]);
  finally
    Free;
  end;
end;

procedure TPlan.Setfile(Value: String);
begin
  fData.Filename:= Value;
end;

end.

