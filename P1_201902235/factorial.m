clc;
clear;

pkg load database;

conn = pq_connect(setdbopts('dbname', 'parcial1', 'host', 'localhost', 'port', '5432', 'user', 'postgres', 'password', '2008000070*a'));

function [n, resultado] = calcular_factorial()
    while true
        try
            n = input('Ingresa un número entero positivo: ', 's');

            if isempty(regexp(n, '^\d+$', 'once'))
                error('Has ingresado un carácter no numérico. Intenta de nuevo.');
            end

            n = str2double(n);

            if n < 0
                error('El factorial no está definido para números negativos.');
            elseif n == 0 || n == 1
                resultado = 1;
            else
                resultado = prod(2:n);
            end

            % Mostrar el resultado sin notación científica
            fprintf('El factorial de %d es %d\n', n, resultado);
            return;

        catch err
            fprintf('Error: %s\n', err.message);
        end
    end
end

function registrar_factorial(conn, nombre, n, resultado)
    fecha = datestr(now, 'yyyy-mm-dd');
    hora = datestr(now, 'HH:MM:SS');

    sql = 'INSERT INTO factorial (nombre, dato_ingresado, resultado, fecha, hora) VALUES ($1, $2, $3, $4::date, $5::time)';
    pq_exec_params(conn, sql, {nombre, n, resultado, fecha, hora});
end

function guardar_en_txt(nombre, n, resultado, fecha, hora)
    fecha_formateada = datestr(fecha, 'yyyy-mm-dd');
    hora_formateada = datestr(hora, 'HH:MM:SS');

    archivo = fopen('factorial_registros.txt', 'a');
    if archivo == -1
        disp('Error al abrir el archivo de texto.');
        return;
    end

    fprintf(archivo, 'Nombre: %s | Número: %d | Resultado: %d | Fecha: %s | Hora: %s\n', nombre, n, resultado, fecha_formateada, hora_formateada);
    fclose(archivo);
end

function historial_datos(conn)
    sql_query = 'SELECT nombre, dato_ingresado, resultado, fecha, hora FROM factorial;';
    N = pq_exec_params(conn, sql_query);

    if !isempty(N)
        disp('Historial de registros:');
        disp(N);
    else
        disp('No se encontraron registros.');
    end
end

function borrar_datos(conn)
    N = pq_exec_params(conn, 'DELETE FROM factorial;');
    disp('Se han borrado los registros.');
end

while true
    disp('------ Menú ------');
    disp('1. Calcular factorial');
    disp('2. Mostrar historial');
    disp('3. Borrar historial');
    disp('4. Salir');
    opcion = input('Seleccione una opción: ');

    switch opcion
        case 1
            nombre = input('Ingrese su nombre: ', 's');
            [n, resultado] = calcular_factorial();
            registrar_factorial(conn, nombre, n, resultado);
            disp('Resultado registrado en la base de datos.');

            fecha = datestr(now, 'yyyy-mm-dd');
            hora = datestr(now, 'HH:MM:SS');

            guardar_en_txt(nombre, n, resultado, fecha, hora);
            disp('Resultado guardado en el archivo de texto.');

        case 2
            historial_datos(conn);

        case 3
            borrar_datos(conn);

        case 4
            disp('Saliendo del programa...');
            break;

        otherwise
            disp('Opción no válida. Intente nuevamente.');
    endswitch
endwhile

if exist("conn", "var")
    pq_close(conn);
else
    disp("No hay conexión abierta.");
end


