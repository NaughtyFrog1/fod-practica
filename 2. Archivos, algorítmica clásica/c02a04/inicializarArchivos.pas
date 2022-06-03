program inicializarArchivos;

uses sysutils;

const
  DF_DETALLES = 5;
  VALOR_CORTE = 9999;
  PATH_DETALLE = './data.detalle';      // data.detalleN.bin
  
type
  RDetalles = 1..DF_DETALLES;
  StringDate = String[10];  // YYYY-MM-DD

  TDetalle = record
    idUsuario: Integer;
    fecha: StringDate;
    tiempoSesion: Integer;
  end;

  FDetalle = file of TDetalle;
  VDetalles = array[RDetalles] of FDetalle;


//* OPERACIONES BÁSICAS PARA DETALLES

procedure assignDetalles(var v: VDetalles; path: String);
var i: RDetalles;
begin
  for i := 1 to DF_DETALLES do Assign(v[i], path + IntToStr(i) + '.bin');
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


var
  v: VDetalles;
  t: TDetalle;
begin
  assignDetalles(v, PATH_DETALLE);
  rewriteDetalles(v);

  // Detalle 1
  t.idUsuario := 1; t.fecha := '2022-01-14'; t.tiempoSesion := 10; Write(v[1], t);
  t.idUsuario := 1; t.fecha := '2022-01-19'; t.tiempoSesion := 10; Write(v[1], t);
  t.idUsuario := 3; t.fecha := '2022-01-14'; t.tiempoSesion := 10; Write(v[1], t);
  t.idUsuario := 4; t.fecha := '2022-01-16'; t.tiempoSesion := 10; Write(v[1], t);
  t.idUsuario := 4; t.fecha := '2022-01-24'; t.tiempoSesion := 10; Write(v[1], t);

  // Detalle 2
  t.idUsuario := 1; t.fecha := '2022-01-14'; t.tiempoSesion := 10; Write(v[2], t);
  t.idUsuario := 2; t.fecha := '2022-01-16'; t.tiempoSesion := 10; Write(v[2], t);
  t.idUsuario := 2; t.fecha := '2022-01-17'; t.tiempoSesion := 10; Write(v[2], t);
  t.idUsuario := 4; t.fecha := '2022-01-23'; t.tiempoSesion := 10; Write(v[2], t);
  t.idUsuario := 5; t.fecha := '2022-01-14'; t.tiempoSesion := 10; Write(v[2], t);
  
  // Detalle 3
  t.idUsuario := 3; t.fecha := '2022-01-10'; t.tiempoSesion := 10; Write(v[3], t);
  t.idUsuario := 3; t.fecha := '2022-01-27'; t.tiempoSesion := 10; Write(v[3], t);
  t.idUsuario := 4; t.fecha := '2022-01-10'; t.tiempoSesion := 10; Write(v[3], t);
  t.idUsuario := 4; t.fecha := '2022-01-17'; t.tiempoSesion := 10; Write(v[3], t);
  t.idUsuario := 5; t.fecha := '2022-01-25'; t.tiempoSesion := 10; Write(v[3], t);

  // Detalle 4
  t.idUsuario := 1; t.fecha := '2022-01-19'; t.tiempoSesion := 10; Write(v[4], t);
  t.idUsuario := 3; t.fecha := '2022-01-14'; t.tiempoSesion := 10; Write(v[4], t);
  t.idUsuario := 5; t.fecha := '2022-01-14'; t.tiempoSesion := 10; Write(v[4], t);

  // Detalle 5
  t.idUsuario := 4; t.fecha := '2022-01-16'; t.tiempoSesion := 10; Write(v[5], t);
  t.idUsuario := 4; t.fecha := '2022-01-16'; t.tiempoSesion := 10; Write(v[5], t);

  closeDetalles(v);
end.
