import psycopg2
from psycopg2 import sql

def input_int(prompt, min_value=None, max_value=None):
    while True:
        try:
            value = int(input(prompt))
            if (min_value is not None and value < min_value) or (max_value is not None and value > max_value):
                print(f"Error: Por favor, ingrese un valor entre {min_value} y {max_value}.")
            else:
                return value
        except ValueError:
            print("Error: Debe ingresar un número válido.")

def menu():
    conn = psycopg2.connect(
        dbname='tarea6',
        host='localhost',
        port='5432',
        user='postgres',
        password='2008000070*a'
    )
    cur = conn.cursor()
    
    while True:
        print('------ Menú ------')
        print('1. Ingreso de datos')
        print('2. Historial de datos')
        print('3. Borrar datos')
        print('4. Salir')
        opcion = input('Seleccione una opción (1-4): ')

        if opcion == '1':
            nombre = input('Ingrese su nombre: ')
            nit = input('Ingrese su número de nit: ')
            placa = input('Ingrese su número de placa: ')
            
            print('Para los siguientes datos utilice formato 24 horas')
            print('Por ejemplo 4:30 pm ingrese primero 16 y luego 30')

            entradah = input_int('Ingrese la hora a la que entró (0-23): ', 0, 23)
            entradam = input_int('Ingrese el minuto al que entró (0-59): ', 0, 59)

            entrada = (entradah * 100) + entradam

            salidah = input_int('Ingrese la hora a la que saldrá (0-23): ', 0, 23)
            while salidah < entradah:
                print('Error: La hora de salida debe ser igual o mayor a la hora de entrada.')
                salidah = input_int('Ingrese la hora a la que saldrá (0-23): ', 0, 23)

            salidam = input_int('Ingrese el minuto al que saldrá (0-59): ', 0, 59)
            while salidah == entradah and salidam <= entradam:
                print('Error: El minuto de salida debe ser mayor que el minuto de entrada si la hora es la misma.')
                salidam = input_int('Ingrese el minuto al que saldrá (0-59): ', 0, 59)

            salida = (salidah * 100) + salidam

            horas = salidah - entradah
            if entradam <= salidam:
                horas += 1

            total = 15 if horas < 2 else horas * 20

            # Mostrar resumen en pantalla
            print('\n---------------------------------')
            print('\nParqueo del T3\n')
            print('FACTURA')
            print(f'\nNombre del usuario: {nombre}')
            print(f'NIT del usuario: {nit}')
            print(f'Placa del vehículo: {placa}')
            print(f'\nHora de entrada: {entradah}:{entradam}')
            print(f'Hora de salida: {salidah}:{salidam}')
            print(f'Horas de estadía: {horas}')
            print(f'\nMonto total a pagar: Q{total:.2f}')
            print('\n---------------------------------')

            # Guardar en archivo factura.txt
            with open('factura.txt', 'a') as archivo:
                archivo.write('\n---------------------------------\n')
                archivo.write('Parqueo del T3\n')
                archivo.write('FACTURA\n')
                archivo.write(f'\nNombre del usuario: {nombre}\n')
                archivo.write(f'NIT del usuario: {nit}\n')
                archivo.write(f'Placa del vehículo: {placa}\n')
                archivo.write(f'\nHora de entrada: {entradah}:{entradam}\n')
                archivo.write(f'Hora de salida: {salidah}:{salidam}\n')
                archivo.write(f'Horas de estadía: {horas}\n')
                archivo.write(f'Monto total a pagar: Q{total:.2f}\n')
                archivo.write('\n---------------------------------\n')

            insert_sql = sql.SQL("""
                INSERT INTO parking (nombre, nit, placa, entrada, salida, horas, total)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """)
            cur.execute(insert_sql, (nombre, nit, placa, entrada, salida, horas, total))
            conn.commit()
            print('Datos ingresados correctamente.')

        elif opcion == '2':
            try:
                with open('factura.txt', 'r') as fid:
                    print('Contenido del archivo:')
                    print(fid.read())
            except FileNotFoundError:
                print('El archivo factura.txt no existe.')

        elif opcion == '3':
            truncate_sql = 'TRUNCATE TABLE parking;'
            cur.execute(truncate_sql)
            conn.commit()
            
            try:
                import os
                os.remove('factura.txt')
                print('Datos borrados correctamente.')
            except FileNotFoundError:
                print('El archivo factura.txt no existe.')

        elif opcion == '4':
            print('Saliendo del programa...')
            break

        else:
            print('Opción no válida. Intente nuevamente.')

        input('Presione Enter para continuar...')
    
    cur.close()
    conn.close()

if __name__ == '__main__':
    menu()
