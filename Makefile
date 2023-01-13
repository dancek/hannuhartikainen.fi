all: build upload

build:
	zola build

upload:
	ansible-playbook ../infra/upload.yml


KDIR ?= ~/dev/linux
linux-log:
	git -C ${KDIR} log --grep="Hannu Hartikainen" > data/linux.log

.PHONY: all build upload linux-log
