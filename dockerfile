# FROM python:3.11-slim

# #NAME
# LABEL maintainer="TIỂU BỐI HỌC CODE"

# # Không tạo .pyc, __pycache__, giữ cho container sạch
# ENV PYTHONDONTWRITEBYTECODE=1

# # Log ra stdout/stderr ngay lập tức, dễ debug khi chạy bằng Docker
# ENV PYTHONUNBUFFERED=1

# # THƯC MỤC LÀM VIỆC
# WORKDIR /app

# # Mở cổng 8000 để Django runserver lắng nghe
# EXPOSE 8000

# # Cài pip và các thư viện Python
# COPY ./requirements.txt /tmp/requirements.txt
# COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# #/app thư mục làm việc

# COPY ./app /app
# #Tạo virtualenv riêng (/py) để tránh dùng Python hệ thống
# # install pip and upgrade
# # install requirements djang && flake8
# # có dev, thì có if
# ARG DEV=False
# RUN python -m venv /py && \
#     /py/bin/pip install --upgrade pip && \
#     /py/bin/pip install -r /tmp/requirements.txt && \
#     /gcc && \
#     /build-essential && \
#     /libpq-dev && \
#     && rm -rf /var/lib/apt/lists/* && \
#     /py/bin/pip install -r /tmp/requirements.dev.txt && \
#     if [ "$DEV" = "True" ]; then \
#     /py/bin/pip install -r /tmp/requirements.dev.txt ; \
#     fi && \
#     rm -rf /tmp

# # tạo user không cần root
# RUN useradd -m django-user
# USER django-user

# # ensure local python is preferred over distribution python
# ENV PATH="/py/bin:$PATH"


FROM python:3.11-slim

LABEL maintainer="TIỂU BỐI HỌC CODE"

# Không tạo file .pyc và log ra stdout để dễ debug
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Thư mục làm việc trong container
WORKDIR /app

# Expose port để chạy Django server
EXPOSE 8000

# Biến môi trường xác định có cài tool dev không
ARG DEV=False

# Cài các gói hệ thống cần thiết (psycopg2, build)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    build-essential \
    libpq-dev \
    passwd \
    && rm -rf /var/lib/apt/lists/*

# Tạo môi trường ảo tại /py
RUN python -m venv /py
ENV PATH="/py/bin:$PATH"

# Copy file requirements để cài thư viện
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Cài pip và các thư viện cần thiết (kể cả flake8 nếu DEV=True)
RUN pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "True" ]; then \
    pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp/*

# Copy toàn bộ source code vào container
COPY ./app /app

# Tạo user không chạy bằng root
RUN useradd -m django-user
USER django-user
