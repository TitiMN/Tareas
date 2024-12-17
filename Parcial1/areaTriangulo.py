# Programa para calcular el área de un triángulo

try:
    # Solicitar la base y la altura
    base = float(input("Ingresa la base del triángulo: "))
    altura = float(input("Ingresa la altura del triángulo: "))

    # Validar la entrada
    if base <= 0 or altura <= 0:
        print("Error: La base y la altura deben ser números positivos.")
    else:
        # Calcular el área
        area = (base * altura) / 2

        # Mostrar el resultado
        print(f"El área del triángulo con base {base:.2f} y altura {altura:.2f} es: {area:.2f}")

except ValueError:
    print("Error: Debes ingresar valores numéricos.")
