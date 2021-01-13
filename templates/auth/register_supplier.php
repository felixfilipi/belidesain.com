<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Register Supplier</title>
	<style type="text/css">
		body{
			font: 14px sans-serif;
		}
		.wrapper{
			width: 350px;
			padding: 20px;
		}
	</style>
</head>
<body>
	<div>
		<p>please fill this form to upgrade to supplier account</p>
		<form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
			<div class="form-group <?php echo (!empty($name_err)) ? 'has-error' : ''; ?>">
				<label>Name</label>
				<input type="text" id="name" name="name" class="form-control" value="<?php echo $name; ?>">
				<span class="help-block"><?php echo $name_err; ?></span>
			</div>
			<div class="form-group <?php echo (!empty($phoneNumber_err)) ? 'has-error' : ''; ?>">
				<label>Phone Number</label>
				<input type="text" id="phoneNumber" name="phoneNumber" class="form-control" value="<?php echo $phoneNumber; ?>">
				<span class="help-block"><?php echo $phoneNumber_err; ?></span>
			</div>
			<div class="form-group">
				<input type="submit" class="btn btn-primary" value="Submit">
				<input type="reset" class="btn btn-default" value="Reset">
			</div>
		</form>
	</div>
</body>
</html>
