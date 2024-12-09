if (exist('OCTAVE_VERSION', 'builtin') ~= 0)
    pkg load signal;
end

% MENÚ
opcion = 0;
while opcion ~= 5
    disp('Seleccione una opción:')
    disp('1. Grabar')
    disp('2. Reproducir')
    disp('3. Graficar')
    disp('4. Graficar densidad espectral de potencia')
    disp('5. Salir')
    opcion = input('Ingrese su elección: ');

    switch opcion
        case 1
            % GRABAR AUDIO
            try
                duracion = input('Ingrese la duración de la grabación en segundos: ');
                disp('Comenzando la grabación...');
                recObj = audiorecorder;
                recordblocking(recObj, duracion);
                disp('Grabación finalizada.');

                % Guardar archivo
                data = getaudiodata(recObj);
                audiowrite('audio.wav', data, recObj.SampleRate);
                disp('Archivo de audio grabado correctamente: audio.wav');
            catch
                disp('Error al grabar audio.');
            end

        case 2
            % REPRODUCIR AUDIO
            try
                [data, fs] = audioread('audio.wav');
                sound(data, fs);
                disp('Reproduciendo audio...');
            catch
                disp('Error al reproducir el audio. Asegúrate de que el archivo audio.wav existe.');
            end

        case 3
            % GRAFICAR AUDIO
            try
                [data, fs] = audioread('audio.wav');
                tiempo = linspace(0, length(data) / fs, length(data));
                plot(tiempo, data);
                xlabel('Tiempo (s)');
                ylabel('Amplitud');
                title('Señal de audio');
                disp('Gráfica generada.');
            catch
                disp('Error al graficar el audio. Asegúrate de que el archivo audio.wav existe.');
            end

        case 4
            % GRAFICAR DENSIDAD ESPECTRAL
            try
                disp('Graficando espectro de frecuencia...');
                [audio, FS] = audioread('audio.wav'); % Leer archivo de audio
                N = length(audio); % Número de muestras
                ventana = hann(floor(N / 4)); % Ventana de Hann
                [Sxx, f] = pwelch(audio, ventana, [], [], FS); % Densidad espectral
                plot(f, 10 * log10(Sxx));
                xlabel('Frecuencia (Hz)');
                ylabel('Densidad espectral de potencia (dB/Hz)');
                title('Espectro de frecuencia de la señal grabada');
                disp('Espectro de frecuencia generado.');
            catch
                disp('Error al graficar el espectro de frecuencia. Asegúrate de que el archivo audio.wav existe.');
            end

        case 5
            % SALIR DEL PROGRAMA
            disp('Saliendo del programa...');
            break;

        otherwise
            disp('Opción inválida. Por favor, seleccione una opción válida.');
    end
end

