import psycopg2
import os
from datetime import datetime
import time
import re

def base_datos():
    try:
        conn = psycopg2.connect(host="localhost", dbname="parcial1", user="postgres", password="2008000070*a", port=5432)
        return conn
    except Exception as e:
        print("Error en la conexión:", e)
        return None

def menu():
    print("\n")
    print("1. Ingresar datos de usuario")
    print("2. Número factorial")
    print("3. Borrado de datos")
    print("4. Salir")

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

def obtener_fecha_hora():
    # Obtener la fecha y hora actual
    now = datetime.now()
    fecha = now.strftime("%Y-%m-%d")  # Solo la fecha
    hora = now.strftime("%H:%M:%S")  # Solo la hora
    return fecha, hora


def borrar():
    try:
        conn = base_datos()
        if conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM factorial;")
            conn.commit()
            conn.close()
            print("Todos los datos han sido borrados de la base de datos.")
    except Exception as e:
        print(f"Error al borrar datos: {e}")

def factorial():
    while True:
        try:
            n = input('Ingresa un número entero positivo: ')
            
            if not n.isdigit():
                raise ValueError('Has ingresado un carácter no numérico. Intenta de nuevo.')
            
            n = int(n)
            
            if n < 0:
                raise ValueError('El factorial no está definido para números negativos.')
            elif n == 0 or n == 1:
                resultado = 1
            else:
                resultado = 1
                for i in range(2, n + 1):
                    resultado *= i
            
            # Mostrar el resultado sin notación científica
            print(f'El factorial de {n} es {resultado}')
            return n, str(resultado)
        
        except ValueError as e:
            print(f'Error: {e}')

def principal():
    nombre = None
    while True:
        menu()
        opcion = input("\nSeleccione una opción: ")

        if opcion == "1":
            nombre = ingresar_datos_cliente()

        elif opcion == "2":
            if not nombre:
                print("Primero debe ingresar un nombre de usuario.")
                continue

            numero, resultado = factorial()
            conn = base_datos()
            if conn:
                cursor = conn.cursor()
                fecha, hora = obtener_fecha_hora()  # Obtener la fecha y hora separadas
                cursor.execute("""
                    INSERT INTO factorial (nombre, dato_ingresado, resultado, fecha, hora)
                    VALUES (%s, %s, %s, %s, %s)
                """, (nombre, numero, resultado, fecha, hora))
                conn.commit()
                conn.close()

        elif opcion == "3":
            borrar()

        elif opcion == "4":
            print("Saliendo del sistema...")
            time.sleep(1)
            break

        else:
            print("Opción no válida. Intenta nuevamente.")

principal()
