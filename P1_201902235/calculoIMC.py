import psycopg2
import re
import time
from datetime import datetime
import os

def base_datos():
    try:
        conn = psycopg2.connect(host="localhost", dbname="parcial1", user="postgres", password="2008000070*a", port=5432)
        return conn
    except Exception as e:
        print("Error en la conexión:", e)
        return None
    
def obtener_fecha_hora():
    now = datetime.now()
    fecha = now.strftime("%Y-%m-%d") 
    hora = now.strftime("%H:%M:%S")  
    return fecha, hora

def menu():
    print("\n")
    print("1. Ingresar datos de usuario")
    print("2. Ejecución de programa")
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


def borrar():
    try:
        conn = base_datos()
        if conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM peso_corporal;")
            conn.commit()
            conn.close()
            print("Todos los datos han sido borrados de la base de datos.")
    except Exception as e:
        print(f"Error al borrar datos: {e}")

def calcular_imc(peso, altura):
    return peso / (altura ** 2)

def imc():
    nombre_usuario = ingresar_datos_cliente()
    while True:
        sexo = input("Ingresa tu sexo (M/F): ").strip().upper() 
        if sexo in ["M", "F"]:
            break  
        else:
            print("Sexo no válido. Por favor, ingresa 'M' o 'F'.")
    
    peso = float(input("Ingresa tu peso en kilogramos: "))
    altura = float(input("Ingresa tu altura en metros: "))
    imc_calculado = calcular_imc(peso, altura)

    print(f"Tu Índice de Masa Corporal (IMC) es: {imc_calculado:.2f}")

    fecha, hora = obtener_fecha_hora()

    conn = base_datos()
    if conn:
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO peso_corporal (nombre, peso, altura, genero, imc, fecha, hora)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (nombre_usuario, peso, altura, sexo, imc_calculado, fecha, hora))
        conn.commit()
        conn.close()


def principal():
    while True:
        menu()
        opcion = input("\nSeleccione una opción: ")

        if opcion == "1":
            imc()

        elif opcion == "2":
            print("Ejecución del programa.")
        
        elif opcion == "3":
            borrar()

        elif opcion == "4":
            print("Saliendo del sistema...")
            time.sleep(1)
            break

        else:
            print("Opción no válida. Intenta nuevamente.")

principal()
