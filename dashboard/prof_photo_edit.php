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

	function generateImageName(){
		
	}

	$message = "";
	if(isset($_POST["uploadBtn"]) && $_POST["uploadBtn"] == "Upload"){
		if(isset($_POST["uploadedFile"]) && $_FILES["uploadedFile"]["error"] === UPLOAD_ERR_OK){

			//get file details
			$fileTmpPath = $_FILES["uploadedFile"]["tmp_name"];
			$fileName = $_FILES["uploadedFile"]["name"];
			$fileSize = $_FILES["uploadedFile"]["size"];
			$fileType = $_FILES["uploadedFile"]["type"];
			$fileNameCmps = explode(".", $fileName);
			$fileExtension = strtolower(end($fileNameCmps));

			//sanitize file name
			$
		}
	}

?>
