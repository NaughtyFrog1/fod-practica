program inicializarArchivos;

const
  PATH_DISTRIBUCIONES = './data.distribuciones.bin';
 
type
  String25 = String[25];
  StringKernel = String[8];

  TDistribucion = record
    nombre: String25;
    lanzamiento: Integer;
    kernel: StringKernel;
    desarrolladores: Integer;
    descripcion: String;
  end;

  FDistribuciones = file of TDistribucion;


procedure setDistribucion(
  var f: FDistribuciones;
  nombre: String25;
  desarrolladores: Integer
);
var t: TDistribucion;
begin
  t.nombre := nombre;
  t.lanzamiento := 2022;
  t.kernel := '5.17';
  t.desarrolladores := desarrolladores;
  t.descripcion := 'Distribucion ' + nombre;
  Write(f, t);
end;


var
  f: FDistribuciones;
begin
  Assign(f, PATH_DISTRIBUCIONES);
  Rewrite(f);
                                          // NRR
  setDistribucion(f, 'Debian',     -17);  //   0
  setDistribucion(f, 'Fedora',     420);  //   1
  setDistribucion(f, 'Ubuntu',     643);  //   2
  setDistribucion(f, 'Pop! OS',    -14);  //   3
  setDistribucion(f, 'Manjaro',     -3);  //   4
  setDistribucion(f, 'Arch',       340);  //   5
  setDistribucion(f, 'Mint',       462);  //   6
  setDistribucion(f, 'Ubuntu',     -20);  //   7
  setDistribucion(f, 'Deepin',     562);  //   8
  setDistribucion(f, 'Raspbian',   -12);  //   9
  setDistribucion(f, 'openSUSE',   362);  //  10 
  setDistribucion(f, 'Zorin',      346);  //  11 
  setDistribucion(f, '',             0);  //  12 
  setDistribucion(f, 'Lubuntu',    853);  //  13 
  setDistribucion(f, 'Ubuntu',      -7);  //  14 
  setDistribucion(f, 'Kubuntu',    466);  //  15 
  setDistribucion(f, 'RHEL',       345);  //  16 
  setDistribucion(f, 'MX Linux',    -4);  //  17 
  setDistribucion(f, 'Pop! OS',    464);  //  18 
  setDistribucion(f, 'Elementary', 356);  //  19 
  setDistribucion(f, 'MX Linux',    -9);  //  20
  setDistribucion(f, 'Kali',       357);  //  21
  setDistribucion(f, 'CentOS',     351);  //  22

  Close(f);
end.