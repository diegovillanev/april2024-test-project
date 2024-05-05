#!/usr/bin/env sh
#
# This script is POSIX-compliant
#
# By Diego Villarreal Nevárez, @diegovillanev in my Job GitHub profile

## Detect if the system is the deprecated script "docker-compose"
## or the new docker option "docker compose"
if docker compose version > /dev/null 2>&1;
then
	docker_compose_cmd="docker compose"
else
	docker_compose_cmd="docker-compose"
fi

sudo rm -rf "$PWD/src" "$PWD/mysql";
mkdir -pv "$PWD/src" "$PWD/mysql";

## We are gonna use this var a lot, so let's make it a constant
LARAVEL_SRC_FOLDER="$PWD/src"

## If the user is root, use the compose file that uses the root php Dockerfile
case $(id -u) \
in
	0)
		${docker_compose_cmd:?} --file docker-compose-root.yml up --detach --build app && \
		bash -c "cd ./src && ${docker_compose_cmd:?} run --rm composer create-project laravel/laravel ."
	;;
	*)
		${docker_compose_cmd:?} --file docker-compose.yml up --detach --build app && \
		bash -c "cd ./src && ${docker_compose_cmd:?} run --rm composer create-project laravel/laravel ."
	;;
esac

if [ -f "${LARAVEL_SRC_FOLDER:?}/bootstrap/app.php" ];
then
	if [ -f "${LARAVEL_SRC_FOLDER:?}/.env" ];
	then
		## Use POSIX sed to add our environment vars to a temp file
		sed -E -e 's|^(DB_CONNECTION=).*|\1mysql|g' \
		       -e 's|^# ?(DB_HOST=).*|\1mysql|g' \
		       -e 's|^# ?(DB_DATABASE=).*|\1homestead|g' \
		       -e 's|^# ?(DB_USERNAME=).*|\1homestead|g' \
		       -e 's|^# ?(DB_PASSWORD=).*|\1secret|g' \
		"${LARAVEL_SRC_FOLDER:?}/.env" > "${LARAVEL_SRC_FOLDER:?}/env.tmp"

		## Let's convert temp file to an actual envfile so the project can read its env vars
		mv -v "${LARAVEL_SRC_FOLDER:?}/env.tmp" "${LARAVEL_SRC_FOLDER:?}/.env"
	else
		printf "%b" "${LARAVEL_SRC_FOLDER:?}/.env file could no be found! Exiting...\n\n" 1>&2
		exit 1
	fi

	## Run the DB migrations and seeding
	${docker_compose_cmd:?} run --rm artisan migrate --seed

	## Let's make the modifications to read a row from the DB
	if [ -f "${LARAVEL_SRC_FOLDER:?}/routes/web.php" ];
	then
		cat << EOF > "${LARAVEL_SRC_FOLDER:?}/routes/web.php"
<?php

use Illuminate\Support\Facades\Route;

// Route::get('/', function () {
//     return view('welcome');
// });

use App\Http\Controllers\HomeController;

Route::get('/', [HomeController::class, 'index']);

EOF
	else
		printf "%b" "${LARAVEL_SRC_FOLDER:?}/web/routes.php" \
		" file could no be found! Exiting...\n\n" 1>&2
		exit 1
	fi


	## A simple controller to echo the received row because it won't return to welcome view
	${docker_compose_cmd:?} run --rm artisan make:controller HomeController

	if [ -f "${LARAVEL_SRC_FOLDER:?}/app/Http/Controllers/HomeController.php" ];
	then
		cat << EOF > "${LARAVEL_SRC_FOLDER:?}/app/Http/Controllers/HomeController.php"
<?php

// app/Http/Controllers/HomeController.php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;

class HomeController extends Controller
{
    public function index()
    {
        // Retrieve a record from the database
        \$user = User::first();
        echo(\$user);

        // Return view with retrieved user
        return view('welcome', ['user' => \$user]);
    }
}

EOF
	else
		printf "%b" "${LARAVEL_SRC_FOLDER:?}/app/Http/Controllers/Home" \
		"Controller.php file could no be found! Exiting...\n\n" 1>&2
		exit 1
	fi
else
	printf "%b" "${LARAVEL_SRC_FOLDER:?}/bootstrap/app." \
	"php file could no be found! Exiting...\n\n" 1>&2
	exit 1
fi

