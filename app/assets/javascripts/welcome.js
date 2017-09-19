$(document).ready(function() {
    $("input#pool_genre").change(addHideGenres);
    $("input#pool_top_tracks").change(addHideGenres);
});

var genreNum = "two";

function addHideGenres() {
    if ($("input:radio[name=pool]#pool_genre").is(":checked")) {
        $("#genre-seeds").removeClass("hide");
    } else if ($("input:radio[name=pool]#pool_top_tracks").is(":checked")) {
        $("#genre-seeds").addClass("hide");
    }
}