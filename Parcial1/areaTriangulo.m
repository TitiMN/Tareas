% Programa para calcular el área de un triángulo

% Solicitar la base y la altura
base = input('Ingresa la base del triángulo: ');
altura = input('Ingresa la altura del triángulo: ');

% Validar la entrada
if ~isnumeric(base) || base <= 0
    fprintf('Error: La base debe ser un número positivo.\n');
elseif ~isnumeric(altura) || altura <= 0
    fprintf('Error: La altura debe ser un número positivo.\n');
else
    % Calcular el área
    area = (base * altura) / 2;

    % Mostrar el resultado
    fprintf('El área del triángulo con base %.2f y altura %.2f es: %.2f\n', base, altura, area);
end

