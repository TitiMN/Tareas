#Conexión a la base de datos
import psycopg2
from datetime import datetime

conn = psycopg2.connect(
    dbname="Corto1",
    user="postgres",
    password="2008000070*a",
    host="localhost",
    port="5432"
)

#Función para detectar palíndromos
def detectar_palindromo(texto):
    texto = ''.join(e for e in texto if e.isalnum()).lower()
    return texto == texto[::-1]

#Función para detectar números primos
def detectar_primo(numero):
    if numero <= 1:
        return False
    for i in range(2, int(numero**0.5) + 1):
        if numero % i == 0:
            return False
    return True

#Función para detectar números perfectos
def detectar_perfecto(numero):
    return sum(i for i in range(1, numero) if numero % i == 0) == numero

#Función para registrar datos en la base de datos
def registrar_datos(conn, nombre_usuario, tipo, entrada, resultado):
    fecha = datetime.now().strftime('%Y-%m-%d')
    hora = datetime.now().strftime('%H:%M:%S')
    ejecucion = f"{tipo}: Entrada = {entrada}, Resultado = {resultado}"
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO ejecuciones_programa (nombre_usuario, fecha, hora, ejecucion) VALUES (%s, %s, %s, %s)",
        (nombre_usuario, fecha, hora, ejecucion)
    )
    conn.commit()
    cur.close()

#programa
def main():
    while True:
        print('------ Menú ------')
        print('1. Detector de Palíndromos')
        print('2. Detector de Número Primo')
        print('3. Detector de Número Perfecto')
        print('4. Mostrar historial de datos')
        print('5. Borrar datos')
        print('6. Salir')

        opcion = input('Seleccione una opción: ')

        if opcion == '1':
            nombre_usuario = input('Ingrese su nombre de usuario: ')
            texto = input('Ingrese un texto: ')
            resultado = detectar_palindromo(texto)
            registrar_datos(conn, nombre_usuario, 'Palíndromo', texto, resultado)
            print(f'El texto "{texto}" {"es" if resultado else "no es"} un palíndromo.')

        elif opcion == '2':
            nombre_usuario = input('Ingrese su nombre de usuario: ')
            numero = int(input('Ingrese un número: '))
            resultado = detectar_primo(numero)
            registrar_datos(conn, nombre_usuario, 'Número Primo', numero, resultado)
            print(f'El número {numero} {"es" if resultado else "no es"} un número primo.')

        elif opcion == '3':
            nombre_usuario = input('Ingrese su nombre de usuario: ')
            numero = int(input('Ingrese un número: '))
            resultado = detectar_perfecto(numero)
            registrar_datos(conn, nombre_usuario, 'Número Perfecto', numero, resultado)
            print(f'El número {numero} {"es" if resultado else "no es"} un número perfecto.')

        elif opcion == '4':
            historial_datos()

        elif opcion == '5':
            borrar_datos()

        elif opcion == '6':
            print('Saliendo del programa...')
            break

        else:
            print('Opción no válida. Intente nuevamente.')

if __name__ == '__main__':
    main()

#Mostrar historial de datos
def historial_datos():
    cur = conn.cursor()
    cur.execute("SELECT nombre_usuario, fecha, hora, ejecucion FROM ejecuciones_programa")
    registros = cur.fetchall()
    if registros:
        print('Historial de ejecuciones:')
        for registro in registros:
            print(f'Usuario: {registro[0]}, Fecha: {registro[1]}, Hora: {registro[2]}, Ejecución: {registro[3]}')
    else:
        print('No se encontraron registros.')
    cur.close()

#borrar datos
def borrar_datos():
    cur = conn.cursor()
    cur.execute("DELETE FROM ejecuciones_programa")
    conn.commit()
    print('Se han borrado los registros.')
    cur.close()
