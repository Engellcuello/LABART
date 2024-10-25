let slider = document.querySelector('.slider .list');
let items = document.querySelectorAll('.slider .list .item');
let next = document.getElementById('next');
let prev = document.getElementById('prev');
let dots = document.querySelectorAll('.slider .dots li');

let lengthItems = items.length - 1;
let active = 0;
next.onclick = function () {
    active = active + 1 <= lengthItems ? active + 1 : 0;
    reloadSlider();
}
prev.onclick = function () {
    active = active - 1 >= 0 ? active - 1 : lengthItems;
    reloadSlider();
}
let refreshInterval = setInterval(() => { next.click() }, 4000);
function reloadSlider() {
    slider.style.left = -items[active].offsetLeft + 'px';
    // 
    let last_active_dot = document.querySelector('.slider .dots li.active');
    last_active_dot.classList.remove('active');
    dots[active].classList.add('active');

    clearInterval(refreshInterval);
    refreshInterval = setInterval(() => { next.click() }, 4000);


}

dots.forEach((li, key) => {
    li.addEventListener('click', () => {
        active = key;
        reloadSlider();
    })
})
window.onresize = function (event) {
    reloadSlider();
};


const checkbox1 = document.getElementById('checkbox1');
const checkbox2 = document.getElementById('checkbox2');

checkbox1.addEventListener('change', function () {
    if (checkbox1.checked && checkbox2.checked) {
        checkbox2.checked = false;
    }
});

checkbox2.addEventListener('change', function () {
    if (checkbox2.checked && checkbox1.checked) {
        checkbox1.checked = false;
    }
});




function mostrar(){
    var elemento = document.getElementById("ind_register");
    var elemento2 = document.getElementById("ind_login");
    elemento.classList.remove("active");
    elemento2.classList.add("active");
    document.getElementById('div2').style.display = 'block';
    document.getElementById('div1').style.display = 'none';
    
}

function nomostrar(){
    var elemento = document.getElementById("ind_register");
    var elemento2 = document.getElementById("ind_login");
    elemento2.classList.remove("active");
    elemento.classList.add("active");
    document.getElementById('div2').style.display = 'none';
    document.getElementById('div1').style.display = 'block';
    
}