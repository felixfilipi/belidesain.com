<?php
	session_start();
	require_once '../function.php';

	$name = $phoneNumber = "";
	$name_err = $phoneNumber_err = "";		

	function validateName(){
		if(empty(trim($_POST["name"]))){
			$name_err = "Please enter your name!";
		}else{
			$name_err = "";
		}
		return $name_err;
	}

	function validatePhoneNumber(){
		if(empty(trim($_POST["phoneNumber"]))){
			$phoneNumber_err = "Please enter your phone number!";
		}else if(strlen(trim($_POST["phoneNumber"])) < 12){
			$phoneNumber_err = "Phone number must have atleast 12 characters!";
		}else{
			$phoneNumber_err = "";
		}
		return $phoneNumber_err;
	}

	function isSupplierToggle($userId, $param){
		global $conn;
		$query = "UPDATE User SET IsSupplier = ? WHERE UserId = ?";
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("ii", $param_isSupplier, $param_userId);
			$param_isSupplier = $param;
			$param_userId = $userId;
			if($stmt->execute()){
				return 1;
			}else{
				die($fatalError);
			}
		}else{
			die($fatalError);
		}
		$stmt->close();
		$conn->close();
	}

	$loggedin = "";
	if(isset($_SESSION["loggedin"]) == TRUE){
		$loggedin = TRUE;
		$userId = htmlspecialchars($_SESSION["id"]);
	}else{
		$loggedin = FALSE;
	}

	if($loggedin){
		if(isSupplierRequirement($userId)){
			header("./success_page/register_supplier.php");
		}else{
			if($_SERVER["REQUEST_METHOD"] == "POST"){
				$name_err = validateName();
				$phoneNumber_err = validatePhoneNumber();

				if(empty($name_err) && empty($phoneNumber_err)){
					$name = trim($_POST["name"]);
					$phoneNumber = trim($_POST["phoneNumber"]);
					$query = "UPDATE UserInfo SET Name = ?, PhoneNumber = ? WHERE UserId = ?";

					if($stmt = $conn->prepare($query)){
						$stmt->bind_param("ssi", $param_name, $param_phoneNumber, $param_userId);

						$param_name = $name;
						$param_phoneNumber = $phoneNumber;
						$param_userId = $userId;

						if($stmt->execute()){
							if(isSupplierToggle($userId, 1)){
								header("location: ./success_page/register_supplier.php");
							}else{
								die($fatalError);
							}
						}//end if for executing prepared statements
					}// end if for preparing query
					$stmt->close();
				}//end if for checking empty var
			}//end if for request POST method
			$conn->close();
		}//end if for checking supplier requirement
		
		include '../templates/auth/register_supplier.php';
	}else{
		header("../index.php");
	}
?>
