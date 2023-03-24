program exercise3;
type
    empleado = record
        apellido:string[20];
        nombre: string[20];
        nro: integer;
        edad: integer;
        dni: integer;
    end;
    empleados_archivo= file of empleado;

procedure crearArchivo( var empleados: empleados_archivo);
var
    emp: empleado;
begin
  rewrite(empleados);
  write('Ingrese el apellido: ');
  readln(emp.apellido);
  while(emp.apellido <> 'fin') do begin
    write('Ingrese el nombre: ');
    readln(emp.nombre);
    write('Ingrese el numero de empleado: ');
    readln(emp.nro);
    write('Ingrese la edad: ');
    readln(emp.edad);
    write('Ingrese el DNI: ');
    readln(emp.dni);

    write(empleados, emp);

    write('Ingrese otro apellido o "fin" para terminar: ');
    readln(emp.apellido);
  end;

  close(empleados);
end;

procedure  listarEmpleados (var empleados: empleados_archivo);
var
    nombreApellido: string[20];
    emp: empleado;
begin
  write('Ingrese el nombre o apellido a buscar: ');
  readln(nombreApellido);

  reset(empleados);
  while not eof(empleados) do begin
    read (empleados, emp);
    if(nombreApellido = emp.apellido) or (nombreApellido = emp.nombre) then begin
      writeln('---> Apellido: ', emp.apellido);
      writeln('Nombre: ', emp.nombre);
      writeln('Nro. de empleado: ', emp.nro);
      writeln('Edad: ', emp.edad);
      writeln('DNI: ', emp.dni);
    end;
  end;

  close(empleados);

end;

procedure listarTodosLosEmpleados(var empleados: empleados_archivo);
var
    emp: empleado;
begin
  reset(empleados);
  while not eof(empleados) do begin
    read(empleados, emp);
    writeln('Apellido: ', emp.apellido, ' - Nombre: ', emp.nombre, ' - Nro. de empleado: ', emp.nro, ' - Edad: ', emp.edad, ' - DNI: ', emp.dni);
  end;
  close(empleados);
end;

procedure listarEmpleadosMayores(var empleados: empleados_archivo);
var
    emp: empleado;
begin
  reset(empleados);

  while not eof(empleados) do begin
    read(empleados, emp);
    if (emp.edad > 70) then begin
      writeln('---> Apellido: ', emp.apellido);
      writeln('Nombre: ', emp.nombre);
      writeln('Nro. de empleado: ', emp.nro);
      writeln('Edad: ', emp.edad);
      writeln('DNI: ', emp.dni);
    end;
  end;
  
  close(empleados);
end;


var
    empleados: empleados_archivo;
    arch_fisico: string[20];
    opcion: char;
begin
  write('Ingrese el nombre del archivo a crear o utilizar: ');
  readln(arch_fisico);
  assign(empleados, arch_fisico);

  writeln('MENU DE OPCIONES: ');
  writeln('Para crear un archivo ingrese : a');
  writeln('Para abrir el archivo ingrese: b');
  readln(opcion);

  if(opcion = 'a') then
    crearArchivo(empleados)
  else begin
    writeln('Para listar los empleados con un nombre o apellido determinado ingrese: 1');
    writeln('Para listar todos los empleados ingrese: 2');
    writeln('Para listar todos los empleados mayores a 70 anios ingrese: 3');
  end;
  readln(opcion);

  case opcion of
    '1': listarEmpleados(empleados);
    '2': listarTodosLosEmpleados(empleados);
    '3': listarEmpleadosMayores(empleados);
  end;
    

end.