program exercise2;
const
  valorAlto = 9999;
type 
  cadena = string[20];
  alumnoMae = record
    codigo: integer;
    apellido: cadena;
    nombre: cadena;
    cantCursadas: integer;
    cantFinales: integer;
  end;
  materia = record 
    nombre: cadena;
    aprCursada: boolean;
    aprFinal: boolean;
  end;
  alumnoDet = record
    codigo: integer;
    mat: materia;
  end;
  archivo_maestro = file of alumnoMae;
  archivo_detalle = file of alumnoDet;


// ------- Procesos leer --------------------------------------------

procedure leerMaestro(var mae: archivo_maestro; var alMae: alumnoMae);
begin
  if not eof(mae) then
    read(mae, alMae)   
  else
    alMae.codigo:= valorAlto;
end;


procedure leerDetalle(var det: archivo_detalle; var alDet: alumnoDet);
begin
  if not eof(det) then
    read(det, alDet)   
  else
    alDet.codigo:= valorAlto;
end;

// ---- Creación e impresion del maestro solo para probar !!! ---------------------

procedure leerAlumnoMae(var alumMae: alumnoMae);
begin
  with alumMae do begin
    write('Ingrese el codigo del alumno o -1 para terminar: ');
    readln(codigo);
    if( codigo <> -1) then begin
      write('Ingrese apellido: ');
      readln(apellido);
      write('Ingrese nombre: ');
      readln(nombre);
      write('Ingrese cant de cursadas aprobadas sin final: ');
      readln(cantCursadas);
      write('Ingrese cant de finales aprobados: ');
      readln(cantFinales);
    end;
  end;
end;

procedure crearMaestro(var maestro: archivo_maestro);
var 
  alumMae: alumnoMae;
begin
  rewrite(maestro);
  leerAlumnoMae(alumMae);
  while(alumMae.codigo <> -1) do begin
    write(maestro, alumMae);
    leerAlumnoMae(alumMae)
  end;
  close(maestro);
end;

procedure imprimirAlumnoMae(alumMae: alumnoMae);
begin
  with alumMae do begin
    writeln('Codigo ---------------> ', codigo);
    writeln('Cant cursadas sin final: ', cantCursadas);
    writeln('Cant finales: ', cantFinales);
  end;
end;

procedure imprimirMaestro(var maestro: archivo_maestro);
var
  alumMae: alumnoMae;
begin
  reset(maestro);
  leerMaestro(maestro, alumMae);
  while(alumMae.codigo <> valorAlto) do begin
    imprimirAlumnoMae(alumMae);
    leerMaestro(maestro, alumMae);
  end;
  close(maestro);
end;

// ---- Creación e impresion del detalle solo para probar !!! ---------------------

procedure leerMateria (var mate: materia);
var
  respuesta: cadena;
begin
  with mate do begin
    write('Ingrese el nombre de la matteria: ');
    readln(nombre);

    write('Ingrese true o false si aprobo cursada sin final: ');
    readln(respuesta);
    if (respuesta = 'true') then
      aprCursada:= true
    else
      aprCursada:= false;

    write('Ingrese true o false si aprobo final: ');
    readln(respuesta);
    if (respuesta = 'true') then
      aprFinal:= true
    else
      aprFinal:= false;
  end;
end;

procedure leerAlumnoDet(var alumDet: alumnoDet);
begin
  with alumDet do begin
    write('Ingrese el codigo del alumno o -1 para terminar: ');
    readln(codigo);
    if( codigo <> -1) then begin
      leerMateria(mat)
    end;
  end;
end;

procedure crearDetalle(var detalle: archivo_detalle);
var 
  alumDet: alumnoDet;
begin
  rewrite(detalle);
  leerAlumnoDet(alumDet);
  while(alumDet.codigo <> -1) do begin
    write(detalle, alumDet);
    leerAlumnoDet(alumDet)
  end;
  close(detalle);
end;

