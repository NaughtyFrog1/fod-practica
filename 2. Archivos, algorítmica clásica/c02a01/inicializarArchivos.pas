program inicializarArchivos;

const
  PATH_DETALLE = 'data.detalle.bin';
 
type
  String25 = String[25];

  TComision = record
    id: Integer;
    nombre: String25;
    comision: Real;
  end;

  FComisiones = file of TComision;


procedure imprimirComisiones(var f: FComisiones);
var
  t: TComision;
begin
  Reset(f);
  while (not eof(f)) do begin
    Read(f, t);
    WriteLn(
      '{ id: ', t.id, 
      ', nombre: ', t.nombre, 
      ', comision: ', t.comision:0:2, 
      ' }'
    );
  end;
  WriteLn();
  Close(f);
end;


procedure agregarComision(
  var f: FComisiones;
  id: Integer;
  nombre: String25;
  comision: Real
);
var
  t: TComision;
begin
  t.id := id;
  t.nombre := nombre;
  t.comision := comision;
  Write(f, t);
end;


var
  detalle: FComisiones;
begin
  Assign(detalle, PATH_DETALLE);
  Rewrite(detalle);

  agregarComision(detalle,  1,  'John Doe',        25);
  agregarComision(detalle,  1,  'John Doe',        100);
  agregarComision(detalle,  1,  'John Doe',        50);

  agregarComision(detalle,  2,  'Foo Bar',         45);
  agregarComision(detalle,  2,  'Foo Bar',         80);

  agregarComision(detalle,  3,  'Cesar Gonzalez',  80);

  agregarComision(detalle,  4,  'Juan Merluso',    60);
  agregarComision(detalle,  4,  'Juan Merluso',    100);

  Close(detalle);

  imprimirComisiones(detalle);
end.
