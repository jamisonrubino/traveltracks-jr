$("#playlist-form").ready(function() {
    $("input#pool_genre").change(addHidePool);
    $("input#pool_top_tracks").change(addHidePool);
    $("input#pool_saved_tracks").change(addHidePool);
    $("input#pool_artist").change(addHidePool);
        
    $("label[for=pool_top_tracks], label[for=pool_genre], label[for=pool_saved_tracks], label[for=pool_artist]").css({"transition": "0.25s background, 0.25s color", "border-bottom": "2px solid #ffff8d", "width": "100%", "font-size": "1.1em", "padding": "7px 0"});
    
    $("#genre-seeds, #artist-input").addClass("hide");
    $("input:radio").css("display", "none");
    
    var topTracksR = $("input:radio[name=pool]#pool_top_tracks");
    var genreR = $("input:radio[name=pool]#pool_genre");
    var savedTracksR = $("input:radio[name=pool]#pool_saved_tracks");
    var artistR = $("input:radio[name=pool]#pool_artist");
        
    var topTracksL = $("label[for=pool_top_tracks]");
    var genreL = $("label[for=pool_genre]");
    var savedTracksL = $("label[for=pool_saved_tracks]");
    var artistL = $("label[for=pool_artist]");

    function addHidePool() {
        if (genreR.is(":checked")) {
            // $("#artist-input").removeClass();
            $("#artist-input").fadeOut(400).hide();
            $("#genre-seeds").fadeIn(400).show();
            unsetAll();
            genreL.addClass("selected");
        } else if (topTracksR.is(":checked") || savedTracksR.is(":checked")) {
            $("#genre-seeds").fadeOut(400).hide();
            $("#artist-input").fadeOut(400).hide()
            if (topTracksR.is(":checked")) {
                unsetAll();
                topTracksL.addClass("selected");
            } else {
                unsetAll();
                savedTracksL.addClass("selected");
            }
        } else if (artistR.is(":checked")) {
            $("#genre-seeds").fadeOut(400).hide();
            $("#artist-input").fadeIn(400).show();

            unsetAll();
            artistL.addClass("selected");
        }
        
        function unsetAll() {
            topTracksL.removeClass("selected");
            genreL.removeClass("selected");
            savedTracksL.removeClass("selected");
            artistL.removeClass("selected");
        }
    } 
});
