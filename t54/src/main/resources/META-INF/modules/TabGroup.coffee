define ["jquery"],
    ($) ->
        ping = (p) ->
            console.log("I'm here! " + p);

        pong = (p) ->
            console.log("I'm outta here! " + p);

#        console.log("I'm here!");
#    $('[data-toggle="tooltip"]').tooltip({'placement': 'auto'})
#    $('[data-toggle="popover"]').popover({trigger: 'hover focus', 'placement': 'auto'})
#    $('#tooltip').tooltip()

        # Exports.
        { ping, pong }
