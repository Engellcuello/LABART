<?php
require_once 'Conexion.php';
class Estado
{
    private $ID_estado;
    private $Nombre_estado;
    private $Descripcion_estado;
    private $Conexion;

    public function __construct($ID_estado = null, $Nombre_estado = null, $Descripcion_estado = null)
    {
        $this->ID_estado = $ID_estado;
        $this->Nombre_estado = $Nombre_estado;
        $this->Descripcion_estado = $Descripcion_estado;
        $this->Conexion = Conectarse();
    }
    public function agregarEstado($ID_estado = null, $Nombre_estado = null, $Descripcion_estado = null)
    {        
        $this->Conexion = Conectarse();
        
        $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
        $this->Conexion->query($sql_key);
    
        $sql = "INSERT INTO estado(ID_estado, Nombre_estado,Descripcion_estado)
                VALUES (?, (AES_ENCRYPT(?, @encryption_key)), (AES_ENCRYPT(?, @encryption_key)))";
        $stmt = $this->Conexion->prepare($sql);
        $stmt->bind_param("sss", $ID_estado, $Nombre_estado, $Descripcion_estado);
        $stmt->execute();
        $stmt->close();
        $this->Conexion->close();
    }
    public function consultarEstado($ID_estado)
 	{
        $this->Conexion = Conectarse();

 		$sql="SELECT * FROM estado WHERE ID_estado ='$ID_estado'";
        
 		$resultado=$this->Conexion->query($sql);
 		$this->Conexion->close();
 		return $resultado;	
 	}
    public function consultarEstados()
 	{
        $this->Conexion = Conectarse();
        $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
        $this->Conexion->query($sql_key);

        $sql="SELECT 
            ID_estado, 
            AES_DECRYPT((Nombre_estado), @encryption_key) AS Nombre_estado,
            AES_DECRYPT((Descripcion_estado), @encryption_key) AS Descripcion_estado
        FROM estado";
 		$resultado=$this->Conexion->query($sql);
 		$this->Conexion->close();
 		return $resultado;	
 	}
     public function borrarEstado($ID_estado)
    {
        $this->Conexion = Conectarse();

        $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
        $this->Conexion->query($sql_key);

        $nuevoNombreEstado = 'Inexistente';
        $nombreEstadoCifrado = "AES_ENCRYPT(?, @encryption_key)";

        $sql = "UPDATE estado SET Nombre_estado = $nombreEstadoCifrado WHERE ID_estado = ?";

        $stmt = $this->Conexion->prepare($sql);
        $stmt->bind_param("ss", $nuevoNombreEstado, $ID_estado);

        $resultado = $stmt->execute();

        $stmt->close();
        $this->Conexion->close();

        return $resultado;
    }
     public function actualizarEstado($ID_estado, $Nombre_estado, $Descripcion_estado)
     {
         $this->Conexion = Conectarse();

         $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
         $this->Conexion->query($sql_key);
      
         $sql = "UPDATE estado SET Nombre_estado = AES_ENCRYPT(?, @encryption_key), 
                     Descripcion_estado = AES_ENCRYPT(?, @encryption_key) WHERE ID_estado=?";
 
         $stmt = $this->Conexion->prepare($sql);
         $stmt->bind_param("sss", $Nombre_estado, $Descripcion_estado, $ID_estado);
 
         $resultado = $stmt->execute();
 
         $stmt->close();
         $this->Conexion->close();
 
         return $resultado;
     }
}