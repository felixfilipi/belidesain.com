<?php
/*	Pseudocode :
[1]. Search n-rows where designId = $_GET['id']
[2].	Search spesificationId where DesignId = 74
[3]. for (i=74; i <= spesificationId + n-rows; i++){
					$_GET['id'](){
							
					}
			}

$DesignId = $_GET['id'];
query = "SELECT * FROM DesignSpesification WHERE DesignId = '$DesignId'";
$stmt[DesignSpesification];
$stmt = $row;
while($row){
		
}
 */
session_start();

$ifloggedin = "";
if(isset($_SESSION["loggedin"]) == TRUE){
	$loggedin = TRUE;
	$userId = htmlspecialchars($_SESSION["id"]);
}else{
	$loggedin = FALSE;
}

$designSpec_error = "";

$designId = $_GET["id"];

if($loggedin){

	function getNRows($designId){
		global $conn;
		$query = "SELECT SpesificationId WHERE DesignId = ?";
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("i",$param_designId);
			$param_designId = $designId;
			if($stmt->execute){
				$result = $stmt->get_result();
				return $result->num_rows;	
			}else{
				die($fatalError);
				echo $stmt->error;
				echo $conn->error;
			}

		}else{
			die($fatalError);
			echo $stmt->error;
			echo $conn->error;
		}
	}

	function getSpesificationId($designId){
		global $conn;
		$query = "SELECT SpesificationId FROM DesignSpesification WHERE DesignId = ? LIMIT 1";
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("i", $param_designId);
			$param_designId = $designId;
			if($stmt->execute()){
				$result = $stmt->get_result();
				$row = $result->fetch_array(MYSQLI_ASSOC);
				return $row["SpesificationId"];

			}else{
				die($fatalError);
				$stmt->error;
				$conn->error;
			}

		}else{
			die($fatalError);
			$stmt->error;
			$conn->error;
		}
	}

	$isSupplier = isSupplier($userId);
	if($isSupplier == 1){

		$input_err = '';

		if($_SERVER["REQUEST_METHOD"] == "POST"){
			$nRows = getNRows($designId);
			$spesificationId = getSpesificationId($designId);

			for($i = $spesificationId; $i <= ($spesificationId+$nRows); $i++){
				if(empty(trim($_POST["spesificationName". $i .""]))){
					$input_err = "Not all fields are entered!";
				}else{
					$specificationNameInput = trim($_POST["spesificationName". $i .""]);
				}
			}

			for($i = $spesificationId; $i <= ($spesificationId+$nRows); $i++){
				if(empty(trim($_POST["spesificationDesc". $i .""]))){
					$input_err = "Not all fields are entered";
				}else{
					$spesificationDescInput = trim($_POST["spesificationDesc". $i .""]);
				}
			}
			
			$query = "UPDATE SpesificationName = ?, SpesificationDesc = ? FROM DesignSpesification WHERE SpesificationId = ?";

			for($i = $spesificationId; $i <= ($spesificationId+$nRows); $i++){
				if($stmt = $conn->prepare($query)){
					$stmt->bind_param("ssi", $param_spesificationName, $param_spesificationDesc, $param_spesificationId);

					$param_spesificationName = $spesificationNameInput;
					$param_spesificationDesc = $spesificationDescInput;
					$param_spesificationId = $i;
					if($stmt->execute()){
						echo "Success";
					}else{
						die($fatalError);
						$stmt->error;
						$conn->error;
					}
				}else{
					die($fatalError);
					$stmt->error;
					$conn->error;
				}
			}
		}


	}		
	
	header("Location: ./upload_design4.php");

}else{
	header("Location: ../index.php");
}

?>
