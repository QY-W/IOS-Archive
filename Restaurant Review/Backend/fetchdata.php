<?php
    require 'database.php';

    $query = $_GET['query'];
    
    if($query !=''){
        $tmp = "%".$query."%";
        $stmt = $mysqli->prepare("SELECT * FROM restaurant WHERE name LIKE ?");
        $stmt->bind_param('s', $tmp);
    }
    else{
        $stmt = $mysqli->prepare("SELECT * FROM restaurant");
    }
    

    if ($stmt->execute()) {

        $result = $stmt->get_result();
        $event = array();

        while($row = $result->fetch_assoc()){
            foreach($row as $value){
                // Safe from XSS attacks
                $value = htmlentities($value);
            }
            array_push($event,$row);
        }
    
        // $event = array($title => $result['title'], $body => $result['body'], $date => $result['date'],
        //                $time => $result['time'], $duration => $result['duration']);


        echo json_encode(array(
            "success" => true,
            "message" => $event,
        ));
    } 
    else{
        echo json_encode(array(
            "success" => false,
            "message" => "Only body and duration can be null"
        ));
    }
    $stmt->close();
?>