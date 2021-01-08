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

	function generateQuery($userId){
		$isSupplier = isSupplier($userId);
		if($isSupplier == 1){
			$query = "UPDATE UserInfo SET Name = ?, Description = ?, Company = ?, Location = ?, Website = ?, PhoneNumber = ? WHERE UserId = ?";
			return $query;
		}else{
			$query = "UPDATE UserInfo SET Name = ?, Description = ?, PhoneNumber = ? WHERE UserId = ?";
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

			$query = generateQuery($userId);

			if($stmt = $conn->prepare($query)){
				if($isSupplier == 1){
					$stmt->bind_param("ssssssi", 
						$param_userName, 
						$param_userDesc, 
						$param_userComp,
						$param_userLoc,
						$param_userWebsite,
						$param_userPhoneNumber,
						$param_userId);

					$param_userName = $userName;
					$param_userDesc = $userDesc;
					$param_userComp = $userComp;
					$param_userLoc = $userLoc;
					$param_userWebsite = $userWebsite;
					$param_userPhoneNumber = $userPhoneNumber;
					$param_userId = $userId;

				}else{
					$stmt->bind_param("sssi",
						$param_userName,
						$param_userDesc,
						$param_userPhoneNumber,
						$param_userId);

					$param_userName = $userName;
					$param_userDesc = $userDesc;
					$param_userPhoneNumber = $userPhoneNumber;
					$param_userId = $userId;
				}

				if($stmt->execute()){
					$success = "Edit Success";
					header("Location: ./profile.php");
				}else{
					$stmt->error;
					die($fatalError);
				}

			}else{
				$stmt->error;
				die($fatalError);
			}

		}
/*		else{ // POST METHOD
			echo "here";
			echo $conn->error;
			die($fatalError);
		} */
	include '../templates/updates/user_edit.php';
	}else{
		header("Location: ../index.php");
	}
?>
