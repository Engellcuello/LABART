<?php
require_once 'Conexion.php';
class Rol
{
    private $ID_rol;
    private $Nombre_rol;
    private $Descripcion_rol;
    private $ID_estado;
    private $Conexion;

    public function __construct($ID_rol = null, $Nombre_rol = null, $Descripcion_rol = null, $ID_estado = null)
    {
        $this->ID_rol = $ID_rol;
        $this->Nombre_rol = $Nombre_rol;
        $this->Descripcion_rol = $Descripcion_rol;
        $this->ID_estado = $ID_estado;
        $this->Conexion = Conectarse();
    }
    public function agregarRol($ID_rol = null, $Nombre_rol = null, $Descripcion_rol = null, $ID_estado = null)
    {        
        $this->Conexion = Conectarse();

        $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
        $this->Conexion->query($sql_key);
    
        $sql = "INSERT INTO rol(ID_rol,Nombre_rol,Descripcion_rol,ID_estado)
                VALUES (?, (AES_ENCRYPT(?, @encryption_key)), (AES_ENCRYPT(?, @encryption_key)), ?)";
        $stmt = $this->Conexion->prepare($sql);
        $stmt->bind_param("ssss", $ID_rol, $Nombre_rol, $Descripcion_rol, $ID_estado);
        $stmt->execute();
        $stmt->close();
        $this->Conexion->close();
    }
    public function consultarRol($ID_rol)
 	{
        $this->Conexion = Conectarse();

 		$sql="SELECT * FROM rol WHERE ID_rol ='$ID_rol'";
        
 		$resultado=$this->Conexion->query($sql);
 		$this->Conexion->close();
 		return $resultado;	
 	}
     public function consultarRoles()
 	{
        $this->Conexion = Conectarse();

        $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
        $this->Conexion->query($sql_key);
        
        $sql="SELECT 
                ID_rol, 
                AES_DECRYPT((Nombre_rol	), @encryption_key) AS Nombre_rol,
                AES_DECRYPT((Descripcion_rol), @encryption_key) AS Descripcion_rol,
                ID_estado
        FROM rol";
 		$resultado=$this->Conexion->query($sql);
 		$this->Conexion->close();
 		return $resultado;	
 	}
     public function borrarRol($ID_rol)
     {
         $this->Conexion = Conectarse();
    
         $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
         $this->Conexion->query($sql_key);
     
         // Encriptamos el nuevo valor
         $nuevoNombreRol = 'Rol Inexistente';
         $nombreRolCifrado = "AES_ENCRYPT(?, @encryption_key)";
     
         $sql = "UPDATE rol SET Nombre_rol = $nombreRolCifrado WHERE ID_rol = ?";
     
         $stmt = $this->Conexion->prepare($sql);
         $stmt->bind_param("ss", $nuevoNombreRol, $ID_rol);
     
         $resultado = $stmt->execute();
     
         $stmt->close();
         $this->Conexion->close();
     
         return $resultado;
     }

     public function obtenerEstado() {
        $estado = new Estado();
        $resultado = $estado->consultarEstados();
        $estados = [];
        
        while ($fila = $resultado->fetch_assoc()) {
            $estados[] = [
                'ID_estado' => $fila['ID_estado'],
                'Nombre_estado' => $fila['Nombre_estado']
            ];
        }
        
        return $estados;
    }

    public function actualizarRol($ID_rol, $Nombre_rol, $Descripcion_rol, $ID_estado)
    {
        $this->Conexion = Conectarse();

        $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
        $this->Conexion->query($sql_key);
     
        $sql = "UPDATE rol SET Nombre_rol = AES_ENCRYPT(?, @encryption_key), 
                    Descripcion_rol = AES_ENCRYPT(?, @encryption_key),ID_estado=? WHERE ID_rol=?";
         
        $stmt = $this->Conexion->prepare($sql);
        $stmt->bind_param("ssss", $Nombre_rol, $Descripcion_rol, $ID_estado, $ID_rol);

        $resultado = $stmt->execute();

        $stmt->close();
        $this->Conexion->close();
     
        return $resultado;
    }  
}