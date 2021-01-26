<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<h1>Input spesification name and desc</h1>
<?php
	$phpAction = htmlspecialchars($_SERVER["PHP_SELF"]) . "?id=" . $_GET["id"];
	
	echo "<form action='".  $phpAction . "'></form>";
	echo "<div class='form-group'>";

	for($i = $spesificationId; $i <= ($spesificationId+$nRows); $i++){
		echo "<div class='form-group ". (!empty($specInput_error)) ? 'has-error' : ''; ."'>";
		echo "<label>Input spesification ". $i ." Name</label>";
		echo "<input type='text' id='spesificationName' name='specInput' class='form-control'>";
		echo "<span class='help-block'>" + $specInput_error;
		echo "<input type='hidden' name='id' value='". $spesificationId . $id ."'>";
	}

	echo "<input type='submit' class='btn btn-primary' value='Submit'>";
	echo "<input type='reset' class='btn btn-primary' value='Reset'>";
	echo "</form>";

?>
</body>
</html>
