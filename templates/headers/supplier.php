<?php
$namestr = getName($userId);
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title></title>
</head>
<body>
<h1>hi, <?php echo $namestr; ?></h1>
<ul>
  <li>be a designer <a href="../auth/register_designer.php">designer</a></li>
  <li><a href="../../dashboard/profile.php">Profile</a></li>
  <li>Categories</li>
  <li><a href="../forms/upload_design.php">Upload Design</a></li>
  <li><a href="../forms/make_event.php">Make Event</a></li>
</ul>
</body>
</html>
