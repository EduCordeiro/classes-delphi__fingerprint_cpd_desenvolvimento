unit udatatypes_apps;

{Unit que centraliza os tipos de dados customizados.}

interface

uses
  SysUtils, Variants, Classes;

type


  {OBS.: Se precisar retornar vários dados no campo "mensagem",
   usar "JSON" como retorno. }
  RActionReturn = record
    sucesso: boolean;
    mensagem: AnsiString;
  end;

  ETipoLog = (Normal, Warning, Erro, Debug);

  ESistemaOperacional = (soWindows, soLinux);

  EClassesCaracteresASCII = (asControle, asPontuacao, asMatematica, asAcentuacao, asNumeros,
   asCaracteres, asCaracteresAcentuados, asSimbolos, asGraficos);

  aDynamicStringArray = array of array of AnsiString;

  aString      = array of string;
  TStringArray = array of string;

  aStringArray = array of AnsiString;

  EDatasetModes = (Browsing, Editing, Inserting);

  EFileStreamAddMode = (amAppend, amRewrite);

  ESQLOperations = (sopInsert, sopUpdate, sopDelete,
   sopSelect, sopSelectIntoOutfile, sopLoadDataInfile,
   sopCreateTable, sopCreateDatabase, sopCreateIndex, sopShow,
   sopDescribe, sopProcedure, sopTrigger, sopUnknown);

  EModosExecucaoProgramas = (meDesenvolvimento, meProducao, meTestes); 

  RJSONKeyPositions = record
    nome_chave: array of string;
    posicao: array of integer;
  end;

  RInfoArquivo = record
    Nome: array of string;
    Tamanho: array of double;
    Path: array of string;
  end;

  RIni = record
    path_conexoes : string;
    path_configuracoes : string;
    path_arquivos_temporarios : string;
    path_scripts_sql : string;
    path_outros_recursos : string;
  end;

  RDatabaseProperties = record
    Name: string;
    Host: string;
    User: string;
    Password: string;
    protocolo : string;
  end;

  RListaDeBases = array of RDatabaseProperties;

  RValidationErrorsList = record
    ids: array of string;
    messages: array of string;
    sltListaDeErros : TStringList;
  end;

  RValidationResult = record
    valid: boolean;
    validationErrorsList: RValidationErrorsList;
  end;

  RFile = record
    Tamanho: double;
    Unidade: string;
  end;

implementation



end.

