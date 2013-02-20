unit XMLOutputAdaptor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  Tree,
  XMLWrite,
  DOM,
  FileOutputAdaptor,
  baseoutputadaptor;

type

  { TXMLOutputAdaptor }

  TXMLOutputAdaptor = class(TFileOutputAdaptor)
  private
    FXML: TXMLDocument;
    procedure TraverseNode(ANode: TFieldData; ADomNode: TDOMNode);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute(ATree: TFieldData); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  {$I datasetinputadaptor_icon.lrs}
  RegisterComponents('LazDataIntegrator',[TXMLOutputAdaptor]);
end;

{ TXMLOutputAdaptor }

procedure TXMLOutputAdaptor.Execute(ATree: TFieldData);
(* This method traverses ATree, then generates an XML file *)
var
  lNode: TDOMNode;
begin
  lNode := FXML.CreateElement(ATree.Name);
  FXML.AppendChild(lNode);
  TraverseNode(ATree, lNode);
  WriteXMLFile(FXML, FileName);
end;

procedure TXMLOutputAdaptor.TraverseNode(ANode: TFieldData; ADomNode: TDOMNode);
var
  lNode: TFieldData;
  lXmlNode: TDOMElement;
begin
  lXmlNode := FXML.CreateElement(ANode.Name);

  if ANode is TStringFieldData then
    lXmlNode.SetAttribute(
      (ANode as TStringFieldData).Name,
      (ANode as TStringFieldData).Value)
  else
  if ANode is TIntegerFieldData then
    lXmlNode.SetAttribute(
      (ANode as TIntegerFieldData).Name,
      IntToStr((ANode as TIntegerFieldData).Value));

  ADomNode.AppendChild(lXmlNode);

  for lNode in ANode.SubItems do
  begin
    TraverseNode(lNode, ADomNode);
  end;
end;

constructor TXMLOutputAdaptor.Create(AOwner: TComponent);
begin
  inherited;
  FXML := TXMLDocument.Create;
end;

destructor TXMLOutputAdaptor.Destroy;
begin
  FXML.Free;
  inherited Destroy;
end;


end.
