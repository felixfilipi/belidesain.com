<?php

	require_once 'vendor/autoload.php';

	$dbhost = 'localhost';
	$dbname = 'beli_desain';
	$dbuser = 'root';
	$dbpass = '1234';
	$appname = 'belidesain.com';
	$fatalError = "ERROR: Please contact Administrator if you see this message!";

//Checks mysqli plugin (for debug only!)	
//if(!function_exists('mysqli_init') && !extension_loaded('mysqli')) {
//echo "Error: mysqli is missing or failed to start";
//}else{
//echo "mysqli founded!";
//}


	$conn = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
	if($conn->connect_error) die($connection->connect_error);

	function createTable($name, $query){
		queryMysql("CREATE TABLE IF NOT EXISTS $name($query)");
		echo "Table '$name' created or already exists. <br>";
	}

	function queryMysql($query){
		global $conn;
		$result = $conn->query($query);
		if(!$result) die($conn->error);
		return $result;
	}

	function destroySession(){
		$_SESSION = array();

		if(session_id() != "" || isset($_COOKIE[session_name()])){
			setcookie(session_name(), '', time()-2592000, '/');
			session_destroy();
		}
	}

	function sanitizeString($var){
		global $conn;
		$var = strip_tags($var);
		$var = htmlentities($var);
		$var = stripslashes($var);
		return $connection->real_escape_string($var);
	}

	function getDateNow(){
		$d = strtotime("now");
		$date = date("Y-m-d h:i:s", $d);
		return $date;
	}

	function generateLastActivity($UserId){
		global $conn;
		$query = "UPDATE User SET LastActivity = ? WHERE UserId = ?";
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("si",$param_lastactivity, $param_id);
			$param_lastactivity = getDateNow();
			$param_id = $UserId;
			if($stmt->execute()){
				return 1;
			}else{
				return 0;
			}
		}else{
			die($fatalError);
		}
		$stmt->close();
		$conn->close();
	}

	function userToggleIsOnline($userId, $isOnline){ // 1 = online, 0 = offline
		global $conn;
		$query = "UPDATE User SET IsOnline = ? WHERE UserId = ?";
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("ii",$param_isonline, $param_id);
			$param_isonline = $isOnline;
			$param_id = $userId;
			if($stmt->execute()){
				return 1;
			}else{
				return 0;
			}
		}
		$stmt->close();
		$conn->close();
	}

	function isSupplier($userId){
		global $conn;
		$query = "SELECT IsSupplier FROM User WHERE UserId = ?";
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("i", $param_id);
			$param_id = $userId;
			if($stmt->execute()){
				$stmt->store_result();
				$stmt->bind_result($isSupplier);
				$stmt->fetch();
				return $isSupplier;
			}else{
				die($fatalError);
			}
		}else{
			die($fatalError);
		}
		$stmt->close();
		$conn->close();
	}

	function isSupplierRequirement($userId){
		global $conn;
		$query = "SELECT Name, PhoneNumber FROM UserInfo WHERE UserId = ?";
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("i", $param_id);
			$param_id = $userId;
			if($stmt->execute()){
				$stmt->store_result();
				$stmt->bind_result($name, $phoneNumber);
				$stmt->fetch();
				if($name == NULL || $phoneNumber == NULL){
					return 0;
				}else{
					return 1;
				}
			}else{
				die($fatalError);
			}
		}else{
			die($fatalError);
		}
		$stmt->close();
		$conn->close();
	}

	function getName($userId){
		global $conn;
		$query = "SELECT Name FROM UserInfo WHERE UserId = ?";
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("i", $param_userId);
			$param_userId = $userId;
			if($stmt->execute()){
				$stmt->store_result();
				$stmt->bind_result($name);
				$stmt->fetch();
				return $name;
			}
		}else{
			die($fatalError);
		}
		$stmt->close();
		$conn->close();
	}

?>
