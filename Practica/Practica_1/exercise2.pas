program exercise2;
type
    archivo_enteros = file of integer;

function calcularPromedio(sumaTotal, tamano: integer): double;
begin
  calcularPromedio:= sumaTotal/tamano;
end;

var 
    sumaTotal, cantNumMenores, num: integer;
    arch_enteros: archivo_enteros;
    arch_fisico: string[20];
begin
  write('Ingrese el nombre del archivo: ');
  readln(arch_fisico);
  assign(arch_enteros, arch_fisico);
  reset (arch_enteros);

  cantNumMenores:=0;
  sumaTotal:= 0;
  while not eof(arch_enteros) do begin
    read(arch_enteros, num);
    if num<1500 then
      cantNumMenores:= cantNumMenores + 1;
    sumaTotal:= sumaTotal + 1;
    writeln(num);
  end;

  writeln('La cantidad de numeros menores a 1500 es: ', cantNumMenores);
  writeln('El promedio de los numeros es: ', calcularPromedio(sumaTotal, fileSize(arch_enteros)):2:2);

  close(arch_enteros);
end.
