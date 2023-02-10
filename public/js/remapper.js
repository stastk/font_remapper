$(document).ready(function() {

    (function(){
        var input                = $("#rm_one textarea");
        var input_transcription  = $("#rm_one .transcription");
        var output               = $("#rm_another textarea");
        var output_transcription = $("#rm_another .transcription");

        var ws       = new WebSocket('ws://' + window.location.host + window.location.pathname);
        ws.onopen    = function()  { console.log("Socket open") };
        ws.onclose   = function()  { console.log("Socket closed") }
        ws.onmessage = function(m) {
            console.log(m.data);
            output.val(m.data);
            output_transcription.html(m.data);
        };

        input.bind('input propertychange', function() {
            //input.keyup(function(event) {
            console.log(input_transcription)
            transcript_it();
            return false;
            //});
        });

        $('.char').on("click", function() {
            value = $(this).find('span').text();
            console.log("VALUE: " + value);
            input.val(input.val() + value);
            console.log("TEXTAREA: " + input.val());
            transcript_it();
            //return false;
        });

        $('.char1').on("click", function(){
            value = $(this).find('span').text();
            var $temp = $("<input>");
            $("body").append($temp);
            $temp.val(value).select();
            document.execCommand("copy");
            $temp.remove();
        })
        var direction = ""

        function transcript_it(){
            input_transcription.html(input.val());
            value_to_send = input.val().replace(/["]/g,'\\"')
            ws.send(`{"direction": "`+ direction +`", "text": "`+ value_to_send + `" }`);
            console.log("transcript: " + `{"direction": "`+ direction +`", "text": "`+ value_to_send + `" }`);
            return false;
        }

    })();

});