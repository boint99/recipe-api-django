- Create users and manage users then run behind
  run:
  - docker-compose run --rm app sh -c "python manage.py makemigrations" .
  - docker-compose run --rm app sh -c "python manage.py wait_for_db && python manage.py migrate" .
    => Fix lỗi rác:
    1. docker-compose down.
    2. docker volume ls.
    3. docker volume rm recipe-api-django_postgres_data.
    4. docker-compose run --rm app sh -c "python manage.py wait_for_db && python manage.py migrate".
    5. docker-compose run --rm app sh -c "python manage.py test".
       => tất cả điều ok thành công.
