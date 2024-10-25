<?php
require_once 'Conexion.php';
class Usuario
{
    private $ID_usuario;
    private $Nombre_usuario;
    private $Contraseña;
    private $Correo_usuario;
    private $Fecha_usuario;
    private $Notificaciones;
    private $ID_sexo;
    private $Img_usuario;
    private $ID_rol;
    private $Cont_Explicit;
    private $Conexion;

    public function __construct($ID_usuario = null, $Nombre_usuario = null, $Contraseña = null, $Correo_usuario = null, $Fecha_usuario = null, $Notificaciones = null,$ID_sexo= null,$Img_usuario= null,$ID_rol=null,$Cont_Explicit=null)
    {
        $this->ID_usuario = $ID_usuario;
        $this->Nombre_usuario = $Nombre_usuario;
        $this->Contraseña = $Contraseña;
        $this->Correo_usuario = $Correo_usuario;
        $this->Fecha_usuario = $Fecha_usuario;
        $this->Notificaciones = $Notificaciones;
        $this->ID_sexo = $ID_sexo;
        $this->Img_usuario = $Img_usuario;
        $this->ID_rol = $ID_rol;
        $this->Cont_Explicit = $Cont_Explicit;
        $this->Conexion = Conectarse();
    }
    public function agregarUsuario($ID_usuario = null, $Nombre_usuario = null, $Contraseña = null, $Correo_usuario = null, $Fecha_usuario = null, $Notificaciones = null,$ID_sexo= null,$Img_usuario= null,$ID_rol=null,$Cont_Explicit=null)
    {        
        $this->Conexion = Conectarse();

        $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
        $this->Conexion->query($sql_key);
    
        $sql = "INSERT INTO usuario(ID_usuario,Nombre_usuario,Contraseña,Correo_usuario,Fecha_usuario,Notificaciones,ID_sexo,Img_usuario,ID_rol,Cont_Explicit)
                VALUES (?, ?, (AES_ENCRYPT(?, @encryption_key)), (AES_ENCRYPT(?, @encryption_key)), ?, ?, ?, ?, ?, ?)";
        $stmt = $this->Conexion->prepare($sql);
        $stmt->bind_param("ssssssssss", $ID_usuario, $Nombre_usuario, $Contraseña, $Correo_usuario, $Fecha_usuario, $Notificaciones,$ID_sexo,$Img_usuario,$ID_rol,$Cont_Explicit);
        $stmt->execute();
        $stmt->close();
        $this->Conexion->close();
    }
    public function consultarUsuario($ID_usuario)
 	{
        $this->Conexion = Conectarse();

 		$sql="SELECT * FROM usuario WHERE ID_usuario ='$ID_usuario'";
        
 		$resultado=$this->Conexion->query($sql);
 		$this->Conexion->close();
 		return $resultado;	
 	}
     public function consultarUsuarios()
     {
         $this->Conexion = Conectarse();
     
      
         $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
         $this->Conexion->query($sql_key);
     
         $sql = "SELECT 
                     ID_usuario, 
                     Nombre_usuario, 
                     AES_DECRYPT((Contraseña), @encryption_key) AS Contraseña,
                     AES_DECRYPT((Correo_usuario), @encryption_key) AS Correo_usuario,
                     Fecha_usuario, 
                     Notificaciones, 
                     ID_sexo,
                     Img_usuario,  
                     ID_rol,
                     Cont_Explicit   
                 FROM usuario";
     
         $resultado = $this->Conexion->query($sql);
         $this->Conexion->close();
     
         return $resultado;
     }
     public function borrarUsuario($ID_usuario,$Notificaciones)
     {
         $this->Conexion = Conectarse();
 
         $sql = "UPDATE usuario SET Notificaciones = '0' WHERE ID_usuario=?";
 
         $stmt = $this->Conexion->prepare($sql);
         $stmt->bind_param("s", $ID_usuario);
 
         $resultado = $stmt->execute();
 
         $stmt->close();
         $this->Conexion->close();
 
         return $resultado;
     }

     public function obtenerSexos() {
        $sexo = new Sexo();
        $resultado = $sexo->consultarSexos();
        $sexos = [];
        
        while ($fila = $resultado->fetch_assoc()) {
            $sexos[] = [
                'ID_sexo' => $fila['ID_sexo'],
                'Nombre_sexo' => $fila['Nombre_sexo']
            ];
        }
        
        return $sexos;
    }

    public function obtenerRoles() {
        $rol = new Rol();
        $resultado = $rol->consultarRoles();
        $roles = [];
        
        while ($fila = $resultado->fetch_assoc()) {
            $roles[] = [
                'ID_rol' => $fila['ID_rol'],
                'Nombre_rol' => $fila['Nombre_rol']
            ];
        }
        
        return $roles;
    }


    public function actualizarUsuario($ID_usuario, $Nombre_usuario, $Contraseña, $Correo_usuario, $Fecha_usuario, $Notificaciones, $ID_sexo, $Img_usuario, $ID_rol, $Cont_Explicit)
    {
        $this->Conexion = Conectarse();
    
        $sql_key = "SET @encryption_key = 'MiClaveDeEncriptacionSegura123!';";
        $this->Conexion->query($sql_key);
    
        $sql = "UPDATE usuario 
                SET Nombre_usuario = ?, 
                    Contraseña = AES_ENCRYPT(?, @encryption_key), 
                    Correo_usuario = AES_ENCRYPT(?, @encryption_key), 
                    Fecha_usuario = ?, 
                    Notificaciones = ?, 
                    ID_sexo = ?, 
                    Img_usuario = ?, 
                    ID_rol = ?, 
                    Cont_Explicit = ? 
                WHERE ID_usuario = ?";
    

        $stmt = $this->Conexion->prepare($sql);
    
        $stmt->bind_param("ssssssssss", $Nombre_usuario, $Contraseña, $Correo_usuario, $Fecha_usuario, $Notificaciones, $ID_sexo, $Img_usuario, $ID_rol, $Cont_Explicit, $ID_usuario);
    
        $resultado = $stmt->execute();
    
        $stmt->close();
        $this->Conexion->close();
    
        return $resultado;
    }
    
}