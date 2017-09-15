function validateHhMm() {
    inputField = $("#time_input");
    var isValid = /^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/.test(inputField.val());
    if (isValid) {
        inputField.css("background", "#bfa");
    } else {
        inputField.css("background", "#fba");
    }

    return isValid;
}

$("#time_input").change(validateHhMm());