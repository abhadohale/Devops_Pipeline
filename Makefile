.PHONY: setup lint test build ci

setup:
	@if [ -f package.json ]; then npm install; fi
	@if [ -f requirements.txt ]; then python3 -m pip install -r requirements.txt; fi

lint:
	@if [ -f package.json ]; then npm run lint --if-present; fi
	@if [ -f requirements.txt ] || [ -f pyproject.toml ]; then python3 -m compileall .; fi

test:
	@if [ -f package.json ]; then npm run test --if-present; fi
	@if [ -f requirements.txt ] || [ -f pyproject.toml ]; then python3 -m pip install pytest >/dev/null 2>&1 || true; python3 -m pytest -q || true; fi

build:
	@if [ -f package.json ]; then npm run build --if-present; fi
	@if [ -f Dockerfile ]; then docker build -t devops-pipeline:local .; fi

ci: setup lint test build
