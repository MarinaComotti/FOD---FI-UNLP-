program exercise5;

const
  valorAlto = 9999;
  dimF=3;
type
  cadena = string[40];
  direc = record
    calle: cadena;
    nro: integer;
    piso: integer;
    depto: integer;
    ciudad: cadena;
  end;
  regMaestro = record
    nroPartida: integer;
    nombre: cadena;
    apellido: cadena;
    direccion: direc;
    matriMedNacim: integer;
    nomApMadre: cadena;
    dniMadre: integer;
    nomApPadre: cadena;
    dniPadre: integer;
    matriMedFallec: integer;   //0 si no falleció
    fechaHoraFallec: cadena;   // - si no fallecio
    lugarFallec: cadena;       // - si no fallecio
  end;
  regNacimiento = record
    nroPartida: integer;
    nombre: cadena;
    apellido: cadena;
    direccion: direc;
    matriMed: integer;
    nomApMadre: cadena;
    dniMadre: integer;
    nomApPadre: cadena;
    dniPadre: integer;
  end;
  regFallecimiento = record 
    nroPartida: integer;
    dni: integer;
    nomAp: cadena;
    matriMed: integer;
    fechaHora: cadena;
    lugar: cadena;
  end;

  archivoMaestro = file of regMaestro;
  archivoNacimiento = file of regNacimiento;
  archivoFallecimiento = file of regFallecimiento;

  vectorArchNacim = array[1..dimF] of archivoNacimiento;
  vectorNacimientos = array[1..dimF] of regNacimiento;

  vectorArchFallec = array[1..dimF] of archivoFallecimiento;
  vectorFallecimientos = array[1..dimF] of regFallecimiento;



// ---------SOLO PARA PROBAR ------------------
procedure leerNacim(var regNac: regNacimiento);
begin
  write('Ingrese nro de partida : ------------> ');
  readln(regNac.nroPartida);
end;

procedure crearArchNacim(var archNacim: archivoNacimiento);
var 
   regNac: regNacimiento;
begin
  writeln('Ingrese los numeros de partidas de los NACIMIENTOS hasta ingresar 0: ');
  leerNacim(regNac);
  while(regNac.nroPartida <> 0) do begin
    write(archNacim, regNac);
    leerNacim(regNac);
  end;
  
  //close(archNacim);
  
end;


procedure crearNacimientos(var vectArchNacim: vectorArchNacim);
var
  i: integer;
begin
  for i:=0 to dimF do begin
    rewrite(vectArchNacim[i]);
    crearArchNacim(vectArchNacim[i]);
    close(vectArchNacim[i]);
    writeln('DSOIFNIEDNFI');               // EL ERROR ESTA ACÁ !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  end;
  writeln('SALIIII');
end;

procedure leerFallec(var regNac: regFallecimiento);
begin
  write('Ingrese nro de partida : ------------> ');
  readln(regNac.nroPartida);
end;

procedure crearArchFallec(var archNacim: archivoFallecimiento);
var 
   regNac: regFallecimiento;
begin
  writeln('Ingrese los numeros de partidas de los FALLECIMIENTOS hasta ingresar 0: ');
  leerFallec(regNac);
  while(regNac.nroPartida <> 0) do begin
    write(archNacim, regNac);
    leerFallec(regNac);
  end;
 // close(archNacim);
  
end;


procedure crearFallecimientos(var vectArchNacim: vectorArchFallec);
var
  i: integer;
begin

  for i:=0 to dimF do begin
    rewrite(vectArchNacim[i]);
    crearArchFallec(vectArchNacim[i]);
    close(vectArchNacim[i]);
  end;
end;



// ------------------------------------------------------------------------------------------------

procedure leerNacimientos (var archNacim: archivoNacimiento; var regNacim: regNacimiento);
begin
  if not eof(archNacim) then
    read(archNacim, regNacim)
  else
    regNacim.nroPartida:= valorAlto;
end;

procedure leerFallecimientos (var archFallec: archivoFallecimiento; var regFallec: regFallecimiento);
begin
  if not eof(archFallec) then
    read(archFallec, regFallec)
  else
    regFallec.nroPartida:= valorAlto;
end;

procedure minimoNacim (var vectArch: vectorArchNacim; var vectReg: vectorNacimientos; var min: regNacimiento);
var
  i, nroMin, posMin: integer;
begin
  nroMin:=9999;
  for i:=0 to dimF do 
    if(vectReg[i].nroPartida < nroMin) then begin
      min:= vectReg[i];
      nroMin:= vectReg[i].nroPartida;
      posMin:= i;
    end;
  leerNacimientos(vectArch[posMin], vectReg[posMin]);
end;

procedure minimoFallec (var vectArch: vectorArchFallec; var vectReg: vectorFallecimientos; var min: regFallecimiento);
var
  i, nroMin, posMin: integer;
