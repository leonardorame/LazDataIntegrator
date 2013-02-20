unit XMLOutputAdaptor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  Tree,
  XMLWrite,
  XMLRead,
  DOM,
  FileOutputAdaptor,
  baseoutputadaptor,
  frmDataTree;

type

  { TXMLOutputAdaptor }

  TXMLOutputAdaptor = class(TFileOutputAdaptor)
  private
    FSampleXml: TStringList;
    FXML: TXMLDocument;
    procedure SetSampleXML(AValue: TStringList);
    procedure TraverseNode(ANode: TFieldData; ADomNode: TDOMNode);
    procedure PopulateTree; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute(ATree: TFieldData); override;
  published
    property SampleXML: TStringList read FSampleXml write SetSampleXML;
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
  (* Once XML was assigned FTree is populated *)
  PopulateTree;
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

procedure TXMLOutputAdaptor.PopulateTree;
var
  lStr: TStringStream;
  lXML: TXMLDocument;
  lNode: TDOMNode;

  procedure ProcessNode(ANode: TDomNode; ATree: TFieldData);
  var
    cNode: TDomNode;
    lTree: TStringFieldData;

  begin
    if ANode = nil then
      Exit;

    lTree := TStringFieldData.Create(ANode.NodeName);
    lTree.Value := ANode.FirstChild.NodeValue;
    ATree.SubItems.Add(lTree);
    // Goes to the child node
    cNode := ANode.FirstChild.FirstChild;
    // Processes all child nodes
    while cNode <> nil do
    begin
      ProcessNode(cNode, lTree);
      cNode := cNode.NextSibling;
    end;
  end;

begin
  lStr := TStringStream.Create(FSampleXml.Text);
  try
    (* Read complete XML document *)
    ReadXMLFile(lXML, lStr);
    (* Traverse XML *)
    Tree.SubItems.Clear;
    Tree.Name:= lXML.DocumentElement.NodeName;
    lNode := lXML.DocumentElement.FirstChild;
    while lNode <> nil do
    begin
      ProcessNode(lNode, Tree);
      lNode := lNode.NextSibling;
    end;
  finally
    lStr.Free;
    lXml.Free;
  end;
end;

procedure TXMLOutputAdaptor.SetSampleXML(AValue: TStringList);
begin
  FSampleXml.Assign(AValue);
  PopulateTree;
end;

constructor TXMLOutputAdaptor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FXML := TXMLDocument.Create;
  FSampleXml := TStringList.Create;
end;

destructor TXMLOutputAdaptor.Destroy;
begin
  FSampleXml.Free;
  FXML.Free;
  inherited Destroy;
end;


end.
