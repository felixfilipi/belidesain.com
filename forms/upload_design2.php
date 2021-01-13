<?php
session_start();
require_once '../function.php';

/*
[2] design specification input qty -> updates
 */

$loggedin = "";
if(isset($_SESSION["loggedin"]) == TRUE){
	$loggedin = TRUE;
	$userId = htmlspecialchars($_SESSION["id"]);
}else{
	$loggedin = FALSE;
}

$specInput = "";
$specInput_error = "";

if($loggedin){
	$isSupplier = isSupplier($userId);
	if($isSupplier == 1){
		if($_SERVER["REQUEST_METHOD"] == "POST"){
		
			if(empty(trim($_POST["specInput"]))){
				$specInput_error = "Please enter specification quantity";
			}else if(trim($_POST["specInput"]) > 10){
				$specInput_error = "maximum is 10";
			}else{
				$specInput = trim($_POST["specInput"]);
			}

			if(empty($specInput_error)){
				$query = "INSERT INTO DesignSpesification VALUES (NULL, ?, NULL, NULL)";
				$designId = trim($_GET["id"]);
				for($i = 0; $i < $specInput; $i++){
					if($stmt = $conn->prepare($query)){
						$stmt->bind_param("i", $param_designId);
						$param_designId = $designId;
						if($stmt->execute()){
							echo $stmt->error;
							echo $conn->error;	
						}
					}else{
						echo $stmt->error;
						echo $conn->error;
					}
				}

				header("Location: ./upload_design3.php?id=$designId");
			
			}

		}
	}else{
		header("Location: ../index.php");
	}

}else{
	header("Location: ../index.php");
}

include '../templates/forms/upload_design2.php';
?>
