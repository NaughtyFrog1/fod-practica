program c01a01;

type
  FEnteros = file of Integer;


procedure leerNumero(var n: Integer);
begin
  Write('> '); ReadLn(n);
end;


var
  enteros: FEnteros;
  pathEnteros: String;
  numero: Integer;
begin
  Write('Ingrese la ruta del archivo: '); ReadLn(pathEnteros);
  Assign(enteros, pathEnteros);
  Rewrite(enteros);

  leerNumero(numero);
  while (numero <> 30000) do begin
    Write(enteros, numero);
    leerNumero(numero);
  end;

  Close(enteros);
end.
