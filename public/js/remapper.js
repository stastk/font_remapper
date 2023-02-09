$(document).ready(function() {
    (function(){
        var input = $("#rm_one textarea");
        var input_transcription = $("#rm_one .transcription");

        var output = $("#rm_another textarea");
        var output_transcription = $("#rm_another .transcription");

        var ws       = new WebSocket('ws://' + window.location.host + window.location.pathname);
        ws.onopen    = function()  { console.log("Socket open") };
        ws.onclose   = function()  { console.log("Socket closed") }
        ws.onmessage = function(m) {
            console.log(m.data);
            output.val(m.data);
            output_transcription.html(m.data);
        };
        input.keyup(function(event) {
            console.log(input_transcription)
            input_transcription.html(input.val());
            ws.send(input.val());
            return false;
        });
    })();
});

