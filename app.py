from flask import Flask, request, jsonify

import os
import uuid  # UUID를 사용하여 고유한 파일 이름 생성

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 100 * 1024 * 1000  # 최대 100MB로 설정
# 이미지 업로드 경로
UPLOAD_FOLDER = '/usr/share/nginx/html/images/'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# 이미지 업로드 API
@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:  # 파일 전송 실패
        return jsonify({'error': 'No file part'}),400
    file = request.files['file']
    
    if file.filename == '':  # 파일 이름이 비어있는 경우
        return jsonify({'error': 'No selected file'}),400

    # 고유한 파일 이름 생성 (UUID 사용)
    unique_file_name = str(uuid.uuid4()) + os.path.splitext(file.filename)[1]
    
    # 파일을 저장 (unique_file_name으로)
    file.save(os.path.join(app.config['UPLOAD_FOLDER'], unique_file_name))
    
    # 저장된 파일 이름을 반환
    return jsonify({'message': 'File uploaded successfully!', 'file_name': unique_file_name}),200

