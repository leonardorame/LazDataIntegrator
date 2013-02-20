unit DataSetInputAdaptor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  db,
  Tree,
  ComponentEditors,
  frmDataTree,
  baseinputadaptor;

type

  { TDataSetInputAdaptor }

  TDataSetInputAdaptor = class(TBaseInputAdaptor)
  private
    FDataSet: TDataSet;
  public
    procedure DoBefore; override;
  published
    property DataSet: TDataSet read FDataSet write FDataSet;
  end;

  { TDataSetInputAdaptorComponentEditor }

  TDataSetInputAdaptorComponentEditor = class(TComponentEditor)
  protected
    procedure DoShowEditor;
  public
    procedure ExecuteVerb(Index: Integer); override;
    function  GetVerb(Index: Integer): String; override;
    function  GetVerbCount: Integer; override;
  end;

procedure Register;

implementation

procedure Register;
begin
  {$I datasetinputadaptor_icon.lrs}
  RegisterComponents('LazDataIntegrator',[TDataSetInputAdaptor]);
  RegisterComponentEditor([TDataSetInputAdaptor], TDataSetInputAdaptorComponentEditor);
  RegisterComponentEditor([TDataSetInputAdaptor], TBaseInputAdaptorComponentEditor);
end;

{ TDataSetInputAdaptorComponentEditor }

procedure TDataSetInputAdaptorComponentEditor.DoShowEditor;
var
  lComponent: TDataSetInputAdaptor;
begin
  lComponent := (GetComponent as TDataSetInputAdaptor);
  lComponent.DoBefore;
  TdlgDataTree.Execute(lComponent.Tree);
end;

procedure TDataSetInputAdaptorComponentEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: DoShowEditor;
  end;
end;

function TDataSetInputAdaptorComponentEditor.GetVerb(Index: Integer): String;
begin
  Result := 'DatasetInputAdaptor Editor...';
end;

function TDataSetInputAdaptorComponentEditor.GetVerbCount: Integer;
begin
  Result:=1;
end;

{ TDataSetInputAdaptor }

procedure TDataSetInputAdaptor.DoBefore;
(* This method traverses FDataSet.
   For Each row it creates a Tree of TNode, containing
   FieldName, and FieldValue *)
var
  lField: TField;
  lSubNode: TFieldData;
begin
  inherited;
  FDataSet.Open;
  while not FDataSet.EOF do
  begin
    for lField in FDataSet.Fields do
    begin
      case lField.DataType of
        ftString: begin
          lSubNode := TStringFieldData.Create(lField.FieldName);
          (lSubNode as TStringFieldData).Value:= lField.AsString;
        end;
        ftInteger: begin
          lSubNode := TIntegerFieldData.Create(lField.FieldName);
          (lSubNode as TIntegerFieldData).Value := lField.AsInteger;
        end;
      end;
      Tree.SubItems.Add(lSubNode);
    end;
    if csDesigning in ComponentState then
      break
    else
      FDataSet.Next;
  end;
  FDataSet.Close;
end;

end.
