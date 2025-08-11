<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

function tryWrite($path, $file) {
  if (!is_dir($path)) {
    echo "Creating dir: $path<br>";
    if (!@mkdir($path, 0775, true)) {
      echo "❌ mkdir failed for $path (" . error_get_last()['message'] . ")<br>";
      return;
    }
  }
  $full = rtrim($path, '/').'/'.$file;
  $ok = @file_put_contents($full, "test ".date('c')."\n", FILE_APPEND);
  if ($ok === false) {
    echo "❌ write failed: $full (" . error_get_last()['message'] . ")<br>";
  } else {
    echo "✅ wrote: $full<br>";
  }
  clearstatcache(true, $full);
  $st = @stat($full);
  echo $st ? "owner: {$st['uid']}, mode: ".decoct($st['mode'] & 0777)."<br>" : "";
}

tryWrite(__DIR__.'/var/cache', 'canwrite.txt');
tryWrite(__DIR__.'/var/logs',  'canwrite.txt');  // some versions use var/log
tryWrite(__DIR__.'/var/log',   'canwrite.txt');  // others use var/log
tryWrite(__DIR__.'/app/config','local.php');     // installer writes here

echo "<br>Who am I? ".get_current_user()." (uid=".getmyuid().")<br>";
