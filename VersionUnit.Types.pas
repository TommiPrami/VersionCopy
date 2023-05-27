unit VersionUnit.Types;

interface

type
  TCopyItem = record
    SourceFullFilename: string;
    SourcePath: string;
    SourceFilename: string;
    DestinationPath: string;
    DestinationFullFilename: string;

    SourceVersion: string;
    DestinationVersion: string;

    procedure ParseSourceFullFilename(const ASourceFullFilename: string);
  end;

implementation

uses
  System.SysUtils;

{ TCopyItem }

procedure TCopyItem.ParseSourceFullFilename(const ASourceFullFilename: string);
begin
  SourceFullFilename := ASourceFullFilename;

  SourcePath := IncludeTrailingPathDelimiter(ExtractFilePath(SourceFullFilename));
  SourceFilename := ExtractFileName(SourceFullFilename);
end;

end.
