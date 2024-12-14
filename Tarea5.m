% Categorías del IMC
bajoPeso = "Bajo peso";
pesoNormal = "Peso normal";
sobrePeso = "Sobrepeso";

% Ciclo principal
while true
    % Mostrar opciones
    disp("1. Calcular IMC y mostrar resultados");
    disp("2. Leer información del archivo");
    disp("3. Borrar información del archivo");
    disp("4. Salir del programa");

    % Leer opción del usuario
    opcion = input("Ingrese la opción deseada: ");

    % Calcular y mostrar IMC
    if opcion == 1
        nombre = input("Ingrese su nombre: ", "s");
        peso = input("Ingrese su peso en kilogramos: ");
        altura = input("Ingrese su altura en metros: ");

        % Calcular IMC
        imc = peso / (altura^2);

        % Determinar categoría
        if imc < 18.5
            categoria = bajoPeso;
        elseif imc < 25
            categoria = pesoNormal;
        else
            categoria = sobrePeso;
        end

        % Mostrar resultados
        fprintf("IMC de %s: %.2f\n", nombre, imc);
        fprintf("Categoría: %s\n", categoria);

        % Guardar en archivo
        fid = fopen("imc.txt", "a");
        if fid != -1
            fprintf(fid, "Nombre: %s, IMC: %.2f, Categoría: %s\n", nombre, imc, categoria);
            fclose(fid);
        else
            disp("Error: No se pudo abrir el archivo.");
        end

    % Leer información del archivo
    elseif opcion == 2
        fid = fopen("imc.txt", "r");
        if fid != -1
            contenido = fread(fid, Inf, "char=>char")';
            fclose(fid);
            disp(contenido);
        else
            disp("El archivo no existe o no se pudo abrir.");
        end

    % Borrar información del archivo
    elseif opcion == 3
        fid = fopen("imc.txt", "w");
        if fid != -1
            fclose(fid);
            disp("Información borrada correctamente.");
        else
            disp("Error: No se pudo borrar la información.");
        end

    % Salir del programa
    elseif opcion == 4
        disp("¡SALIDA EXITOSA!");
        break;

    % Manejar opción inválida
    else
        disp("Opción no válida. Intente de nuevo.");
    end
end

