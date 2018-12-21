.PHONY: up
up:
	docker-compose up --build -d

.PHONY: down
down:
	docker-compose down

.PHONY: shell
shell:
	docker-compose exec --user `id -u`:`id -g` $(SERVICE) bash

.PHONY: jsonlint
jsonlint:
	docker-compose exec node sh -c "find km45-playbooks/ -name '*.json' -type f | xargs npx jsonlint -q"

.PHONY: yamllint
yamllint:
	docker-compose exec python sh -c "find km45-playbooks/ -name '*.yml' -type f | xargs yamllint"
