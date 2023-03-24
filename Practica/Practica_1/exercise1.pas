program exercise1;
type
    archivo_enteros = file of integer;
var 
    arch_enteros: archivo_enteros; 
    arch_fisico: string[30];
    num: integer;
begin
    write('Ingrese el nombre del archivo: ');
    readln(arch_fisico);

    assign(arch_enteros, arch_fisico);
    rewrite(arch_enteros);


    write('Ingrese numeros enteros y finalizar con el numero 30000: ');
    readln(num);
    while(num <> 30000) do begin
        write(arch_enteros, num);
        readln(num);
    end;
    close(arch_enteros);
end.
    