procedure imprimirAlumnoDet(alumDet: alumnoDet);
begin
  with alumDet do begin
    writeln('Codigo ---------------> ', codigo);
    writeln('Materia: ', mat.nombre);
    writeln('Aprobo cursada sin final: ', mat.aprCursada);
    writeln('Aprobo final: ', mat.aprFinal);
  end;
end;

procedure imprimirDetalle(var detalle: archivo_detalle);
var
  alumDet: alumnoDet;
begin
  reset(detalle);
  leerDetalle(detalle, alumDet);
  while(alumDet.codigo <> valorAlto) do begin
    imprimirAlumnoDet(alumDet);
    leerDetalle(detalle, alumDet);
  end;
  close(detalle);
end;




// ----- Actualización del Maestro ------ 

procedure actualizarMaestro(var maestro: archivo_maestro; var detalle: archivo_detalle);
var
  alumMae: alumnoMae;
  alumDet: alumnoDet;
begin
  reset(maestro);
  reset(detalle);

  leerDetalle(detalle, alumDet);
  
  while (alumDet.codigo <> valorAlto) do begin
    read(maestro, alumMae);
    while(alumMae.codigo <> alumDet.codigo) do
      read(maestro, alumMae);

    while (alumMae.codigo = alumDet.codigo) do begin
      if (alumDet.mat.aprFinal) then                          //Si el alumno aprobó el final de la materia no es necesario incrementar tambien la cursada porque ya tiene el final
        alumMae.cantFinales:= alumMae.cantFinales + 1
      else if(alumDet.mat.aprCursada) then
        alumMae.cantCursadas:= alumMae.cantCursadas + 1;
      
      leerDetalle(detalle, alumDet);
    end;
    seek(maestro, filepos(maestro)-1);
    write(maestro, alumMae);
  end;
  writeln('Actualizacion finalizada. ');
  close(maestro);
  close(detalle);
end;

// ----- Creación del archivo de texto --------



procedure crearArchivoTexto(var maestro: archivo_maestro; var archText: text );
var
  alumMae: alumnoMae;
begin
  reset(maestro);
  rewrite(archText);
  
  leerMaestro(maestro, alumMae);
  while(alumMae.codigo <> valorAlto) do begin
    if (alumMae.cantCursadas > 4) then //           CONSULTAR si interprete bien esto de la consigna
      with alumMae do begin
        writeln(archText, 'Codigo: ', codigo, ' - cant. de cursadas sin final: ', cantCursadas, ' - cant de finales: ', cantFinales);
        writeln(archText, ' - apellido: ', apellido);
        writeln(archText, ' - nombre: ', nombre);
      end;
    leerMaestro(maestro, alumMae);
  end;
   writeln('Creacion del archivo de texto finalizada. ');
  close(maestro);
  close(archText);
end;



var
  maestro: archivo_maestro;
  detalle: archivo_detalle;
  archText: text;
  opcion: integer;

begin
  assign(maestro, 'masterFileEx2.dat'); 
  assign(detalle, 'detailFileEx2.dat');
  assign(archText, 'textFileEx2.dat');

  writeln(' ');

  writeln('Ingrese el numero segun la opcion elegida: ');
  writeln('    1 -- Actualizar el archivo maestro.');
  writeln('    2 -- Listar en un archivo de texto los alumnos con mas de cuatro materias con cursada aprobada y final desaprobado.');
  writeln(' ');
  //Menu para crear e imprimir el maestro y el detalle
  writeln('    3 -- Crear archivo maestro.');
  writeln('    4 -- Crear archivo detalle.');
  writeln('    5 -- Imprimir archivo maestro.');
  writeln('    6 -- Imprimir archivo detalle.');
  writeln(' ');

  write('Opcion: ');
  readln(opcion);

  case opcion of
    1: actualizarMaestro(maestro, detalle);
    2: crearArchivoTexto(maestro, archText);
    3: crearMaestro(maestro);
    4: crearDetalle(detalle);
    5: imprimirMaestro(maestro);
    6: imprimirDetalle(detalle);

  end;

  
end.