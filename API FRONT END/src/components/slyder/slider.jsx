import React, { useState, useEffect } from 'react';

import img1 from '../../assets/img/login/img1.jpg';
import img2 from '../../assets/img/login/img2.jpg';
import img3 from '../../assets/img/login/img3.jpg';
import img4 from '../../assets/img/login/img4.jpg';
import img5 from '../../assets/img/login/img5.jpg';
import img6 from '../../assets/img/login/img6.jpg';
import img7 from '../../assets/img/login/img7.jpg';

const Slider = () => {
  const [active, setActive] = useState(0);
  const [intervalId, setIntervalId] = useState(null);

  const images = [img1, img2, img3, img4, img5, img6, img7];

  const dots = Array(images.length).fill(false);

  useEffect(() => {
    const interval = setInterval(() => {
      setActive(prev => (prev + 1) % images.length);
    }, 5000);
    setIntervalId(interval);
    return () => clearInterval(interval);
  }, [images.length]);

  const handleNext = () => {
    setActive(prev => (prev + 1) % images.length);
  };

  const handlePrev = () => {
    setActive(prev => (prev - 1 + images.length) % images.length);
  };

  const handleDotClick = (index) => {
    setActive(index);
  };

  const handleResize = () => {
  };

  useEffect(() => {
    window.addEventListener('resize', handleResize);
    return () => {
      window.removeEventListener('resize', handleResize);
    };
  }, []);

  return (
    <div className="slider">
      <div className="list" style={{ left: `-${active * 108}%` }}>
        {images.map((src, index) => (
          <div className="item" key={index}>
            <img className="imagen_login" src={src} alt={`Slide ${index}`} />
          </div>
        ))}
      </div>

      <div className="buttons">
        <button id="prev" onClick={handlePrev}>‹</button>
        <button id="next" onClick={handleNext}>›</button>
      </div>

      <ul className="dots">
        {dots.map((_, index) => (
          <li
            key={index}
            className={active === index ? 'active' : ''}
            onClick={() => handleDotClick(index)}
          ></li>
        ))}
      </ul>
    </div>
  );
};

export default Slider;