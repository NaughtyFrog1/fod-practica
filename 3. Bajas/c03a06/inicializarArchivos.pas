program inicializarArchivos;

const
  PATH_PRENDAS =   './data.prendas.bin';
  PATH_OBSOLETAS = './data.obsoletas.bin';
 
type
  String25 = String[25];
  
  TPrenda = record
    id:          Integer;
    descripcion: String;
    colores:     String25;
    tipo:        String25;
    stock:       Integer;
    precio:      Real
  end;

  FPrendas =     file of TPrenda;
  FObsoletas =   file of Integer;


procedure setPrenda(
  var f: FPrendas;
  id: Integer;
  tipo: String25;
  stock: Integer;
  precio: Real
);
var t: TPrenda;
begin
  t.id := id;
  t.descripcion := '';
  t.colores := '';
  t.tipo := tipo;
  t.stock := stock;
  t.precio := precio;
  Write(f, t);
end;

procedure cargarPrendas(var f: FPrendas);
begin
  Rewrite(f);
  setPrenda(f,   5,         'jean',   20,  100);
  setPrenda(f,   9,      'campera',   12,  100);
  setPrenda(f,   2,       'remera',    5,  100);
  setPrenda(f,  11,       'remera',   24,  100);
  setPrenda(f,   6,     'pantalon',   21,  100);
  setPrenda(f,   4,      'campera',    7,  100);
  setPrenda(f,  10,         'jean',   14,  100);
  setPrenda(f,   3,       'camisa',   20,  100);
  setPrenda(f,   8,     'pantalon',    3,  100);
  setPrenda(f,  12,     'pantalon',   17,  100);
  setPrenda(f,   1,     'pantalon',   13,  100);
  setPrenda(f,   7,       'remera',    1,  100);
  Close(f);
end;

procedure cargarObsoletas(var f: FObsoletas);
begin
  Rewrite(f);
  Write(f,  8);
  Write(f,  5);
  Write(f, 10);
  Write(f, 12);
  Write(f,  9);
  Write(f,  1);
  Write(f,  3);
  Close(f);
end;


var
  prendas: FPrendas;
  obsoletas: FObsoletas;
begin
  Assign(prendas, PATH_PRENDAS);
  Assign(obsoletas, PATH_OBSOLETAS);
  cargarPrendas(prendas);
  cargarObsoletas(obsoletas);
end.
