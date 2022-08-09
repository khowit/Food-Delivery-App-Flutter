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
			
		$id = $_GET['id'];		
		$NameShop = $_GET['NameShop'];
		$Address = $_GET['Address'];
                $Phone = $_GET['Phone'];
                $UrlPicture = $_GET['UrlPicture'];		
		
							
		$sql = "UPDATE `usertable` SET `NameShop` = '$NameShop', `Address` = '$Address', `Phone` = '$Phone', `UrlPicture` = '$UrlPicture' WHERE id = '$id'";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome GoFood !!!";
   
}

	mysqli_close($link);
?>