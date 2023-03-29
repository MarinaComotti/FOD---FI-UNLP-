program exercise1;
const
  valorAlto = 9999;
type
  cadena = string[20];
  comision = record
    codigo: integer;
    nombre: cadena;
    monto: double;
  end;
  archivo_comisiones = file of comision;


procedure leer(var comisiones: archivo_comisiones; var com: comision);
begin
  if not eof(comisiones) then
    read(comisiones, com)
  else
    com.codigo:= valorAlto;
end;

procedure imprimirComision(com: comision);
begin
  writeln('Codigo ----> ', com.codigo, ' - Nombre: ', com.nombre, ' - Monto: *** ', com.monto:2:2);
end;

// ------------- Procesos creados para probar ------------------------

procedure crearArchivo(var comisiones:archivo_comisiones);
var
  com: comision;
begin
  rewrite(comisiones);

  with com do begin
    write('Ingrese el codigo del empleado o -1 para finalizar: -------------> ');
    readln(codigo);
    while(codigo <> -1) do begin
      write('Ingrese el nombre del empleado: ');
      readln(nombre);
      write('Ingrese el monto: *******  ');
      readln(monto);

      write(comisiones, com);

      write('Ingrese otro codigo de empleado o -1 para terminar: -------------> ');
      readln(codigo);
    end;
  end;
  close(comisiones);

end; 



procedure imprimirArchivo(var arch: archivo_comisiones);
var
  com: comision;
begin
  reset(arch);
  leer(arch, com);
  while(com.codigo <> valorAlto) do begin
    imprimirComision(com);
    leer(arch, com);
  end;
  close(arch);
end;

// ----------------------FIN de procesos creados para probar ----------------------



procedure cearArchivoCorteDeControl(var archCom, archTot: archivo_comisiones);
var
  codActual: integer;
  montoTotal: double;
  com, comNueva: comision;
begin
  reset(archCom);
  rewrite(archTot);

  leer(archCom, com);
  
  while (com.codigo <> valorAlto) do begin
    comNueva.codigo:= com.codigo;
    comNueva.nombre:= com.nombre;
    comNueva.monto:= 0;

    while(com.codigo = comNueva.codigo) do begin
      comNueva.monto:= comNueva.monto + com.monto;
      leer(archCom, com);
    end;

    write(archTot, comNueva);

  end;

  writeln('Archivo nuevo creado correctamente. ');

  close(archCom);
  close(archTot);

  
end;

var
  archComisiones, archTotal: archivo_comisiones;
  opcion: integer;

begin
  assign(archComisiones, 'archivoComisionesOriginal.dat');
  assign(archTotal, 'archivoComisionesTotal');

// --- Esto lo hice para poder probar bien todo ----
  writeln('OPCIONES: ');
  writeln('1 - Crear archivo de comisiones');
  writeln('2 - Imprimir archivo original');
  writeln('3 - Crear nuevo archivo con corte de control');
  writeln('4 - Imprimir archivo nuevo');

  readln(opcion);
  
  case opcion of
    1: crearArchivo(archComisiones);
    2: imprimirArchivo(archComisiones);
    3: cearArchivoCorteDeControl(archComisiones, archTotal);
    4: imprimirArchivo(archTotal);
  end;

end.