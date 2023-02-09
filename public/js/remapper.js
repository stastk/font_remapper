$(document).ready(function() {
    (function(){
        var input    = $("#rm_one textarea");
        var output   = $("#rm_another textarea");
        var ws       = new WebSocket('ws://' + window.location.host + window.location.pathname);
        ws.onopen    = function()  { console.log("Socket open") };
        ws.onclose   = function()  { console.log("Socket closed") }
        ws.onmessage = function(m) {
            console.log(m.data);
            output.val(m.data);
        };
        input.keyup(function(event) {
            ws.send(input.val());
            return false;
        });
    })();
});

