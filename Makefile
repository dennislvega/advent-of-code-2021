SHELL  := /bin/bash
# OPTION:PYTHON           Python binary (default: python)
PYTHON := $(shell builtin command -v python)

.DEFAULT: help
all: help

.PHONY: bootstrap
# TARGET:bootstrap        Install/update project dependencies
bootstrap:
	@$(PYTHON) -m pip install -U pip
	@$(PYTHON) -m pip install -U setuptools wheel
	@$(PYTHON) -m pip install -U poetry
	@$(PYTHON) -m poetry install

.PHONY: clean
# TARGET:clean            Remove all cached/build files
clean:
	@find . -name '*.pyc' -exec rm -f {} +
	@find . -name '*.pyo' -exec rm -f {} +
	@find . -maxdepth 4 | egrep -E "(dist|__pycache__|.pytest_cache|.coverage\.(html|xml))$$" | xargs rm -rf

.PHONY: format
# TARGET:format           Apply formatting rules to Python files
format:
	@$(PYTHON) -m poetry run isort src tests
	@$(PYTHON) -m poetry run black src tests

.PHONY: lint
# TARGET:lint             Apply linting rules to Python files
lint:
	@$(PYTHON) -m poetry run flake8 src tests --count --show-source --statistics

.PHONY: test
# TARGET:test             Run unit tests
test:
	@$(PYTHON) -m poetry run pytest --no-cov --verbose

.PHONY: coverage
# TARGET:coverage         Generate code coverage artifacts
coverage:
	@$(PYTHON) -m poetry run pytest --cov=. --cov-config=.coveragerc --cov-report=xml --cov-report=html --cov-context=test

.PHONY: help
# TARGET:help
help:
	# Usage:
	#   make <TARGET> [OPTION=value]
	#
	# Options:
	@egrep "^# OPTION:" [Mm]akefile | sed 's/^# OPTION:/#   /'
	#
	# Targets:
	@egrep "^# TARGET:" [Mm]akefile | sed 's/^# TARGET:/#   /'
	#
	# Examples
	#   Installs project dependencies
	#   $$ make bootstrap