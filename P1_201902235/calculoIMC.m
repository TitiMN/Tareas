clc;
clear;

pkg load database;

% Conexión a la base de datos
conn = pq_connect(setdbopts('dbname', 'parcial1', 'host', 'localhost', 'port', '5432', 'user', 'postgres', 'password', '2008000070*a'));


% Función para calcular el IMC
function [peso, altura, genero, imc] = calcular_imc()
    while true
        try
            genero = input('Ingrese su género (M/F): ', 's');
            if ~any(strcmp(genero, {'M', 'F'}))
                error('Género no válido. Debe ser "M" o "F".');
            end

            peso = input('Ingrese su peso en kilogramos: ');
            if peso <= 0
                error('El peso debe ser un número positivo.');
            end

            altura = input('Ingrese su altura en metros: ');
            if altura <= 0
                error('La altura debe ser un número positivo.');
            end

            imc = peso / (altura^2);
            fprintf('Su IMC es %.2f\n', imc);
            return;

        catch err
            fprintf('Error: %s\n', err.message);
        end
    end
end

% Función para registrar los datos en la base de datos
function registrar_imc(conn, nombre, peso, altura, genero, imc, fecha, hora)
    sql = 'INSERT INTO peso_corporal (nombre, peso, altura, genero, imc, fecha, hora) VALUES ($1, $2, $3, $4, $5, $6::date, $7::time)';
    pq_exec_params(conn, sql, {nombre, peso, altura, genero, imc, fecha, hora});
end

% Función para guardar los datos en un archivo de texto
function guardar_en_txt(nombre, peso, altura, genero, imc, fecha, hora)
    fecha_formateada = datestr(fecha, 'yyyy-mm-dd');
    hora_formateada = datestr(hora, 'HH:MM:SS');

    archivo = fopen('imc_registros.txt', 'a');
    if archivo == -1
        disp('Error al abrir el archivo de texto.');
        return;
    end

    fprintf(archivo, 'Nombre: %s | Peso: %.2f kg | Altura: %.2f m | Género: %s | IMC: %.2f | Fecha: %s | Hora: %s\n', nombre, peso, altura, genero, imc, fecha_formateada, hora_formateada);
    fclose(archivo);
end

% Función para mostrar el historial de la base de datos
function historial_datos(conn)
    sql_query = 'SELECT nombre, peso, altura, genero, imc, fecha, hora FROM peso_corporal;';
    N = pq_exec_params(conn, sql_query);

    if !isempty(N)
        disp('Historial de registros:');
        for i = 1:size(N, 1)
            % Convertir valores numéricos a formato adecuado si es necesario
            peso = str2double(N{i, 2});
            altura = str2double(N{i, 3});
            imc = str2double(N{i, 5});

            fprintf('Nombre: %s, Peso: %.2f, Altura: %.2f, Género: %s, IMC: %.2f, Fecha: %s, Hora: %s\n', ...
                    N{i, 1}, peso, altura, N{i, 4}, imc, N{i, 6}, N{i, 7});
        end
    else
        disp('No se encontraron registros.');
    end
end

function borrar_datos(conn)
    pq_exec_params(conn, 'DELETE FROM peso_corporal;');
    disp('Se han borrado los registros.');
end

% Programa principal
while true
    disp('------ Menú ------');
    disp('1. Calcular IMC');
    disp('2. Mostrar historial');
    disp('3. Borrar historial');
    disp('4. Salir');
    opcion = input('Seleccione una opción: ');

    switch opcion
        case 1
            % Ingreso de nombre y cálculo del IMC
            nombre = input('Ingrese su nombre: ', 's');
            [peso, altura, genero, imc] = calcular_imc();

            % Obtener la fecha y hora actuales
            fecha = datestr(now, 'yyyy-mm-dd');  % Fecha en formato YYYY-MM-DD
            hora = datestr(now, 'HH:MM:SS');     % Hora en formato HH:MM:SS

            % Registrar en la base de datos
            registrar_imc(conn, nombre, peso, altura, genero, imc, fecha, hora);
            disp('Resultado registrado en la base de datos.');

            % Guardar en el archivo de texto
            guardar_en_txt(nombre, peso, altura, genero, imc, fecha, hora);
            disp('Resultado guardado en el archivo de texto.');

        case 2
            % Mostrar historial
            historial_datos(conn);

        case 3
            % Borrar historial
            borrar_datos(conn);

        case 4
            disp('Saliendo del programa...');
            break;

        otherwise
            disp('Opción no válida. Intente nuevamente.');
    endswitch
endwhile

% Cerrar conexión a la base de datos
if exist("conn", "var")
    pq_close(conn);
else
    disp("No hay conexión abierta.");
end


