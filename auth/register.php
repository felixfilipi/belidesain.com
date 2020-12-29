<?php
require_once '../function.php';

$email = $password = $confirm_password = "";
$email_err = $password_err = $confirm_password_err = "";

if($_SERVER["REQUEST_METHOD"] == "POST"){

	//validate inputted email -->

	if(empty(trim($_POST["email"]))){
		$email_err = "Please enter an email!";
	}else if(!filter_var(trim($_POST["email"]), FILTER_VALIDATE_EMAIL)){
		$email_err = "Invalid email format!";
	}else{
		$query = "SELECT UserId FROM User WHERE Email = ?";

		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("s", $param_email);

			$param_email = trim($_POST["email"]);

			if($stmt->execute()){

				$stmt->store_result();
				if($stmt->num_rows == 1){
					$email_err = "This email is already taken.";	
				}else{
					$email = trim($_POST["email"]);
				}
			}else{
				die("ERROR: Please contact administrator if you see this error!");
			}
			$stmt->close();
		}
	}

	//validate password ->

	if(empty(trim($_POST["password"]))){
		$password_err = "Please enter a password!";
	}else if(strlen(trim($_POST["password"])) < 6){
		$password_err = "Password must have atleast 6 characters.";
	}else{
		$password = trim($_POST["password"]);
	}

	//validate confirmed password ->

	if(empty(trim($_POST["confirm_password"]))){
		$confirm_password_err = "Please confirm password.";
	}else{
		$confirm_password = trim($_POST["confirm_password"]);
		if(empty($password_err) && ($password != $confirm_password)){
			$confirm_password_err = "Password did not match.";
		}
	}

	//querying to database

	if(empty($username_err) && empty($password_err) && empty($confirm_password_err)){
		$query = "INSERT INTO User VALUES (NULL, ?, ?, ?, ?, ?, ?)";

		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("sssiii", $param_email, $param_password, $param_lastactivity, $param_isonline, $param_issupplier, $param_isadmin);

			$param_email = $email;
			$param_password = password_hash($password, PASSWORD_DEFAULT);
			$param_lastactivity = strval(getDateNow());
			$param_isonline = 0;
			$param_issupplier = 0;
			$param_isadmin = 0;

			if($stmt->execute()){
				$last_id = $conn->insert_id;
				$query = "INSERT INTO UserInfo VALUES (?, NULL, NULL, NULL, NULL, NULL, NULL)";
				$stmt = $conn->prepare($query);
				$stmt->bind_param("i", $param_id);
				$param_id = $last_id;
				$stmt->execute();

				header("location: ./register_success.php");
			}else{
				echo $stmt->error;
				echo "ERROR: please contact administrator if you see this message!";
			}

			$stmt->close();
		}
	}

	$conn->close();
}

include '../templates/auth/register.php';

?>
