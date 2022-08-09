<?php
$link = mysqli_connect('localhost','root','admin','gofood');

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET['isAdd'])) {
	if ($_GET['isAdd'] == 'true') {
				
		$Name = $_GET['Name'];
		$Users = $_GET['Users'];
		$Password = $_GET['Password'];
		$ChooseType = $_GET['ChooseType'];
							
		$sql = "INSERT INTO `usertable`(`id`, `ChooseType`, `Name`, `Users`, `Password`, `NameShop`, `Address`, `Phone`, `UrlPicture`, `Token`) VALUES (Null,'$ChooseType','$Name','$Users','$Password','','','','','')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Go Food";
   
}
	mysqli_close($link);
?>