program exercise1;
const 
  valor_alto = 9999;
type
    empleado = record
        apellido:string[20];
        nombre: string[20];
        nro: integer;
        edad: integer;
        dni: integer;
    end;
    empleados_archivo= file of empleado;


procedure leerEmpleados (var emp: empleado);
begin
  write('Ingrese el apellido del empleado: ');
  readln(emp.apellido);
  if(emp.apellido <> 'fin') then begin
    write('Ingrese el nombre del empleado: ');
    readln(emp.nombre);
    write('Ingrese el nro. del empleado: ');
    readln (emp.nro);
    write('Ingrese la edad del empleado: ');
    readln(emp.edad);
    write('Ingrese el dni del empleado: ');
    readln(emp.dni);
  end;
  
end;



procedure crearArchivo( var empleados: empleados_archivo);
var
    emp: empleado;
begin
  rewrite(empleados);
  writeln('Ingrese los datos de los empleados hasta ingresar apellido: "fin" ');
  writeln(' ---- ');
  
  leerEmpleados(emp);
  while(emp.apellido <> 'fin') do begin
    write(empleados, emp);
    leerEmpleados(emp);
  end;

  writeln(' ---- Finalizo la carga de datos ---- ');

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

// ---------------------- Punto P1. 4) a. --------------------

procedure controlDeUnicidad (var empleados: empleados_archivo; var yaExiste: boolean; nro: integer);
var
    emp: empleado;
begin
  yaExiste:= false;

  reset(empleados);
  while (not eof(empleados)) and (not yaExiste) do begin
    read(empleados, emp);
    if(emp.nro = nro) then 
      yaExiste:= true
  end;

end;

procedure agragarEmpleados (var empleados: empleados_archivo);
var
    emp: empleado;
    estaRepetido: boolean;
begin
  reset(empleados);
  writeln('Agregue los empleados que sea necesario hasta ingresar apellido: "fin" ');

  leerEmpleados(emp);
  while(emp.apellido <> 'fin') do begin
    controlDeUnicidad(empleados, estaRepetido, emp.nro);
    if (not estaRepetido) then 
      write(empleados, emp)
    else
      writeln('Ya se encuentra un empleado con ese numero. No se puede agregar');
    
    leerEmpleados(emp);
  end;

  close(empleados);

end;

// ----------- FIN Punto a. --------------------------

// -------- Punto P1. 4) b. --------------------

procedure leer (var archivo:empleados_archivo; var dato:empleado);  
begin
  if (not eof(archivo)) then      // Si no llegó al final de Detalle, entonces ...
    read (archivo,dato)           // Lee un registro de Detalle y lo guarda en dato
  else
    dato.nro := valor_alto;        // Si llegó al final de Detalle, modifica el codigo de dato por valor_alto = 9999
end;

procedure buscarPos(var empleados: empleados_archivo; nro: integer; var pos: integer);
var
  emp: empleado;
begin
  reset(empleados);

  leer(empleados, emp);
  while(emp.nro <> valor_alto) and (emp.nro <> nro) do begin
    leer(empleados, emp);
  end;

  if (emp.nro = nro) then 
    pos:= filepos(empleados) - 1
  else
    pos:= -3;
  
  
end;

procedure modificarEdades(var empleados: empleados_archivo);
var
  nuevaEdad, nro, pos: integer;
  emp: empleado;
begin
  reset(empleados);

  write('Ingrese el nro. del empleado cuya edad va a ser modificada, o ingrese -1 para terminar: ');
  readln(nro);

  while(nro <> -1) do begin
    buscarPos(empleados, nro, pos);

    if(pos <> -3) then begin
      write('Ingrese la nueva edad: ');
      readln(nuevaEdad);
      seek(empleados, pos);
      read(empleados, emp);
      emp.edad:= nuevaEdad;
      seek(empleados, filepos(empleados)-1);
      write(empleados, emp);
    end
    else
      writeln('No se encontro un empleado con ese numero.');
    
    write('Ingrese otro nro. del empleado cuya edad va a ser modificada, o ingrese -1 para terminar: ');
    readln(nro);

  end;

  close(empleados);

end;

// ----------- FIN Punto P1. 4) b. -----------------------------

// ------------ Punto P1. 4) c. ----------------------------

