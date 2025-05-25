import { useEffect } from "react";
import { useNavigate, Outlet, Navigate } from "react-router-dom";

export const AuthGuard = () => {
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem("token");
    const idUsuario = localStorage.getItem("ID_usuario");

    if (!token || !idUsuario) {
      navigate("/"); 
    }

  }, [navigate]);


  return <Outlet />; 
};



export const RolGuard = ({ allowedRoles }) => {
  const rol = localStorage.getItem("ID_rol");

  if (allowedRoles.includes(rol)) {
    return <Outlet />;
  } else {
    return <Navigate to="/home" />;
  }
};

export default RolGuard;
