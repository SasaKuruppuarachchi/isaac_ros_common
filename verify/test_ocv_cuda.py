import cv2

print("OpenCV version:", cv2.__version__)

# Check CUDA availability
cuda_enabled = cv2.cuda.getCudaEnabledDeviceCount()
print("CUDA-enabled devices:", cuda_enabled)

if cuda_enabled == 0:
    print("❌ No CUDA device detected by OpenCV!")
    exit(1)

# Device info
dev = cv2.cuda.getDevice()
print("Active GPU device ID:", dev)

try:
    info = cv2.cuda.DeviceInfo(dev)
    print("GPU Name:", info.name())
    print("Compute Capability:", info.majorVersion(), ".", info.minorVersion())
except Exception as e:
    print("Warning: Could not read device info:", e)

# Create CPU image
import numpy as np
img = (np.ones((512, 512, 3), dtype=np.uint8) * 120)

# Upload to GPU
gpu = cv2.cuda_GpuMat()
gpu.upload(img)

# CUDA Gaussian blur
gauss = cv2.cuda.createGaussianFilter(gpu.type(), gpu.type(), (15,15), 2)
blur_gpu = gauss.apply(gpu)

# Download back
blur_img = blur_gpu.download()

print("CUDA Gaussian blur completed successfully!")
