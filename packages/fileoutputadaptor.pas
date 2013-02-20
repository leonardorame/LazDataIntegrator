unit FileOutputAdaptor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  baseoutputadaptor;

type

  { TFileOutputAdaptor }

  TFileOutputAdaptor = class(TBaseOutputAdaptor)
  private
    FFileName: string;
  published
    property FileName: string read FFileName write FFileName;
  end;

implementation

{ TFileOutputAdaptor }

end.
