<?php
    // connect to database
    $mysqli = new mysqli('localhost', 'cse438', 'cse438', 'cse438');

    if($mysqli->connect_errno) {
        printf("Connection Failed: %s\n", $mysqli->connect_error);
        exit;
    }
    
?>