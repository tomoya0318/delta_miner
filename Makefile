build:
	docker compose build
up:
	docker compose up -d
down:
	docker compose down
exec:
	docker exec -it delta_miner bash -c "source .venv/bin/activate && exec bash"
activate:
	source .venv/bin/activate
