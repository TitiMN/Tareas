# Programa para calcular el factorial de un número dado "X"

# Solicitar al usuario el número "X"
try:
    X = int(input("Ingresa un número entero positivo: "))

    # Validar la entrada
    if X < 0:
        print("Error: El factorial no está definido para números negativos.")
    else:
        # Calcular el factorial
        factorial = 1
        for i in range(1, X + 1):
            factorial *= i

        # Mostrar el resultado
        print(f"El factorial de {X} es {factorial}")

except ValueError:
    print("Error: Debes ingresar un número entero.")
