import psycopg2
import re
import time
from datetime import datetime

precio_hora = 6

def base_datos():
    try:
        conn = psycopg2.connect(host="localhost", dbname="parcial1", user="postgres", password="2008000070*a", port=5432)
        return conn
    except Exception as e:
        print("Error en la conexión:", e)
        return None

def menu():
    print("\n")
    print("1. Ingresar datos de usuario y calcular sueldo")
    print("2. Borrado de datos")
    print("3. Salir")

def ingresar_datos_cliente():
    while True:
        print("\nIngrese nombre de usuario:")
        while True:
            nombre = input("Nombre del cliente: ")
            if re.match(r"^[A-Za-z\s]+$", nombre): 
                break
            else:
                print("Error: El nombre solo debe contener letras y espacios. Intenta nuevamente.")
        return nombre

def borrar():
    try:
        conn = base_datos()
        if conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM empleado_sueldo;")
            conn.commit()
            conn.close()
            print("Todos los datos han sido borrados de la base de datos.")
    except Exception as e:
        print(f"Error al borrar datos: {e}")

def calcular_sueldo(horas_trabajo, horas_extra):
    if horas_extra < 10:
        precio_hora_extra = precio_hora * 1.5
    elif 10 <= horas_extra <= 20:
        precio_hora_extra = precio_hora * 1.4
    else:
        precio_hora_extra = precio_hora * 1.2

    sueldo_base = (horas_trabajo * precio_hora) + (horas_extra * precio_hora_extra)
    return sueldo_base

def sueldo():
    nombre_usuario = ingresar_datos_cliente()

    horas_trabajo = float(input("Ingresa el número de horas trabajadas (sin contar horas extra): "))
    horas_extra = float(input("Ingresa el número de horas extra trabajadas: "))

    sueldo_total = calcular_sueldo(horas_trabajo, horas_extra)

    print(f"El sueldo base semanal es: {sueldo_total:.2f}")

    # Obtener fecha y hora actuales
    now = datetime.now()
    fecha_actual = now.strftime("%Y-%m-%d")
    hora_actual = now.strftime("%H:%M:%S")

    conn = base_datos()
    if conn:
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO empleado_sueldo (nombre, horas_trabajo, horas_extra, sueldo_total, fecha, hora)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (nombre_usuario, horas_trabajo, horas_extra, sueldo_total, fecha_actual, hora_actual))
        conn.commit()
        conn.close()

def principal():
    while True:
        menu()
        opcion = input("\nSeleccione una opción: ")

        if opcion == "1":
            sueldo()

        elif opcion == "2":
            borrar()

        elif opcion == "3":
            print("Saliendo del sistema...")
            time.sleep(1)
            break

        else:
            print("Opción no válida. Intenta nuevamente.")

principal()
