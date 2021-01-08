<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<div>
		<p>please fill this form to edit profile</p>
		<form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" method="post">
			<div class="form-group <?php echo (!empty($userName_err)) ? 'has-error' : ''; ?>">
				<label>Full Name</label>
				<input type="text" name="userName" class="form-control" value="<?php echo $userName; ?>">
				<span class="help-block"><?php echo $userName_err; ?></span>
			</div>
			<div class="form-group <?php echo (!empty($userDesc_err)) ? 'has-error' : ''; ?>">
				<label>Description</label>
				<input type="text" name="userDesc" class="form-control" value="<?php echo $userDesc; ?>">
				<span class="help-block"><?php echo $userDesc_err; ?></span>
			</div>
			<div class="form-group <?php echo (!empty($userPhoneNumber_err)) ? 'has-error' : ''; ?>">
				<label>Phone Number</label>
				<input type="text" name="userPhoneNumber" class="form-control" value="<?php echo $userPhoneNumber; ?>">
				<span class="help-block"><?php echo $userPhoneNumber_err; ?></span>
			</div>
			<?php
			if($isSupplier == 1){
			?>
				<div class="form-group" <?php echo (!empty($userComp_err)) ? 'has-error' : ''; ?>>
					<label>Company</label>
					<input type="text" name="userComp" class="form-control" value="<?php echo $userComp; ?>">
					<span class="help-block"><?php echo $userComp_err; ?></span>
				</div>
				<div class="form-group <?php echo (!empty($userLoc_err)) ? 'has-error' : ''; ?>">
					<label>Location</label>
					<input type="text" name="userLoc" class="form-control" value="<?php echo $userLoc; ?>">
					<span class="help-block"><?php echo $userLoc_err; ?></span>
				</div>
				<div class="form-group <?php echo (!empty($userWebsite_err)) ? 'has-error' : ''; ?>">
					<label>Website</label>
					<input type="text" name="userWebsite" class="form-control" value="<?php echo $userWebsite; ?>">
					<span class="help-block"><?php echo $userWebsite_err; ?></span>
				</div>
			<?php
			}
			?>
			<div class="form-group">
				<input type="submit" class="btn btn-primary" value="Submit">
				<input type="reset" class="btn btn-default" value="Reset">
			</div>
		</form>
	</div>
</body>
</html>
