# Sử dụng Python image nhẹ (slim) làm nền
FROM python:3.9-slim

# Thiết lập thư mục làm việc trong container
WORKDIR /app

# Copy file requirements vào trước để tận dụng cache của Docker
COPY requirements.txt .

# Cài đặt các thư viện
RUN pip install --no-cache-dir -r requirements.txt

# Copy toàn bộ code dự án vào container
COPY . .

# Mở port 5000 (Port mặc định của Flask)
EXPOSE 5000

# Lệnh chạy ứng dụng khi container khởi động
# Thay 'app.py' bằng tên file chạy chính của bạn
CMD ["python", "app.py"]