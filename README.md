# Implemented CUDA-accelerated grayscale conversion

## Overview
In this commit, I integrated a CUDA-accelerated C++ program for converting uploaded images to grayscale. Leveraging the power of CUDA, the program efficiently processes each pixel of the image in parallel, significantly reducing processing time compared to traditional CPU-based methods.

![image](https://github.com/luis0o2/FilterFlexCuda/assets/59019460/be14d765-7b81-4e8f-99f2-ca6b1d3e1f86)

## Technologies and Tools Used
- CUDA C++: Implemented the GPU-accelerated grayscale conversion algorithm.
- STB Image: Utilized for image loading and saving functionalities in the CUDA C++ code.
- Python: Used for developing the Flask web application and orchestrating the image processing workflow.
- Flask: A micro web framework in Python used for handling HTTP requests and rendering HTML templates.
- HTML: Used for creating the structure and content of the web pages, including the user interface for image upload and display.
- CSS: Used for styling the HTML elements, including layout, colors, fonts, and other visual aspects of the web pages.


## Implementation Details
To facilitate user interaction, I developed a Flask application using Python, providing a user-friendly interface for uploading images and viewing the grayscale results. The Flask application, defined in `app.py`, handles HTTP requests and orchestrates the image processing workflow.

Additionally, I crafted HTML templates stored in the `templates` directory to render the web interface. The `index.html` template presents a simple yet intuitive design, showcasing the uploaded image alongside its grayscale counterpart. To enhance user experience, I included a download button for easy access to the processed image.

## CPU Implementation
![image](https://github.com/luis0o2/FilterFlexCuda/assets/59019460/bab50dd3-a3ce-41e4-bfd9-39bbb627b9fd)

## GPU Implementation
![image](https://github.com/luis0o2/FilterFlexCuda/assets/59019460/e0f40ddc-d234-4cb2-89df-dacd9a3343a2)


## Inspiration from "Programming Massively Parallel Processors"
This implementation draws inspiration from the concepts discussed in the book "Programming Massively Parallel Processors" by David B. Kirk and Wen-mei W. Hwu. By applying the principles outlined in the book, particularly those related to parallel programming with CUDA, I was able to develop a highly efficient image processing pipeline that takes full advantage of modern GPU architectures.

## Conclusion
This implementation underscores the convergence of GPU acceleration with web development technologies, empowering users with fast and efficient image processing capabilities while maintaining a seamless and accessible interface.
