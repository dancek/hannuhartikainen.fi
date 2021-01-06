all: build upload

build:
	zola build

upload:
	ansible-playbook ../infra/upload.yml

.PHONY: all build upload
