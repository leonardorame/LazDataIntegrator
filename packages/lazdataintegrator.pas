{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazDataIntegrator;

interface

uses
  DataSetInputAdaptor, tree, frmDataTree, XMLOutputAdaptor, FileOutputAdaptor, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('DataSetInputAdaptor', @DataSetInputAdaptor.Register);
  RegisterUnit('XMLOutputAdaptor', @XMLOutputAdaptor.Register);
end;

initialization
  RegisterPackage('lazDataIntegrator', @Register);
end.
