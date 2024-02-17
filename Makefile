TTY := true
OUT := dest

.PHONY: lint
lint: awesome-ci ansiblelint

.PHONY: ansiblelint
ansiblelint:
	ansible-lint src/playbooks/site.yml -x yaml,meta-no-info,risky-file-permissions,701,name[play],risky-shell-pipe

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

.PHONY: package
package: clean
	mkdir -p $(OUT)/
	cp -pr src/playbooks $(OUT)/

.PHONY: distribute-templates
distribute-templates:
	cp -p templates/Dockerfile.j2 src/playbooks/roles/cplusplus/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/git/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/hadolint/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/javascript/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/nkf/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/prompt/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/python/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/rust/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/shellcheck/molecule/default/
	cp -p templates/Dockerfile.j2 src/playbooks/roles/zip/molecule/default/
