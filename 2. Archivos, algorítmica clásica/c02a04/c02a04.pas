program c02a04;

uses sysutils;

const
  DF_DETALLES = 5;
  VALOR_CORTE = 9999;
  PATH_MAESTRO = './data.maestro.bin';
  PATH_DETALLE = './data.detalle';      // data.detalleN.bin
  
type
  RDetalles = 1..DF_DETALLES;
  StringDate = String[10];  // YYYY-MM-DD

  TDetalle = record
    idUsuario: Integer;
    fecha: StringDate;
    tiempoSesion: Integer;
  end;

  TMaestro = record
    idUsuario: Integer;
    fecha: StringDate;
    totalTiempoSesiones: Integer;
  end;

  FMaestro = file of TMaestro;
  FDetalle = file of TDetalle;
  VDetalles = array[RDetalles] of FDetalle;
  VRegsDetalles = array[RDetalles] of TDetalle;


//* OPERACIONES BÁSICAS PARA DETALLES

procedure assignDetalles(var v: VDetalles; path: String);
var i: RDetalles;
begin
  for i := 1 to DF_DETALLES do Assign(v[i], path + IntToStr(i) + '.bin');
end;

procedure resetDetalles(var v: VDetalles);
var i: RDetalles;
begin
  for i := 1 to DF_DETALLES do Reset(v[i]);
end;

procedure closeDetalles(var v: VDetalles);
var i: RDetalles;
begin
  for i := 1 to DF_DETALLES do Close(v[i]);
end;


//* HELPERS

procedure leer(var f: FDetalle; var t: TDetalle);
begin
  if (Eof(f)) then t.idUsuario := VALOR_CORTE else Read(f, t);
end;

procedure inicializarDetalles(var v: VDetalles; var regs: VRegsDetalles);
var i: RDetalles;
begin
  for i := 1 to DF_DETALLES do Read(v[i], regs[i]);
end;

procedure getMinimo(
  var detalles: VDetalles;
  var regs: VRegsDetalles;
  var min: TDetalle
);
var i, minPos: RDetalles;
begin
  minPos := 1;
  for i := 2 to DF_DETALLES do
    if (
      (regs[i].idUsuario < regs[minPos].idUsuario) or (
        (regs[i].idUsuario = regs[minPos].idUsuario) and
        (regs[i].fecha < regs[minPos].fecha)
    )) then minPos := i;
  min := regs[minPos];
  leer(detalles[minPos], regs[minPos]);
end;


//* CONSIGNAS

procedure mergeDetalles(var maestro: FMaestro; var detalles: VDetalles);
var
  regMaestro: TMaestro;
  regsDetalles: VRegsDetalles;
  min: TDetalle;
begin
  Rewrite(maestro); resetDetalles(detalles);

  inicializarDetalles(detalles, regsDetalles);
  getMinimo(detalles, regsDetalles, min);
  while (min.idUsuario <> VALOR_CORTE) do begin
    regMaestro.idUsuario := min.idUsuario;
    regMaestro.fecha := min.fecha;
    regMaestro.totalTiempoSesiones := 0;
    while (regMaestro.fecha = min.fecha) do begin
      regMaestro.totalTiempoSesiones += min.tiempoSesion;
      getMinimo(detalles, regsDetalles, min);
    end;
    Write(maestro, regMaestro);
  end;

  Close(maestro); closeDetalles(detalles);  
end;


//* PRUEBAS

procedure imprimir(var f: FMaestro);
var t: TMaestro;
begin
  Reset(f);
  while (not Eof(f)) do begin
    Read(f, t);
    Write('{ ');
    Write('idUsuario: ', t.idUsuario, ', ');
    Write('fecha: ', t.fecha, ', ');
    Write('totalTiempoSesiones: ', t.totalTiempoSesiones);
    WriteLn(' }');
  end;
  WriteLn();
  Close(f);
end;


var
  maestro: FMaestro;
  detalles: VDetalles;
begin
  Assign(maestro, PATH_MAESTRO);
  assignDetalles(detalles, PATH_DETALLE);

  mergeDetalles(maestro, detalles);
  imprimir(maestro);
end.

{
  [x] TMaestro
  [x] TDetalle
  [x] FMaestro
  [x] FDetalle
  [x] VDetalles
  [x] VRegsDetalles
  
  [x] Operaciones básicas para detalles
      [x] assign
      [x] reset
      [x] close
  [x] mergeDetalles
      [x] leer
      [x] inicializarReg
      [x] getMinimo
      [x] merge
}