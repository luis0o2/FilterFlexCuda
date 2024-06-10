# Implemented CUDA-accelerated grayscale conversion

## Overview
In this commit, I integrated a CUDA-accelerated C++ program for converting uploaded images to grayscale. Leveraging the power of CUDA, the program efficiently processes each pixel of the image in parallel, significantly reducing processing time compared to traditional CPU-based methods.

## Implementation Details
To facilitate user interaction, I developed a Flask application using Python, providing a user-friendly interface for uploading images and viewing the grayscale results. The Flask application, defined in `app.py`, handles HTTP requests and orchestrates the image processing workflow.

Additionally, I crafted HTML templates stored in the `templates` directory to render the web interface. The `index.html` template presents a simple yet intuitive design, showcasing the uploaded image alongside its grayscale counterpart. To enhance user experience, I included a download button for easy access to the processed image.

## Conclusion
This implementation underscores the convergence of GPU acceleration with web development technologies, empowering users with fast and efficient image processing capabilities while maintaining a seamless and accessible interface. By embracing this synergy, we strive to deliver impactful solutions with humility and a commitment to continuous improvement.
