<?php

if (!class_exists('RequestParseBodyException')) {
    class RequestParseBodyException extends \Exception {}
}
if (!function_exists('request_parse_body')) {
    function request_parse_body(?array $options = null): array {
        throw new RequestParseBodyException();
    }
}

use Illuminate\Foundation\Application;
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// Determine if the application is in maintenance mode...
if (file_exists($maintenance = __DIR__.'/../storage/framework/maintenance.php')) {
    require $maintenance;
}

// Register the Composer autoloader...
require __DIR__.'/../vendor/autoload.php';

// Bootstrap Laravel and handle the request...
/** @var Application $app */
$app = require_once __DIR__.'/../bootstrap/app.php';

try {
    $app->handleRequest(Request::capture());
} catch (\Throwable $e) {
    file_put_contents(__DIR__.'/../storage/logs/real_error.log', $e->getMessage() . "\n" . $e->getTraceAsString() . "\n\n", FILE_APPEND);
    throw $e;
}
