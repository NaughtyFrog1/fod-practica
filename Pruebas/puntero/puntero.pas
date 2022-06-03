program puntero;

const
  PATH_NUMEROS = './data.numeros.bin';
  
 
type
  FNumeros = file of Integer;
  

// Opción 1
procedure crearNumeros(var f: FNumeros);
var n: Integer;
begin
  Rewrite(f);
  WriteLn('FileSize: ', FileSize(f));

  WriteLn('Agregar números: ');
  Write('> '); ReadLn(n);
  while (n <> -1) do begin
    Write(f, n);
    Write('> '); ReadLn(n);
  end;
  WriteLn();
  Close(f);
end;

// Opción 2
procedure imprimirNumeros(var f: FNumeros);
var n: Integer;
begin
  Reset(f);
  while (not Eof(f)) do begin
    Write('FilePos(', FilePos(f), '): ');
    Read(f, n);
    WriteLn(n);
  end;
  WriteLn('FilePos(', FilePos(f), '): EOF');
  WriteLn('FileSize: ', FileSize(f));
  Close(f);
end;

var
  numeros: FNumeros;
  opcion: Char;
begin
  Assign(numeros, PATH_NUMEROS);

  repeat
    WriteLn('Seleccione una opción');
    WriteLn('  1. Crear archivo');
    WriteLn('  2. Imprimir archivo');
    WriteLn('  0. Salir');
    Write('> '); ReadLn(opcion);
    WriteLn();
    WriteLn();

    case opcion of
      '1': crearNumeros(numeros);
      '2': imprimirNumeros(numeros);
      '0': WriteLn('Saliendo del programa');
      else WriteLn('Opción incorrecta');
    end;
  until opcion = '0';
end.

{
  FileSize = 0 cuando el archivo está vacío
}