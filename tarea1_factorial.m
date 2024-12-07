while true
    % Mostrar menú
    disp('========================');
    disp('Calculadora de Factorial');
    disp('1. Calcular factorial');
    disp('2. Salir');
    disp('========================');

    % Pedir la opción del usuario
    opcion = input('Selecciona una opción: ');

    % Verificar la opción seleccionada
    if opcion == 1
        % Pedir al usuario que ingrese un número
        n = input('Ingresa un número entero positivo: ');

        % Validar la entrada
        if ~isnumeric(n) || mod(n, 1) ~= 0
            fprintf('Error: Debes ingresar un número entero.\n');
        elseif n < 0
            fprintf('Error: El factorial no está definido para números negativos.\n');
        else
            % Calcular el factorial
            if n == 0 || n == 1
                factorial = 1;
            else
                factorial = 1;
                for i = 2:n
                    factorial = factorial * i;
                end
            end

            % Mostrar el resultado
            fprintf('El factorial de %d es %d\n', n, factorial);
        end

    elseif opcion == 2
        % Salir del programa
        disp('Gracias por usar la calculadora de factorial.');
        break;
    else
        % Opción no válida
        disp('Opción no válida. Por favor, intenta de nuevo.');
    end
end

