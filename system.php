<?php
require_once('../lib/functions.php');

// НУЖНО НАСТРОИТЬ ВОЗМОЖНОСТЬ ИЗМЕНЕНИЯ ПАРАМЕТРОВ ПОДКЛЮЧЕНИЯ К БД

// Параметры подключения к базе данных PostgreSQL
// $host = "localhost"; // Хост (для локального сервера Open Server в старых версиях)
// $host = "127.127.126.31"; // домашний ip OpenServer (для доступа в новой версии Open Server)
$host = "192.168.19.138"; // домашний ip OpenServer (для доступа в новой версии Open Server)
$port = "5432"; // Порт PostgreSQL (по умолчанию)
$dbname = "app"; // Имя вашей базы данных
$user = "postgres"; // Имя пользователя PostgreSQL
$password = "postgres"; // Пароль пользователя

// Формируем строку подключения
$connection_string = "host={$host} port={$port} dbname={$dbname} user={$user} password={$password}";

// Пытаемся установить соединение
$dbconn = @pg_connect($connection_string);
$conn = $dbconn; // $conn - используется в функциях (привычно по работе)

// Проверяем, удалось ли подключение
if (!$dbconn) {
    // echo "Не удалось подключиться к базе данных PostgreSQL: " . @pg_last_error(); // Вывод сообщения об ошибке стандартными средствами PHP
    output('red', 'Не удалось подключиться к базе данных PostgreSQL.' . @pg_last_error()); // Функция functions.php
    exit;
}
