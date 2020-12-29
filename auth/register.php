<?php
require_once '../../function.php';

$email = $password = $confirm_password = "";
$email_err = $password_err = $confirm_password_err = "";

if($_SERVER["REQUEST_METHOD"] == "POST"){

	if(empty(trim($_POST["email"]))){ // validate email
		$email_err = "Please enter an email!";
	}else{
		$query = "SELECT UserId FROM User WHERE Email = ?";

		if($stmt = mysqli_prepare($link, $query)){
			mysqli_stmt_bind_param($stmt, "s", $param_username);

			$param_username = trim($_POST["email"]);

			if(mysqli_stmt_execute($stmt)){

			}
		}
	}
}
?>
