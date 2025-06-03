build:
	docker compose build
build_no_cache:
	docker compose build --no-cache
up:
	docker compose up -d
down:
	docker compose down
exec:
	docker exec -it delta_miner bash -c "source .venv/bin/activate && exec bash"
activate:
	source .venv/bin/activate
