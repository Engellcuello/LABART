<?php
require_once 'Conexion.php';
class Pqrs
{
    private $ID_pqrs;
    private $Fecha_pqrs;
    private $Contenido_pqrs;
    private $ID_estado;
    private $ID_usuario ;
    private $Conexion;

    public function __construct($ID_pqrs = null, $Fecha_pqrs = null, $Contenido_pqrs = null, $ID_estado = null, $ID_usuario=null)
    {
        $this->ID_pqrs = $ID_pqrs;
        $this->Fecha_pqrs = $Fecha_pqrs;
        $this->Contenido_pqrs = $Contenido_pqrs;
        $this->ID_estado = $ID_estado;
        $this->ID_usuario = $ID_usuario;
        $this->Conexion = Conectarse();
    }
    public function agregarPqrs($ID_pqrs = null, $Fecha_pqrs = null, $Contenido_pqrs = null, $ID_estado = null, $ID_usuario=null)
    {        
        $this->Conexion = Conectarse();

        $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
        $this->Conexion->query($sql_key);
    
        $sql = "INSERT INTO pqrs(ID_pqrs,Fecha_pqrs,Contenido_pqrs,ID_estado,ID_usuario)
                VALUES (?, ?, (AES_ENCRYPT(?, @encryption_key)), ?,?)";
        $stmt = $this->Conexion->prepare($sql);
        $stmt->bind_param("sssss", $ID_pqrs, $Fecha_pqrs, $Contenido_pqrs, $ID_estado, $ID_usuario);
        $stmt->execute();
        $stmt->close();
        $this->Conexion->close();
    }
    public function consultarPqr($ID_pqrs)
 	{
        $this->Conexion = Conectarse();

 		$sql="SELECT * FROM pqrs WHERE ID_pqrs ='$ID_pqrs'";
        
 		$resultado=$this->Conexion->query($sql);
 		$this->Conexion->close();
 		return $resultado;	
 	}
     public function consultarPqrs()
 	{
        $this->Conexion = Conectarse();

        $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
        $this->Conexion->query($sql_key);
        
        $sql="SELECT 
                ID_pqrs, 
                Fecha_pqrs,
                AES_DECRYPT((Contenido_pqrs), @encryption_key) AS Contenido_pqrs,
                ID_estado,
                ID_usuario
        FROM pqrs";
 		$resultado=$this->Conexion->query($sql);
 		$this->Conexion->close();
 		return $resultado;	
 	}
     public function borrarPqrs($ID_pqrs)
     {
         $this->Conexion = Conectarse();
    
         $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
         $this->Conexion->query($sql_key);
     
         // Encriptamos el nuevo valor
         $nuevoContenidoPqrs = 'Contenido No Existente';
         $nombrePqrsCifrado = "AES_ENCRYPT(?, @encryption_key)";
     
         $sql = "UPDATE pqrs SET Contenido_pqrs = $nombrePqrsCifrado WHERE ID_pqrs = ?";
     
         $stmt = $this->Conexion->prepare($sql);
         $stmt->bind_param("ss", $nuevoContenidoPqrs, $ID_pqrs);
     
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
    public function obtenerUsuario() {
        $usuario = new Usuario();
        $resultado = $usuario->consultarUsuarios();
        $usuarios = [];
        
        while ($fila = $resultado->fetch_assoc()) {
            $usuarios[] = [
                'ID_usuario' => $fila['ID_usuario'],
                'Nombre_usuario' => $fila['Nombre_usuario']
            ];
        }
        
        return $usuarios;
    }

    public function actualizarPqrs($ID_pqrs, $Fecha_pqrs, $Contenido_pqrs, $ID_estado, $ID_usuario)
    {
        $this->Conexion = Conectarse();

        $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
        $this->Conexion->query($sql_key);
     
        $sql = "UPDATE pqrs SET Fecha_pqrs=?,Contenido_pqrs = AES_ENCRYPT(?, @encryption_key),ID_estado=?,ID_usuario=? WHERE ID_pqrs=?";
         
        $stmt = $this->Conexion->prepare($sql);
        $stmt->bind_param("sssss", $Fecha_pqrs, $Contenido_pqrs, $ID_estado, $ID_usuario, $ID_pqrs);

        $resultado = $stmt->execute();

        $stmt->close();
        $this->Conexion->close();
     
        return $resultado;
    }  
}