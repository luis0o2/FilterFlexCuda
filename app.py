from flask import Flask, render_template, request, redirect, url_for, flash, send_from_directory
import os
import subprocess
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'static/uploads'
app.config['PROCESSED_FOLDER'] = 'static/processed'
app.secret_key = 'supersecretkey'

if not os.path.exists(app.config['UPLOAD_FOLDER']):
    os.makedirs(app.config['UPLOAD_FOLDER'])

if not os.path.exists(app.config['PROCESSED_FOLDER']):
    os.makedirs(app.config['PROCESSED_FOLDER'])

@app.route('/', methods=['GET', 'POST'])
def index():
    processed_file_path = None  # Initialize processed_file_path
    if request.method == 'POST':
        file = request.files['file']
        if file and file.filename != '':
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(filepath)

            # Call CUDA program to process the image
            processed_file_path = process_image_with_cuda(filepath)

    return render_template('index.html', processed_file_path=processed_file_path)

def process_image_with_cuda(input_image_path):
    cuda_executable_path = r'C:\Users\ochoa\Desktop\Dev\Cuda\Proj\FiltersCuda\x64\Release\FiltersCuda.exe'
    output_image_filename = secure_filename(os.path.basename(input_image_path))
    output_image_path = os.path.join(app.config['PROCESSED_FOLDER'], output_image_filename)

    # Execute the CUDA program with input and output paths
    subprocess.run([cuda_executable_path, input_image_path, output_image_path])

    return output_image_filename  # Return the filename of the processed image

@app.route('/download_processed_image/<filename>')
def download_processed_image(filename):
    processed_image_path = os.path.join(app.config['PROCESSED_FOLDER'], filename)
    return send_from_directory(app.config['PROCESSED_FOLDER'], filename, as_attachment=True)

if __name__ == '__main__':
    app.run(debug=True)
