// $(document).ready(function() {
//     addEventListeners();
// });

// function addEventListeners() {
//     $("input#pool_genre").change(addHidePool);
//     $("input#pool_top_tracks").change(addHidePool);
//     $("input#pool_saved_tracks").change(addHidePool);
//     $("input#pool_artist").change(addHidePool)
// }

// function addHidePool() {
//     if ($("input:radio[name=pool]#pool_genre").is(":checked")) {
//         $("#artist-input").removeClass();
//         $("#artist-input").addClass("hide");
//         $("#genre-seeds").removeClass();
//     } else if ($("input:radio[name=pool]#pool_top_tracks").is(":checked") || $("input:radio[name=pool]#pool_saved_tracks").is(":checked")) {
//         $("#genre-seeds").removeClass();
//         $("#artist-input").removeClass();
//         $("#genre-seeds").addClass("hide");
//         $("#artist-input").addClass("hide");
//     } else if ($("input:radio[name=pool]#pool_artist").is(":checked")) {
//         $("#artist-input").removeClass();
//         $("#genre-seeds").removeClass();
//         $("#genre-seeds").addClass("hide");
//     }
// }