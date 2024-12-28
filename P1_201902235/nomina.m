clc;
clear;

pkg load database;

% Conexión a la base de datos
conn = pq_connect(setdbopts('dbname', 'parcial1', 'host', 'localhost', 'port', '5432', 'user', 'postgres', 'password', '2008000070*a'));

% Constantes
precio_hora = 6;  % Precio por hora normal

% Función para calcular el sueldo
function [nombre, horas_trabajo, horas_extras, sueldo_total] = calcular_sueldo(precio_hora)
    while true
        try
            % Ingreso de datos
            nombre = input('Ingrese su nombre: ', 's');
            horas_trabajo = input('Ingrese las horas trabajadas (horas normales): ');
            if horas_trabajo < 0
                error('Las horas trabajadas no pueden ser negativas.');
            end

            horas_extras = input('Ingrese las horas extras trabajadas: ');
            if horas_extras < 0
                error('Las horas extras no pueden ser negativas.');
            end

            % Cálculo del precio por hora extra
            if horas_extras < 10
                precio_hora_extra = precio_hora * 1.5;  % 50% mayor
            elseif horas_extras >= 10 && horas_extras <= 20
                precio_hora_extra = precio_hora * 1.4;  % 40% mayor
            else
                precio_hora_extra = precio_hora * 1.2;  % 20% mayor
            end

            % Cálculo del sueldo total
            sueldo_base = (horas_trabajo * precio_hora) + (horas_extras * precio_hora_extra);
            sueldo_total = sueldo_base;

            fprintf('El sueldo total de %s es: %.2f\n', nombre, sueldo_total);
            return;

        catch err
            fprintf('Error: %s\n', err.message);
        end
    end
end

% Función para registrar los datos en la base de datos
function registrar_sueldo(conn, nombre, horas_trabajo, horas_extras, sueldo_total, fecha, hora)
    % Asegurarse de que los valores son del tipo adecuado
    horas_trabajo = double(horas_trabajo); % Asegurarse de que horas_trabajo es un número
    horas_extras = double(horas_extras);   % Asegurarse de que horas_extras es un número
    sueldo_total = double(sueldo_total);    % Asegurarse de que sueldo_total es un número

    % Convertir fecha y hora al formato adecuado
    fecha_formateada = datestr(fecha, 'yyyy-mm-dd');
    hora_formateada = datestr(hora, 'HH:MM:SS');

    % Consulta SQL para insertar en la base de datos
    sql = 'INSERT INTO empleado_sueldo (nombre, horas_trabajo, horas_extra, sueldo_total, fecha, hora) VALUES ($1, $2, $3, $4, TO_DATE($5, ''YYYY-MM-DD''), TO_TIMESTAMP($6, ''HH24:MI:SS''))';
    pq_exec_params(conn, sql, {nombre, horas_trabajo, horas_extras, sueldo_total, fecha_formateada, hora_formateada});
end

% Función para guardar los datos en un archivo de texto
function guardar_en_txt(nombre, horas_trabajo, horas_extras, sueldo_total, fecha, hora)
    % Convertir fecha y hora al formato adecuado
    fecha_formateada = datestr(fecha, 'yyyy-mm-dd');
    hora_formateada = datestr(hora, 'HH:MM:SS');

    % Abrir o crear el archivo de texto
    archivo = fopen('sueldo_registros.txt', 'a');
    if archivo == -1
        disp('Error al abrir el archivo de texto.');
        return;
    end

    % Escribir los datos en el archivo
    fprintf(archivo, 'Nombre: %s | Horas Trabajadas: %.2f | Horas Extras: %.2f | Sueldo Total: %.2f | Fecha: %s | Hora: %s\n', nombre, horas_trabajo, horas_extras, sueldo_total, fecha_formateada, hora_formateada);

    % Cerrar el archivo
    fclose(archivo);
end

% Función para mostrar el historial de la base de datos
function historial_datos(conn)
    sql_query = 'SELECT nombre, horas_trabajo, horas_extra, sueldo_total, fecha, hora FROM empleado_sueldo;';
    N = pq_exec_params(conn, sql_query);

    if ~isempty(N)
        disp('Historial de registros:');
        disp(N);
    else
        disp('No se encontraron registros.');
    end
end

% Función para borrar los datos de la tabla
function borrar_datos(conn)
    pq_exec_params(conn, 'DELETE FROM empleado_sueldo;');
    disp('Se han borrado los registros.');
end

% Programa principal
while true
    disp('------ Menú ------');
    disp('1. Calcular sueldo');
    disp('2. Mostrar historial');
    disp('3. Borrar historial');
    disp('4. Salir');
    opcion = input('Seleccione una opción: ');

    switch opcion
        case 1
            % Ingreso de nombre y cálculo del sueldo
            [nombre, horas_trabajo, horas_extras, sueldo_total] = calcular_sueldo(precio_hora);

            % Obtener la fecha y hora actuales
            fecha = now;  % Fecha y hora actual en formato serial
            hora = fecha;

            % Registrar en la base de datos
            registrar_sueldo(conn, nombre, horas_trabajo, horas_extras, sueldo_total, fecha, hora);
            disp('Resultado registrado en la base de datos.');

            % Guardar en el archivo de texto
            guardar_en_txt(nombre, horas_trabajo, horas_extras, sueldo_total, fecha, hora);
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
    disp("No hay conexión activa.");
end



