import psycopg2
import re
import time
import math
from datetime import datetime

def base_datos():
    try:
        conn = psycopg2.connect(host="localhost", dbname="parcial1", user="postgres", password="2008000070*a", port=5432)
        return conn
    except Exception as e:
        print("Error en la conexión:", e)
        return None

def menu():
    print("\n")
    print("1. Ingresar datos de usuario y calcular distancia")
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
            cursor.execute("DELETE FROM distancia_puntos;")
            conn.commit()
            conn.close()
            print("Todos los datos han sido borrados de la base de datos.")
    except Exception as e:
        print(f"Error al borrar datos: {e}")

def calcular_distancia(x1, y1, x2, y2):
    return math.sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2)

def distancia():
    nombre_usuario = ingresar_datos_cliente()

    x1 = float(input("Ingresa la coordenada x del primer punto (x1): "))
    y1 = float(input("Ingresa la coordenada y del primer punto (y1): "))
    x2 = float(input("Ingresa la coordenada x del segundo punto (x2): "))
    y2 = float(input("Ingresa la coordenada y del segundo punto (y2): "))

    distancia_calculada = calcular_distancia(x1, y1, x2, y2)

    print(f"La distancia entre los puntos ({x1}, {y1}) y ({x2}, {y2}) es {distancia_calculada:.2f}")

    # Obtener fecha y hora actuales
    now = datetime.now()
    fecha_actual = now.strftime("%Y-%m-%d")
    hora_actual = now.strftime("%H:%M:%S")

    conn = base_datos()
    if conn:
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO distancia_puntos (nombre, x1, y1, x2, y2, resultado, fecha, hora)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (nombre_usuario, x1, y1, x2, y2, distancia_calculada, fecha_actual, hora_actual))
        conn.commit()
        conn.close()

def principal():
    while True:
        menu()
        opcion = input("\nSeleccione una opción: ")

        if opcion == "1":
            distancia()

        elif opcion == "2":
            borrar()

        elif opcion == "3":
            print("Saliendo del sistema...")
            time.sleep(1)
            break

        else:
            print("Opción no válida. Intenta nuevamente.")

principal()
