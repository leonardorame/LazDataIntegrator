unit tree;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type

  { TNodeData }

  TFieldData = class;

  TSubItems = specialize TFPGList<TFieldData>;

  { TFieldData }

  TFieldData = class
  private
    FName: string;
    FSubItems: TSubItems;
  public
    constructor Create(ACaption: string);
    destructor Destroy; override;
    property Name: string read FName write FName;
  published
    property SubItems: TSubItems read FSubItems write FSubItems;
  end;

  { TIntegerFieldData }

  TIntegerFieldData = class(TFieldData)
  private
    FValue: Integer;
  published
    property Value: Integer read FValue write FValue;
  end;

  { TStringFieldData }

  TStringFieldData = class(TFieldData)
  private
    FValue: string;
  published
    property Value: string read FValue write FValue;
  end;

implementation

{ TFieldData }

constructor TFieldData.Create(ACaption: string);
begin
  FName:= ACaption;
  FSubItems := TSubItems.Create;
end;

destructor TFieldData.Destroy;
begin
  FSubItems.Free;
  inherited Destroy;
end;

end.


