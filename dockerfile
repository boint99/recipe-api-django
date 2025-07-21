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

# Không tạo .pyc, __pycache__, log ngay stdout
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Làm việc trong /app
WORKDIR /app

# Cài pip và các thư viện Python
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# Mở port Django
EXPOSE 8000

# Biến dùng khi build để xác định môi trường dev
ARG DEV=False

# Cài các gói hệ thống cần cho psycopg2
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    build-essential \
    libpq-dev \
    passwd \
    && rm -rf /var/lib/apt/lists/*

# Tạo virtualenv tại /py
RUN python -m venv /py
ENV PATH="/py/bin:$PATH"

# Cài pip và các gói yêu cầu
COPY ./requirements.txt /tmp/
COPY ./requirements.dev.txt /tmp/

RUN pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "True" ]; then \
    pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp/*

# Copy mã nguồn vào container
COPY ./app /app

# Tạo user không cần quyền root
RUN useradd -m django-user
USER django-user
