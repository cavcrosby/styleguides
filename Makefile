# special makefile variables
.DEFAULT_GOAL := help
.RECIPEPREFIX := >

# recursive variables
# NOTE: for some reason /bin/sh does not have the 'command' builtin despite
# it being a POSIX requirement, then again one system has /bin as a
# symlink to /usr/bin
SHELL = /usr/bin/sh
MKDOCS = mkdocs
SITE_DIR = site
executables = \
	${MKDOCS}\

# NOTES: e ==> executable, certain executables should exist before
# running. Inspired from:
# https://stackoverflow.com/questions/5618615/check-if-a-program-exists-from-a-makefile#answer-25668869
_check_executables := $(foreach e,${executables},$(if $(shell command -v ${e}),pass,$(error "No ${e} in PATH")))

# NOTE: may need to be passed in as a var at make runtime
# (e.g. make FOO=1), depending on the target
message =

.PHONY: help
help:
	# inspired by the makefiles of the Linux kernel and Mercurial
>	@echo 'Available make targets:'
>	@echo '  build        - creates the project site into a directory called'
>	@echo '                 "${SITE_DIR}", at least by default'
>	@echo '  test         - launches a web server with the project site'
>	@echo '  deploy       - deploys the project site to a GitHub Pages branch'
>	@echo '  clean        - remove files created by other targets'
>	@echo 'Target configurations (e.g. make [config]=1 [targets]):'
>	@echo '  message      - commit message to use when deploying to a GitHub'
>	@echo '                 Pages branch'

.PHONY: build
build:
>	${MKDOCS} build --clean --site-dir "${SITE_DIR}"

.PHONY: test
test:
>	${MKDOCS} serve --livereload

.PHONY: deploy
deploy:
>	@[ -n "${message}" ] || { echo "'message' was not passed into make"; exit 1; }
>	${MKDOCS} gh-deploy --message "${message}"

.PHONY: clean
clean:
>	rm --recursive --force "${SITE_DIR}"
