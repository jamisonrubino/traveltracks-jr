function validateHhMm(inputField) {
    var isValid = /^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/.test(inputField.value);
    if (isValid) {
        inputField.style.backgroundColor = '#bfa';
    } else {
        inputField.style.backgroundColor = '#fba';
    }

    return isValid;
}

$("#time_input").change(validateHhMm(this));