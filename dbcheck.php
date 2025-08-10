<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$host = getenv('MAUTIC_DB_HOST') ?: getenv('DB_HOST');
$port = getenv('MAUTIC_DB_PORT') ?: getenv('DB_PORT') ?: '3306';
$db   = getenv('MAUTIC_DB_NAME') ?: getenv('DB_NAME');
$user = getenv('MAUTIC_DB_USER') ?: getenv('DB_USER');
$pass = getenv('MAUTIC_DB_PASSWORD') ?: getenv('DB_PASSWORD');

echo "Trying PDO to $host:$port / $db as $user<br>";

try {
    $dsn = "mysql:host=$host;port=$port;dbname=$db;charset=utf8mb4";
    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_TIMEOUT => 10,
    ]);
    echo "✅ Connected! Running SELECT 1…<br>";
    $stmt = $pdo->query('SELECT 1');
    var_dump($stmt->fetchAll());
} catch (Throwable $e) {
    echo "❌ Connection failed: " . htmlspecialchars($e->getMessage());
}
