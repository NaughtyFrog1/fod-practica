# Algorítmica clásica sobre archivos




## Actualización

Se actualiza un archivo maestro a partir de un conjunto de archivos detalles.



### Un maestro, un detalle. Sin repetición

- **Precondiciones:**
  - Cada registro del detalle modifica a un registro en el maestro.
  - Solo aparecerán datos en el detalle que también existan en el maestro.
  - Cada elemento del detalle es modificado por un único registro del detalle.
  - No todos los registros del maestro son modificados.
  - Ambos archivos están ordenados por el mismo criterio


```
actualizarMaestro(maestro, detalle) {
  Reset(maestro); Reset(detalle);

  while (not Eof(detalle)) {
    Read(maestro, regMaestro); Read(detalle, regDetalle);
    Buscar el registro maestro que coincida con el detalle;
    Modificar la información del registro maestro;
    Actualizar el archivo maestro;
  }

  Close(maestro); Close(detalle);
}
```



### Un maestro, un detalle. Con repetición

- **Precondiciones:**
  - *Cada registro del detalle modifica a un registro en el maestro.*
  - *Solo aparecerán datos en el detalle que también existan en el maestro.*
  - **Cada elemento del detalle es modificado por varios registro del detalle.**
  - *No todos los registros del maestro son modificados.*
  - *Ambos archivos están ordenados por el mismo criterio*

```
leer(detalle, regDetalle) {
  if (Eof(detalle)) regDetalle.id = VALOR_CORTE 
  else Read(detalle, regDetalle);
}

actualizarMaestro(maestro, detalle) {
  Reset(maestro); Reset(detalle);

  leer(detalle, regDetalle);
  while (regDetalle.id <> VALOR_CORTE) {
    Buscar el registro maestro que coincida con el detalle;
    while (regMaestro.id = regDetalle.id) {
      actualizar información en el registro maestro;
      leer(detalle, regDetalle);
    }
    Actualizar el archivo maestro;
  }

  Close(maestro); Close(detalle);
}
```




### Un Maestro, *N* detalles. Con repetición

- **Precondiciones:**
  - *Cada registro del detalle modifica a un registro en el maestro.*
  - *Solo aparecerán datos en el detalle que también existan en el maestro.*
  - *Cada elemento del detalle es modificado por varios registro del detalle.*
  - *No todos los registros del maestro son modificados.*
  - *Todos los archivos están ordenados por el mismo criterio*
  - **Los *N* archivos detalles están guardados en un vector**

```
leer(detalle, regDetalle) {
  if (Eof(detalle)) regDetalle.id = VALOR_CORTE 
  else Read(detalle, regDetalle);
}

inicializar(detalles, regsDetalles) {
  for i := 1 to N do leer(detalles[i], regsDetalles[i]);
}

getMinimo(detalles, regsDetalles, min) {
  Buscar el registro detalle menor;
  actualizar el valor de min con el nuevo valor;
  leer(detalles[minPos], regsDetalles[minPos]);
}

// Detalles es un vector con N archivos detalle
actualizarMaestro(maestro, detalles) {
  Reset(maestro); Reset(detalles);

  inicializar(detalles, regsDetalles);
  getMinimo(detalles, regsDetalles, min);

  while (min.id <> VALOR_CORTE) {
    Buscar el registro maestro que coincide con el detalle.
    while (regDetalle.id = min.id) {
      actualizar información registro maestro;
      getMinimo(detalles, regsDetalles, min);
    }
    Actualizar el archivo maestro;
  }

  Close(maestro); Close(detalles)
}
```
- Al buscar el registro detalle menor en `getMinimo`, deben tenerse en cuenta todos los criterios de ordenación del archivo.
- `VALOR_CORTE` tiene que ser un valor muy alto.




## Merge

Se genera un nuevo archivo maestro a partir de la información distribuida en varios archivos detalles.



### Merge N archivos. Sin repetición

```
mergeSinRepeticion(maestro, detalles) {
  Rewrite(maestro); Reset(detalles);

  inicializar(detalles, regsDetalles);
  getMinimo(detalles, regsDetalles, min);
  
  while (min.id <> VALOR_CORTE) {
    Write(maestro, min);
    minimo(detalles, regsDetalles, min);
  }

  Close(maestro); Close(detalles);
}
```



### Merge N archivos. Con repetición

```
mergeConRepeticion(maestro, detalles) {
  Rewrite(maestro); Reset(detalles);

  inicializar(detalles, regsDetalles);
  getMinimo(detalles, regsDetalles, min);

  while (min.id <> VALOR_CORTE) {
    regMaestro = información que se repite en los detalles;
    while (regMaestro.id = min.id) {
      regMaestro += información que se procesa para cada detalle;
      getMinimo(detalles, regsDetalles, min);
    }
    Write(regMaestro, maestro);
  }

  Close(maestro); Close(detalles);
}
```




## Corte de control

