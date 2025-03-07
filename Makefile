.DEFAULT_GOAL := help

PREFIX_ARG := $(if $(PREFIX),--prefix $(PREFIX),)
LIBDIR_ARG := $(if $(LIBDIR),--libdir $(LIBDIR),)
DESTDIR_ARG := $(if $(DESTDIR),--destdir $(DESTDIR),)
INSTALL_ARGS := $(PREFIX_ARG) $(LIBDIR_ARG) $(DESTDIR_ARG)
BIN := ./_boot/dune.exe

# Dependencies used for testing dune, when developed locally and
# when tested in CI
TEST_DEPS := \
lwt \
cinaps \
core_bench \
"csexp>=1.3.0" \
js_of_ocaml \
js_of_ocaml-compiler \
"mdx>=2.1.0" \
menhir \
ocamlfind \
ocamlformat.$$(awk -F = '$$1 == "version" {print $$2}' .ocamlformat) \
"odoc>=2.0.1" \
"ppx_expect.v0.15.0" \
ppx_inline_test \
ppxlib \
ctypes \
"utop>=2.6.0" \
"melange>=0.3.1" \
"mel>=0.3.1"

# Dependencies recommended for developing dune locally,
# but not wanted in CI
DEV_DEPS := \
"dkml-workflows>=1.2.0" \
patdiff

TEST_OCAMLVERSION := 4.14.1

-include Makefile.dev

.PHONY: help
help:
	@cat doc/make-help.txt

.PHONY: release
release: $(BIN)
	@$(BIN) build @install -p dune --profile dune-bootstrap

$(BIN):
	@ocaml boot/bootstrap.ml

dev: $(BIN)
	$(BIN) build @install

all: $(BIN)
	$(BIN) build

.PHONY: install
install:
	$(BIN) install $(INSTALL_ARGS) dune

.PHONY: uninstall
uninstall:
	$(BIN) uninstall $(INSTALL_ARGS) dune

.PHONY: reinstall
reinstall: uninstall install

install-ocamlformat:
	opam install -y ocamlformat.$$(awk -F = '$$1 == "version" {print $$2}' .ocamlformat)

dev-depext:
	opam depext -y $(TEST_DEPS)

.PHONY: melange
melange:
	opam pin add -n melange-compiler-libs https://github.com/melange-re/melange-compiler-libs.git#48ff923f2c25136de8ab96678f623f54cdac438c
	opam pin add -n melange https://github.com/melange-re/melange.git#a8f50420a548f8323f8be3d9f66ce71336e314fc

.PHONY: dev-deps
dev-deps: melange
	opam install -y $(TEST_DEPS)

.PHONY: coverage-deps
coverage-deps:
	opam install -y bisect_ppx

.PHONY: dev-deps-sans-melange
dev-deps-sans-melange:
	opam install -y $(TEST_DEPS)

.PHONY: dev-switch
dev-switch:
	opam update
# Ensuring that either a dev switch already exists or a new one is created
	test "$(shell opam switch show)" = "$(shell pwd)" || \
		opam switch create -y . $(TEST_OCAMLVERSION) --deps-only --with-test
	opam install -y --update-invariant ocaml.$(TEST_OCAMLVERSION) $(TEST_DEPS) $(DEV_DEPS)

.PHONY: test
test: $(BIN)
	$(BIN) runtest

test-windows: $(BIN)
	$(BIN) build @runtest-windows

test-js: $(BIN)
	$(BIN) build @runtest-js

test-coq: $(BIN)
	DUNE_COQ_TEST=enable $(BIN) build @runtest-coq

test-melange: $(BIN)
	$(BIN) build @runtest-melange

test-all: $(BIN)
	$(BIN) build @runtest @runtest-js @runtest-coq @runtest-melange

test-all-sans-melange: $(BIN)
	$(BIN) build @runtest @runtest-js @runtest-coq

test-coverage: $(BIN)
	- $(BIN) build --instrument-with bisect_ppx --force @runtest
	bisect-ppx-report send-to Coveralls

