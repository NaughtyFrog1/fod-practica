program c02a05;

uses sysutils;

const
  VALOR_CORTE =            9999;
  CANT_LOCALIDADES =       3;
  PATH_MAESTRO =           'data.maestro.bin';
  PATH_NACIMIENTOS =       'data.nacimientos';
  PATH_FALLECIMIENTOS =    'data.fallecimientos';
  PATH_TXT =               'data.maestro.txt';

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

  TMaestro = record
    nroPartida:            Integer;
    nombre:                String25;
    apellido:              String25;
    direccion:             TDireccion;
    matriculaMedNac:       Integer;
    madre:                 TPersona;
    padre:                 TPersona;
    matriculaMedFall:      Integer;
    fechaFall:             StringFecha;
    lugarFall:             String25;
  end;    

  FNacimientos =           file of TNacimiento;
  FFallecimientos =        file of TFallecimiento;
  FMaestro =               file of TMaestro;

  VNacimientos =           array[RLocalidades] of FNacimientos;
  VFallecimientos =        array[RLocalidades] of FFallecimientos;
  VRegsNacimientos =       array[RLocalidades] of TNacimiento;
  VRegsFallecimientos =    array[RLocalidades] of TFallecimiento;


//* OPERACIONES BÁSICAS SOBRE ARCHIVOS DE NACIMIENTOS

procedure assignNacimientos(var v: VNacimientos; path: String);
var i: RLocalidades;
begin
  for i := 1 to CANT_LOCALIDADES do Assign(v[i], path + IntToStr(i) + '.bin');
end;

procedure resetNacimientos(var v: VNacimientos);
var i: RLocalidades;
begin
  for i := 1 to CANT_LOCALIDADES do Reset(v[i]);
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

procedure resetFallecimientos(var v: VFallecimientos);
var i: RLocalidades;
begin
  for i := 1 to CANT_LOCALIDADES do Reset(v[i]);
end;

procedure closeFallecimientos(var v: VFallecimientos);
var i: RLocalidades;
begin
  for i := 1 to CANT_LOCALIDADES do Close(v[i]);
end;


//* HELPERS PARA NACIMIENTOS

procedure leer(var f: FNacimientos; var t: TNacimiento);
begin
  if (Eof(f)) then t.nroPartida := VALOR_CORTE else Read(f, t);
end;

procedure inicializar(var v: VNacimientos; var regs: VRegsNacimientos);
var i: RLocalidades;
begin
  for i := 1 to CANT_LOCALIDADES do leer(v[i], regs[i]);
end;

procedure getMinimo(
  var v: VNacimientos;
  var regs: VRegsNacimientos;
  var min: TNacimiento
);
var i, minPos: RLocalidades;
begin
  minPos := 1;
  for i := 2 to CANT_LOCALIDADES do begin
    if (regs[i].nroPartida < regs[minPos].nroPartida) then minPos := i;
  end;
  min := regs[minPos];
  leer(v[minPos], regs[minPos]);
end;


//* HELPERS PARA FALLECIMIENTOS

procedure leer(var f: FFallecimientos; var t: TFallecimiento);
begin
  if (Eof(f)) then t.nroPartida := VALOR_CORTE else Read(f, t);
end;

procedure inicializar(var v: VFallecimientos; var regs: VRegsFallecimientos);
var i: RLocalidades;
begin
  for i := 1 to CANT_LOCALIDADES do leer(v[i], regs[i]);
end;

procedure getMinimo(
  var v: VFallecimientos;
  var regs: VRegsFallecimientos;
  var min: TFallecimiento
);
var i, minPos: RLocalidades;
begin
  minPos := 1;
  for i := 2 to CANT_LOCALIDADES do begin
    if (regs[i].nroPartida < regs[minPos].nroPartida) then minPos := i;
  end;
  min := regs[minPos];
  leer(v[minPos], regs[minPos]);
end;


//* HELPERS PARA TXT

procedure escribir(var f: Text; t: TMaestro);
begin
  WriteLn(f, t.nroPartida);
  WriteLn(f, t.nombre);
  WriteLn(f, t.apellido);
  WriteLn(f, t.direccion.calle);
  WriteLn(f, t.direccion.numero);
  WriteLn(f, t.direccion.piso);
  WriteLn(f, t.direccion.dpto);
  WriteLn(f, t.direccion.ciudad);
  WriteLn(f, t.matriculaMedNac);
  WriteLn(f, t.madre.nombre);
  WriteLn(f, t.madre.apellido);
  WriteLn(f, t.madre.dni);
  WriteLn(f, t.padre.nombre);
  WriteLn(f, t.padre.apellido);
  WriteLn(f, t.padre.dni);
  WriteLn(f, t.matriculaMedFall);
  WriteLn(f, t.fechaFall);
  WriteLn(f, t.lugarFall);
  WriteLn(f);
