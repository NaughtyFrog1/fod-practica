program c01a03;

const
  VALOR_CORTE = 'fin';
 
type
  StringId = String[4];
  String25 = String[25];
  StringDni = String[8];

  TEmpleado = record
    id: StringId;
    apellido: String25;
    nombre: String25;
    edad: Integer;
    dni: StringDni;
  end;

  FEmpleados = file of TEmpleado;


procedure leerEmpleado(var t: TEmpleado);
begin
  Write('Apellido: '); ReadLn(t.apellido);
  if (t.apellido <> VALOR_CORTE) then begin
    Write('Nombre  : '); ReadLn(t.nombre);
    Write('id      : '); ReadLn(t.id);
    Write('edad    : '); ReadLn(t.edad);
    Write('DNI     : '); ReadLn(t.dni);
  end;
  WriteLn();
end;


procedure imprimirEmpleado(t: TEmpleado);
begin
  Write('{ ');
  Write('id: ', t.id, ', ');
  Write('apellido: ', t.apellido, ', ');
  Write('nombre: ', t.nombre, ', ');
  Write('edad: ', t.edad, ', ');
  Write('dni: ', t.dni);
  Write(' }');
  WriteLn();
end;


procedure crearArchivo(var f: FEmpleados);
var
  t: TEmpleado;
begin
  Rewrite(f);
  leerEmpleado(t);
  while (t.apellido <> VALOR_CORTE) do begin
    Write(f, t);
    leerEmpleado(t);
  end;
  WriteLn();
  Close(f);
end;


procedure listarEmpleadosPorNombre(var f: FEmpleados);
var
  empleado: TEmpleado;
  nombre: String25;
begin
  Write('Buscar empleado por nombre: '); ReadLn(nombre);
  Reset(f);
  while (not eof(f)) do begin
    Read(f, empleado);
    if (empleado.nombre = nombre) then imprimirEmpleado(empleado);
  end;
  WriteLn();
  Close(f);
end;


procedure listarEmpleadosPorApellido(var f: FEmpleados);
var
  empleado: TEmpleado;
  apellido: String25;
begin
  Write('Buscar empleado por apellido: '); ReadLn(apellido);
  Reset(f);
  while (not eof(f)) do begin
    Read(f, empleado);
    if (empleado.apellido = apellido) then imprimirEmpleado(empleado);
  end;
  WriteLn();
  Close(f);
end;


procedure listarEmpleadosMayoresDe(var f: FEmpleados; edad: Integer);
var
  empleado: TEmpleado;
begin
  Reset(f);
  while (not eof(f)) do begin
    Read(f, empleado);
    if (empleado.edad > edad) then imprimirEmpleado(empleado);
  end;
  WriteLn();
  Close(f);
end;


procedure listarEmpleados(var f: FEmpleados);
var
  empleado: TEmpleado;
begin
  Reset(f);
  while (not eof(f)) do begin
    Read(f, empleado);
    imprimirEmpleado(empleado);
  end;
  WriteLn();
  Close(f);
end;


var
  empleados: FEmpleados;
  pathEmpleados: String;
  opcion: Char;
begin
  Write('Ingrese la ruta del archivo: '); ReadLn(pathEmpleados);
  Assign(empleados, pathEmpleados);

  repeat
    WriteLn('Seleccione una opción:');
    WriteLn('  1. Crear archivo de empleados');
    WriteLn('  2. Listar empleados');
    WriteLn('  3. Listar empleados por nombre');
    WriteLn('  4. Listar empleados por apelldo');
    WriteLn('  5. Listar empleados mayores de 70 años');
    WriteLn('  0. Salir');
    Write('> '); ReadLn(opcion);
    Write(#13#10#13#10#13#10);

    case opcion of
      '1': crearArchivo(empleados);
      '2': listarEmpleados(empleados);
      '3': listarEmpleadosPorNombre(empleados);
      '4': listarEmpleadosPorApellido(empleados);
      '5': listarEmpleadosMayoresDe(empleados, 70);
      '0': WriteLn('Saliendo del programa...');
      else WriteLn('Opción inválida, elija una opción correcta');
    end;
  until opcion = '0';
end.

{
  [x] Menu de opciones para:
      [x] Crear archivo de empleados no ordenado
      [x] Listar los datos de empleados con un nombre o apellido determinado
      [x] Listar los empleados
      [x] Listar los empleados mayores a 70 años
  [x] Proporcionar el nombre del archivo

  ---

  [x] TEmpleado
  [x] FEmpleados
  [x] crearArchivo()
  [x] listarEmpleadosPorNombre()
  [x] listarEmpleadosPorApellido()
  [x] listarEmpleados()
  [x] listarEmpleadosMayoresDe70()
  [x] imprimirEmpleado()
  [x] leerEmpleado()
}