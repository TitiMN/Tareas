# Programa para calcular la nómina semanal de los trabajadores

try:
    # Solicitar las entradas
    horas_trabajo = float(input("Ingresa las horas trabajadas (semanales): "))
    horas_extra = float(input("Ingresa las horas extras trabajadas: "))
    precio_hora = float(input("Ingresa el precio por hora: "))

    # Validar las entradas
    if horas_trabajo < 0 or horas_extra < 0 or precio_hora <= 0:
        print("Error: Los valores deben ser positivos.")
    else:
        # Determinar el precio de la hora extra según las reglas
        if horas_extra < 10:
            precio_hora_extra = precio_hora * 1.5  # 50% mayor
        elif 10 <= horas_extra <= 20:
            precio_hora_extra = precio_hora * 1.4  # 40% mayor
        else:
            precio_hora_extra = precio_hora * 1.2  # 20% mayor

        # Calcular el sueldo semanal
        sueldo_base = horas_trabajo * precio_hora
        sueldo_extra = horas_extra * precio_hora_extra
        sueldo_total = sueldo_base + sueldo_extra

        # Mostrar los resultados
        print(f"Sueldo base: {sueldo_base:.2f}")
        print(f"Sueldo por horas extra: {sueldo_extra:.2f}")
        print(f"Sueldo total semanal: {sueldo_total:.2f}")

except ValueError:
    print("Error: Debes ingresar valores numéricos válidos.")
