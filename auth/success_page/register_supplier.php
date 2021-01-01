<?php
session_start();
require_once '../../function.php';

$loggedin = "";
if(isset($_SESSION["loggedin"]) == TRUE){
	$loggedin = TRUE;
	$userId = htmlspecialchars($_SESSION["id"]);
}else{
	$loggedin = FALSE;
}

if($loggedin){
	echo "Selamat, anda menjadi supplier! klik <a href='../../index.php'>disini</a> untuk kembali ke menu utama";	
}else{
	header("../../index.php");
}

?>
