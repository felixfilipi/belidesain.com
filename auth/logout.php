<?php
require_once '../function.php';
session_start();
$userId = htmlspecialchars($_SESSION["id"]);
if(userToggleIsOnline($userId, 0) == 0){
	die("ERROR: Please contact administrator if you see this message");
}

generateLastActivity($userId);

$_SESSION = array();

session_destroy();
header("location: ../index.php");
exit;

?>
