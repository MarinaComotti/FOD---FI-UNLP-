program exercise5;
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



// -------------------- Punto a. --------------- 

procedure crearArchivoBinario(var celulares: archivo_celulares; var arch_text: Text);
var
  cel: celular;
begin
  reset(arch_text);
  rewrite(celulares);

  while not eof(arch_text) do begin
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

// --------------------- FIN Punto a. ------------------------

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



// ------------------------> Punto b. ------------------

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

// ------------------------> FIN  Punto b. ------------------

// ------------------------> Punto c. ------------------

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

// ------------------------ Punto d.  ----------------
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

// ------------------------FIN Punto d.  ----------------


var
  arch_text: Text;
  celulares: archivo_celulares;
  cel: celular;
  opcion: char;
  arch_Text2: Text;
  nomArch: string[20];
begin
  assign(celulares, 'fileExercise5.dat');
  assign(arch_text, 'celularesText.txt');
  assign(arch_Text2, 'celulares.txt');
  
  writeln('MENU DE OPCIONES: ');

  writeln('Para crear un archivo binario desde un archivo de texto ingrese ---> a');
  writeln('Para listar en pantalla los celulares con stock menor al stock minimo ---> b');
  writeln('Para listar en pantalla los celulares cuya descripcion contenga una cadena de caracteres ingresada ---> c');
  writeln('Para crear un archivo de texto nuevo con la informacion de los celulares ---> d');
  

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
    end;
    
 

end.
