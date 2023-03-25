program exercise6;
const
  valor_alto= 9999;
type
  celular = record
    codigo: integer;
    nombre: string[15];
    descripcion: string[20];
    marca: string[15];
    precio: integer;
    stockMin: integer;
    stockDisp: integer;
  end;
  archivo_celulares = file of celular;



// -------------------- Punto 5a. --------------- 

procedure crearArchivoBinario(var celulares: archivo_celulares; var arch_text: Text);
var
  cel: celular;
begin
  reset(arch_text);
  rewrite(celulares);

  while not eof(arch_text) do begin
    writeln('Entro al whileee');
    with cel do begin
      readln(arch_text, codigo, precio, marca);  //CONSULTAR POR ESTO !!!! Porque pasa????
      readln(arch_text, stockDisp, stockMin, descripcion);
      readln(arch_text, nombre);
    end;
    write(celulares, cel);
  end;
  writeln('Archivo binario creado.');

  close(celulares);
  close(arch_text);
end;

// --------------------- FIN Punto 5a. ------------------------

procedure leer(var celulares: archivo_celulares; var cel: celular);
begin
  if not eof(celulares) then
    read(celulares, cel)
  else
    cel.codigo:= valor_alto;
  
end;

procedure imprimirUnCelular(cel: celular);
begin
  with cel do
    writeln('Codigo: ', codigo, ' Nombre ', nombre, ' Descripcion: ', descripcion, ' Marca: ', marca, ' Precio: ', precio, ' StockMin: ', stockMin, ' StockDisp: ', stockDisp);
end;



// ------------------------> Punto 5b. ------------------

procedure imprimirCelConMenosDelMinimoStock(var celulares: archivo_celulares);
var
  cel: celular;
begin
  reset(celulares);
  
  leer(celulares, cel);
  while (cel.codigo <> valor_alto) do begin
    if (cel.stockDisp < cel.stockMin) then
      imprimirUnCelular(cel);
    leer(celulares, cel);
  end;
  close(celulares);
end;

// ------------------------> FIN  Punto 5b. ------------------

// ------------------------> Punto 5c. ------------------

procedure imprimirCelularesCadenaDescripcion(var celulares: archivo_celulares);
var  
  cel: celular;
  cadena: string[20];
begin
  reset(celulares);
  write('Ingrese la cadena de caracteres a buscar en las descripciones de los celulares: ');
  readln(cadena);

  leer(celulares, cel);
  while(cel.codigo <> valor_alto) do begin
    if(cel.descripcion = cadena) then
      imprimirUnCelular(cel);
    leer(celulares, cel);
  end;

  close(celulares);

end;

// ------------------------ Punto 5d.  ----------------
procedure exportarATexto(var celulares: archivo_celulares; var arch_text: text);
var
  cel: celular;
begin
  rewrite(arch_text);
  reset(celulares);

  while not eof(celulares) do begin
    read(celulares, cel); 
    writeln(arch_text, cel.codigo, ' ', cel.precio,' ', cel.marca);
    writeln(arch_text, cel.stockDisp, ' ', cel.stockMin, ' ', cel.descripcion);
    writeln(arch_text, cel.nombre);
  end;
  close(celulares);
  close(arch_text);
end;

// ------------------------FIN Punto 5d.  ----------------

// ------------------------- Punto 6a. ...................
procedure leerCelular(var cel: celular);
begin
  writeln('Ingrese el codigo: ');
  readln(cel.codigo);
  if(cel.codigo <> -1) then begin
      writeln('Ingrese el nombre: ');
      readln(cel.nombre);
      writeln('Ingrese la descripcion: ');
      readln(cel.descripcion);
      writeln('Ingrese la marca: ');
      readln(cel.marca);
      writeln('Ingrese el stock minimo: ');
      readln(cel.stockMin);
      writeln('Ingrese el stock disponible: ');
      readln(cel.stockDisp);
  end;

end;

procedure agregarCelulares(var celulares: archivo_celulares);
var
  cel: celular;
begin
  reset(celulares);
  seek(celulares, filesize(celulares));
  writeln('Ingrese la informarcion del celular a agregar o -1 para terminar: ----> ');
  leerCelular(cel);
  while(cel.codigo <> -1) do begin
    write(celulares, cel);
    writeln('Ingrese la informacion de otro celular a agregar o -1 para terminar: ----> ');
    leerCelular(cel);
  end;
  
  close(celulares);
