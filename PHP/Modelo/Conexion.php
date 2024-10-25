<?php
function Conectarse(){
	$Conexion =  mysqli_connect("localhost","root","","labart");
	return $Conexion;
}
?>