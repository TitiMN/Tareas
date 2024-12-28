import psycopg2
import re
import time
from datetime import datetime
import getpass  

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
    print("2. Ejecución del programa")
    print("3. Borrado de datos")
    print("4. Salir")


def ingresar_datos_cliente():
    while True:
        try:
            print("\nIngrese nombre de usuario:")

            while True:
                nombre = input("Nombre del cliente: ")
                # Validar con regex que solo contenga letras y espacios
                if re.match(r"^[A-Za-z\s]+$", nombre): 
                    return nombre
                else:
                    raise ValueError("El nombre solo debe contener letras y espacios.")  # Lanzar excepción
        except ValueError as ve:
            print(f"Error: {ve}. Intenta nuevamente.")
        except Exception as e:
            print(f"Ocurrió un error inesperado: {e}. Intenta nuevamente.")



def borrar():
    try:
        conn = base_datos()
        if conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM login;")
            conn.commit()
            conn.close()
            print("Todos los datos han sido borrados de la base de datos.")
    except Exception as e:
        print(f"Error al borrar datos: {e}")

def login():
    usuario_correcto = "admin"
    contrasena_correcta = "123"
    intentos_restantes = 3
    nombre_usuario = ingresar_datos_cliente()

    while intentos_restantes > 0:
        usuario = input("Ingresa el nombre de usuario: ")
        contrasena = getpass.getpass("Ingresa la contraseña: ")

        if usuario == usuario_correcto and contrasena == contrasena_correcta:
            print("¡Login exitoso!")
            aprobo = "SI"
            break
        else:
            intentos_restantes -= 1
            print(f"Credenciales incorrectas. Te quedan {intentos_restantes} intentos.")
        
        if intentos_restantes == 0:
            print("Has excedido el número de intentos. El programa se cerrará.")
            aprobo = "NO"

    now = datetime.now()
    fecha_actual = now.strftime("%Y-%m-%d")
    hora_actual = now.strftime("%H:%M:%S")

    conn = base_datos()
    if conn:
        cursor = conn.cursor()
        # Incluye el valor de 'aprobo' en la consulta
        cursor.execute("""INSERT INTO login (nombre, aprobo, fecha, hora)
                          VALUES (%s, %s, %s, %s)""", (nombre_usuario, aprobo, fecha_actual, hora_actual))
        conn.commit()
        conn.close()


def principal():
    while True:
        menu()
        opcion = input("\nSeleccione una opción: ")

        if opcion == "1":
            login()


        elif opcion == "2":
            borrar()

        elif opcion == "3":
            print("Saliendo del sistema...")
            time.sleep(1)
            break

        else:
            print("Opción no válida. Intenta nuevamente.")

principal()
