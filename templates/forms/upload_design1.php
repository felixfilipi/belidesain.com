<?php 

function getCategories(){
	global $conn;
	$query = "SELECT CategoryId, CategoryName FROM DesignCategories";
	if($stmt = $conn->prepare($query)){
		$stmt->execute();
		$result = $stmt->get_result();	
		
		while($row = $result->fetch_assoc()){
			$rows[] = $row["CategoryName"];
		};

		return $rows;
	}else{
		$stmt->error;
		$conn->error;
	}
	$stmt->close();
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title></title>
<script src="jquery-3.5.1.min.js"></script>
</head>
<body>
	<div>
	<h1>TEst</h1>
  <?php getCategories(); ?>
		<form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
			<div class="form-group <?php echo (!empty($errorMessage)) ? 'has-error' : ''; ?>">
				<label for="categories">Select a categories:</label>
					<select id="categories" name="categories" onChange="changeSubCat(this.value);">
						<option disabled selected value="">Please select</option>

						<?php
							$rows = getCategories();
							foreach($rows as $i){
								echo "<option value='". $i ."'>". $i ."</option>";
							}
							echo $i; 
?>

					</select>
					<span class="help-block"><?php echo $errorMessage; ?></span>
			</div>
			<div class="form-group <?php (!empty($errorMessage)) ? 'has-error' : ''; ?>">
				<label>Select a sub-categories:</label>
					<select id="subCategories" name="subCategories">
						<option value="" disabled selected>please choose from above</option>
					</select>
				<span class="help-block"><?php echo $errorMessage; ?></span>
			</div>
			<div class="form-group <?php (!empty($errorMessage)) ? 'has-error' : ''; ?>">
				<label>Input Design Name</label>
				<input type="text" id="name" name="name" class="form-control" value="<?php //echo $name; ?>">
				<span class="help-block"><?php echo $errorMessage; ?></span>
			</div>
			<div class="form-group <?php (!empty($errorMessage)) ? 'has-error' : ''; ?>">
				<label>Input design description</label>
				<input type="text" id="desc" name="desc" class="form-control" value="<?php //echo $desc; ?>">
				<span class="help-block"><?php echo $errorMessage; ?></span>
			</div>
			<div class="form-group <?php (!empty($errorMessage)) ? 'has-error' : ''; ?>">
				<label>Input design theme</label>
				<input type="text" id="themes" name="themes" class="form-control" value="<?php //echo $themes; ?>">
				<span class="help-block"><?php echo $errorMessage; ?></span>
			</div>
			<div class="form-group <?php (!empty($errorMessage)) ? 'has-error' : ''; ?>">
				<label>Input design price</label>
				<input type="text" id="price" name="price" class="form-control" value="<?php //echo $price; ?>">
				<span class="help-block"><?php echo $errorMessage; ?></span>
			</div>
			<div class="form-group">
				<input type="submit" class="btn btn-primary" value="Submit">
				<input type="reset" class="btn btn-default" value="Reset">
			</div>
		</form>
	</div>
</body>
</html>
<script>
var subCategories = {
'Desain Interior': ["Ruang Tamu", "Dapur", "Kamar Tidur", "Ruang Bersantai"],
'Desain Komunikasi Visual': ["Poster", "Flyer", "Card", "Brochure", "Logo"],
'Desain Furnitur': ["Kursi", "Meja", "Lemari"],
'Desain Busana': ["Batik", "Kasual", "Resmi", "Pesta"],
'Desain Website': ["Online Shop", "Portofolio", "Photography", "Entertainment", "Food", "Event"]
}

	function changeSubCat(value) {
		if (value.length == 0) document.getElementById("categories").innerHTML = "<option></option>";
		else {
			var subCatOptions = "";
			for (subCategoryId in subCategories[value]) {
				subCatOptions += "<option value='" + subCategories[value][subCategoryId] + "'>" + subCategories[value][subCategoryId] + "</option>";
			}
			document.getElementById("subCategories").innerHTML = subCatOptions;
		}
	}
</script>
