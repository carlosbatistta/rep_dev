var peso;
var altura;
var imc;
var resultado;

function calcular(event) {
    event.preventDefault(); //para não apagar os dados do campo quando houver algum alerta
    resultado = document.getElementById('resultado');
    peso = document.getElementById('peso').value;
    altura = document.getElementById('altura').value;

    imc = peso / (altura * altura)

    if (imc < 17) {
        resultado.innerHTML = '<br/> Seu resultado foi: ' + imc.toFixed(2) + '<br/> Cuidado você está muito abaixo do peso!';
    } else if (imc > 17 && imc <= 18.49) {
        resultado.innerHTML = '<br/> Seu resultado foi: ' + imc.toFixed(2) + '<br/> Você está abaixo do peso!';
    } else if (imc > 18.49 && imc <= 24.99) {
        resultado.innerHTML = '<br/> Seu resultado foi: ' + imc.toFixed(2) + '<br/> Você está no peso ideal';
    } else if (imc > 24.99 && imc <= 29.99) {
        resultado.innerHTML = '<br/> Seu resultado foi: ' + imc.toFixed(2) + '<br/> Você está acima do peso';
    } else if (imc >= 30) {
        resultado.innerHTML = '<br/> Seu resultado foi: ' + imc.toFixed(2) + '<br/> Cuidado Obesidade';
    }

    document.getElementById('peso').value = '';
    document.getElementById('altura').value = '';
}