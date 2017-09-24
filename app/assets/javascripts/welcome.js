$(document).ready(function() {
    $("input#pool_genre").change(addHidePool);
    $("input#pool_top_tracks").change(addHidePool);
    $("input#pool_saved_tracks").change(addHidePool);
    $("input#pool_artist").change(addHidePool)
});

var genreNum = "two";

function addHidePool() {
    if ($("input:radio[name=pool]#pool_genre").is(":checked")) {
        $("#genre-seeds").removeClass("hide");
    } else if ($("input:radio[name=pool]#pool_top_tracks").is(":checked") || $("input:radio[name=pool]#pool_saved_tracks").is(":checked")) {
        $("#genre-seeds").removeClass();
        $("#track-input").removeClass();
        $("#genre-seeds").addClass("hide");
        $("#track-input").addClass("hide");
    } else if ($("input:radio[name=pool]#pool_track").is(":checked")) {
        $("#track-input").removeClass("hide");
        $("#genre-seeds").removeClass();
        $("#genre-seeds").addClass("hide");
    }
}