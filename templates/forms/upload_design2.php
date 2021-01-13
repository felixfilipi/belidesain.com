<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<h1>Input specification quantity</h1>
<?php
$phpAction = htmlspecialchars($_SERVER["PHP_SELF"]) . "?id=" . $_GET["id"]; 
?>
	<form action="<?php echo $phpAction; ?>" method="post">
		<div class="form-group <?php echo (!empty($specInput_error)) ? 'has-error' : ''; ?>">
			<label>input how many specifications (max 10):</label>
			<input type="text" id="specInput" name="specInput" class="form-control">
			<span class="help-block"><?php echo $specInput_error; ?></span>
			<input type="hidden" name="id" value="<?php echo $designId; ?>">
		</div>
		<div>
			<input type="submit" class="btn btn-primary" value="Submit">
			<input type="reset" class="btn btn-primary" value="Reset">
		</div>
	</form>
</body>
</html>
