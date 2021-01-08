<?php
	session_start();
	require_once '../function.php';

	$loggedin = "";
	if(isset($_SESSION["loggedin"]) == TRUE){
		$loggedin = TRUE;
		$userId = htmlspecialchars($_SESSION["id"]);
		$isSupplier = isSupplier($userId);
	}else{
		$loggedin = FALSE;
	}

	function generateQuery(){
		if($isSupplier == 1){
			$query = "UPDATE UserInfo SET Name = ?, Description = ?, Company = ?, Location = ?, Website = ?, PhoneNumber = ? WHERE UserId = ?";
			return $query;
		}else{
			$query = "UPDATE UserInfo SET Name = ?, Description = ?, PhoneNumber = ?";
			return $query;
		}
	}

	if($loggedin == TRUE){
		$userName = $userDesc = $userComp = $userLoc = "";
		$userWebsite = $userPhoneNumber = "";
		$userName_err = $userDesc_err = $userComp_err = $userLoc_err = "";
		$userWebsite_err = $userPhoneNumber_err = "";

		if($_SERVER["REQUEST_METHOD"] == "POST"){

			$userName = trim($_POST["userName"]);
			$userDesc = trim($_POST["userDesc"]);
			$userPhoneNumber = trim($_POST["userPhoneNumber"]);

			if($isSupplier == 1){
				$userComp = trim($_POST["userComp"]);
				$userLoc = trim($_POST["userLoc"]);
				$userWebsite = trim($_POST["userWebsite"]);
				$userPhoneNumber = trim($_POST["userPhoneNumber"]);
			}

			$query = generateQuery();
		}else{ // POST METHOD

		}

	}else{

	}

?>
