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
				
		$idShop = $_GET['idShop'];

		$result = mysqli_query($link, "SELECT * FROM foodtable WHERE idShop = '$idShop'");

		if ($result) {
                        global $output;
			while($row=mysqli_fetch_assoc($result)){
			$output[]=$row;

			}	// while

			echo json_encode($output);

		} //if

	} else echo "Welcome GoFood !!";	// if2
   
}	// if1


	mysqli_close($link);
?>