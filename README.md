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