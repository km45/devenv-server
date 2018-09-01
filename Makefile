.PHONY: yamllint
yamllint:
	find km45-playbooks/ -name '*.yml' -type f | xargs pipenv run yamllint
