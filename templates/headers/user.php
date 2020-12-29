<?php
$emailstr = htmlspecialchars($_SESSION["email"]);
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title></title>
</head>
<body>
<h1>hi, <?php echo $emailstr; ?></h1>
<ul>
  <li>be a <a href="../auth/register_supplier.php">supplier</a></li>
  <li><a href="../../dashboard/profile.php">Profile</a></li>
  <li>Categories</li>
</ul>
<h2><a href="../auth/logout.php">logout</a></h2>
</body>
</html>
