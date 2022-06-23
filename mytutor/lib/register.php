<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$name = addslashes($_POST['name']);
$phonenumber = addslashes($_POST['phonenumber']);
$email = $_POST['email'];
$password = sha1($_POST['password']);
$address = $_POST['address'];

$sqlinsert = "INSERT INTO tbl_users(user_name, user_phonenum, user_email, user_pass, user_address) VALUES ('$name','$phonenumber','$email', '$password', '$address')";
if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    $filename = mysqli_insert_id($conn);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>