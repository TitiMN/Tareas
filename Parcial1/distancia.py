import math  # Importar la librería para operaciones matemáticas

# Programa para calcular la distancia entre dos puntos en el plano cartesiano

try:
    # Solicitar las coordenadas del primer punto
    x1 = float(input("Ingresa la coordenada x1: "))
    y1 = float(input("Ingresa la coordenada y1: "))

    # Solicitar las coordenadas del segundo punto
    x2 = float(input("Ingresa la coordenada x2: "))
    y2 = float(input("Ingresa la coordenada y2: "))

    # Calcular la distancia usando la fórmula
    distancia = math.sqrt((x2 - x1)**2 + (y2 - y1)**2)

    # Mostrar el resultado
    print(f"La distancia entre los puntos ({x1:.2f}, {y1:.2f}) y ({x2:.2f}, {y2:.2f}) es: {distancia:.2f}")

except ValueError:
    print("Error: Todas las coordenadas deben ser valores numéricos.")
