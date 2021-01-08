<?php
	session_start();
	require_once '../function.php';


	$loggedin = "";
	if(isset($_SESSION["loggedin"]) == TRUE){
		$loggedin = TRUE;
		$userId = htmlspecialchars($_SESSION["id"]);
	}else{
		$loggedin = FALSE;
	}

	$designName = $designDesc = $designCategories = $designSubCategories = "";
	$designThemes = $designSpecificationName = $designSpecificationDesc = $designPrice = "";
	$errorMessage = "";

	function designFormVerify(){
		if(empty(trim($_POST["categories"]))
			|| empty(trim($_POST["subCategories"]))
			|| empty(trim($_POST["themes"]))
			|| empty(trim($_POST["name"]))
			|| empty(trim($_POST["desc"]))){
			$errorMessage = "Not all fields are entered!";
		}else{
			$errorMessage = "";
		}
		return $errorMessage;
	} 

	if($loggedin){
		$isSupplier = isSupplier($userId);
		if($isSupplier == 0){
			if($_SERVER["REQUEST_METHOD"] == "POST"){
				
			}
		}else{
			die("");//menuju index;
		}
	}else{
		header("");//menuju index;
	}



?>
