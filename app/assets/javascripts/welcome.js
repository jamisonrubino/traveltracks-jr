$(document).ready(function() {
    $("input#pool_genre").change(addHideGenres);
    $("input#pool_top_tracks").change(addHideGenres);
});

var genreNum = "two";

function addHideGenres() {
    $("#genre-seeds").append("<div class=\"genre\"><%= label_tag \"genre_seed_" + genreNum + "\", \"Music Genre\" %>");
    
    if (genreNum === "two") {   
        genreNum = "three";
    } else if (genreNum === "three") {
        $("#add_genre").addClass("hide");
    }
}