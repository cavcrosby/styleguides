# special makefile variables
.DEFAULT_GOAL := help
.RECIPEPREFIX := >

# recursive variables
SHELL = /usr/bin/sh
SITE_DIR = site

# executables
MKDOCS = mkdocs
executables = \
	${MKDOCS}\

# targets
HELP = help
BUILD = build
TEST = test
DEPLOY = deploy
CLEAN = clean

# inspired from:
# https://stackoverflow.com/questions/5618615/check-if-a-program-exists-from-a-makefile#answer-25668869
_check_executables := $(foreach e,${executables},$(if $(shell command -v ${e}),pass,$(error "No ${e} in PATH")))

# May need to be passed in as a var at make runtime (e.g. make FOO=1),
# depending on the target.
message =

.PHONY: ${HELP}
${HELP}:
	# inspired by the makefiles of the Linux kernel and Mercurial
>	@echo 'Available make targets:'
>	@echo '  ${BUILD}        - creates the project site into a directory called'
>	@echo '                 "${SITE_DIR}"'
>	@echo '  ${TEST}         - launches a web server with the project site'
>	@echo '  ${DEPLOY}       - deploys the project site to a GitHub Pages branch'
>	@echo '  ${CLEAN}        - remove files created by other targets'
>	@echo 'Public make configurations (e.g. make [config]=1 [targets]):'
>	@echo '  message      - commit message to use when deploying to a GitHub'
>	@echo '                 Pages branch'

.PHONY: ${BUILD}
${BUILD}:
>	${MKDOCS} build --clean --site-dir "${SITE_DIR}"

.PHONY: ${TEST}
${TEST}:
>	${MKDOCS} serve --livereload

.PHONY: ${DEPLOY}
${DEPLOY}:
>	@[ -n "${message}" ] || { echo "'message' was not passed into make"; exit 1; }
>	${MKDOCS} gh-deploy --message "${message}"

.PHONY: ${CLEAN}
${CLEAN}:
>	rm --recursive --force "${SITE_DIR}"
