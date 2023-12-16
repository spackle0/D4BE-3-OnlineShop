PROJECT_NAME=myshop
VERSION=0.1.0
# For build process, minimum test coverage required to pass testing
MIN_COVERAGE=0

$(info ========================================)
$(info Version=${VERSION})
$(info Min Test Coverage=${MIN_COVERAGE})
$(info ========================================)

.PHONY: run
run:
	poetry run python manage.py runserver

.PHONE: run_plus
run_plus:
	poetry run python manage.py runserver_plus --cert-file cert.crt

# Update semver per .bumpversion.cfg
.PHONY: bump_major
bump_major:
	poetry run bumpversion --list major

.PHONY: bump_minor
bump_minor:
	poetry run bumpversion --list minor

.PHONY: bump_patch
bump_patch:
	poetry run bumpversion --list patch

.PHONY: lint
lint:
	@echo "Flake8 running"
	-poetry run flake8 ${PROJECT_NAME}
	@echo "Pylint running"
	-poetry run pylint ${PROJECT_NAME}

.PHONY: ruff
ruff:
	ruff format .
	ruff check .

.PHONY: dbmigrate
dbmigrate:
	# Generate a new .py file in versions folder with changes
	poetry run python manage.py makemigrations
	poetry run python manage.py migrate

.PHONY: format
format:
	poetry run isort --skip migrations ${PROJECT_NAME}
	poetry run black --exclude="migrations/" ${PROJECT_NAME}

.PHONY: sec
sec:
	poetry run bandit ./intertraq
	poetry run pyt -a D ./intertraq

.PHONY: mksu
mksu:
	poetry run python manage.py createsuperuser

.PHONY: make_key
make_key:
	poetry run python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'

.PHONY: runrabbit
runrabbit:
	docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:management
