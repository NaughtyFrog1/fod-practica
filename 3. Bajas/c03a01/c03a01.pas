program c03a01;

const
  VALOR_CORTE     =  'fin';
  PATH_EMPLEADOS  =  './empleados.bin';
  PATH_TODOS      =  './empleados_todos.txt';
  PATH_DNI_VACIO  =  './empleados_sin_dni.txt';


type
  StringOpcion = String[2];
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


//* HELPERS 

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

procedure cargarEmpleados(var f: FEmpleados);
var
  t: TEmpleado;
begin
    leerEmpleado(t);
  while (t.apellido <> VALOR_CORTE) do begin
    Write(f, t);
    leerEmpleado(t);
  end;
  WriteLn();
end;

procedure buscarEmpleadoPorId(
  var f: FEmpleados;
  var t: TEmpleado;
  id: StringId
);
begin
  Seek(f, 0);
  t.id := '-1';
  while ((not eof(f)) and (t.id <> id)) do Read(f, t);
  if (t.id = id) then Seek(f, FilePos(f) - 1);
end;

procedure writeEmpleado(var txt: Text; t: TEmpleado);
begin
  WriteLn(txt, t.id);
  WriteLn(txt, t.apellido);
  WriteLn(txt, t.nombre);
  WriteLn(txt, t.edad);
  WriteLn(txt, t.dni);
  WriteLn(txt);
end;


//* OPCIONES

// Opción 1
procedure crearArchivo(var f: FEmpleados);
begin
  Rewrite(f);
  cargarEmpleados(f);
  Close(f);
end;

// Opción 2
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

// Opción 3
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

// Opción 4
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

// Opción 5
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

// Opción 6
procedure agregarEmpleados(var f: FEmpleados);
begin
  Reset(f);
  Seek(f, FileSize(f));
  cargarEmpleados(f);
  Close(f);
end;

// Opción 7
procedure modificarEdadEmpleados(var f: FEmpleados);
var
  t: TEmpleado;
  id: StringId;
begin
  Reset(f);

  Write('id (-1 salir): '); ReadLn(id);
  WriteLn();
  while (id <> '-1') do begin
    buscarEmpleadoPorId(f, t, id);
    if (id <> t.id) then WriteLn('No se puedo encontrar al empleado')
    else begin
      imprimirEmpleado(t);
      Write('Nueva edad: '); ReadLn(t.edad);
      Write(f, t);
    end;
    WriteLn();
    Write('id (-1 salir): '); ReadLn(id);
    WriteLn();
  end;

  Close(f);
end;

// Opción 8
procedure exportarTodosLosEmpleados(var f: FEmpleados; var txt: Text);
var
  t: TEmpleado;
begin
  Reset(f); Rewrite(txt);
  while (not eof(f)) do begin
    Read(f, t);
    writeEmpleado(txt, t);
  end;  
  Close(f); Close(txt);
end;

// Opción 9
procedure exportarEmpleadosDniVacio(var f: FEmpleados; var txt: Text);
var
  t: TEmpleado;
begin
  Reset(f); Rewrite(txt);
  while (not eof(f)) do begin
    Read(f, t);
    if (t.dni = '00') then writeEmpleado(txt, t);
  end;  
  Close(f); Close(txt);
end;

// Opción 10
procedure eliminarEmpleadoPorId(var f: FEmpleados);
var
  t: TEmpleado;
  id: StringId;
  posEliminar: Integer;
begin
  Reset(f);
  WriteLn('Reset; FileSize: ', FileSize(f));

  Write('id: '); ReadLn(id); WriteLn();
  buscarEmpleadoPorId(f, t, id);

  if (eof(f)) then begin
    WriteLn('No se encontró ningún empleado con id ', id);
    Close(f);
  end
  else begin
    imprimirEmpleado(t);
    posEliminar := FilePos(f);

    Seek(f, FileSize(f) - 1);
    Read(f, t);
    
    Seek(f, posEliminar);
    Write(f, t);

    Seek(f, FileSize(f) - 1);
    Truncate(f);
  end;
end;


//* PROGRAMA PRINCIPAL

var
  empleados: FEmpleados;
  txtTodos, txtDniVacio: Text;
  opcion: StringOpcion;
begin
  Assign(empleados, PATH_EMPLEADOS);
  Assign(txtTodos, PATH_TODOS);
  Assign(txtDniVacio, PATH_DNI_VACIO);

  repeat
    WriteLn('Seleccione una opción:');
    WriteLn('   1. Crear archivo de empleados');
    WriteLn('   2. Listar empleados');
    WriteLn('   3. Listar empleados por nombre');
    WriteLn('   4. Listar empleados por apelldo');
    WriteLn('   5. Listar empleados mayores de 70 años');
    WriteLn('   6. Agregar nuevos empleados al final del archivo');
    WriteLn('   7. Modificar la edad de los empleados');
    WriteLn('   8. Exportar todos los empleados a ', PATH_TODOS);
    WriteLn('   9. Exportar empleados sin DNI a ', PATH_DNI_VACIO);
    WriteLn('  10. Eliminar empleado por id');
    WriteLn('   0. Salir');
    Write('> '); ReadLn(opcion);
    Write(#13#10#13#10#13#10);

    case opcion of
       '1': crearArchivo(empleados);
       '2': listarEmpleados(empleados);
       '3': listarEmpleadosPorNombre(empleados);
       '4': listarEmpleadosPorApellido(empleados);
       '5': listarEmpleadosMayoresDe(empleados, 70);
       '6': agregarEmpleados(empleados);
       '7': modificarEdadEmpleados(empleados);
       '8': exportarTodosLosEmpleados(empleados, txtTodos);
       '9': exportarEmpleadosDniVacio(empleados, txtDniVacio);
      '10': eliminarEmpleadoPorId(empleados);
       '0': WriteLn('Saliendo del programa...');
      else WriteLn('Opción inválida, elija una opción correcta');
    end;
  until opcion = '0';
end.

{
  [x] Agregar una opción para borrar.

  [ ] Buscar un registro a borrar.
  [ ] Copiar el registro de la última posición a la posición del registro a borrar
  [ ] Truncar el archivo en la posición del último registro para evitar duplicados
}
