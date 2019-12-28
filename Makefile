TTY := true

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
lint: jsonlint ansiblelint

.PHONY: jsonlint
jsonlint:
ifeq ($(TTY), false)
	docker-compose exec -T node bash -c "find src/playbooks/ -name '*.json' -type f | xargs npx jsonlint -q"
else
	docker-compose exec    node bash -c "find src/playbooks/ -name '*.json' -type f | xargs npx jsonlint -q"
endif

.PHONY: ansiblelint
ansiblelint:
ifeq ($(TTY), false)
	docker-compose exec -T python bash -c "ansible-lint -x 301,305,306,701 src/playbooks/site.yml"
else
	docker-compose exec    python bash -c "ansible-lint -x 301,305,306,701 src/playbooks/site.yml"
endif

.PHONY: sync
sync:
	poetry install

.PHONY: test
test:
	poetry run bash misc/run-molecule test
