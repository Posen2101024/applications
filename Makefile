SHELL := /bin/bash
PHONY :=

VENV := .venv

GIT ?= git
DOCKER ?= docker
PYTHON ?= python3
DOCK ?= $(VENV)/bin/dock

CURRENT_COMMIT_ID ?= $(shell $(GIT) rev-parse --short=11 HEAD)
DOCK_IMAGE_TAGS ?= latest $(CURRENT_COMMIT_ID)

$(VENV):
	@set -euo pipefail; \
	$(PYTHON) -m venv $(VENV); \
	$(VENV)/bin/pip install -Uq pip; \
	$(VENV)/bin/pip install -Uq --pre dock-cli; \
	echo -e "Successfully created a new virtualenv $(VENV) in $$PWD";

PHONY += init
init: $(VENV)

PHONY += list
list: init
	@set -euo pipefail; \
	$(VENV)/bin/pip list;

PHONY += clean
clean:
	@rm -rf $(VENV)

PHONY += build-images
build-images: init
	$(DOCK) image diff HEAD^1
	$(DOCK) image diff HEAD^1 | DOCK_IMAGE_BUILD_TAGS="$(DOCK_IMAGE_TAGS)" xargs -r $(DOCK) image build

PHONY += push-images
push-images: init
	$(DOCKER) images --digests
	$(DOCK) image diff HEAD^1 | DOCK_IMAGE_PUSH_TAGS="$(DOCK_IMAGE_TAGS)"  xargs -r $(DOCK) image push

PHONY += clean-images
clean-images: init
	$(DOCK) image diff HEAD^1 | DOCK_IMAGE_CLEAN_TAGS="$(DOCK_IMAGE_TAGS)" xargs -r $(DOCK) image clean
	$(DOCKER) images --digests

PHONY += package-charts
package-charts: init
	$(DOCK) chart diff HEAD^1
	$(DOCK) chart diff HEAD^1 | xargs -r $(DOCK) chart package --destination=/tmp/charts

PHONY += push-charts
push-charts: init
	$(DOCK) chart diff HEAD^1 | xargs -r $(DOCK) chart push --destination=/tmp/charts

PHONY += clean-charts
clean-charts:
	rm --force /tmp/charts/*.tgz

.PHONY: $(PHONY)
