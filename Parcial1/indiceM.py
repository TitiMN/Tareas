# Programa para calcular el Índice de Masa Corporal (IMC)

try:
    # Solicitar el género
    genero = input("Ingresa tu género (hombre/mujer): ").strip().lower()

    # Solicitar la masa y altura
    masa = float(input("Ingresa tu masa en kilogramos (kg): "))
    altura = float(input("Ingresa tu altura en metros (m): "))

    # Validar las entradas
    if masa <= 0 or altura <= 0:
        print("Error: La masa y la altura deben ser números positivos.")
    else:
        # Calcular el índice de masa corporal
        imc = masa / (altura ** 2)

        # Mostrar el resultado con base en el género
        if genero == "hombre":
            print(f"Eres hombre. Tu índice de masa corporal (IMC) es: {imc:.2f}")
        elif genero == "mujer":
            print(f"Eres mujer. Tu índice de masa corporal (IMC) es: {imc:.2f}")
        else:
            print(f"Género no identificado. Tu índice de masa corporal (IMC) es: {imc:.2f}")

except ValueError:
    print("Error: Debes ingresar valores numéricos válidos para masa y altura.")
