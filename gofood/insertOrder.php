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
				
		$OrderDateTime = $_GET['OrderDateTime'];
                $idUser = $_GET['idUser'];
                $NameUser = $_GET['NameUser'];
                $idShop = $_GET['idShop'];
                $NameShop = $_GET['NameShop'];
                $Distance = $_GET['Distance'];
                $Transport = $_GET['Transport'];
                $idFood = $_GET['idFood'];
                $NameFood = $_GET['NameFood'];
                $Price = $_GET['Price'];
                $Amount = $_GET['Amount'];
                $Sum = $_GET['Sum'];
                $idRider = $_GET['idRider'];
                $Status = $_GET['Status'];    
							
		$sql = "INSERT INTO `ordertable`(`id`, `OrderDateTime`, `idUser`, `NameUser`, `idShop`, `NameShop`, `Distance`, `Transport`, `idFood`, `NameFood`, `Price`, `Amount`, `Sum`, `idRider`, `Status`) VALUES (Null,'$OrderDateTime', '$idUser', '$NameUser', '$idShop','$NameShop','$Distance','$Transport','$idFood','$NameFood','$Price','$Amount','$Sum','$idRider','$Status')";

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