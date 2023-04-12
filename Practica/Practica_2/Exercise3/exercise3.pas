// ESTÁ TODO CORREGIDO PERO NO LO PROBÉ
program exercise3;
const
  valorAlto = 9999;
  dimF = 30;
type
  
  cadena = string [30];
  productoMae = record
    codigo: integer;
    nombre: cadena;
    descripcion: cadena; 
    stockDisponible: integer;
    stockMinimo: integer;
    precio: double;
  end;
  productoDet = record
    codigo: integer;
    cantVendida: integer;
  end;
  archivoMaestro = file of productoMae;
  archivoDetalle = file of productoDet;

  vectorDetalles = array[1..dimF] of archivoDetalle; //Tengo que meterlo en un vector verdad??
  vectorProdDet = array[1..dimF] of productoDet; 

procedure leerDetalle(var detalle: archivoDetalle; var prodDet: productoDet);
begin
  if not eof(detalle) then
    read(detalle, prodDet)
  else
    prodDet.codigo:= valorAlto;
end;

procedure leerMaestro(var mae: archivoMaestro; var prodMae: productoMae);
begin
  if not eof(mae) then
    read(mae, prodMae)
  else
    prodMae.codigo:= valorAlto;
end;

procedure minimo(var prodsDet: vectorProdDet; var min: productoDet; var detalles: vectorDetalles);
var
  i: integer;
  codMin: integer;
  posMin:integer;
begin
  codMin:= 9999;  // inicializo el min alto
  for i:=0 to dimF do 
    if (prodsDet[i].codigo < codMin) then begin
      min:= prodsDet[i];
      posMin := i;    //!           // encuentra el producto con codigo minimo
      codMin:= prodsDet[i].codigo;
    end;
  
  leerDetalle(detalles[posMin], prodsDet[posMin]);  //guarda el producto siguiente al minimo en el vector de productos
end;



procedure actualizarMaestro(var maestro: archivoMaestro; var detalles: vectorDetalles);
var
  prodsDet: vectorProdDet;
  prodMae: productoMae;
  min: productoDet;
  i: integer;
begin
  reset(maestro);
  for i:=0 to dimF do begin           
    reset(detalles[i]);       // reset de los 30 detalles
    leerDetalle(detalles[i], prodsDet[i])  // carga el vector de productos con el primer producto de cada archivo detalle
  end;

  minimo (prodsDet, min, detalles);  // calcula el producto minimo del vector de productos 
  
  while(min.codigo <> valorAlto) do begin  
    read(maestro, prodMae);
    while(prodMae.codigo <> min.codigo) do 
      read(maestro, prodMae);
    
    while( prodMae.codigo = min.codigo) do begin
      prodMae.stockDisponible:= prodMae.stockDisponible - min.cantVendida;
      minimo(prodsDet, min, detalles);
    end;
    seek(maestro, filepos(maestro)-1);
    write(maestro, prodMae);

  end;

  close(maestro);
  for i:=1 to dimF do 
    close(detalles[i]);
end;

procedure crearArchivoDeTexto(var maestro: archivoMaestro; var texto: text );
var
  prod: productoMae;
begin
  reset(maestro);
  rewrite(texto);
  leerMaestro(maestro, prod);
  while (prod.codigo <> valorAlto) do begin
    writeln(texto, 'Nombre del producto: ', prod.nombre);
    writeln(texto, '- descripcion: ', prod.descripcion);
    writeln(texto, ' - stock disponible: ', prod.stockDisponible, ' - precio: ', prod.precio);
    leerMaestro(maestro, prod);
  end;
  close(maestro);
  close(texto);
end;


var
  maestro: archivoMaestro;
  detalles: vectorDetalles;
  arch_texto: text;
  i: integer;
  nombreFisico: cadena;
begin
  assign(maestro, 'masterFileEx3.dat');
  for i:= 0 to dimF do begin                   // ESTA BIEN ASÍ ??
    write('Ingrese el nombre del archivo detalle ', i, ': ');
    readln(nombreFisico);
    assign(detalles[i], nombreFisico);
  end;
  actualizarMaestro(maestro, detalles);
  crearArchivoDeTexto(maestro, arch_texto);

end.
    

