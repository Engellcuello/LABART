<?php
require_once 'Conexion.php';
class Sexo
{
    private $ID_sexo;
    private $Descripcion_sexo;
    private $Nombre_sexo;
    private $Conexion;

    public function __construct($ID_sexo = null, $Descripcion_sexo = null, $Nombre_sexo = null)
    {
        $this->ID_sexo = $ID_sexo;
        $this->Descripcion_sexo = $Descripcion_sexo;
        $this->Nombre_sexo = $Nombre_sexo;
        $this->Conexion = Conectarse();
    }
    public function agregarSexo($ID_sexo = null, $Descripcion_sexo = null, $Nombre_sexo = null)
    {        
        $this->Conexion = Conectarse();
    
        $sql = "INSERT INTO sexo(ID_sexo, Descripcion_sexo,Nombre_sexo)
                VALUES (?, ?, ?)";
        $stmt = $this->Conexion->prepare($sql);
        $stmt->bind_param("sss", $ID_sexo, $Descripcion_sexo, $Nombre_sexo);
        $stmt->execute();
        $stmt->close();
        $this->Conexion->close();
    }
    public function consultarSexo($ID_sexo)
 	{
        $this->Conexion = Conectarse();

 		$sql="SELECT * FROM sexo WHERE ID_sexo ='$ID_sexo'";
        
 		$resultado=$this->Conexion->query($sql);
 		$this->Conexion->close();
 		return $resultado;	
 	}
    public function consultarSexos()
 	{
        $this->Conexion = Conectarse();

 		$sql="SELECT * FROM sexo";
 		$resultado=$this->Conexion->query($sql);
 		$this->Conexion->close();
 		return $resultado;	
 	}
     public function borrarSexo($ID_sexo,$Nombre_sexo)
    {
        $this->Conexion = Conectarse();

        $sql = "UPDATE sexo SET Nombre_sexo = 'Indefinido' WHERE ID_sexo=?";

        $stmt = $this->Conexion->prepare($sql);
        $stmt->bind_param("s", $ID_sexo);

        $resultado = $stmt->execute();

        $stmt->close();
        $this->Conexion->close();

        return $resultado;
    }
     public function actualizarSexo($ID_sexo, $Descripcion_sexo, $Nombre_sexo)
     {
         $this->Conexion = Conectarse();
 
         $sql = "UPDATE sexo SET Descripcion_sexo=?,Nombre_sexo=? WHERE ID_sexo=?";
 
         $stmt = $this->Conexion->prepare($sql);
         $stmt->bind_param("sss", $Descripcion_sexo, $Nombre_sexo, $ID_sexo);
 
         $resultado = $stmt->execute();
 
         $stmt->close();
         $this->Conexion->close();
 
         return $resultado;
     }
}