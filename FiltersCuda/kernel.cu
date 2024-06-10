#define STB_IMAGE_IMPLEMENTATION
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include <iostream>
#include "stb_image.h"
#include "stb_image_write.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void rgbToGrayscaleKernel(unsigned char* d_in, unsigned char* d_out, int width, int height) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x < width && y < height) {
        int idx = (y * width + x) * 3;
        unsigned char r = d_in[idx];
        unsigned char g = d_in[idx + 1];
        unsigned char b = d_in[idx + 2];
        d_out[y * width + x] = 0.299f * r + 0.587f * g + 0.114f * b;
    }
}

void processImage(const char* inputPath, const char* outputPath) {
    int width, height, channels;
    unsigned char* img = stbi_load(inputPath, &width, &height, &channels, 0);
    if (!img) {
        std::cerr << "Error reading input image: " << inputPath << std::endl;
        return;
    }
    if (channels < 3) {
        std::cerr << "Image does not have 3 channels: " << inputPath << std::endl;
        stbi_image_free(img);
        return;
    }

    unsigned char* d_in, * d_out;
    size_t numPixels = width * height;
    size_t inputSize = numPixels * 3 * sizeof(unsigned char);
    size_t outputSize = numPixels * sizeof(unsigned char);

    cudaError_t err;

    err = cudaMalloc(&d_in, inputSize);
    if (err != cudaSuccess) {
        std::cerr << "CUDA error: " << cudaGetErrorString(err) << std::endl;
        stbi_image_free(img);
        return;
    }

    err = cudaMalloc(&d_out, outputSize);
    if (err != cudaSuccess) {
        std::cerr << "CUDA error: " << cudaGetErrorString(err) << std::endl;
        cudaFree(d_in);
        stbi_image_free(img);
        return;
    }

    err = cudaMemcpy(d_in, img, inputSize, cudaMemcpyHostToDevice);
    if (err != cudaSuccess) {
        std::cerr << "CUDA error: " << cudaGetErrorString(err) << std::endl;
        cudaFree(d_in);
        cudaFree(d_out);
        stbi_image_free(img);
        return;
    }

    dim3 blockDim(16, 16);
    dim3 gridDim((width + blockDim.x - 1) / blockDim.x, (height + blockDim.y - 1) / blockDim.y);

    rgbToGrayscaleKernel << <gridDim, blockDim >> > (d_in, d_out, width, height);

    err = cudaGetLastError();
    if (err != cudaSuccess) {
        std::cerr << "CUDA error: " << cudaGetErrorString(err) << std::endl;
        cudaFree(d_in);
        cudaFree(d_out);
        stbi_image_free(img);
        return;
    }

    err = cudaDeviceSynchronize();
    if (err != cudaSuccess) {
        std::cerr << "CUDA error: " << cudaGetErrorString(err) << std::endl;
        cudaFree(d_in);
        cudaFree(d_out);
        stbi_image_free(img);
        return;
    }

    unsigned char* h_out = new unsigned char[outputSize];
    err = cudaMemcpy(h_out, d_out, outputSize, cudaMemcpyDeviceToHost);
    if (err != cudaSuccess) {
        std::cerr << "CUDA error: " << cudaGetErrorString(err) << std::endl;
        cudaFree(d_in);
        cudaFree(d_out);
        delete[] h_out;
        stbi_image_free(img);
        return;
    }

    stbi_write_png(outputPath, width, height, 1, h_out, width);

    std::cout << "Successfully wrote image to: " << outputPath << std::endl;

    cudaFree(d_in);
    cudaFree(d_out);
    delete[] h_out;
    stbi_image_free(img);
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <input_image_path> <output_image_path>" << std::endl;
        return 1;
    }

    const char* inputPath = argv[1];
    const char* outputPath = argv[2];

    processImage(inputPath, outputPath);
    return 0;
}
