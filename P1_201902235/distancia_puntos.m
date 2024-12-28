clc;
clear;

pkg load database;

% Conexión a la base de datos
conn = pq_connect(setdbopts('dbname', 'parcial1', 'host', 'localhost', 'port', '5432', 'user', 'postgres', 'password', '2008000070*a'));

function [x1, y1, x2, y2, resultado] = calcular_distancia()
    while true
        try

            x1 = input('Ingrese la coordenada x1: ');
            if !isnumeric(x1)
                error('La coordenada x1 debe ser un número.');
            end

            y1 = input('Ingrese la coordenada y1: ');
            if !isnumeric(y1)
                error('La coordenada y1 debe ser un número.');
            end

            x2 = input('Ingrese la coordenada x2: ');
            if !isnumeric(x2)
                error('La coordenada x2 debe ser un número.');
            end

            y2 = input('Ingrese la coordenada y2: ');
            if !isnumeric(y2)
                error('La coordenada y2 debe ser un número.');
            end

            % Calcular la distancia
            resultado = sqrt((x2 - x1)^2 + (y2 - y1)^2);
            fprintf('La distancia entre los puntos (%.2f, %.2f) y (%.2f, %.2f) es %.2f\n', x1, y1, x2, y2, resultado);
            return;

        catch err
            fprintf('Error: %s\n', err.message);
        end
    end
end

function registrar_distancia(conn, nombre, x1, y1, x2, y2, resultado, fecha, hora)
    sql = 'INSERT INTO distancia_puntos (nombre, x1, y1, x2, y2, resultado, fecha, hora) VALUES ($1, $2, $3, $4, $5, $6, TO_DATE($7, ''YYYY-MM-DD''), CAST($8 AS time));';
    pq_exec_params(conn, sql, {nombre, x1, y1, x2, y2, resultado, fecha, hora});
end

function guardar_en_txt(nombre, x1, y1, x2, y2, resultado, fecha, hora)
    fecha_formateada = datestr(fecha, 'yyyy-mm-dd');
    hora_formateada = datestr(hora, 'HH:MM:SS');

    archivo = fopen('distancia_registros.txt', 'a');
    if archivo == -1
        disp('Error al abrir el archivo de texto.');
        return;
    end

    fprintf(archivo, 'Nombre: %s | Coordenada (x1, y1): (%.2f, %.2f) | Coordenada (x2, y2): (%.2f, %.2f) | Distancia: %.2f | Fecha: %s | Hora: %s\n', nombre, x1, y1, x2, y2, resultado, fecha_formateada, hora_formateada);
    fclose(archivo);
end

function historial_datos(conn)
    sql_query = 'SELECT nombre, x1, y1, x2, y2, resultado, fecha, hora FROM distancia_puntos;';
    N = pq_exec_params(conn, sql_query);

    if !isempty(N)
        disp('Historial de registros:');
        disp(N);
    else
        disp('No se encontraron registros.');
    end
end

function borrar_datos(conn)
    pq_exec_params(conn, 'DELETE FROM distancia_puntos;');
    disp('Se han borrado los registros.');
end

while true
    disp('------ Menú ------');
    disp('1. Calcular distancia');
    disp('2. Mostrar historial');
    disp('3. Borrar historial');
    disp('4. Salir');
    opcion = input('Seleccione una opción: ');

    switch opcion
        case 1
            nombre = input('Ingrese su nombre: ', 's');
            [x1, y1, x2, y2, resultado] = calcular_distancia();

            fecha = datestr(now, 'yyyy-mm-dd');
            hora = datestr(now, 'HH:MM:SS');

            registrar_distancia(conn, nombre, x1, y1, x2, y2, resultado, fecha, hora);
            disp('Resultado registrado en la base de datos.');

            guardar_en_txt(nombre, x1, y1, x2, y2, resultado, fecha, hora);
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


