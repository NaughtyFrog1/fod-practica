program inicializarArchivos;

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


//* OPERACIONES BÀSICAS PARA VDETALLES

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

procedure rewriteDetalles(var v: VDetalles);
var i: RDetalles;
begin
  for i := 1 to DF_DETALLES do Rewrite(v[i]);
end;

procedure closeDetalles(var v: VDetalles);
var i: RDetalles;
begin
  for i := 1 to DF_DETALLES do Close(v[i]);
end;


//* GENERAR MAESTRO

function getMaestro(
  idLocalidad, idCepa, recuperados, fallecidos: Integer
): TMaestro;
var t: TMaestro;
begin
  t.idLocalidad := idLocalidad;
  t.nombreLocalidad := 'Localidad ' + IntToStr(idLocalidad);
  t.idCepa := idCepa;
  t.nombreCepa := 'Cepa ' + IntToStr(idCepa);
  t.activos := -1;
  t.nuevos := -1;
  t.recuperados := recuperados;
  t.fallecidos := fallecidos;
  getMaestro := t;
end;

procedure generarMaestro(var f: FMaestro);
begin
  Rewrite(f);

  Write(   f, getMaestro(    1,    1,  100,   10));
  Write(   f, getMaestro(    1,    2,  100,   10));
  Write(   f, getMaestro(    1,    3,  100,   10));

  Write(   f, getMaestro(    2,    3,  100,   10));

  Write(   f, getMaestro(    3,    1,  100,   10));
  Write(   f, getMaestro(    3,    2,  100,   10));
  Write(   f, getMaestro(    3,    3,  100,   10));

  Write(   f, getMaestro(    4,    2,  100,   10));
  Write(   f, getMaestro(    4,    3,  100,   10));

  Write(   f, getMaestro(    5,    1,  100,   10));

  Close(f);
end;


//* GENERAR DETALLES

function getDetalle(
  idLocalidad, idCepa, recuperados, fallecidos: Integer
): TDetalle;
var t: TDetalle;
begin
  t.idLocalidad := idLocalidad;
  t.idCepa := idCepa;
  t.activos := idLocalidad * idCepa * 10;
  t.nuevos := idLocalidad * idCepa;
  t.recuperados := recuperados;
  t.fallecidos := fallecidos;
  getDetalle := t;
end;

procedure generarDetalles(var v: VDetalles);
begin
  rewriteDetalles(v);

  Write(v[1], getDetalle(    2,    3,   20,    2));
  Write(v[1], getDetalle(    3,    2,   10,    1));
  Write(v[1], getDetalle(    3,    2,   15,    3));
  Write(v[1], getDetalle(    3,    2,    5,    1));
  Write(v[1], getDetalle(    4,    2,   25,    5));

  Write(v[2], getDetalle(    4,    2,   30,    10));

  Write(v[3], getDetalle(    1,    1,   30,    10));

  closeDetalles(v);
end;




//* PROGRAMA PRINCIPAL

var
  maestro: FMaestro;
  detallles: VDetalles;
  t: TDetalle;
  i: RDetalles;
begin
  Assign(maestro, PATH_MAESTRO);
  assignDetalles(detallles, PATH_DETALLE);

  generarMaestro(maestro);
  generarDetalles(detallles);

  resetDetalles(detallles);
  for i := 1 to DF_DETALLES do begin
    WriteLn('# ARCHIVO ', i);
    while (not eof(detallles[i])) do begin
      Read(detallles[i], t);
      WriteLn('idLocalidad: ', t.idLocalidad);
      WriteLn('idCepa: ', t.idCepa);
      WriteLn('activos: ', t.activos);
      WriteLn('nuevos: ', t.nuevos);
      WriteLn('recuperados: ', t.recuperados);
      WriteLn('fallecidos: ', t.fallecidos);
      WriteLn();
    end;
    WriteLn();
  end;
  closeDetalles(detallles);
end.
