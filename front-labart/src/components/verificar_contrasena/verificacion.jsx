import React, { useState } from 'react';
import axios from '../../utils/axiosintance';
import '../../assets/styles/verificacion/verificacion.css';

const PasswordResetModal = ({ onClose }) => {
  const [email, setEmail] = useState('');
  const [otp, setOtp] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [step, setStep] = useState(1); // 1: Email, 2: OTP, 3: New Password
  const [userId, setUserId] = useState(null);
  const [message, setMessage] = useState('');

  const handleEmailSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post('/password-reset/init', { email });
      setUserId(response.data.user_id);
      setStep(2);
      setMessage('Código de verificación enviado a tu correo');
    } catch (error) {
      setMessage(error.response?.data?.error || 'Error al enviar el código de verificación');
    }
  };

  const handleOtpSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.post('/password-reset/verify', {
        user_id: userId,
        otp
      });
      setStep(3);
      setMessage('Código verificado correctamente');
    } catch (error) {
      setMessage(error.response?.data?.error || 'Código incorrecto o expirado');
    }
  };

  const handlePasswordSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.post('/password-reset/complete', {
        user_id: userId,
        new_password: newPassword
      });
      setMessage('Contraseña actualizada exitosamente');
      setTimeout(onClose, 2000);
    } catch (error) {
      setMessage(error.response?.data?.error || 'Error al actualizar contraseña');
    }
  };

  return (
    <div className="password-reset-modal">
      <div className="password-reset-container">
        <button className="password-reset-close" onClick={onClose}>
          <i className="fas fa-times"></i>
        </button>
        
        <h2 className="password-reset-title">Recuperación de Contraseña</h2>
        
        {step === 1 && (
          <form className="password-reset-form" onSubmit={handleEmailSubmit}>
            <div className="form-group">
              <label htmlFor="email" className="form-label">Correo electrónico</label>
              <input
                id="email"
                type="email"
                className="form-input"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="Ingresa tu correo registrado"
                required
              />
            </div>
            <button type="submit" className="password-reset-button">
              Enviar código
            </button>
          </form>
        )}

        {step === 2 && (
          <form className="password-reset-form" onSubmit={handleOtpSubmit}>
            <div className="form-group">
              <label htmlFor="otp" className="form-label">Código de verificación</label>
              <input
                id="otp"
                type="text"
                className="form-input"
                value={otp}
                onChange={(e) => setOtp(e.target.value)}
                placeholder="Ingresa el código de 6 dígitos"
                maxLength="6"
                required
              />
              <p className="otp-hint">Revisa tu correo electrónico para obtener el código</p>
            </div>
            <button type="submit" className="password-reset-button">
              Verificar código
            </button>
          </form>
        )}

        {step === 3 && (
          <form className="password-reset-form" onSubmit={handlePasswordSubmit}>
            <div className="form-group">
              <label htmlFor="newPassword" className="form-label">Nueva contraseña</label>
              <input
                id="newPassword"
                type="password"
                className="form-input"
                pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"
                value={newPassword}
                onChange={(e) => setNewPassword(e.target.value)}
                placeholder="Crea una nueva contraseña"
                minLength="8"
                required
              />
              <p className="password-hint">Mínimo 8 caracteres, Incluyendo una letra y un numero</p>
            </div>
            <button type="submit" className="password-reset-button">
              Actualizar contraseña
            </button>
          </form>
        )}

        {message && (
          <div className={`password-reset-message ${message.includes('Error') ? 'error' : 'success'}`}>
            {message}
          </div>
        )}
      </div>
    </div>
  );
};

export default PasswordResetModal;