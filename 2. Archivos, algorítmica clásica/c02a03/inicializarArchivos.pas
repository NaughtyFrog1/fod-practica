program inicializarArchivos;

uses sysutils;

const
  PATH_PRODUCTOS = './data.productos.bin';
  PATH_VENTAS = './data.ventas';  // data.ventaN.bin
  DF_VENTAS = 5;
 
type
  String25 = String[25];
  RVentas = 1..DF_VENTAS;

  TProducto = record
    id: Integer;
    nombre: String25;
    descripcion: String;
    stockDisp: Integer;
    stockMin: Integer;
    precio: Real;
  end;

  TVenta = record
    idProducto: Integer;
    cantidad: Integer;
  end;

  FProductos = file of TProducto;  // Maestro
  FVentas = file of TVenta;        // Detalle

  VVentas = array[RVentas] of FVentas;


//* OPERACIONES BÁSICAS PARA VFVentas

procedure assignVentas(var v: VVentas; path: String);
var i: RVentas;
begin
  for i := 1 to DF_VENTAS do Assign(v[i], path + IntToStr(i) + '.bin');
end;

procedure rewriteVentas(var v: VVentas);
var i: RVentas;
begin
  for i := 1 to DF_VENTAS do Rewrite(v[i]);
end; 

procedure closeVentas(var v: VVentas);
var i: RVentas;
begin
  for i := 1 to DF_VENTAS do Close(v[i]);
end;


var
  productos: FProductos;
  ventas: VVentas;
  m: TProducto;
  d: TVenta;
  i: RVentas;
begin
  Assign(productos, PATH_PRODUCTOS); assignVentas(ventas, PATH_VENTAS);
  Rewrite(productos); rewriteVentas(ventas);

  for i := 1 to DF_VENTAS do begin
    m.id          := i;
    m.nombre      := 'Producto ' + IntToStr(i);
    m.descripcion := 'Esto es una descripción del producto ' + IntToStr(i);
    m.stockDisp   := 20;
    m.stockMin    := 10;
    m.precio      := i * 10;
    Write(productos, m);
  end;

  //* Generar información detalle 1
  d.idProducto := 3; d.cantidad := 3; Write(ventas[1], d);
  d.idProducto := 3; d.cantidad := 1; Write(ventas[1], d);
  d.idProducto := 3; d.cantidad := 4; Write(ventas[1], d);
  d.idProducto := 4; d.cantidad := 2; Write(ventas[1], d);
  d.idProducto := 5; d.cantidad := 1; Write(ventas[1], d);
  d.idProducto := 5; d.cantidad := 3; Write(ventas[1], d);

  //* Generar información detalle 2
  d.idProducto := 1; d.cantidad := 1; Write(ventas[2], d);
  d.idProducto := 1; d.cantidad := 6; Write(ventas[2], d);
  d.idProducto := 2; d.cantidad := 3; Write(ventas[2], d);
  d.idProducto := 4; d.cantidad := 6; Write(ventas[2], d);

  //* Generar información detalle 3
  d.idProducto := 2; d.cantidad := 2; Write(ventas[3], d);
  d.idProducto := 2; d.cantidad := 2; Write(ventas[3], d);
  d.idProducto := 3; d.cantidad := 4; Write(ventas[3], d);
  d.idProducto := 4; d.cantidad := 1; Write(ventas[3], d);

  //* Generar información detalle 4
  d.idProducto := 2; d.cantidad := 4; Write(ventas[4], d);

  //* Generar información detalle 5
  d.idProducto := 1; d.cantidad := 6; Write(ventas[5], d);

  Close(productos); closeVentas(ventas);
end.
