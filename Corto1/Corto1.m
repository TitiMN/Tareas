clc;
clear;

pkg load database;

% Conexión a la base de datos
conn = pq_connect(setdbopts('dbname', 'Corto1', 'host', 'localhost', 'port', '5432', 'user', 'postgres', 'password', '2008000070*a'));

% Función para detectar palíndromos
function es_palindromo = detectar_palindromo(texto)
    texto = lower(regexprep(texto, '\W', ''));  % Convertir a minúsculas y eliminar caracteres no alfanuméricos
    es_palindromo = strcmp(texto, flip(texto));
end

% Función para detectar números primos
function es_primo = detectar_primo(numero)
    if numero <= 1
        es_primo = false;
        return;
    end
    es_primo = all(mod(numero, 2:floor(sqrt(numero))) != 0);
end

% Función para detectar números perfectos
function es_perfecto = detectar_perfecto(numero)
    suma_divisores = sum(divisors(numero)) - numero;
    es_perfecto = (suma_divisores == numero);
end

% Función para registrar datos en la base de datos
function registrar_datos(conn, nombre_usuario, tipo, entrada, resultado)
    try
        fecha = datestr(now, 'yyyy-mm-dd');
        hora = datestr(now, 'HH:MM:SS');

        sql = 'INSERT INTO ejecuciones_programa (nombre_usuario, fecha, hora, ejecucion) VALUES ($1, $2::date, $3::time, $4)';
        ejecucion = sprintf('%s: Entrada = %s, Resultado = %s', tipo, num2str(entrada), num2str(resultado));
        pq_exec_params(conn, sql, {nombre_usuario, fecha, hora, ejecucion});
    catch err
        fprintf('Error al registrar datos: %s\n', err.message);
    end
end

% Función para mostrar el historial de datos
function historial_datos(conn)
    try
        sql_query = 'SELECT nombre_usuario, fecha, hora, ejecucion FROM ejecuciones_programa;';
        N = pq_exec_params(conn, sql_query);

        if !isempty(N)
            disp('Historial de ejecuciones:');
            for i = 1:size(N, 1)
                fprintf('Usuario: %s, Fecha: %s, Hora: %s, Ejecución: %s\n', N{i, 1}, N{i, 2}, N{i, 3}, N{i, 4});
            end
        else
            disp('No se encontraron registros.');
        end
    catch err
        fprintf('Error al mostrar historial: %s\n', err.message);
    end
end

% Función para borrar datos
function borrar_datos(conn)
    try
        pq_exec_params(conn, 'DELETE FROM ejecuciones_programa;');
        disp('Se han borrado los registros.');
    catch err
        fprintf('Error al borrar datos: %s\n', err.message);
    end
end

% Programa principal
while true
    disp('------ Menú ------');
    disp('1. Detector de Palíndromos');
    disp('2. Detector de Número Primo');
    disp('3. Detector de Número Perfecto');
    disp('4. Mostrar historial de datos');
    disp('5. Borrar datos');
    disp('6. Salir');
    opcion = input('Seleccione una opción: ');

    switch opcion
        case 1
            nombre_usuario = input('Ingrese su nombre de usuario: ', 's');
            texto = input('Ingrese un texto: ', 's');
            resultado = detectar_palindromo(texto);
            registrar_datos(conn, nombre_usuario, 'Palíndromo', texto, resultado);
            if resultado
                fprintf('El texto "%s" es un palíndromo.\n', texto);
            else
                fprintf('El texto "%s" no es un palíndromo.\n', texto);
            end

        case 2
            nombre_usuario = input('Ingrese su nombre de usuario: ', 's');
            numero = input('Ingrese un número: ');
            resultado = detectar_primo(numero);
            registrar_datos(conn, nombre_usuario, 'Número Primo', numero, resultado);
            if resultado
                fprintf('El número %d es un número primo.\n', numero);
            else
                fprintf('El número %d no es un número primo.\n', numero);
            end

        case 3
            nombre_usuario = input('Ingrese su nombre de usuario: ', 's');
            numero = input('Ingrese un número: ');
            resultado = detectar_perfecto(numero);
            registrar_datos(conn, nombre_usuario, 'Número Perfecto', numero, resultado);
            if resultado
                fprintf('El número %d es un número perfecto.\n', numero);
            else
                fprintf('El número %d no es un número perfecto.\n', numero);
            end

        case 4
            historial_datos(conn);

        case 5
            borrar_datos(conn);

        case 6
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



