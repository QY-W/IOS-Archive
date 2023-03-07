<?php
    require 'database.php';

    $username = trim($_GET["username"]);

    // check if username already exists
    $stmt = $mysqli->prepare("SELECT COUNT(*) FROM user WHERE username=?");
    $stmt->bind_param('s', $username);
    $stmt->execute();

    $stmt->bind_result($cnt);
    $stmt->fetch();

    $isExit = false;
    if($cnt > 0) {
        $isExit = true;
    }
    $stmt->close();

    if ($isExit == false) {

        // insert to db
        $password_hash = password_hash(trim($_GET["password"]), PASSWORD_BCRYPT);
        $stmt = $mysqli->prepare("INSERT INTO user(username, password) VALUES (?, ?)");
        $stmt->bind_param('ss', $username, $password_hash);
        $stmt->execute();
        $stmt->close();

        echo json_encode(array(
            "success" => true,
            "message" => $username,
        ));
    } 
    else {
        echo json_encode(array(
            "success" => false,
            "message" => "User already exists"
        ));
    }

?>