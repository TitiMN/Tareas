% Programa para calcular la nómina semanal de los trabajadores

% Solicitar las entradas
horas_trabajo = input('Ingresa las horas trabajadas (semanales): ');
horas_extra = input('Ingresa las horas extras trabajadas: ');
precio_hora = input('Ingresa el precio por hora: ');

% Validar las entradas
if horas_trabajo < 0 || horas_extra < 0 || precio_hora <= 0
    fprintf('Error: Los valores deben ser positivos.\n');
else
    % Determinar el precio de la hora extra según las reglas
    if horas_extra < 10
        precio_hora_extra = precio_hora * 1.5; % 50% mayor
    elseif horas_extra >= 10 && horas_extra <= 20
        precio_hora_extra = precio_hora * 1.4; % 40% mayor
    else
        precio_hora_extra = precio_hora * 1.2; % 20% mayor
    end

    % Calcular el sueldo semanal
    sueldo_base = horas_trabajo * precio_hora;
    sueldo_extra = horas_extra * precio_hora_extra;
    sueldo_total = sueldo_base + sueldo_extra;

    % Mostrar los resultados
    fprintf('Sueldo base: %.2f\n', sueldo_base);
    fprintf('Sueldo por horas extra: %.2f\n', sueldo_extra);
    fprintf('Sueldo total semanal: %.2f\n', sueldo_total);
end

