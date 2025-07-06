FROM python:3.11-slim

#NAME 
LABEL maintainer="TIỂU BỐI HỌC CODE"

# Không tạo .pyc, __pycache__, giữ cho container sạch
ENV PYTHONDONTWRITEBYTECODE=1

# Log ra stdout/stderr ngay lập tức, dễ debug khi chạy bằng Docker
ENV PYTHONUNBUFFERED=1

# THƯC MỤC LÀM VIỆC
WORKDIR /app

# Mở cổng 8000 để Django runserver lắng nghe
EXPOSE 8000

# Cài pip và các thư viện Python
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
#/app thư mục làm việc

COPY ./app /app 
#Tạo virtualenv riêng (/py) để tránh dùng Python hệ thống
# install pip and upgrade
# install requirements djang && flake8
# có dev, thì có if
ARG DEV=False
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    /py/bin/pip install -r /tmp/requirements.dev.txt && \
    if [ "$DEV" = "True" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp

    # tạo user không cần root
RUN useradd -m django-user
USER django-user

# ensure local python is preferred over distribution python
ENV PATH="/py/bin:$PATH"