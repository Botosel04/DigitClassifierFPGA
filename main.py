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
       

def write_coe(path, data, radix=10, vals_per_line=32):
    """
    Emit a Xilinx .coe file which Vivado BRAM IP can consume.
      - data: 1D numpy array of ints (-128..127)
      - radix: 10 for decimal, 16 for hex
      - vals_per_line: how many comma-sep entries per text line
    """
    n = data.size
    with open(path, "w") as f:
        f.write(f"memory_initialization_radix={radix};\n")
        f.write("memory_initialization_vector=\n")
        for i, v in enumerate(data):
            # if hex desired: token = f"{(v & 0xFF):02X}"
            token = str(int(v))
            sep = "," if i < n-1 else ";"
            f.write(token + sep)
            if (i+1) % vals_per_line == 0:
                f.write("\n")
        f.write("\n")

def export_model(model_path, out_dir="coe_files", scale=127):
    os.makedirs(out_dir, exist_ok=True)
    model = tf.keras.models.load_model(model_path)
    params = model.get_weights()
    for idx in range(0, len(params), 2):
        layer = idx // 2
        W, B = params[idx], params[idx+1]
        # quantize to int8
        Wq = np.round(W * scale).astype(np.int8).flatten()
        Bq = np.round(B * scale).astype(np.int8).flatten()
        # write one COE per tensor
        write_coe(os.path.join(out_dir, f"layer{layer}_W.coe"), Wq, radix=10)
        write_coe(os.path.join(out_dir, f"layer{layer}_B.coe"), Bq, radix=10)
        print(f" -> layer{layer}_W.coe ({Wq.size}), layer{layer}_B.coe ({Bq.size})")



if __name__ == "__main__":
    export_model("model.keras", out_dir="coe_files")
    # export_model("model.keras", out_dir="coe_files", scale=127)       