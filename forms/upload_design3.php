<?php
session_start();

$ifloggedin = "";
if(isset($_SESSION["loggedin"]) == TRUE){
	$loggedin = TRUE;
	$userId = htmlspecialchars($_SESSION["id"]);
}else{
	$loggedin = FALSE;
}

$designSpec_error = "";

$designId = $_GET["id"];

if($loggedin){
	$isSupplier = isSupplier($userId);
	if($isSupplier == 1){
		if($_SERVER["REQUEST_METHOD"] == "POST"){

		}
	}else{

	}	

}else{
	header("Location: ../index.php");
}

?>
