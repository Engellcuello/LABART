<?php
require_once 'Conexion.php';
class publicaciones
{
    private $ID_publicacion;
    private $Fecha_publicacion;
    private $Descripcion_publicacion;
    private $Img_publicacion;
    private $Cont_Explicit_publi;
    private $ID_usuario;
    private $Conexion;

    public function __construct($ID_publicacion = null, $Fecha_publicacion = null, $Descripcion_publicacion = null, $Img_publicacion = null, $Cont_Explicit_publi = null, $ID_usuario = null)
    {
        $this->ID_publicacion = $ID_publicacion;
        $this->Fecha_publicacion = $Fecha_publicacion;
        $this->Descripcion_publicacion = $Descripcion_publicacion;
        $this->Img_publicacion = $Img_publicacion;
        $this->Cont_Explicit_publi = $Cont_Explicit_publi;
        $this->ID_usuario = $ID_usuario;
        $this->Conexion = Conectarse();
    }
    public function agregarPublicacion($ID_publicacion = null, $Fecha_publicacion = null, $Descripcion_publicacion = null, $Img_publicacion = null, $Cont_Explicit_publi = null, $ID_usuario = null)
    {        
        $this->Conexion = Conectarse();
    
        $sql = "INSERT INTO Publicacion(ID_publicacion,Fecha_publicacion,Descripcion_publicacion,Img_publicacion,Cont_Explicit_publi,ID_usuario)
                VALUES (?, ?, ?, ?, ?, ?)";
        $stmt = $this->Conexion->prepare($sql);
        $stmt->bind_param("ssssss", $ID_publicacion, $Fecha_publicacion, $Descripcion_publicacion, $Img_publicacion, $Cont_Explicit_publi, $ID_usuario);
        $stmt->execute();
        $stmt->close();
        $this->Conexion->close();
    }
    public function consultarPublicacion($ID_publicacion)
    {
        $this->Conexion = Conectarse();
    
        // Consulta con JOIN para obtener los datos de la publicación y el nombre del usuario
        $sql = "
            SELECT Publicacion.*, Usuario.Nombre_usuario
            FROM Publicacion
            JOIN Usuario ON Publicacion.ID_usuario = Usuario.ID_usuario
            WHERE Publicacion.ID_publicacion = '$ID_publicacion'
        ";
    
        $resultado = $this->Conexion->query($sql);
        $this->Conexion->close();
        return $resultado;
    }
    public function consultarPublicaciones()
 	{
        $this->Conexion = Conectarse();

 		$sql="SELECT * FROM Publicacion";
 		$resultado=$this->Conexion->query($sql);
 		$this->Conexion->close();
 		return $resultado;	
 	}
     public function borrarPublicacion($ID_publicacion)
     {
         $this->Conexion = Conectarse();
 
         $sql = "UPDATE Publicacion SET TraEstado = 'Inactivo' WHERE ID_publicacion=?";
 
         $stmt = $this->Conexion->prepare($sql);
         $stmt->bind_param("s", $ID_publicacion);
 
         $resultado = $stmt->execute();
 
         $stmt->close();
         $this->Conexion->close();
 
         return $resultado;
     }

    public function actualizarPublicacion($ID_publicacion, $Fecha_publicacion, $Descripcion_publicacion, $Img_publicacion, $Cont_Explicit_publi, $ID_usuario)
    {
        $this->Conexion = Conectarse();
     
        $sql = "UPDATE Publicacion SET Fecha_publicacion=?, Descripcion_publicacion=?, Img_publicacion=?,Cont_Explicit_publi=?,ID_usuario=? WHERE ID_publicacion=?";
         
        $stmt = $this->Conexion->prepare($sql);
        $stmt->bind_param("ssssss", $TraFechaAsignado,$TraDescripcion, $TraFechaInicio,$TraFechaFin, $TraObservaciones,$TraPaciente,$TraEstado,$TraNumero);

        $resultado = $stmt->execute();

        $stmt->close();
        $this->Conexion->close();
     
        return $resultado;
    }  
}