procedure exportarATexto (var empleados: empleados_archivo; var arch_text: Text);
var
  emp: empleado;
begin
  reset(empleados);
  rewrite(arch_text);

  while not eof(empleados) do begin
    read(empleados, emp);
    
    with emp do
      writeln(arch_text, 'Apellido: ', apellido, ' Nombre: ', nombre, ' Nro: ', nro, ' Edad: ', edad, ' Dni: ', dni);
  end;

  close(empleados);
  close(arch_text);

end;
// ---------------- FIN Punto c. --------------------------------

// --------------- Punto 4) d. -------------------------------------

procedure exportarATextoSinDNI(var empleados: empleados_archivo; var arch_text: Text);
var
  emp: empleado;
begin
  reset(empleados);
  rewrite(arch_text);

  while not eof(empleados) do begin
    read(empleados, emp);
    if (emp.dni = 0) then 
      with emp do
        writeln(arch_text, 'Apellido: ', apellido, ' Nombre: ', nombre, ' Nro: ', nro, ' Edad: ', edad, ' Dni: ', dni);
    
  end;
  close(empleados);
  close(arch_text);
  
end;


// ---------------------- Punto P3. 1) --------------------------------------

procedure realizarBaja(var empleados: empleados_archivo);
var
  nroEmpABorrar: integer;
  ultimoReg, regEmpleado: empleado;
  posABorrar: integer;
begin
  reset(empleados);
  writeln('Ingrese el nro del empleado que quiere borrar: ');
  readln(nroEmpABorrar);
  
  leer(empleados, regEmpleado);
  //Recorro el archivo hasta encontrar el empleado a borrar
  while (regEmpleado.nro <> valor_alto) and (regEmpleado.nro <> nroEmpABorrar) do 
    leer(empleados, regEmpleado);
  
  if(regEmpleado.nro <> valor_alto) then begin
     //Cuando lo encuentro, guardo la posicion en la que se encontro
    posABorrar:= filepos(empleados) - 1;

//
    if(posABorrar <> filesize(empleados)-1) then begin
        //Me ubico en la pos del ultimo reg del archivo
        seek(empleados, filesize(empleados) -1);
        //writeln('Pos del ultimo registro: ', filesize(empleados));
        read(empleados, ultimoReg);  //guardo el ultimo registro del archivo para no perderlo y avanza autom. una pos
        seek(empleados, posABorrar);  //Voy a la posicion del registro que se quiere borrar
        write(empleados, ultimoReg); //Escribo el ultimo registro en esa posicion
    end;

    seek(empleados, filesize(empleados) -1);  //me ubico en la pos del ultimo registro

    Truncate(empleados); //trunco el archivo desde la posicion del ultimo registro
  

  
    writeln('El empleado con nro. ', nroEmpABorrar, ' fue borrado correctamente del archivo.');
    
  end
  else
    writeln('El nro de empleado ingresado no se encuentra registrado en el archivo.');
  
 
  close(empleados);
end;  






// -------------------------------------------------------------------------



var
    empleados: empleados_archivo;
    arch_fisico: string[20];
    opcion: char;
    todos_text: Text;
    faltanDNI_text: Text;
begin
  //write('Ingrese el nombre del archivo a crear o utilizar: ');
  //readln(arch_fisico);
  assign(empleados, 'fileExercise4.dat');
  assign(todos_text, 'todos_empleados.txt');
  assign(faltanDNI_text, 'faltaDNIEmpleado.txt');

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
    writeln('Para agregar empleados nuevos: 4');
    writeln('Para modificar la edad de 1 o mas empleados: 5');
    writeln('Para exportar el contenido del archivo a un archivo de texto: 6');
    writeln('Para exportar a un archivo de texto los empleados que no tengan cargado el DNI: 7');
    writeln('Para borrar un empleado del archivo: 8');
  end;
  readln(opcion);

  case opcion of
    '1': listarEmpleados(empleados);
    '2': listarTodosLosEmpleados(empleados);
    '3': listarEmpleadosMayores(empleados);
    '4': agragarEmpleados(empleados);
    '5': modificarEdades(empleados);
    '6': exportarATexto(empleados, todos_text);
    '7': exportarATextoSinDNI(empleados, faltanDNI_text);
    '8': realizarBaja(empleados);
  end;
    

end.