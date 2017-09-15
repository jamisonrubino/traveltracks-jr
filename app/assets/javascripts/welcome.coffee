# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

function validateHhMm(inputField) {
    var isValid = /^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/.test(inputField.value);
    if (isValid) {
        inputField.style.backgroundColor = '#bfa';
    } else {
        inputField.style.backgroundColor = '#fba';
    }

    return isValid;
}

var timeInput = document.getElementById("time_input");
timeInput.change(validateHhMm(this));