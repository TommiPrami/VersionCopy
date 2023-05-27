unit VersionUnit.Utils;

interface

  function GetFileVersion(const AFileName: string): string;
  function CompareVersionNumbers(const AVersion1, AVersion2: string): Integer;

implementation

uses
  Winapi.Windows, System.Classes, System.Math, System.SysUtils;

function CompareVersionNumbers(const AVersion1, AVersion2: string): Integer;
var
  LVersion1List: TStringList;
  LOVersion2List: TStringList;
  LIndex: Integer;
  LVersion1Part: Integer;
  LVersion2Part: Integer;
begin
  // Versions are equal (Default)
  Result := 0;

  LVersion1List := TStringList.Create;
  LOVersion2List := TStringList.Create;
  try
    // Split version numbers into parts
    ExtractStrings(['.'], [], PChar(AVersion1), LVersion1List);
    ExtractStrings(['.'], [], PChar(AVersion2), LOVersion2List);

    // Compare each part of the version numbers
    for LIndex := 0 to Min(LVersion1List.Count - 1, LOVersion2List.Count - 1) do
    begin
      LVersion1Part := StrToIntDef(LVersion1List[LIndex], 0);
      LVersion2Part := StrToIntDef(LOVersion2List[LIndex], 0);

      if LVersion1Part < LVersion2Part then
        Exit(-1)
      else if LVersion1Part > LVersion2Part then
        Exit(1);
    end;

    // If all parts compared so far are equal, check the length
    if LVersion1List.Count < LOVersion2List.Count then
      Exit(-1)
    else if LVersion1List.Count > LOVersion2List.Count then
      Exit(1);

  finally
    LVersion1List.Free;
    LOVersion2List.Free;
  end;
end;

function GetFileVersion(const AFileName: string): string;
var
  LSize, LDummy: DWORD;
  LVersionInfo: Pointer;
  LVersionInfoSize: UINT;
  LFileInfo: PVSFixedFileInfo;
begin
  Result := '';

  LSize := GetFileVersionInfoSize(PChar(AFileName), LDummy);
  if LSize = 0 then
    Exit;

  GetMem(LVersionInfo, LSize);
  try
    if GetFileVersionInfo(PChar(AFileName), 0, LSize, LVersionInfo) then
    begin
      if VerQueryValue(LVersionInfo, '\', Pointer(LFileInfo), LVersionInfoSize) then
      begin
        Result :=
          IntToStr(LFileInfo.dwFileVersionMS shr 16) + '.' +
          IntToStr(LFileInfo.dwFileVersionMS and $FFFF) + '.' +
          IntToStr(LFileInfo.dwFileVersionLS shr 16) + '.' +
          IntToStr(LFileInfo.dwFileVersionLS and $FFFF);
      end;
    end;
  finally
    FreeMem(LVersionInfo);
  end;
end;

end.