begin
  nroMin:=9999;
  for i:=0 to dimF do 
    if(vectReg[i].nroPartida < nroMin) then begin
      min:= vectReg[i];
      nroMin:= vectReg[i].nroPartida;
      posMin:= i;
    end;
  leerFallecimientos(vectArch[posMin], vectReg[posMin]);
end;

procedure crearArchMaestro(var maestro: archivoMaestro; var vectArchNacim: vectorArchNacim; var vectArchFallec: vectorArchFallec);
var
  vectNacim: vectorNacimientos;
  vectFallec: vectorFallecimientos;
  i: integer;
  minNacim: regNacimiento;
  minFallec: regFallecimiento;
  regMae: regMaestro;
begin
  rewrite(maestro);
  for i:=0 to dimF do begin
    reset(vectArchNacim[i]);
    leerNacimientos(vectArchNacim[i], vectNacim[i]);
    reset(vectArchFallec[i]);
    leerFallecimientos(vectArchFallec[i], vectFallec[i]);
  end;
  
  minimoNacim(vectArchNacim, vectNacim, minNacim);
  minimoFallec(vectArchFallec, vectFallec, minFallec);

  while(minNacim.nroPartida <> valorAlto) do begin
    regMae.nroPartida:= minNacim.nroPartida;
    regMae.nombre:= minNacim.nombre;
    regMae.apellido:= minNacim.apellido;
    regMae.direccion:= minNacim.direccion;
    regMae.matriMedNacim:= minNacim.matriMed;
    regMae.nomApMadre:= minNacim.nomApMadre;
    regMae.dniMadre:= minNacim.dniMadre;
    regMae.nomApPadre:= minNacim.nomApPadre;
    regMae.dniPadre:= minNacim.dniPadre;
    if(minNacim.nroPartida = minFallec.nroPartida) then begin  // si tienen el mismo número la persona falleció
      regMae.matriMedFallec:= minFallec.matriMed;
      regMae.fechaHoraFallec:= minFallec.fechaHora;
      regMae.lugarFallec:= minFallec.lugar;

      minimoFallec(vectArchFallec, vectFallec, minFallec);
    end
    else begin
      regMae.matriMedFallec:= 0;
      regMae.fechaHoraFallec:= '-';
      regMae.lugarFallec:= '-';
    end;

    write(maestro, regMae);
    minimoNacim(vectArchNacim, vectNacim, minNacim);

  end;
  writeln('El archivo maestro fue creado correctamente. ');
  close(maestro);
  for i:=0 to dimF do begin
    close(vectArchNacim[i]);
    close(vectArchFallec[i]);
  end;
  
end;

procedure leerMaestro (var maestro: archivoMaestro; var regMae: regMaestro);
begin
  if not eof(maestro) then
    read(maestro, regMae)
  else
    regMae.nroPartida:= valorAlto;
end;

procedure crearArchTexto(var maestro: archivoMaestro; var texto: text);
var
  regMae: regMaestro;
begin
  reset(maestro);
  rewrite(texto);

  leerMaestro(maestro, regMae);
  while (regMae.nroPartida <> valorAlto) do begin
    with regMae do begin
      writeln(texto, 'Nro.Partido ----> ', nroPartida, 'Matricula Nacim: ', matriMedNacim);
      writeln(texto, 'Nombre: ', nombre);
      writeln(texto, 'Apellido: ', apellido);
      writeln(texto, 'Nombre y Apellido Madre: ', nomApMadre);
      writeln(texto, 'Nombre y Apellido Padre: ', nomApPadre);
      writeln(texto, 'Dni Madre: ', dniMadre, 'Dni Padre: ', dniPadre);
      writeln(texto, 'Matri medico FALLECIMIENTO: ', matriMedFallec);
      writeln(texto, 'Fecha y Hora de Fallecimiento: ', fechaHoraFallec);
      writeln(texto, 'Lugar de Fallecimiento: ', lugarFallec);
      writeln(texto, ' ---- ');
    end;
    leerMaestro(maestro, regMae);
  end;
  writeln('El archivo de texto fue creado correctamente. ');
  close(maestro);
  close(texto);

end;

var
  i: integer;
  maestro: archivoMaestro;
  vectArchNacim: vectorArchNacim;
  vectArchFallec: vectorArchFallec;
  archTexto: text;
  str: cadena;
begin
  assign(maestro, 'masterFileEx5.dat');
//assign Nacim
  assign(vectArchNacim[0], 'birthFile1.dat');
  assign(vectArchNacim[1], 'birthFile2.dat');
  assign(vectArchNacim[2], 'birthFile3.dat');
//assign Fallec
  assign(vectArchFallec[0], 'deathFile1.dat');
  assign(vectArchFallec[1], 'deathFile2.dat');
  assign(vectArchFallec[2], 'deathFile3.dat');
  
  crearNacimientos(vectArchNacim);
  writeln(' ');
  writeln('ENTROOOOO');
  crearFallecimientos(vectArchFallec);
  writeln(' ');
  crearArchMaestro(maestro, vectArchNacim, vectArchFallec);
  crearArchTexto(maestro, archTexto);
end.