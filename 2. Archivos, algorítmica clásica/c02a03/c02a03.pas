program c02a03;

uses sysutils;

const
  PATH_PRODUCTOS = './data.productos.bin';
  PATH_VENTAS = './data.ventas';  // data.ventasN.bin
  PATH_PRODUCTOS_SIN_STOCK = './data.prodcutos_sin_stock.txt';
  DF_VENTAS = 5;
  VALOR_CORTE = 9999;
 
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
  VRegVentas = array[RVentas] of TVenta;


//* OPERACIONES BÁSICAS PARA VFVentas

procedure assignVentas(var v: VVentas; path: String);
var i: RVentas;
begin
  for i := 1 to DF_VENTAS do Assign(v[i], path + IntToStr(i) + '.bin');
end;

procedure resetVentas(var v: VVentas);
var i: RVentas;
begin
  for i := 1 to DF_VENTAS do Reset(v[i]);
end; 

procedure closeVentas(var v: VVentas);
var i: RVentas;
begin
  for i := 1 to DF_VENTAS do Close(v[i]);
end;


//* HELPERS

procedure leer(var f: FVentas; var t: TVenta);
begin
  if (eof(f)) then t.idProducto := VALOR_CORTE else Read(f, t);
end;

procedure inicializar(var v: VVentas; var t: VRegVentas);
var i: RVentas;
begin
  for i := 1 to DF_VENTAS do leer(v[i], t[i]);
end;

procedure getMinimo(
  var ventas: VVentas;
  var regVentas: VRegVentas;
  var min: TVenta
);
var i, minPos: RVentas;
begin
  minPos := 1;
  for i := 2 to DF_VENTAS do begin
    if (regVentas[i].idProducto < regVentas[minPos].idProducto) then 
      minPos := i;  
  end;
  min := regVentas[minPos];
  leer(ventas[minPos], regVentas[minPos]);
end;

procedure writeProducto(var f: Text; t: TProducto);
begin
  WriteLn(f, t.nombre);
  WriteLn(f, t.descripcion);
  WriteLn(f, t.stockDisp);
  WriteLn(f, t.precio:0:2);
  WriteLn(f);
end;

procedure imprimirMaestro(var f: FProductos);
var t: TProducto;
begin
  Reset(f);
  while (not eof(f)) do begin
    Read(f, t);
    Write('{');
    Write('id: ', t.id, ', ');
    Write('nombre: ', t.nombre, ', ');
    Write('descripcion: ', t.descripcion, ', ');
    Write('stockDisp: ', t.stockDisp, ', ');
    Write('stockMin: ', t.stockMin, ', ');
    Write('precio: ', t.precio:0:2);
    WriteLn('}')
  end;
  Close(f);
end;


//* CONSIGNAS

procedure actualizarMaestro(var productos: FProductos; var ventas: VVentas);
var
  regProducto: TProducto;
  regVentas: VRegVentas;
  min: TVenta;
begin
  Reset(productos); resetVentas(ventas);

  inicializar(ventas, regVentas);
  getMinimo(ventas, regVentas, min);
  while (min.idProducto <> VALOR_CORTE) do begin
    Read(productos, regProducto);
    while (regProducto.id <> min.idProducto) do Read(productos, regProducto);
    while (regProducto.id = min.idProducto) do begin
      regProducto.stockDisp -= min.cantidad;
      getMinimo(ventas, regVentas, min);
    end;

    Seek(productos, FilePos(productos) - 1);
    Write(productos, regProducto);
  end;

  Close(productos); closeVentas(ventas);
end;

procedure exportarProductosSinStock(
  var productos: FProductos;
  var txt: Text
);
var producto: TProducto;
begin
  Reset(productos); Rewrite(txt);
  while (not eof(productos)) do begin
    Read(productos, producto);
    if (producto.stockDisp < producto.stockMin) then 
      writeProducto(txt, producto);
  end;
  Close(productos); Close(txt);
end;


var
  productos: FProductos;
  ventas: VVentas;
  txt: Text;
begin
  Assign(productos, PATH_PRODUCTOS);
  assignVentas(ventas, PATH_VENTAS);
  Assign(txt, PATH_PRODUCTOS_SIN_STOCK);

  actualizarMaestro(productos, ventas);
  imprimirMaestro(productos);

  exportarProductosSinStock(productos, txt);
end.