end;


//* CONSIGNAS

procedure generarMaestro(
  var maestro: FMaestro;
  var nacimientos: VNacimientos;
  var fallecimientos: VFallecimientos
);
var
  regMaestro: TMaestro;
  regsNacimientos: VRegsNacimientos;
  regsFallecimientos: VRegsFallecimientos;
  minNacimiento: TNacimiento;
  minFallecimiento: TFallecimiento;
begin
  Rewrite(maestro);
  resetNacimientos(nacimientos);
  resetFallecimientos(fallecimientos);

  inicializar(nacimientos, regsNacimientos);
  inicializar(fallecimientos, regsFallecimientos);
  getMinimo(nacimientos, regsNacimientos, minNacimiento);
  getMinimo(fallecimientos, regsFallecimientos, minFallecimiento);

  while (minNacimiento.nroPartida <> VALOR_CORTE) do begin
    regMaestro.nroPartida :=           minNacimiento.nroPartida;
    regMaestro.nombre :=               minNacimiento.nombre;
    regMaestro.apellido :=             minNacimiento.apellido;
    regMaestro.direccion :=            minNacimiento.direccion;
    regMaestro.matriculaMedNac :=      minNacimiento.matriculaMedico;
    regMaestro.madre :=                minNacimiento.madre;
    regMaestro.padre :=                minNacimiento.padre;
    
    if (minFallecimiento.nroPartida = regMaestro.nroPartida) then begin
      regMaestro.matriculaMedFall :=   minFallecimiento.matriculaMedico;
      regMaestro.fechaFall :=          minFallecimiento.fecha;
      regMaestro.lugarFall :=          minFallecimiento.lugar;
      getMinimo(fallecimientos, regsFallecimientos, minFallecimiento);
    end else begin
      regMaestro.matriculaMedFall :=   -1;
      regMaestro.fechaFall :=          '-';
      regMaestro.lugarFall :=          '-';
    end;

    Write(maestro, regMaestro);
    getMinimo(nacimientos, regsNacimientos, minNacimiento);
  end;

  Close(maestro);
  closeNacimientos(nacimientos);
  closeFallecimientos(fallecimientos);
end;

procedure generarTxt(var txt: Text; var maestro: FMaestro);
var t: TMaestro;
begin
  Rewrite(txt); Reset(maestro);
  while (not Eof(maestro)) do begin
    Read(maestro, t);
    escribir(txt, t);
  end;
  Close(txt); Close(maestro);
end;


//* PROGRAMA PRPINCIPAL

var
  maestro: FMaestro;
  nacimientos: VNacimientos;
  fallecimientos: VFallecimientos;
  txt: Text;
begin
  Assign(maestro, PATH_MAESTRO);
  assignNacimientos(nacimientos, PATH_NACIMIENTOS);
  assignFallecimientos(fallecimientos, PATH_FALLECIMIENTOS);
  Assign(txt, PATH_TXT);

  WriteLn('Generando maestro...');
  generarMaestro(maestro, nacimientos, fallecimientos);
  WriteLn('Maestro generado...');

  WriteLn('Generando txt...');
  generarTxt(txt, maestro);
  WriteLn('Txt generado');
end.

{
  - Se perdieron las actas de nacimiento y fallecimiento.
  - Procesasr 2 archivos (actas nacimientos y actas fallecimientos) por cada
    una de las 50 delegaciones.
  - Crear el archivo maestro juntando información de ambos archivos.
  - Crear un archivo de texto con la información de cada persona.

  - Los archivos están ordenados por numero de partida de nacimiento.
  - Las personas pueden fallecer en un distrito distinto al de nacimiento.

  --

  [ ] 4 archivos
      [ ] nacimientos
          [x] T
          [x] F
          [x] V
          [x] VT
      [ ] fallecimientos
          [x] T
          [x] F
          [x] V
          [x] VT
      [ ] maestro
          [x] T
          [x] F
      [ ] maestro.txt
  
  [x] operaciones básicas para archivos nacimiento y fallecimiento
  [x] leer nacimiento y fallecimiento
  [x] inicializar nacimiento y fallecimiento
  [x] getMinimo nacimiento y fallecimiento
  [x] merge
  [ ] exportar a txt
}