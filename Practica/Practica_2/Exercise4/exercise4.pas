//FALTA TERMINAR --> CONSULTAR EL TEMA DE LAS FECHAS

program exercise4;
const
    valorAlto = 9999;
    dimF = 5;
type
    regMestro = record
        codUsuario: integer;
        fecha: integer;   // ?? 
        tiempoSesionTotal: double;    //tiempo en segundos, ponele
    end; 
    regDetalle = record
        codUsuario: integer;
        fecha:integer;
        tiempoSesion:double;
    end;
    archivoMaestro = file of regMestro;
    archivoDetalle = file of regDetalle;
    vectorArchivosDetalle = array[1..dimF] of archivoDetalle;
    vectorRegDetalle = array [1..dimF] of regDetalle;

procedure leerDetalle (var detalle: archivoDetalle; var regDet: regDetalle)
begin
  if not oef(detalle) then
    read(detalle, regDet)
  else
    regDet.codUsuario:= valorAlto;
end;

procedure minimo (var detalles: vectorDetalles; var vectRegDet: vectorRegDetalle; var min: regDetalle)
var
  i, posMin, codMin: integer;
begin
  codMin:= 9999;
  for i:=0 to dimF do
    if(vectRegDet[i].codUsuario < codMin) then begin
      min:= vectRegDet[i];
      posMin:= i;
      codMin:=vectRegDet[i];
    end;

  leerDetalle(detalles[posMin], vectRegDet[posMin]);
end;


procedure merge(var maestro: archivoMaestro; var detalles: archivoDetalle);
var
  vectRegDet: vectorArchivosDetalle;
  min: regDetalle;
  i: integer;
  regMae: regMestro;
begin
  rewrite(maestro);
  for i:=0 to dimF do begin
    reset(detalles[i]);
    leer(detalles[i], vectRegDet[i]);
  end; 

  minimo(detalles, vectRegDet, min);
  
  while(min.codUsuario <> valorAlto) do begin
    regMae.codUsuario:= min.codUsuario
    regMae.tiempoSesionTotal:= 0;

    while(regMae.codUsuario == min.codUsuario) do begin
      regMae
    end;


  end;
    

  
end;