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

	$message = "";
	if(isset($_POST["uploadBtn"]) && $_POST["uploadBtn"] == "Upload"){
		if(isset($_FILES["uploadedFile"]) && $_FILES["uploadedFile"]["error"] === UPLOAD_ERR_OK){

			//get file details
			$fileTmpPath = $_FILES["uploadedFile"]["tmp_name"];
			$fileName = $_FILES["uploadedFile"]["name"];
			$fileSize = $_FILES["uploadedFile"]["size"];
			$fileType = $_FILES["uploadedFile"]["type"];
			$fileNameCmps = explode(".", $fileName);
			$fileExtension = strtolower(end($fileNameCmps));

			//change file name
			//$generateFileName = generateRandomString();

			//sanitize file name
			$newFileName = md5(time() . $fileName) . '.' . $fileExtension;

			//check file extensions
			$allowedFileExtensions = array('jpg', 'jpeg', 'png');

			if(in_array($fileExtension, $allowedFileExtensions)){
				//directory target
				$uploadFileDir = '../images/profile_pictures/';
				$dest_path = $uploadFileDir . $newFileName;

				if(move_uploaded_file($fileTmpPath, $dest_path)){

					$query = "UPDATE UserPhoto SET PhotoName = ? WHERE UserId = ?";

					if($stmt = $conn->prepare($query)){
						$stmt->bind_param("si", $param_PhotoName, $param_UserId);

						$param_PhotoName = $newFileName;
						$param_UserId = $userId;

						if($stmt->execute()){
							$message = "File is successfully uploaded.";
							header("Location: ./profile.php");

						}else{
							$stmt->error;
							$conn->error;
							echo "here";
							die($fatalError);
						}
					}

				}else{
					echo "HEere";
					die($fatalError);
				}

			}else{
				$message = "Upload failed, Allowed file types: " . implode(',', $allowedFileExtensions);
			}
		}else{
			$message = "There is some error uploading file. Please check the following error<br>";
			$message .= "Error:" . $_FILES["uploadedFile"]["error"];
		}
	}
	$_SESSION["message"] = $message;
	include '../templates/updates/user_photo.php';
?>
