$(document).ready(function() {
    $("input#pool_genre").change(addHideGenres);
    $("input#pool_top_tracks").change(addHideGenres);
});

var genreNum = "two";
