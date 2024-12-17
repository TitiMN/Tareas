% Programa para calcular la distancia entre dos puntos en el plano cartesiano

% Solicitar las coordenadas del primer punto
x1 = input('Ingresa la coordenada x1: ');
y1 = input('Ingresa la coordenada y1: ');

% Solicitar las coordenadas del segundo punto
x2 = input('Ingresa la coordenada x2: ');
y2 = input('Ingresa la coordenada y2: ');

% Validar que las entradas sean numéricas
if ~isnumeric(x1) || ~isnumeric(y1) || ~isnumeric(x2) || ~isnumeric(y2)
    fprintf('Error: Todas las coordenadas deben ser números.\n');
else
    % Calcular la distancia usando la fórmula
    distancia = sqrt((x2 - x1)^2 + (y2 - y1)^2);

    % Mostrar el resultado
    fprintf('La distancia entre los puntos (%.2f, %.2f) y (%.2f, %.2f) es: %.2f\n', x1, y1, x2, y2, distancia);
end

