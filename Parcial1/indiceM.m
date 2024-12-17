% Programa para calcular el Índice de Masa Corporal (IMC)

% Solicitar el género
genero = input('Ingresa tu género (hombre/mujer): ', 's'); % Entrada de texto

% Solicitar la masa y altura
masa = input('Ingresa tu masa en kilogramos (kg): ');
altura = input('Ingresa tu altura en metros (m): ');

% Validar las entradas
if ~isnumeric(masa) || ~isnumeric(altura) || masa <= 0 || altura <= 0
    fprintf('Error: La masa y altura deben ser números positivos.\n');
else
    % Calcular el índice de masa corporal
    imc = masa / (altura^2);

    % Mostrar el resultado con base en el género
    if strcmpi(genero, 'hombre')
        fprintf('Eres hombre. Tu índice de masa corporal (IMC) es: %.2f\n', imc);
    elseif strcmpi(genero, 'mujer')
        fprintf('Eres mujer. Tu índice de masa corporal (IMC) es: %.2f\n', imc);
    else
        fprintf('Género no identificado. Tu índice de masa corporal (IMC) es: %.2f\n', imc);
    end
end

