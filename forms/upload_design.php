<?php
	session_start();
	require_once '../function.php';

/*
steps:
[1] categories->subCategories->name->desc->theme
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
		$query = "SELECT * FROM DesignCategories WHERE CategoryName = ?";
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("s",$param_CatName);
			$param_CatName = $categoryName;

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
	}

	function searchSubCategory($designSubCategoryName){
		$query = "SELECT * FROM DesignSubCategories WHERE DesignSubCategoryName = ?";
		if($stmt = $conn->prepare($query)){
			$stmt->bind_param("s",$param_designSubCategoryName);
			$param_designSubCategoryName = $designSubCategoryName;

			if($stmt->execute()){
				$result = $stmt->get_result();
				if($result->num_rows == 1){
					$row = $stmt->fetch_array(MYSQLI_ASSOC);
					$designSubCategoryId = $row["designSubCategories"];
					return $designSubCategoryId;
				}
			}

		}else{
			$stmt->error;
			$conn->error;
			die($fatalError);
		}
	}

	if($loggedin){
		$isSupplier = isSupplier($userId);
		if($isSupplier == 0){
			if($_SERVER["REQUEST_METHOD"] == "POST"){

				designFormVerify();
				$categoryName = trim($_POST["category"]);
				$subCategoryName = trim($_POST["subCategory"]);
				$theme = trim($_POST["theme"]);
				$designName = trim($_POST["name"]);
				$designDesc = trim($_POST["desc"]);
				$categoryId = searchCategory($categoryName);
				$subCategoryId = searchSubCategory($subCategoryName);

				if(empty($errorMessage)){
					//insert theme
					$query = "INSERT INTO DesignTheme VALUES (NULL, ?)";
					if($stmt = $conn->prepare($query)){
							$stmt->bind_param("s", $param_designName);
							$param_designName = $designName;

							if($stmt->execute()){
								$last_id_theme = $conn->insert_id;
							}else{
								die($fatalError);
							}
					}

					$query = "INSERT INTO DesignHeader VALUES (NULL, ?, ? ,? ,?, ?)";
					if($stmt = $conn->prepare($query)){
						$stmt->bind_param("iiiii", $param_Category, $param_subCategory, $param_theme, $param_userId);
						$param_category = $categoryId;
						$param_subCategory = $subCategoryId;
						$param_theme = $last_id_theme;
						$param_userId = $userId;

						if($stmt->execute()){
							header("Location: ./upload_success");
						}

					}
				}
			}
		}else{
			die("");//menuju index;
		}
	}else{
		header("");//menuju index;
	}



?>
