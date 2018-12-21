.PHONY: up
up:
	docker-compose up --build -d

.PHONY: down
down:
	docker-compose down

.PHONY: shell
shell:
	docker-compose exec --user `id -u`:`id -g` $(SERVICE) bash

.PHONY: lint
lint: jsonlint yamllint

.PHONY: jsonlint
jsonlint:
	docker-compose exec node bash -c "find km45-playbooks/ -name '*.json' -type f | xargs npx jsonlint -q"

.PHONY: yamllint
yamllint:
	docker-compose exec python bash -c "find km45-playbooks/ -name '*.yml' -type f | xargs yamllint"
