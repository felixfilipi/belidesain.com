<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
Setting up database
<?php
	require_once 'function.php';

	createTable('User',
		'UserId INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  	Email VARCHAR(32),
  	Password VARCHAR(32),
  	LastActivity DATE,
  	IsOnline BOOL,
		IsSupplier BOOL');

	createTable('UserInfo',
		'UserId INT(32) NOT NULL,
  	Name VARCHAR(100),
  	Description TEXT,
  	Company VARCHAR(48),
  	Location VARCHAR(48),
  	Website VARCHAR(64),
  	PhoneNumber VARCHAR(16),
  	FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE');

	createTable('UserPhoto', 
		'CREATE TABLE UserPhoto(
  	PhotoId  INT(32) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  	UserId  INT(32) NOT NULL,
  	PhotoName VARCHAR(48),
  	FOREIGN KEY (UserId) REFERENCES User (UserId) ON DELETE CASCADE ON UPDATE CASCADE');

	createTable()
?>
<br>
...done!
</body>
</html>
