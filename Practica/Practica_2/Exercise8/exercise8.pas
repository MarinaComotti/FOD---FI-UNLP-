//Lo revise con la explicación de la práctica y lo tengo igual. Pero no lo ejecuté para probarlo


program exercise8;
const
  valorAlto = 9999;
type
  cadena = string[40];
  regMaestro = record
    codigoCli: integer;
    nomYap: cadena;
    anio: integer;
    mes: integer;
    dia: integer;
    monto: double;
  end;

  archivoMaestro = file of regMaestro;



procedure leer(var maestro: archivoMaestro; var venta: regMaestro);
begin
  if not eof(maestro) then
    read(maestro, venta)
  else
    venta.codigoCli:= valorAlto;
end;


procedure informarDatosPersonales(cod: integer; nA: cadena);
begin
    writeln('Código de cliente: ', cod);
    writeln('Nombre y apellido: ', nA);
end;

procedure informarReporteVentas(var maestro: archivoMaestro);
var
  venta: regMaestro;
  clienteActual, anioActual, mesActual: integer;
  totalMensual, totalAnio, totalCliente, totalEmpresa: double;

begin
  reset(maestro);
  leer(maestro, venta);
   
  totalEmpresa:= 0;

  while(venta.codigoCli <> valorAlto) do begin
    writeln('---------------------------------------------');
    informarDatosPersonales(venta.codigoCli, venta.nomYap);
    clienteActual:= venta.codigoCli;
    totalCliente:= 0;
    while(venta.codigoCli = clienteActual) do begin
      anioActual:= venta.anio;
      totalAnio:= 0;

      while(venta.codigoCli = clienteActual) and (venta.anio = anioActual) do begin
        mesActual:= venta.mes;
        totalMensual:= 0;

        while(venta.codigoCli = clienteActual) and (venta.anio = anioActual) and (venta.mes = mesActual) do begin
          totalMensual:= totalMensual + venta.monto;
          leer(maestro, venta);
        end;
        writeln('El monto total del mes: ', mesActual ,' fue de: ', totalMensual:2:2, '$');
        totalAnio:= totalAnio + totalMensual;
      end;
      writeln('El monto total del anio: ', anioActual,' fue de: ', totalAnio:2:2, '$');
      totalCliente:= totalCliente + totalAnio;     //No lo pide pero lo agregué igual para calcular el totalEmpresa
    end;
    writeln('---------------------------------------------');
    totalEmpresa:= totalEmpresa + totalCliente;

  end;

writeln('El monto total de ventas obtenido por la empresa fue de: ', totalEmpresa:2:2, '$');

close(maestro);
end;

var
  maestro: archivoMaestro;
begin
  assign(maestro, 'masterFileEx8.pas');
  informarReporteVentas(maestro);

end.