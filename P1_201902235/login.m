clc;
clear;

pkg load database;

% Conexión a la base de datos
conn = pq_connect(setdbopts('dbname', 'parcial1', 'host', 'localhost', 'port', '5432', 'user', 'postgres', 'password', '2008000070*a'));

function registrar_login(conn, nombre, aprobo)
    % Obtener la fecha y hora actuales
    fecha = datestr(now, 'yyyy-mm-dd');  % Fecha en formato YYYY-MM-DD
    hora = datestr(now, 'HH:MM:SS');     % Hora en formato HH:MM:SS

    % Guardar en la base de datos
    sql = 'INSERT INTO login (nombre, aprobo, fecha, hora) VALUES ($1, $2, $3::date, $4::time)';
    pq_exec_params(conn, sql, {nombre, aprobo, fecha, hora});

    % Guardar en archivo de texto
    guardar_en_txt(nombre, aprobo, fecha, hora);
end

function guardar_en_txt(nombre, aprobo, fecha, hora)
    % Abre o crea un archivo de texto para guardar los registros
    archivo = fopen('login.txt', 'a');
    if archivo == -1
        disp('Error al abrir el archivo.');
        return;
    end

    % Escribir los datos en el archivo
    fprintf(archivo, 'Nombre: %s | Aprobó: %s | Fecha: %s | Hora: %s\n', nombre, aprobo, fecha, hora);

    % Cerrar el archivo
    fclose(archivo);
end

function contrasena = leer_contrasena(prompt)
    contrasena = '';
    disp(prompt);
    while true
        char = kbhit();
        if char == 13
            break;
        elseif char == 8 && !isempty(contrasena)
            contrasena(end) = '';
            printf('\b \b');
        else
            contrasena = [contrasena, char];
            printf(' ');
        end
    end
    printf('\n');
end

% Función para el sistema de login
function login(conn)

    usuario_correcto = 'admin';
    contrasena_correcta = '123';
    intentos = 3;

    nombre = input("Ingrese su nombre: ", "s");

    while intentos > 0

        usuario_ingresado = input("Ingrese su nombre de usuario: ", "s");
        contrasena_ingresada = leer_contrasena("Ingrese su contraseña: ");

        % Comparar el nombre de usuario y la contraseña
        if strcmp(usuario_ingresado, usuario_correcto) && strcmp(contrasena_ingresada, contrasena_correcta)
            disp('Bienvenido!');
            aprobo = 'SI';
            registrar_login(conn, nombre, aprobo);
            return;
        else
            disp('Nombre de usuario o contraseña incorrectos.');
            intentos = intentos - 1;
            if intentos == 0
                disp('Ha excedido el número de intentos permitidos. El programa se cerrará.');
                aprobo = 'NO';
                registrar_login(conn, nombre, aprobo);
                break;
            else
                fprintf('Le quedan %d intentos.\n', intentos);
            end
        end
    end
end

function historial_login(conn)
    sql_query = 'SELECT nombre, fecha, hora FROM login;';
    N = pq_exec_params(conn, sql_query);

    if !isempty(N)
        disp('Historial de logins:');
        disp(N);
    else
        disp('No se encontraron registros.');
    end
end

% Función para borrar los datos de la tabla
function borrar_login(conn)
    pq_exec_params(conn, 'DELETE FROM login;');
    disp('Se han borrado los registros de login.');
end

while true
    disp('------ Menú ------');
    disp('1. Iniciar sesión');
    disp('2. Mostrar historial de logins');
    disp('3. Borrar historial de logins');
    disp('4. Salir');
    opcion = input('Seleccione una opción: ');

    switch opcion
        case 1
            % Iniciar sesión
            login(conn);

        case 2
            % Mostrar historial de logins
            historial_login(conn);

        case 3
            % Borrar historial de logins
            borrar_login(conn);

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


