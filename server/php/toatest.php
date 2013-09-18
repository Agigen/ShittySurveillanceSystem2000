<?php

$toilets = array();
for ($i=1; $i < rand(2,9); $i++) { 
    
    $toilets[] = (object)array(
        'title' => "tois $i",
        'occupied' => (rand(0,1) > 0)
        
    );
    
}

header('Content-Type: application/json');
echo json_encode((object)array('toilets' => $toilets));