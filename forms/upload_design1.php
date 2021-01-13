<?php
	session_start();
	require_once '../function.php';

/*
steps:
[1] categories->subCategories->name->desc->theme->price
[2] design specification
[3] design upload previews
[4] design upload raw file
*/

	$loggedin = "";
	if(isset($_SESSION["loggedin"]) == TRUE){
		$loggedin = TRUE;
		$userId = htmlspecialchars($_SESSION["id"]);
	}else{
		$loggedin = FALSE;
	}

	$designName = $designDesc = $designCategories = $designSubCategories = "";
	$designThemes = $designSpecificationName = $designSpecificationDesc = $designPrice = "";
	$errorMessage = "";
	$designPrice_err = "";

	function designFormVerify(){
		if(empty(trim($_POST["categories"]))
			|| empty(trim($_POST["subCategories"]))
			|| empty(trim($_POST["themes"]))
			|| empty(trim($_POST["name"]))
			|| empty(trim($_POST["desc"]))){
			$errorMessage = "Not all fields are entered!";
		}else{
			$errorMessage = "";
		}
		return $errorMessage;
	}

	function searchCategory($categoryName){
		global $conn;
		$query = "SELECT * FROM DesignCategories WHERE CategoryName = ?";
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("s",$param_catName);
			$param_catName = $categoryName;

			if($stmt->execute()){
				$result = $stmt->get_result();

				if($result->num_rows == 1){
					$row = $result->fetch_array(MYSQLI_ASSOC);
					$categoryId = $row["CategoryId"];

					return $categoryId;
				}else{
					$message = "ERROR: Query not found";
				}
			}else{
				$stmt->error;
				$conn->error;
				die($fatalError);
			}
		}else{
			$stmt->error;
			$conn->error;
			die($fatalError);
		}
		$stmt->close();
	}

	function searchSubCategory($subCategoryName){
		global $conn;
		$query = "SELECT * FROM DesignSubCategories WHERE SubCategoryName = ?";
		echo $subCategoryName; 
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("s",$param_subCategoryName);
			$param_subCategoryName = $subCategoryName;

			if($stmt->execute()){
				$result = $stmt->get_result();
				if($result->num_rows == 1){
					$row = $result->fetch_array(MYSQLI_ASSOC);
					$subCategoryId = $row["SubCategoryId"];
					return $subCategoryId;
				}
			}

		}else{
			echo $stmt->error;
			echo $conn->error;
		}
		$stmt->close();
	}

	function insertDesignDetails($designId, $designName, $designDesc, $designPrice){
		global $conn;
		$query = "INSERT INTO DesignDetails VALUES (?, ?, ?, ?, NULL)";
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("issi", $param_designId, $param_designName, $param_designDesc, $param_designPrice);
			$param_designId = $designId;
			$param_designName = $designName;
			$param_designDesc = $designDesc;
			$param_designPrice = $designPrice;

			if($stmt->execute()){
				return 1;
			}else{
				return 0;
				echo $stmt->error;
				echo $conn->error;
			}
		}else{
			die($fatalError);
		}
	$stmt->close;	
	}

	function insertDesignDetailsDate($designId){
		global $conn;
		$query = "UPDATE DesignDetails SET DesignDateCreated = ? WHERE DesignId = ?";
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("si", $param_dateCreated, $param_designId);
			$param_designId = $designId;
			$param_dateCreated = getDateNow();
			echo $param_dateCreated;
			$nowDate = getDateNow();

			if($stmt->execute()){
				return 1;
			}else{
				return 0;
			}
		}else{
			die($fatalError);
		}
		$stmt->close();
	}

	if($loggedin){
		$isSupplier = isSupplier($userId);
		if($isSupplier == 1){
			if($_SERVER["REQUEST_METHOD"] == "POST"){

				designFormVerify();
				$categoryName = trim($_POST["categories"]);
				$subCategoryName = trim($_POST["subCategories"]);
				$theme = trim($_POST["themes"]);
				$designName = trim($_POST["name"]);
				$designDesc = trim($_POST["desc"]);
				$designPrice = trim($_POST["price"]);
				$categoryId = searchCategory($categoryName);
				$subCategoryId = searchSubCategory($subCategoryName);

				echo $theme;
				echo $subCategoryId;

				echo $errorMessage;
				if(empty($errorMessage)){
					//insert theme
					$query = "INSERT INTO DesignTheme VALUES (NULL, ?, ?)";
					if($stmt = $conn->prepare($query)){
						$stmt->bind_param("is", $param_subCategoryId, $param_designTheme);
						$param_subCategoryId = $subCategoryId;
						$param_designTheme = $theme;

						if($stmt->execute()){
							$last_id_theme = $conn->insert_id;
						}else{
							echo $stmt->error;
							echo $conn->error;
						}
					}

					echo $categoryId;

					$query = "INSERT INTO DesignHeader VALUES (NULL, ?, ? ,? ,?, ?)";
					if($stmt = $conn->prepare($query)){
						echo "SINI COK";
						$stmt->bind_param("iiiii", $param_Category, $param_subCategory, $param_theme, $param_userId, $param_isSold);
						$param_Category = $categoryId;
						$param_subCategory = $subCategoryId;
						$param_theme = $last_id_theme;
						$param_userId = $userId;
						$param_isSold = 0;

						if($stmt->execute()){
							$lastDesignId = $conn->insert_id;
							if(insertDesignDetails($lastDesignId, $designName, $designDesc, $designPrice) && insertDesignDetailsDate($lastDesignId)){
								header("Location: ./upload_design2.php?id=$lastDesignId");
							}else{
								die($fatalError);
							}
						}else{
							echo $stmt->error;
							echo $conn->error;
						}

					}else{
						die($fatalError);
						$conn->error;
						$stmt->error;
					}
				}
			}
		}else{
			header("Location: ../index.php");//menuju index;
		}
	}else{
		header("Location: ../index.php");//menuju index;
	}

include '../templates/forms/upload_design1.php';

?>
