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
	find km45-playbooks/ -name '*.json' -type f | xargs yarn run jsonlint -q

.PHONY: yamllint
yamllint:
	find km45-playbooks/ -name '*.yml' -type f | xargs pipenv run yamllint
