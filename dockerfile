FROM python:3.11-slim

# Thông tin người duy trì
LABEL maintainer="Hoc Code"

# Không tạo .pyc, __pycache__, log stdout ngay lập tức
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Copy file requirements vào container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# Copy source code vào container
COPY ./app /app


# Thư mục làm việc trong container
WORKDIR /app

# Mở cổng cho Django
EXPOSE 8000

# Biến để xác định môi trường dev
ARG DEV=False


# Cài các gói hệ thống cần thiết cho build và psycopg2
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    build-essential \
    libpq-dev \
    passwd \
    && rm -rf /var/lib/apt/lists/*

# Tạo thư mục virtualenv riêng biệt
RUN python -m venv /py
ENV DEV=${DEV}
# Thêm venv vào PATH
ENV PATH="/py/bin:$PATH"

# Cài pip + requirements (bao gồm flake8 nếu DEV=True)
RUN pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "True" ]; then \
    pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp/*


# Tạo user không cần quyền root
RUN useradd -m django-user
USER django-user
