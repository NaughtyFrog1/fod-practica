program inicializarArchivos;

uses sysutils;

const
  VALOR_CORTE =            9999;
  CANT_LOCALIDADES =       3;
  PATH_NACIMIENTOS =       'data.nacimientos';
  PATH_FALLECIMIENTOS =    'data.fallecimientos';

type
  RLocalidades =           1..CANT_LOCALIDADES;

  String25 =               String[25];
  StringDni =              String[8];
  StringFecha =            String[16];  // YYYY-MM-DD HH:MM

  TPersona = record
    nombre:                String25;
    apellido:              String25;
    dni:                   StringDni;
  end;

  TDireccion = record
    calle:                 String25;
    numero:                Integer;
    piso:                  Integer;
    dpto:                  Char;
    ciudad:                String25;
  end;

  TNacimiento = record
    nroPartida:            Integer;
    nombre:                String25;
    apellido:              String25;
    direccion:             TDireccion;
    matriculaMedico:       Integer;
    madre:                 TPersona;
    padre:                 TPersona;
  end;

  TFallecimiento = record
    nroPartida:            Integer;
    dni:                   StringDni;
    nombre:                String25;
    apellido:              String25;
    matriculaMedico:       Integer;
    fecha:                 StringFecha;
    lugar:                 String25;
  end;

  FNacimientos =           file of TNacimiento;
  FFallecimientos =        file of TFallecimiento;

  VNacimientos =           array[RLocalidades] of FNacimientos;
  VFallecimientos =        array[RLocalidades] of FFallecimientos;


//* OPERACIONES BÁSICAS SOBRE ARCHIVOS DE NACIMIENTOS

procedure assignNacimientos(var v: VNacimientos; path: String);
var i: RLocalidades;
begin
  for i := 1 to CANT_LOCALIDADES do Assign(v[i], path + IntToStr(i) + '.bin');
end;

procedure rewriteNacimientos(var v: VNacimientos);
var i: RLocalidades;
begin
  for i := 1 to CANT_LOCALIDADES do Rewrite(v[i]);
end;

procedure closeNacimientos(var v: VNacimientos);
var i: RLocalidades;
begin
  for i := 1 to CANT_LOCALIDADES do Close(v[i]);
end;


//* OPERACIONES BASICAS PARA ARCHIVOS DE FALLECIMIENTOS

procedure assignFallecimientos(var v: VFallecimientos; path: String);
var i: RLocalidades;
begin
  for i := 1 to CANT_LOCALIDADES do Assign(v[i], path + IntToStr(i) + '.bin');
end;

procedure rewriteFallecimientos(var v: VFallecimientos);
var i: RLocalidades;
begin
  for i := 1 to CANT_LOCALIDADES do Rewrite(v[i]);
end;

procedure closeFallecimientos(var v: VFallecimientos);
var i: RLocalidades;
begin
  for i := 1 to CANT_LOCALIDADES do Close(v[i]);
end;


//* GENERAR NACIMIENTOS

function getNacimiento(
  nroPartida:              Integer;
  nombre:                  String25;
  apellido:                String25;
  ciudad:                  String25
): TNacimiento;
var
  padre, madre: TPersona;
  dir: TDireccion;
  t: TNacimiento;
begin
  padre.nombre :=          'John';
  padre.apellido :=        'Doe';
  padre.dni :=             '12345678';

  madre.nombre :=          'Foo';
  madre.apellido :=        'Bar';
  madre.dni :=             '23456789';

  dir.calle :=             'Una Calle';
  dir.numero :=            1234;
  dir.piso :=              4;
  dir.dpto :=              'C';
  dir.ciudad :=            ciudad;

  t.nroPartida :=          nroPartida;
  t.nombre :=              nombre;
  t.apellido :=            apellido;
  t.direccion :=           dir;
  t.matriculaMedico :=     123;
  t.madre :=               madre;
  t.padre :=               padre;

  getNacimiento := t;
end;

procedure generarNacimientos(var v: VNacimientos);
begin
  rewriteNacimientos(v);

  Write(v[1], getNacimiento( 1, 'Juan',    'Perez',    'La Plata'));
  Write(v[1], getNacimiento( 2, 'Pedro',   'Gonzalez', 'La Plata'));
  Write(v[1], getNacimiento( 5, 'Julia',   'Gomez',    'La Plata'));
  Write(v[1], getNacimiento( 8, 'Juana',   'Miranda',  'La Plata'));
  Write(v[1], getNacimiento(12, 'Micaela', 'Jose',     'La Plata'));

  Write(v[2], getNacimiento( 3, 'Marcelo', 'Mercado', 'San Martin'));
  Write(v[2], getNacimiento( 6, 'Adrian',  'Costa',   'San Martin'));
  Write(v[2], getNacimiento( 7, 'Ana',     'Carmen',  'San Martin'));

  Write(v[3], getNacimiento( 4, 'Camilo', 'Sesto',  'Mar del Plata'));
  Write(v[3], getNacimiento( 9, 'Thom',   'Yorke',  'Mar del Plata'));
  Write(v[3], getNacimiento(10, 'Julian', 'Casas',  'Mar del Plata'));
  Write(v[3], getNacimiento(11, 'Andres', 'Koller', 'Mar del Plata'));

  closeNacimientos(v);
end;


//* GENERAR FALLECIMIENTOS

function getFallecimiento(
  nroPartida:              Integer;
  fecha:                   StringFecha;
  lugar:                   String25
): TFallecimiento;
var t: TFallecimiento;
begin
  t.nroPartida :=          nroPartida;
  t.dni :=                 '12345678';
  t.nombre :=              '';
  t.apellido :=            '';
  t.matriculaMedico :=     321;
  t.fecha :=               fecha;
  t.lugar :=               lugar;

  getFallecimiento := t;
end;

procedure generarFallecimientos(var v: VFallecimientos);
begin
  rewriteFallecimientos(v);

  // 2, 3, 5, 6, 8, 11, 12 

  Write(v[1], getFallecimiento( 2, '2020-05-27 12:45:00', 'La Plata'));
  Write(v[1], getFallecimiento( 6, '2021-07-12 16:42:00', 'La Plata'));
  Write(v[1], getFallecimiento( 8, '2019-02-06 04:20:00', 'La Plata'));

  Write(v[2], getFallecimiento( 5, '2022-03-21 19:24:00', 'San Martin'));
  Write(v[2], getFallecimiento(12, '2019-02-06 13:12:00', 'San Martin'));

  Write(v[3], getFallecimiento( 3, '2019-02-06 13:12:00', 'Mar del Plata'));
  Write(v[3], getFallecimiento(10, '2019-02-06 13:12:00', 'Mar del Plata'));
  Write(v[3], getFallecimiento(11, '2019-02-06 13:12:00', 'Mar del Plata'));

  closeFallecimientos(v);
end;


//* PROGRAMA PRPINCIPAL

var
  nacimientos: VNacimientos;
  fallecimientos: VFallecimientos;
begin
  assignNacimientos(nacimientos, PATH_NACIMIENTOS);
  assignFallecimientos(fallecimientos, PATH_FALLECIMIENTOS);

  generarNacimientos(nacimientos);
  generarFallecimientos(fallecimientos);
end.