end;

// ------------------- FIN Punto 6a. -----------------------

// ----------------- PARA PROBAR ------------------------
procedure listarTodosLosCelulares(var celulares: archivo_celulares);
var
    cel: celular;
begin
  reset(celulares);
  while not eof(celulares) do begin
    read(celulares, cel);
    imprimirUnCelular(cel);
  end;
  close(celulares);
end;

// ----------------------------------------------------------------

// ----------------------- Punto 6b. ------------------------

procedure modificarStock(var celulares: archivo_celulares);
var
  cel: celular;
  nomb: string[15];
  nuevoStock: integer;
  encontro: boolean;
begin
  reset(celulares);

  encontro:= false;

  write('Ingrese el nombre del celular cuyo stock sera modificado: ');
  readln(nomb);

  leer(celulares, cel);

  while(cel.codigo <> valor_alto) and (not encontro) do begin
    if(cel.nombre = nomb) then begin
      write('Ingrese el nuevo stock: ');
      readln(nuevoStock);
      cel.stockDisp:= nuevoStock;           // Yo modifique el stock Disponible

      seek(celulares, filepos(celulares)-1);
      write(celulares, cel);

      encontro:= true;                           // Para que no siga recorriendo todo el archivo
      writeln('El stock fue modificado correctamente. ');
    end;
    leer(celulares, cel);
  end;

  if(not encontro) then
    writeln('No se encontro ningun celular con ese nombre');

  close(celulares);

end;

// ------------------------ FIN Punto 6b. ------------

// ---------------------- Punto 6c. ------------------
procedure exportarATextoSinStock(var celulares: archivo_celulares; var sinStock: text);
var
  cel: celular;
begin
  reset(celulares);
  rewrite(sinStock);

  leer(celulares, cel);
  while (cel.codigo <> valor_alto) do begin
    if (cel.stockDisp = 0) then begin
      writeln(sinStock, cel.codigo, ' ', cel.precio,' ', cel.marca);
      writeln(sinStock, cel.stockDisp, ' ', cel.stockMin, ' ', cel.descripcion);
      writeln(sinStock, cel.nombre);
    end;
    leer(celulares, cel);
  end;
  close(sinStock);
  close(celulares);

end;

// ---------------------- FIN Punto 6c. ------------------

var
  arch_text: Text;
  celulares: archivo_celulares;
  cel: celular;
  opcion: char;
  arch_Text2: Text;
  nomArch: string[20];
  archSinStock: Text;
begin
  assign(celulares, 'fileExercise5.dat');
  assign(arch_text, 'celularesText.txt');
  assign(arch_Text2, 'celulares.txt');
  assign(archSinStock, 'SinStock.txt');
  
  writeln('MENU DE OPCIONES: ');

  writeln('Para crear un archivo binario desde un archivo de texto ingrese ---> a');
  writeln('Para listar en pantalla los celulares con stock menor al stock minimo ---> b');
  writeln('Para listar en pantalla los celulares cuya descripcion contenga una cadena de caracteres ingresada ---> c');
  writeln('Para crear un archivo de texto nuevo con la informacion de los celulares ---> d');
  writeln('Para anadir uno o mas celulares al final del archivo ----> e');
  writeln('Para modificar el stock de un celular dado: ----> f');
  writeln('Para exportar a un archivo de texto la informacion de los celulares sin stock ----> g');
  writeln('Para imprimir todos los celulares -------------------> w');
  

  readln(opcion);
  if(opcion = 'a') then begin                                      //CONSUTAR --> Se puede hacer esto con el Case ??
    write('Ingrese el nombre del archivo binario a crear: ');
    readln(nomArch);
    assign(celulares, nomArch);
    crearArchivoBinario(celulares, arch_text);
  end
  else 
    case opcion of
    'b': imprimirCelConMenosDelMinimoStock(celulares);
    'c': imprimirCelularesCadenaDescripcion(celulares);
    'd': exportarATexto(celulares, arch_Text2);
    'e': agregarCelulares(celulares);
    'f': modificarStock(celulares);
    'g': exportarATextoSinStock(celulares, archSinStock);
    'w': listarTodosLosCelulares(celulares);
    end;
    
 

end.
