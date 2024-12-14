clc;
clear;

pkg load database;

% Opciones de conexión a la base de datos
dbopts.dbname = 'tarea6';           % Nombre de la base de datos
dbopts.host = 'localhost';           % Dirección del servidor
dbopts.port = '5432';                % Puerto del servidor PostgreSQL
dbopts.user = 'postgres';            % Usuario
dbopts.password = '2008000070*a';             % Contraseña

% Conexión a la base de datos
conn = pq_connect(dbopts);

% Verificación de conexión
if isempty(conn)
    error("Error: No se pudo conectar a la base de datos.");
end

disp("Conexión a la base de datos establecida exitosamente.");

while true
    disp('------ Menú ------');
    disp('1. Ingreso de datos');
    disp('2. Historial de datos');
    disp('3. Borrar datos');
    disp('4. Salir');
    opcion = input('Seleccione una opción (1-4): ');

    switch opcion
        case 1
            % Ingreso de datos
            nombre = input("Ingrese su nombre: ", "s");
            nit = input("Ingrese su NIT: ", "s");
            placa = input("Ingrese su número de placa: ", "s");

            disp("Para los siguientes datos utilice formato de 24 horas (Ej: 16:30).\n");

            % Validación de la hora de entrada
            while true
                entradah = input("Ingrese la hora de entrada (0-23): ");
                if entradah >= 0 && entradah <= 23
                    break;
                else
                    disp("Error: Por favor, ingrese una hora válida.");
                end
            end

            while true
                entradam = input("Ingrese el minuto de entrada (0-59): ");
                if entradam >= 0 && entradam <= 59
                    break;
                else
                    disp("Error: Por favor, ingrese un minuto válido.");
                end
            end

            % Validación de la hora de salida
            while true
                salidah = input("Ingrese la hora de salida (0-23): ");
                if salidah >= entradah && salidah <= 23
                    break;
                else
                    disp("Error: La hora de salida debe ser mayor o igual a la hora de entrada y válida.");
                end
            end

            while true
                salidam = input("Ingrese el minuto de salida (0-59): ");
                if salidam >= 0 && salidam <= 59
                    break;
                else
                    disp("Error: Por favor, ingrese un minuto válido.");
                end
            end

            % Cálculo de tiempo y tarifa
            horas = salidah - entradah;
            if salidam > entradam
                horas = horas + 1;
            end

            if horas < 2
                total = 15;
            else
                total = horas * 20;
            end

            % Mostrar factura
            disp(" ");
            disp("---------------------------------");
            disp("Parqueo del T3");
            disp("FACTURA");
            disp(["Nombre del usuario: ", nombre]);
            disp(["NIT del usuario: ", nit]);
            disp(["Placa del vehículo: ", placa]);
            disp(["Hora de entrada: ", num2str(entradah), ":", num2str(entradam)]);
            disp(["Hora de salida: ", num2str(salidah), ":", num2str(salidam)]);
            disp(["Horas de estadía: ", num2str(horas)]);
            disp(["Monto total a pagar: Q", num2str(total)]);
            disp("---------------------------------");

            % Guardar factura en archivo
            archivo_id = fopen("factura.txt", "a");
            fprintf(archivo_id, "\n---------------------------------\n");
            fprintf(archivo_id, "Parqueo del T3\n");
            fprintf(archivo_id, "FACTURA\n");
            fprintf(archivo_id, "Nombre del usuario: %s\n", nombre);
            fprintf(archivo_id, "NIT del usuario: %s\n", nit);
            fprintf(archivo_id, "Placa del vehículo: %s\n", placa);
            fprintf(archivo_id, "Hora de entrada: %02d:%02d\n", entradah, entradam);
            fprintf(archivo_id, "Hora de salida: %02d:%02d\n", salidah, salidam);
            fprintf(archivo_id, "Horas de estadía: %d\n", horas);
            fprintf(archivo_id, "Monto total a pagar: Q%.2f\n", total);
            fprintf(archivo_id, "---------------------------------\n");
            fclose(archivo_id);

            % Guardar datos en la base de datos
            query = "INSERT INTO parking (nombre, nit, placa, entrada, salida, horas, total) VALUES ($1, $2, $3, $4, $5, $6, $7);";
            params = {nombre, nit, placa, (entradah * 100 + entradam), (salidah * 100 + salidam), horas, total};
            res = pq_exec_params(conn, query, params);

            if isempty(res)
                disp("Error: No se pudo guardar la información en la base de datos.");
            else
                disp("Datos guardados exitosamente en la base de datos.");
            end

        case 2
            % Mostrar historial de datos
            fid = fopen('factura.txt', 'r');
            if fid == -1
                disp('Error: No se pudo abrir el archivo.');
            else
                disp('Contenido del archivo:');
                while ~feof(fid)
                    linea = fgetl(fid);
                    disp(linea);
                end
                fclose(fid);
            end

        case 3
            % Borrar datos
            sql = 'TRUNCATE TABLE parking;';
            pq_exec_params(conn, sql);
            archivo = 'factura.txt';
            if exist(archivo, 'file') == 2
                delete(archivo);
            end
            disp('Datos borrados correctamente.');

        case 4
            % Salir del programa
            disp('Saliendo del programa...');
            break;

        otherwise
            disp('Opción no válida. Intente nuevamente.');
    end
end

% Cerrar conexión a la base de datos
pq_close(conn);