.PHONY: check
check: $(BIN)
	@$(BIN) build @check

.PHONY: fmt
fmt: $(BIN)
	@$(BIN) fmt

.PHONY: promote
promote: $(BIN)
	@$(BIN) promote

.PHONY: accept-corrections
accept-corrections: promote

all-supported-ocaml-versions: $(BIN)
	$(BIN) build @install @runtest --workspace dune-workspace.dev --root .

.PHONY: clean
clean:
	rm -rf _boot _build

distclean: clean
	rm -f src/dune_rules/setup.ml

.PHONY: doc
doc:
	sphinx-build -W doc doc/_build

# livedoc-deps: you may need to [pip3 install sphinx-autobuild] and [pip3 install -r doc/requirements.txt]
livedoc:
	cd doc && sphinx-autobuild . _build --port 8888 -q --re-ignore '\.#.*'

update-jbuilds: $(BIN)
	$(BIN) build @doc/runtest --auto-promote

# you will need to use a dev-switch or do opam install dkml-workflows.
# we run --auto-promote twice since first may fail (ex. missing files with Unable to resolve symlink)
update-dkml: $(BIN)
	opam exec -- generate-setup-dkml-scaffold
	$(BIN) build @gen-dkml --auto-promote || $(BIN) build @gen-dkml --auto-promote
	rm -rf ci/setup-dkml/gh-darwin ci/setup-dkml/gh-linux ci/setup-dkml/gl
	rm -rf ci/setup-dkml/pc/setup-dkml-darwin_*.sh ci/setup-dkml/pc/setup-dkml-linux_*.sh
	$(BIN) build @ci/fmt --auto-promote || $(BIN) build @ci/fmt --auto-promote

# assumes MSYS2 or Cygwin, and Visual Studio. Do not use 'with-dkml make ...'
desktop-ci-windows_x86:
	if command -v pwsh; then \
	  pwsh ./ci/setup-dkml/pc/setup-dkml-windows_x86.ps1; \
	else \
	  powershell ./ci/setup-dkml/pc/setup-dkml-windows_x86.ps1; \
	fi
	/usr/bin/env PATH=/usr/bin \
	  dkml_host_abi=windows_x86 abi_pattern=win32-windows_x86_64; \
	  opam_root=.ci/o exe_ext=.exe \
	  /bin/sh ci/build-test.sh

# assumes MSYS2 or Cygwin, and Visual Studio. Do not use 'with-dkml make ...'
desktop-ci-windows_x86_64:
	if command -v pwsh; then \
	  pwsh ./ci/setup-dkml/pc/setup-dkml-windows_x86_64.ps1; \
	else \
	  powershell ./ci/setup-dkml/pc/setup-dkml-windows_x86_64.ps1; \
	fi
	/usr/bin/env PATH=/usr/bin \
	  dkml_host_abi=windows_x86 abi_pattern=win32-windows_x86_64 \
	  opam_root=.ci/o exe_ext=.exe \
	  /bin/sh ci/build-test.sh

# If the first argument is "run"...
ifeq (dune,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

.PHONY: bench
bench: $(BIN)
	@$(BIN) exec -- ./bench/bench.exe $(BIN)

.PHONY: dune
dune: $(BIN)
	$(BIN) $(RUN_ARGS)

# Use this target to make sure that we always run the in source dune when making
# the release
.PHONY: opam-release
opam-release: dev
	$(BIN) exec -- $(MAKE) dune-release

dune-release:
	dune-release tag
	dune-release distrib --skip-build --skip-lint --skip-tests
# See https://github.com/ocamllabs/dune-release/issues/206
	DUNE_RELEASE_DELEGATE=github-dune-release-delegate dune-release publish distrib --verbose
	dune-release opam pkg
	dune-release opam submit

.PHONY: docker-build-image
docker-build-image:
	docker build -f docker/dev.Dockerfile -t dune .

.PHONY: docker-compose
docker-compose:
	docker compose -f docker/dev.yml run dune bash

.PHONY: bootstrap
bootstrap:
	$(BIN) build @install -p dune --profile dune-bootstrap
