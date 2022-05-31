program inicializarArchivos;

const
  PATH_EMPLEADOS = './empleados.bin';

 
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


procedure agregarEmpleado(
  var f: FEmpleados;
  id: StringId;
  apellido: String25;
  nombre: String25;
  edad: Integer;
  dni: StringDni
);
var t: TEmpleado;
begin
  t.id := id;
  t.apellido := apellido;
  t.nombre := nombre;
  t.edad := edad;
  t.dni := dni;
  Write(f, t);
end;

var
  f: FEmpleados;
begin
  WriteLn('Generando empleados en: ', PATH_EMPLEADOS);
  Assign(f, PATH_EMPLEADOS);
  Rewrite(f);

  agregarEmpleado(f,  '0001',  'Lopez',     'Juan',      30,  '12345678');
  agregarEmpleado(f,  '0002',  'Perez',     'Juan',      72,  '00');
  agregarEmpleado(f,  '0003',  'Gomez',     'Jose',      30,  '12345678');
  agregarEmpleado(f,  '0004',  'Perez',     'Ricardo',   72,  '00');
  agregarEmpleado(f,  '0005',  'Garcia',    'Ignacio',   72,  '12345678');
  agregarEmpleado(f,  '0006',  'Romero',    'Mateo',     30,  '12345678');
  agregarEmpleado(f,  '0007',  'Sosa',      'Tomás',     30,  '00');
  agregarEmpleado(f,  '0008',  'Perez',     'Juan',      30,  '00');
  agregarEmpleado(f,  '0009',  'Garcia',    'Santiago',  72,  '12345678');
  agregarEmpleado(f,  '0010',  'Martinez',  'Thiago',    30,  '00');

  WriteLn('Empleados generados con éxito');
  WriteLn(#13#10);
  Close(f);

  listarEmpleados(f);
end.

{
  [x] Empleados con dni '00'
  [x] Empleados con apellido repetido  Perez y Garcia
  [x] Empleados con nombre repetido    Juan
  [x] Empleados mayores de 70          4
}