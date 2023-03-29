program exercise7;
const
  valor_alto= 9999;
type
  cadena = string[30];
  novela = record
    codigo: integer;
    nombre: cadena;
    genero: cadena;
    precio: double;
  end;
  archivo_novelas = file of novela;


// ---------------------- Punto a. ---------------

procedure crearArchivoBinario(var novelas: archivo_novelas; var archTexto: text);
var
  nov: novela;
begin
  rewrite(novelas);
  reset(archTexto);

  while not eof(archTexto) do begin
    with nov do begin
      readln(archTexto, codigo, precio, genero);
      readln(archTexto, nombre);
    end;
    write(novelas, nov);
    
  end;
  writeln('------------------------------------------------------------------------- Archivo binario creado.');

  close(novelas);
  close(archTexto);

end;

// ----------------------- Fin Punto a. ------------------

// ------------------------ Pruba -----------------------

procedure leer(var novelas: archivo_novelas; var nov: novela);
begin
  if not eof(novelas) then
    read(novelas, nov)
  else
    nov.codigo:= valor_alto;
end;

procedure imprimirUnaNovela(nov: novela);
begin
  with nov do
    writeln('Codigo: ', codigo, ' - Nombre: ', nombre, ' - Genero: ', genero, ' - Precio: ', precio:2:2);
end;

procedure imprimirNovelas(var novelas: archivo_novelas);
var
  nov: novela;
begin
  reset(novelas);

  leer(novelas, nov);
  while(nov.codigo <> valor_alto) do begin
    imprimirUnaNovela(nov);
    leer(novelas, nov);
  end;

  close(novelas);
end;

// ------------------------ FIN Pruba -----------------------

// --------------- Punto b. -----------------------------------------
procedure leerNovela(var nov: novela);
begin
  with nov do begin
    write('Ingrese el codigo de la novela: ');
    readln(codigo);
    write('Ingrese el nombre: ');
    readln(nombre);
    write('Ingrese el genero: ');
    readln(genero);
    write('Ingrese el precio: ');
    readln(precio);
  end;
end;

procedure agregarUnaNovela(var novelas: archivo_novelas);
var
 nov: novela;
begin
  reset(novelas);

  writeln('Ingrese la informacion de la novela que quiere agregar: ');
  leerNovela(nov);

  seek(novelas, filesize(novelas));
  write(novelas, nov);

  writeln('------------------------------------------------------------------------- Novela agregada correctamente.');

  close(novelas);
  
end;

procedure modificarCodigo (var nov: novela);
var
  cod: integer;
begin
  write('Ingrese el codigo nuevo: ');
  readln(cod);
  nov.codigo:= cod;
end;

procedure modificarNombre (var nov: novela);
var
 nom: cadena;
begin
  write('Ingrese el nuevo nombre: ');
  readln(nom);
  nov.nombre:= nom;
end;

procedure modificarGenero (var nov: novela);
var
  gen: cadena;
begin
  write('Ingrese el nuevo genero: ');
  readln(gen);
  nov.genero:= gen;
end;

procedure modificarPrecio (var nov: novela);
var
  pre: double;
begin
  write('Ingrese el nuevo precio: ');
  readln(pre);
  nov.precio:= pre;
end;

procedure modificarNovela(var novelas: archivo_novelas);
var
  nov: novela;
  cod: integer;
  campo: cadena;
  encontro: boolean;
begin
  reset(novelas);

  encontro:= false;

  write('Ingrese el codigo de la novela que desea modificar: ');
  readln(cod);

  leer(novelas, nov);
  while (nov.codigo <> valor_alto) and (not encontro) do begin
    if(nov.codigo = cod) then begin
      write('Ingrese el campo ("codigo", "nombre", "genero" o "precio") a modificar: ');
      readln(campo);
      
      case campo of
        'codigo': modificarCodigo(nov);
        'nombre': modificarNombre(nov);
        'genero': modificarGenero(nov);
        'precio': modificarPrecio(nov);
      end;
      

      seek(novelas, filepos(novelas)-1);

      write(novelas, nov);

      writeln('-------------------------------------------------------------------- Novela Modificada Correctamente.');
      encontro:= true;

    end
    else
      leer(novelas, nov);
  end;

  if (not encontro) then
    writeln('No se encontro ninguna novela con ese codigo.');

  close(novelas);
end;

// --------------- FIN Punto b. -----------------------------------------

var
  novelas: archivo_novelas;
  novelasTexto : text;
  opcion: cadena;
begin
  assign(novelas, 'fileExercise7.dat');
  assign(novelasTexto, 'novelas.txt');

  writeln('Para crear un archivo nuevo con la informacion de las novelas almacenada en novelas.txt ingrese: "Crear"');
  writeln('Para agregar una novela nueva ingrese: "Agregar"');
  writeln('Para modificar una novela existente ingrese: "Modificar"');
  writeln('Para imprimir: "Imprimir"');

  readln(opcion);

  case opcion of
    'Crear': crearArchivoBinario(novelas, novelasTexto);
    'Agregar': agregarUnaNovela(novelas);
    'Modificar': modificarNovela(novelas);
    'Imprimir': imprimirNovelas(novelas);   //Esto lo pude para probar!!
  end;
  
  //NO ES NECESARIO EL CLOSE ACA NO???


end.