Proceso mediante el cual la información de un archivo es representada en forma organizada de acuerdo al criterio de orden del archivo.

```
CorteDeControl(archivo) {
  Reset(archivo);

  leer(archivo, reg);
  inicializar accTotal;

  while (reg.provincia <> VALOR_CORTE) {
    inicializar acumulador provincia, accProv;

    while (provActual = reg.prov) {
      iniciar accCiudad;

      while ((provActual = reg.prov) and (ciudadActual = reg.ciudad)) {
        inicializar accSucursal;

        while (
          (provActual = reg.prov) and
          (ciudadActual = reg.ciudad) and
          (sucursalActual = reg.sucursal)
        ) {
          procesar accSucursal;
          leer(archivo, reg);
        }
        procesar accCiudad;
      }
      procesar accProv;
    }
    procesar accTotal;
  }

  Close(archivo);
}
```
- Como los identificadores pueden estar repetidos entre las sucursales, ciudades y provincias; tenemos que ir "pasando" las condiciones a todos los cortes de control.





# Bajas

- **Baja física:** reemplazar el elemento del archivo por otro, decrementando la cantidad de elementos y recuperando espacio físico.
- **Baja lógica:** marcar un elemento como borrado, sigue ocupando espacio en el archivo.




## Procedimientos



### Truncate

```
Truncate(f);
```

Trunca `f` en la posición actual del puntero del archivo y lo cierra.

El archivo tiene que estar abierto



### Rename

```
Rename(f, nuevoNombre);
```
Cambia el nombre asignado al archivo `f` por `nuevoNombre`.

El archivo tiene que estar asignado y cerrado.



### Erase

```
Erase(f);
```
Elimina `f` del disco.

El archivo tiene que estar asignado y cerrado.




## Archivos de longitud fija



### Baja física


#### Sin mantener el orden

```
bajaFisica(archivo, elemento) {
  Reset(archivo);

  Buscar el elemento a eliminar;
  Guardar la posición del elemento;
  Leer el último elemento del archivo;
  Escribir el último elemento del archivo en la posición guardada;
  Volver al último elemento del archivo;

  Truncate(archivo);
}
```
- `Truncate` pone una marca de EOF en la posición del puntero del archivo.


#### Manteniendo el orden

```
bajaFisica(archivo, id) {
  Reset(archivo);

  // Avanzar hasta encontrar el elemento a eliminar
  leer(archivo, t);
  while (t.id <> id) leer(archivo, t);

  // Leer el registro siguiente
  leer(archivo, t);

  // Desplazar todos los registros hacia la izquierda
  while (t.id <> VALOR_CORTE) {
    Seek(archivo, FilePos(archivo) - 2);  // Volvemos a la posición del registro a eliminar
    Write(archivo, t);
    Seek(archivo, FilePos(archivo) + 1);
    leer(archivo, t);
  }

  Truncate(archivo);
}
```



### Baja lógica

Se crea una **lista encadenada invertida** con los registros dados de baja. El primer registro del archivo se utiliza como un **registro de cabecera**.

- Bajas 
  - El registro de cabecera guarda el NRR del último registro borrado, o 0 si no hay registros borrados.
  - Al borrar un registro se guarda su NRR en el registro de cabecera y el que estaba allí se guarda en el registro borrado (generando la lista encadenada invertida).
- Altas
  - Los elementos se insertan el el NRR indicado por el registro de cabecera y este se actualiza con el NRR al que apuntaba el otro registro
  - Si el registro de cabecera es 0, no hay lugares disponibles, se inserta al final del archivo.

```
NRR:            0    1    2    3    4    5    6    7    8    9   10  

             |  0 |  1 |  6 |  2 |  7 |  3 |  8 |  4 |  9 |  5 | 10 |
                ^

BORRAR 2:    | -3 |  1 |  6 |  0 |  7 |  3 |  8 |  4 |  9 |  5 | 10 |
                ^              ^

BORRAR 8:    | -6 |  1 |  6 |  0 |  7 |  3 | -3 |  4 |  9 |  5 | 10 |
                ^              ^              ^

BORRAR 6:    | -2 |  1 | -6 |  0 |  7 |  3 | -3 |  4 |  9 |  5 | 10 |
                ^         ^    ^              ^

INSERTAR 21: | -6 |  1 | 21 |  0 |  7 |  3 | -3 |  4 |  9 |  5 | 10 |
                ^         ·    ^              ^

INSERTAR 32: | -3 |  1 | 21 |  0 |  7 |  3 | 32 |  4 |  9 |  5 | 10 |
                ^         ·    ^              ·

INSERTAR 15: |  0 |  1 | 21 | 15 |  7 |  3 | 32 |  4 |  9 |  5 | 10 |
                ^         ·    ·              ·
```

Después de insertar el 15, el registro de cabecera vuelve a quedar en 0, si se quisieran insertar nuevos elemetnos habrá que hacerlo al final del archivo.
