program exercise6;
const
  valorAlto = 9999;
  dimF = 10;
type
  cadena = string[20];
  regMaestro = record
    codLoc: integer;
    nomLoc: cadena;
    codCepa: integer;
    nomCepa: cadena;
    cantCasosActivos: integer;
    cantCasosNuevos: integer;
    cantRecuperados: integer;
    cantFallecidos: integer;
  end;
  regDetalle = record
    codLoc: integer;
    codCepa: integer;
    cantCasosActivos: integer;
    cantCasosNuevos: integer;
    cantRecuperados: integer;
    cantFallecidos: integer;
  end;

  archivoMaestro = file of regMaestro;
  archivoDetalle = file of regDetalle;

  vectorDetalles = array[1..dimF] of archivoDetalle;
  vectorRegDetalles = array[1..dimF] of regDetalle;


procedure leerDetalle (var detalles: archivoDetalle, var regDet: regDetalle);
begin
  if not eof(detalles) then
    read(detalles, regDet)
  else
    regDet.codLoc:= valorAlto;
end;

procedure minimo(var vectDetalles: vectorDetalles; var vectRegDet: vectorRegDetalles; var min: regDet);
var
  i, codLocMin, posMin: integer;
begin
  codLocMin:= 9999;
  for i:=0 to dimF do 
    if (vectRegDet[i].codLoc < codLocMin) then begin
      min:= vectRegDet[i];
      posMin:= i;
      codLocMin:= vectRegDet[i].codLoc;
    end;
  
  leerDetalle(vectDetalles[posMin], vectRegDet[posMin]);

end;

procedure actualizarMaestro (var maestro: archivoMaestro; var vectDetalles: vectorDetalles);
var
  vectRegDet: vectorRegDetalles;
  min: regDetalle;
  regMae: regMaestro;
  i: integer;
begin
  reset(maestro);
  for i:= 0 to dimF do begin
    reset(vectDetalles[i]);
    leerDetalle(vectDetalles[i], vectRegDet[i]);
  end;

  minimo(vectDetalles, vectRegDet, min);   //Retorna el registro con la localidad mínima del vector de registros Detalles

  while(min.codLoc <> valorAlto) do begin
    read(maestro, regMae);
    while(min.codLoc <> regMae.codLoc) and (min.codCepa <> regMae.codCepa) do 
      read(maestro, regMae);
      //ESTE IF ES MEDIO REDUNDANTE NO ?? Creo que si no está podría funcionar igual. CONSULTAR
    if(min.codLoc = regMae.codLoc) and (min.codCepa = regMae.codCepa) do begin  // Si son iguales, actualiza
      regMae.cantFallecidos:= regMae.cantFallecidos + min.cantFallecidos;
      regMae.cantRecuperados:= regMae.cantRecuperados + min.cantRecuperados; 
      regMae.cantCasosActivos:= min.cantCasosActivos; //Así se actualizarían los activos !!??
      regMae.cantCasosNuevos:=  min.cantCasosNuevos;
    end;
    minimo(vectDetalles, vectRegDet, min);
  end;

  close(maestro);
  for i:=0 to dimF do 
    close(vectDetalles[i]);

end;

procedure leerMaestro(var maestro: archivoMaestro; var regMae: regMaestro);
begin
  if not eof(maestro) then
    read(maestro, regMae)
  else
    regMae.codLoc:= valorAlto;
end;

//Aplique corte de control para contar el total de casos activos de todas las cepas de una misma localidad
//CONSULTAR
procedure informarLocalidades(var maestro);
var
  regMae: regMaestro;
  cantTotalActivos: integer;
  codLocActual: integer;
  cantLoc: integer;
begin
  reset(maestro);
  cantLoc:= 0;

  leerMaestro(maestro, regMae);

  while(regMae.codLoc <> valorAlto) do begin
    codLocActual:= regMae.codLoc;
    cantTotalActivos:= 0;
    while (regMae.codLoc = codLocActual) do begin
      cantTotalActivos:= cantTotalActivos + regMae.cantCasosActivos;
      leerMaestro(maestro, regMae);
    end;
      if(cantTotalActivos > 50) then
        cantLoc:= cantLoc + 1
  end;

  writeln('La cantidad de localidades con mas de 50 casos activos es: ', cantLoc);
  close(maestro);
end;


var
  maestro: archivoMaestro;
  detalles: vectorDetalles;
  i: integer;
begin
  assign(maestro, 'masterFileEx6.dat');
  for i:= 0 to dimF do 
    assign(detalle, 'detFileEx6.dat'+intToString(i));

actualizarMaestro(maestro, detalles);
informarLocalidades(maestro);
end;