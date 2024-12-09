import cv2
import os
import numpy as np

dataPath = 'C:/Users/Pablo Andres/Desktop/TAREAS_U/ProyectosDiciembre24/Tarea3/FotosyVideos/Pablo'
imageFiles = os.listdir(dataPath)

labels = []  # Etiquetas para las imágenes
facesData = []
label = 0    # Etiqueta única para esta categoría (por ejemplo, "Pablo")

print("Leyendo imágenes...")
for fileName in imageFiles:
    imagePath = os.path.join(dataPath, fileName)
    print(f"Procesando: {fileName}")

    # Leer imagen en escala de grises
    image = cv2.imread(imagePath, 0)
    if image is None:
        print(f"Advertencia: No se pudo leer {imagePath}. Ignorando...")
        continue
    
    facesData.append(image)
    labels.append(label)

# Verifica la cantidad de datos procesados
print(f"Número de imágenes procesadas: {len(facesData)}")
print(f"Número de etiquetas: {len(labels)}")

# Entrenar el reconocedor de rostros
face_recognizer = cv2.face.EigenFaceRecognizer_create()
print("Entrenando el modelo...")
face_recognizer.train(facesData, np.array(labels))

# Guardar el modelo
modelPath = os.path.join(dataPath, "modeloEigenFace.xml")
face_recognizer.write(modelPath)
print(f"Modelo almacenado en: {modelPath}")

