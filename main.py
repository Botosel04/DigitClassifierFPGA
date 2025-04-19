import cv2
import os
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf

# mnist = tf.keras.datasets.mnist
# (x_train, y_train), (x_test, y_test) = mnist.load_data()

# x_train = tf.keras.utils.normalize(x_train, axis=1)
# x_test = tf.keras.utils.normalize(x_test, axis=1)


# model = tf.keras.models.Sequential()
# model.add(tf.keras.layers.Flatten(input_shape=(28, 28)))
# model.add(tf.keras.layers.Dense(128, activation='relu'))
# model.add(tf.keras.layers.Dense(128, activation='relu'))
# model.add(tf.keras.layers.Dense(10, activation='softmax'))
# model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy']) 

# model.fit(x_train, y_train, epochs=20, validation_data=(x_test, y_test))
# model.save("model.keras")

model = tf.keras.models.load_model("model.keras")

weights = model.get_weights()

for i in range(0, len(weights), 2):
    w = weights[i]      
    b = weights[i + 1]  
    
    layer_num = i // 2

    w_int = np.round(w * 127).astype(np.int8)
    b_int = np.round(b * 127).astype(np.int8)

    
    np.savetxt(f"layer{layer_num}_weights.txt", w_int, fmt="%d")
    np.savetxt(f"layer{layer_num}_biases.txt", b_int, fmt="%d")


# image_number = 1
# while os.path.isfile(f"input_digits/{image_number}.png"):
#     try:
#         img = cv2.imread(f"input_digits/{image_number}.png", cv2.IMREAD_GRAYSCALE)
#         img = cv2.resize(img, (28, 28))
#         img = np.invert(img)
#         img = img / 255.0
#         img = img.astype(np.float32)
#         img = img.reshape(1, 28, 28)
#         prediction = model.predict(img, verbose=0)
#         print(f"The digit probably is: {np.argmax(prediction)} with {np.max(prediction)} confidence")    
#         plt.imshow(img[0], cmap = plt.cm.binary)
#         plt.show()
#     except:
#         print(f"Error processing image {image_number}.png") 
#     finally:    
#         image_number += 1
       

