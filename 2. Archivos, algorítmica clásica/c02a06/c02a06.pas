program c02a06;

uses sysutils;

const
  DF_DETALLES =                5;
  VALOR_CORTE =                9999;
  PATH_MAESTRO =               'data.maestro.bin';
  PATH_DETALLE =               'data.detalle';      // data.detalleNN.bin
 
type
  RDetalles =                  1..DF_DETALLES;
  String25 =                   String[25];

  TMaestro = record
    idLocalidad:               Integer;
    nombreLocalidad:           String25;
    idCepa:                    Integer;
    nombreCepa:                String25;
    activos:                   Integer;
    nuevos:                    Integer;
    recuperados:               Integer;
    fallecidos:                Integer;
  end;

  TDetalle = record
    idLocalidad:               Integer;
    idCepa:                    Integer;
    activos:                   Integer;
    nuevos:                    Integer;
    recuperados:               Integer;
    fallecidos:                Integer;
  end;

  FMaestro =                   file of TMaestro;
  FDetalle =                   file of TDetalle;

  VDetalles =                  array[RDetalles] of FDetalle;
  VRegsDetalles =              array[RDetalles] of TDetalle;


//* OPERACIONES BÁSICAS PARA VDETALLES

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

procedure leer(var f: FMaestro; var t: TMaestro);
begin
  if (Eof(f)) then t.idLocalidad := VALOR_CORTE else Read(f, t);
end;

procedure leer(var f: FDetalle; var t: TDetalle);
begin
  if (Eof(f)) then t.idLocalidad := VALOR_CORTE else Read(f, t);
end;

procedure inicializar(var v: VDetalles; var regs: VRegsDetalles);
var i: RDetalles;
begin
  for i := 1 to DF_DETALLES do leer(v[i], regs[i]);
end;

procedure getMinimo(
  var v: VDetalles;
  var regs: VRegsDetalles;
  var min: TDetalle
);
var i, minPos: RDetalles;
begin
  minPos := 1;
  for i := 2 to DF_DETALLES do begin
    if ((regs[i].idLocalidad < regs[minPos].idLocalidad) or (
      (regs[i].idLocalidad = regs[minPos].idLocalidad) and
      (regs[i].idCepa < regs[minPos].idCepa)
    )) then minPos := i;
  end;
  min := regs[minPos];
  leer(v[minPos], regs[minPos]);
end;


//* CONSIGNAS

procedure actualizarMaestro(var maestro: FMaestro; var detalles: VDetalles);
var
  regMaestro: TMaestro;
  regsDetalles: VRegsDetalles;
  min: TDetalle;
begin
  Reset(maestro); resetDetalles(detalles);

  Read(maestro, regMaestro);
  inicializar(detalles, regsDetalles);
  getMinimo(detalles, regsDetalles, min);

  while (min.idLocalidad <> VALOR_CORTE) do begin
    // Buscar localidad
    while (regMaestro.idLocalidad <> min.idLocalidad) do
      Read(maestro, regMaestro);
    
    // Actualizar localidad
    while (regMaestro.idLocalidad = min.idLocalidad) do begin
      // Buscar cepa
      while (
        (regMaestro.idLocalidad = min.idLocalidad) and
        (regMaestro.idCepa <> min.idCepa)
      ) do Read(maestro, regMaestro);

      // Actualizar cepa
      while (
        (regMaestro.idLocalidad = min.idLocalidad) and
        (regMaestro.idCepa = min.idCepa)
      ) do begin
        regMaestro.fallecidos += min.fallecidos;
        regMaestro.recuperados += min.recuperados;
        regMaestro.activos := min.activos;
        regMaestro.nuevos := min.nuevos;
        getMinimo(detalles, regsDetalles, min);
      end;

      // Escribir maestro
      Seek(maestro, FilePos(maestro) - 1);
      Write(maestro, regMaestro);
    end;
  end;

  Close(maestro); closeDetalles(detalles);
end;

procedure informarLocalidades(var maestro: FMaestro; cantCasos: Integer);
var
  regMaestro: TMaestro;
  cantCasosLocalidadActual: Integer;
  idLocalidadActual: Integer;
  nombreActual: String25;
begin
  Reset(maestro);

  leer(maestro, regMaestro);
  while (regMaestro.idLocalidad <> VALOR_CORTE) do begin
    idLocalidadActual := regMaestro.idLocalidad;
    nombreActual := regMaestro.nombreLocalidad;
    cantCasosLocalidadActual := 0;

    while (idLocalidadActual = regMaestro.idLocalidad) do begin
      cantCasosLocalidadActual += regMaestro.activos;
      leer(maestro, regMaestro);
    end;

    if (cantCasosLocalidadActual > cantCasos) then
      WriteLn(nombreActual, ': ', cantCasosLocalidadActual, ' casos')
  end;

  Close(maestro);
end;


//* PROGRAMA PRINCIPAL

var
  maestro: FMaestro;
  detallles: VDetalles;
  t: TMaestro;
begin
  Assign(maestro, PATH_MAESTRO);
  assignDetalles(detallles, PATH_DETALLE);

  actualizarMaestro(maestro, detallles);
  informarLocalidades(maestro, 50);
end.

{
  - Sistema de recuentos de casos de covid
  - Actualizar archivo maestro usando 10 detalles
  - Informar las localidades con más de 50 casos activos
  - Todos los archivos están ordenados por código de localidad y código de cepa

  [x] Archivo maestro
  [x] 10 archivos detalle

  [x] leer()
  [x] inicializar()
  [x] getMinimo()

  [ ] actualizarMaestro
  [ ] informar localidades con más de 50 casos
}