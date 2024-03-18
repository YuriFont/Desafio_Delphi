unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  REST.Types, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,

  uFormat;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Layout1: TLayout;
    Layout5: TLayout;
    Rectangle3: TRectangle;
    Image5: TImage;
    rectBusca: TRectangle;
    Label1: TLabel;
    edtCEP: TEdit;
    lblEndereco: TLabel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    MemTable: TFDMemTable;
    procedure edtCEPTyping(Sender: TObject);
    procedure rectBuscaClick(Sender: TObject);
    procedure edtCEPExit(Sender: TObject);
  private
    procedure ConsultarCEP(cep: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.edtCEPExit(Sender: TObject);
begin
    if SomenteNumero(edtCEP.Text) <> ''  then
        ConsultarCEP(edtCEP.Text);
end;

procedure TForm1.edtCEPTyping(Sender: TObject);
begin
    Formatar(edtCEP, TFormato.CEP);
end;

procedure TForm1.ConsultarCEP(cep: string);
begin
    if SomenteNumero(edtCEP.Text).Length <> 8 then
    begin
        ShowMessage('CEP inválido');
        exit;
    end;

    RESTRequest1.Resource := SomenteNumero(edtCEP.Text) + '/json';
    RESTRequest1.Execute;

    if RESTRequest1.Response.StatusCode = 200 then
    begin
        if RESTRequest1.Response.Content.IndexOf('erro') > 0 then
            ShowMessage('CEP não encontrado')
        else
        begin
            with MemTable do
            begin
                lblEndereco.Text := 'CEP: ' + FieldByName('cep').AsString + sLineBreak +
                                    'End: ' + FieldByName('logradouro').AsString + sLineBreak +
                                    'Compl: ' + FieldByName('complemento').AsString + sLineBreak +
                                    'Bairro: ' + FieldByName('bairro').AsString + sLineBreak +
                                    'Cidade: ' + FieldByName('localidade').AsString + sLineBreak +
                                    'UF: ' + FieldByName('uf').AsString + sLineBreak +
                                    'Cod. IBGE: ' + FieldByName('ibge').AsString;
            end;
        end;
    end
    else
        ShowMessage('Erro ao consultar CEP');
end;

procedure TForm1.rectBuscaClick(Sender: TObject);
begin
    ConsultarCEP(edtCEP.Text);
end;

end.
