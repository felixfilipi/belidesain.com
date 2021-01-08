<?php 
	session_start();
	require_once '../function.php';

	$loggedin = "";
	if(isset($_SESSION["loggedin"]) == TRUE ){
		$loggedin = TRUE;
		$userId = htmlspecialchars($_SESSION["id"]);
	}else{
		$loggedin = FALSE;
	}

	function userNameChk($userName){
		if(empty($userName)){
			return "empty";
		}else{
			return $userName;
		}
	}

	function userDescChk($userDesc){
		if(empty($userDesc)){
			return "empty";
		}else{
			return $userName;
		}
	}

	function userCompChk($userComp){
		if(empty($userComp)){
			return "empty";
		}else{
			return $userComp;
		}
	}

	function userLocChk($userLoc){
		if(empty($userLoc)){
			return "empty";
		}else{
			return $userLoc;
		}
	}

	function userWebsiteChk($userWebsite){
		if(empty($userWebsite)){
			return "empty";
		}else{
			return $userWebsite;
		}
	}

	function userPhoneNumberChk($userPhoneNumber){
		if(empty($userPhoneNumber)){
			return "empty";
		}else{
			return $userPhoneNumber;
		}
	}

	if($loggedin){
		$userName = $userDesc = $userComp = $userLoc = $userWebsite = $userPhoneNumber = "";
		$error = "";

		$query = "SELECT * FROM UserInfo WHERE userId = ?";

		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("i", $param_id);
			$param_id = $userId;

			if($stmt->execute()){
				$result = $stmt->get_result();

				if($result->num_rows == 1){
					
					$row = $result->fetch_array(MYSQLI_ASSOC);


					$userName = $row["Name"];
					$userDesc = $row["Description"];
					$userComp = $row["Company"];
					$userLoc = $row["Location"];
					$userWebsite = $row["Website"];
					$userPhoneNumber = $row["PhoneNumber"];

					$userName = userNameChk($userName);
					$userDesc = userDescChk($userDesc);
					$userComp = userCompChk($userComp);
					$userLoc = userLocChk($userLoc);
					$userWebsite = userWebsiteChk($userWebsite);
					$userPhoneNumber = userPhoneNumberChk($userPhoneNumber);

					$query = "SELECT PhotoName FROM UserPhoto WHERE userId = ?";
					$stmt = $conn->prepare($query);
					$stmt->bind_param("i", $param_id);
					$param_id = $userId;
					$stmt->execute();
					$result = $stmt->get_result();
					$row = $result->fetch_array(MYSQLI_ASSOC);
					$userPhoto = $row["PhotoName"];

				}
			}else{
				echo $stmt->error;
				echo $conn->error;
				die($fatalError);
			}
		}else{
			echo $stmt->error;
			echo $conn->error;
			die($fatalError);
		}	

	}else{
		header("Location: ../index.php");
	}
?>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<h1>Profile</h1><br>
	<img src="../images/profile_pictures/<?php echo $userPhoto; ?>" alt=""><br>
	<button><a href="./prof_photo_edit.php">Edit Photo</a></button>
	<h3>Name</h3><br>
	<?php echo $userName; ?><br>
	<h3>Description</h3>
	<?php echo $userDesc; ?><br>
	<h3>Company</h3>
	<?php echo $userComp; ?><br>
	<h3>Location</h3>
	<?php echo $userLoc; ?><br>
	<h3>Website</h3>
	<?php echo $userWebsite; ?><br>
	<h3>Phone Number</h3>
	<?php echo $userPhoneNumber; ?><br>
	<button><a href="./edit_info.php">Edit info</a></button>
</body>
</html>
