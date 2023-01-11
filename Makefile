ifndef env
env:=example
endif
up:
# 	cp docker-compose.yml.$(env) docker-compose.yml
	docker-compose up -d
install:
	cp .env.$(env) .env
	cp docker-compose.yml.$(env) docker-compose.yml
	docker-compose up -d --build
	make init-app
restart:
	- make stop
	- make up
stop:
	docker-compose down
pull:
	- git pull
	- make migrate
#
init-app:
	docker exec -it laravel_app composer install
	docker exec -it laravel_app php artisan key:generate
	docker exec -it laravel_app php artisan migrate
	docker exec -it laravel_app php artisan db:seed
	docker exec -it laravel_app chmod -R 777 storage bootstrap
	docker exec -it laravel_app git config --global url."https://".insteadOf git://
	docker exec -it laravel_app npm cache clean --force
	docker exec -it laravel_app rm -f package-lock.json
	docker exec -it laravel_app npm install
	docker exec -it laravel_app npm run production
	docker exec -it laravel_app php artisan config:cache
dev:
	- docker exec -it laravel_app npm run watch
build:
	docker exec -it laravel_app npm install
	docker exec -it laravel_app composer install
	docker exec -it laravel_app npm run production
update-code:
	git pull
	docker exec -it laravel_app composer install
	docker exec -it laravel_app php artisan config:cache
	make migrate
	make build
	make clear
migrate:
	docker exec -it laravel_app php artisan migrate
seed:
	docker exec -it laravel_app php artisan db:seed
reseed:
	- docker exec -it laravel_app php artisan migrate:reset
	- docker exec -it laravel_app php artisan migrate
	- docker exec -it laravel_app php artisan db:seed
delete:
	- docker-compose stop
	- docker-compose down
	- docker rm $(shell docker ps -la  | grep '${APP_NAME}' | awk '{print $1}')
	- docker rmi $(shell docker images -a -q)
tinker:
	docker exec -it laravel_app php artisan tinker
conn:
	docker exec -it laravel_app bash
down:
	docker exec -it laravel_app php artisan down
start:
	docker exec -it laravel_app php artisan up
clear:
	docker exec -it laravel_app php artisan config:clear
	docker exec -it laravel_app php artisan view:clear
	docker exec -it laravel_app php artisan cache:clear
	docker exec -it laravel_app php artisan route:clear
	docker exec -it laravel_app composer dump-autoload
restart-queue:
	docker exec laravel_worker supervisorctl reread
	docker exec laravel_worker supervisorctl restart all
