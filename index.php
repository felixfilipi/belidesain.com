<?php
	session_start();
	require_once 'function.php';

	if(isset($_SESSION['Email'])){
		$email = $_SESSION['Email'];
		$loggedin = TRUE;
		$emailstr = "$email";
		$useridstr = getUserId($email);
	}else{
		$loggedin = FALSE;
	}

	if($loggedin){
		$isSupplier = isSupplier($useridstr);
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
