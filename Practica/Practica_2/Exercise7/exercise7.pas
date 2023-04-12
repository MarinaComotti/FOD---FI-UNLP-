program exercise9;
const
  valorAlto=9999;
type
  voto = record
    codProv: integer;
    codLoc: integer;
    nroMesa: integer;
    cantVotosMesa: integer;
  end;
  archivo = file of voto;

// ----------------SOLO PARA PROBAR ---------------------------

procedure cargarVoto(var vot: voto);
begin
  with vot do begin
    write('Ingrese codigo de Provincia: ');
    readln(codProv);
    if(codProv <> 0) then
    begin
      write('Ingrese cod de Localidad: ');
      readln(codLoc);
      write('Ingrese nro de Mesa: ');
      readln(nroMesa);
      write('Ingrese la cantidad de votos en esa mesa: ');
      readln(cantVotosMesa);

    end;
  end;
end;

procedure crearArchivo(var arch: archivo);
var
  vot: voto;
begin
  rewrite(arch);
  writeln('Ingrese la informacion hasta llegar a codigo de Provincia = 0: ');
  cargarVoto(vot);

  while(vot.codProv <> 0) do begin
    write(arch, vot);
    cargarVoto(vot);
  end;
  close(arch);
end;
// -------------------------------------------------------------------------------------

procedure leer(var arch: archivo; var vot: voto);
begin
  if not eof(arch) then
    read(arch, vot)
  else
    vot.codProv:= valorAlto;
end;

procedure informarVotos (var arch: archivo);
var
  vot: voto;
  provActual, locActual, totalVotLoc, totalVotProv, totalVotGen: integer;
begin
  reset(arch);
  leer(arch, vot);

  totalVotGen:= 0;

  while(vot.codProv <> valorAlto) do begin
    writeln('---------------------------------------------');
    writeln('Provincia: ', vot.codProv);
    writeln('Codigo de Localidad: ','          Total de Votos:');
    provActual:= vot.codProv;
    totalVotProv:= 0;
    while(vot.codProv = provActual) do begin
      locActual:= vot.codLoc;
      totalVotLoc:= 0;
      while( vot.codProv = provActual) and (vot.codLoc = locActual) do begin
        totalVotLoc:= totalVotLoc + vot.cantVotosMesa;
        leer(arch, vot)
      end;
      writeln('        '  ,locActual, '                            ', totalVotLoc);
      totalVotProv:= totalVotProv + totalVotLoc;
    end;
    writeln('Total de Votos Provincia ', provActual, ': ', totalVotProv);
    totalVotGen:= totalVotGen + totalVotProv;
    writeln('---------------------------------------------');
  end;
  writeln('Total General de Votos: ', totalVotGen);

  close(arch);
end;


var 
 arch: archivo;
begin
  assign(arch, 'masterFileEx9.dat');
  //Solo para probar 
  crearArchivo(arch);

  informarVotos(arch);


end.

  