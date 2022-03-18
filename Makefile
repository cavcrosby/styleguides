include base.mk

# recursive variables
SITE_DIR_PATH = ./site

# executables
MKDOCS = mkdocs
executables = \
	${MKDOCS}\

# targets
BUILD = build
TEST = test

# simply expanded variables
_check_executables := $(foreach e,${executables},$(if $(shell command -v ${e}),pass,$(error "No ${e} in PATH")))

# to be (or can be) passed in at make runtime
COMMIT_MESSAGE =

.PHONY: ${HELP}
${HELP}:
	# inspired by the makefiles of the Linux kernel and Mercurial
>	@echo 'Common make targets:'
>	@echo '  ${BUILD}        - creates the project site into a directory'
>	@echo '  ${TEST}         - launches a web server with the project site'
>	@echo '  ${DEPLOY}       - deploys the project site to a GitHub Pages branch'
>	@echo '  ${CLEAN}        - remove files created by targets'
>	@echo 'Common make configurations (e.g. make [config]=1 [targets]):'
>	@echo '  COMMIT_MESSAGE      - commit message to use when deploying to a GitHub'
>	@echo '                        Pages branch'

.PHONY: ${BUILD}
${BUILD}:
>	${MKDOCS} build --clean --site-dir "${SITE_DIR_PATH}"

.PHONY: ${TEST}
${TEST}:
>	${MKDOCS} serve --livereload

.PHONY: ${DEPLOY}
${DEPLOY}:
>	@[ -n "${COMMIT_MESSAGE}" ] || { echo "make: 'COMMIT_MESSAGE' was not passed into make"; exit 1; }
>	${MKDOCS} gh-deploy --message "${COMMIT_MESSAGE}"

.PHONY: ${CLEAN}
${CLEAN}:
>	rm --recursive --force "${SITE_DIR_PATH}"
