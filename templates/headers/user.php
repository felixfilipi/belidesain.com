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
<h2><a href="../auth/logout.php">logout</a></h2>
</body>
</html>
