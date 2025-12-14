.PHONY: setup build tagger edit down logs clean clean-images help

help:
	@echo "Usage:"
	@echo "  make setup        - Create directory structure"
	@echo "  make build        - Build Docker images"
	@echo "  make tagger       - Run WD Tagger on dataset/images/"
	@echo "  make edit         - Start Tag Editor (http://localhost:7862)"
	@echo "  make down         - Stop all containers"
	@echo "  make logs         - Show container logs"
	@echo "  make clean        - Remove containers and volumes"
	@echo "  make clean-images - Remove Docker images"

setup:
	@mkdir -p dataset/images dataset/tags models
	@echo "Directory structure created:"
	@echo "  dataset/images/ - Place your images here"
	@echo "  dataset/tags/   - Tag files will be saved here"
	@echo "  models/         - Model cache directory"

build:
	docker compose build

tagger:
	docker compose run --rm wd-tagger \
		--dir /dataset/images \
		--recursive \
		--overwrite

edit:
	docker compose --profile editor up tag-editor

down:
	docker compose --profile editor down
	docker compose --profile tagger down

logs:
	docker compose logs -f

clean:
	docker compose down -v --remove-orphans

clean-images:
	docker compose down -v --remove-orphans
	docker rmi $$(docker images -q 'wd-tagger-editor-docker*') 2>/dev/null || true
