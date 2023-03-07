<?php
    require 'database.php';

    $username = $_GET["username"];
    $pwd_guess = $_GET["password"];
    
    // Use a prepared statement
    $stmt = $mysqli->prepare("SELECT COUNT(*), username, password FROM user WHERE username=?");
    $stmt->bind_param('s', $username);
    $stmt->execute();

    // Bind the results
    $stmt->bind_result($cnt, $user_id, $password);
    $stmt->fetch();

    // Compare the submitted password to the actual password hash

    if($cnt == 1 && password_verify($pwd_guess, $password)){
        // Login succeeded!
        echo json_encode(array(
            "success" => true,
            "message" => $username,
        ));
    } else{
        echo json_encode(array(
            "success" => false,
            "message" => "Incorrect Username or Password"
        ));
    }

    $stmt->close();
?>