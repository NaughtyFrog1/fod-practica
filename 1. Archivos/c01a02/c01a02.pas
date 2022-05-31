program c01a02;
 
type
  FEnteros = file of Integer;
  

procedure procesar(
  var f: FEnteros;
  var cantMenores1500: Integer;
  var promedio: Real
);
var
  entero: Integer;
  sumaNumeros: Integer;
begin
  cantMenores1500 := 0;
  sumaNumeros := 0;

  Reset(f);
  while (not eof(f)) do begin
    Read(f, entero);
    if (entero < 1500) then cantMenores1500 += 1;
    sumaNumeros += entero;
    Write(entero, ' ');
  end;
  WriteLn();
  promedio := sumaNumeros / FileSize(f);
  Close(f);
end;


var
  enteros: FEnteros;
  pathEnteros: String;
  cantMenores1500: Integer;
  promedio: Real;
begin
  Write('Ingrese la ruta del archivo: '); ReadLn(pathEnteros);
  Assign(enteros, pathEnteros);
  procesar(enteros, cantMenores1500, promedio);
  WriteLn('Menores a 1500: ', cantMenores1500);
  WriteLn('Promedio: ', promedio:0:2);
end.

{
  [x] Utilizando el archivo del punto 1
  [x] Ingresar el nombre del archivo
  [x] Informar la cantidad de numeros menores a 1500
  [x] Informar el promedio de los numeros ingresados
  [x] Listar el contenido del archivo en pantalla
}