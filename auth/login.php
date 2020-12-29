<?php
session_start();

if(isset($_SESSION["loggedin"]) && $_SESSION["loggedin"] === true){
	header("location: ../templates/headers/user.php");
	exit;
}

require_once 'function.php';

$email = $password = "";
$email_err = $password_err = "";

if($_SERVER["REQUEST_METHOD"] == "POST"){

	if(empty(trim($_POST["email"]))){
		$email_err = "Please enter email!";
	}else{
		$email = trim($_POST["email"]);
	}

	if(empty(trim($_POST["password"]))){
		$password_err = "Please enter password!";
	}else{
		$password = trim($_POST["password"]);
	}

	if(empty($email_err) && empty($password_err)){
		
		$query = "SELECT UserId, Email, Password FROM User WHERE Email = ?";

		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("s", $param_email);
			$param_email = $email;

			if($stmt->execute()){
				$stmt->store_result();

				if($stmt->num_rows == 1){
					$stmt->bind_result($id, $email, $hashed_password);
					if($stmt->fetch()){
						if(password_verify($password, $hashed_password)){
							session_start();
							$_SESSION["loggedin"] = true;
							$_SESSION["id"] = $id;
							$_SESSION["username"] = $email;

							header("location: ../index.php");
						}else{
							$passoword_err = "Password invalid for this email";
						}
					}
				}else{
					$email_err = "Account not found";
				}
			}else{
				die("ERROR: please contact administrator if you see this message!");
			}
			$stmt->close();
		}
	}
	$conn->close();
}

include "../templates/auth/login.php";
?>
