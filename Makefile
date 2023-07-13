TTY := true
OUT := dest

.PHONY: up
up:
	docker-compose up --build -d

.PHONY: down
down:
	docker-compose down

.PHONY: shell
shell:
	docker-compose exec --user `id -u`:`id -g` $(SERVICE) bash

.PHONY: lint2
lint2:
	ansible-lint src/playbooks/well_tested.yml -x yaml,meta-no-info,risky-file-permissions,701,name[play]

.PHONY: lint
lint: jsonlint ansiblelint awesome-ci

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
	docker-compose exec -T python bash -c "ansible-lint -x 106,208,301,305,306,701,risky-file-permissions,no-changed-when,command-instead-of-shell,risky-shell-pipe,meta-no-info src/playbooks/site.yml"
else
	docker-compose exec    python bash -c "ansible-lint -x 106,208,301,305,306,701,risky-file-permissions,no-changed-when,command-instead-of-shell,risky-shell-pipe,meta-no-info src/playbooks/site.yml"
endif

.PHONY: awesome-ci
awesome-ci:
	docker run --rm -v $(CURDIR)/src:/ac cytopia/awesome-ci file-crlf                    --path=/ac --ignore=".git,*/__pycache__"
	docker run --rm -v $(CURDIR)/src:/ac cytopia/awesome-ci file-trailing-newline        --path=/ac --ignore=".git,*/__pycache__"
	docker run --rm -v $(CURDIR)/src:/ac cytopia/awesome-ci file-trailing-single-newline --path=/ac --ignore=".git,*/__pycache__"
	docker run --rm -v $(CURDIR)/src:/ac cytopia/awesome-ci file-trailing-space          --path=/ac --ignore=".git,*/__pycache__"
	docker run --rm -v $(CURDIR)/src:/ac cytopia/awesome-ci file-utf8                    --path=/ac --ignore=".git,*/__pycache__"
	docker run --rm -v $(CURDIR)/src:/ac cytopia/awesome-ci file-utf8-bom                --path=/ac --ignore=".git,*/__pycache__"
	docker run --rm -v $(CURDIR)/src:/ac cytopia/awesome-ci syntax-json                  --path=/ac --ignore=".git,*/__pycache__" --extension=json
	docker run --rm -v $(CURDIR)/src:/ac cytopia/awesome-ci syntax-markdown              --path=/ac --ignore=".git,*/__pycache__" --extension=md

.PHONY: sync
sync:
	pip install -r requirements.txt

.PHONY: test
test:
	bash -c "cd src/playbooks/roles/${ROLE} && molecule test"

.PHONY: clean
clean:
	rm -rf $(OUT)

.PHONY: package-jammy
package-jammy:
	mkdir -p $(OUT)/ubuntu-jammy-vagrant
	cp -p src/vagrantfiles/ubuntu-jammy/Vagrantfile $(OUT)/ubuntu-jammy-vagrant
	cp -pr src/playbooks $(OUT)/ubuntu-jammy-vagrant

.PHONY: package
package: clean package-jammy

.PHONY: distribute-templates
distribute-templates:
	cp -p templates/Dockerfile.j2 src/playbooks/roles/cplusplus/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/font/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/git/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/hadolint/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/nkf/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/prompt/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/python/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/rust/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/shellcheck/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/zip/molecule/default/
