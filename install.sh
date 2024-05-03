#!/usr/bin/env sh
#
## This script is POSIX-compliant
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

## We are gonna use this var a lot, so let's make a constant
LARAVEL_SRC_FOLDER="$PWD/src"

## If the user is root, use the compose file that uses the root php Dockerfile
case $(id -u) \
in
	0)
		${docker_compose_cmd} --file docker-compose-root.yml up --detach --build app && \
		find "${LARAVEL_SRC_FOLDER:?}" -mindepth 1 -delete && \
		bash -c "cd ./src && ${docker_compose_cmd} run --rm composer create-project laravel/laravel ."
	;;
	*)
		${docker_compose_cmd} --file docker-compose.yml up --detach --build app && \
		find "${LARAVEL_SRC_FOLDER:?}" -mindepth 1 -delete && \
		bash -c "cd ./src && ${docker_compose_cmd} run --rm composer create-project laravel/laravel ."
	;;
esac

## Looks like sed won't detect hidden files, so let's convert it first
mv -v "${LARAVEL_SRC_FOLDER:?}/.env" "${LARAVEL_SRC_FOLDER:?}/env"

sed_command=sed
if command -v gsed > /dev/null 2>&1; then
	sed_command=gsed
fi

## Use sed to edit in-place the env to add our environment vars
${sed_command} -i -E 's|^(DB_CONNECTION=).*|\1mysql|g' "${LARAVEL_SRC_FOLDER:?}/env"
${sed_command} -i -E 's|^# ?(DB_HOST=).*|\1mysql|g' "${LARAVEL_SRC_FOLDER:?}/env"
${sed_command} -i -E 's|^# ?(DB_DATABASE=).*|\1homestead|g' "${LARAVEL_SRC_FOLDER:?}/env"
${sed_command} -i -E 's|^# ?(DB_USERNAME=).*|\1homestead|g' "${LARAVEL_SRC_FOLDER:?}/env"
${sed_command} -i -E 's|^# ?(DB_PASSWORD=).*|\1secret|g' "${LARAVEL_SRC_FOLDER:?}/env"

## Let's convert env file back to normal so the project can read its env vars
mv -v "${LARAVEL_SRC_FOLDER:?}/env" "${LARAVEL_SRC_FOLDER:?}/.env"

## Run the DB migrations and seeding
${docker_compose_cmd} run --rm artisan migrate --seed

## Let's make the modifications to read a row from the DB
cat << EOF > "${LARAVEL_SRC_FOLDER:?}/routes/web.php"
<?php

use Illuminate\Support\Facades\Route;

// Route::get('/', function () {
//     return view('welcome');
// });

use App\Http\Controllers\HomeController;

Route::get('/', [HomeController::class, 'index']);

EOF

## A simple controller to echo the received row because it won't return nothing
${docker_compose_cmd} run --rm artisan make:controller HomeController

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
