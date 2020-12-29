<?php
	session_start();
	require_once 'function.php';

	$loggedin = "";
	if(isset($_SESSION["loggedin"]) == TRUE){
		$loggedin = TRUE;
		$userId = htmlspecialchars($_SESSION["id"]);
	}else{
		$loggedin = FALSE;
	}

	if($loggedin){
		$isSupplier = isSupplier($userId);
		if($isSupplier == 0){
			include './templates/headers/user.php';
		}else if($isSupplier == 1){
			include './templates/headers/supplier.php';
		}else{
			die('FATAL ERROR: please contact administrator if you see this message!');
		}
	}else{
		include './templates/headers/guest.php';
	}

?>
