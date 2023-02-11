$(document).ready(function() {

    (function(){
        var content            = $("textarea");
        var gibberish_textarea = $("#rm_gibberish textarea")
        var ws                 = new WebSocket('ws://' + window.location.host + window.location.pathname);
        ws.onopen              = function()  { console.log("Socket open") };
        ws.onclose             = function()  { console.log("Socket closed") }
        ws.onmessage           = function(m) {
            console.log(m.data);
            let answer = JSON.parse(m.data);
            $("#rm_" + answer[0] + " textarea").val(answer[2]);
            $("#rm_" + answer[0] + " .transcription").html(answer[2]);
            $("#rm_" + answer[1] + " .transcription").html($("#rm_" + answer[1] + " textarea").val());
            console.log("answer[0]:" + answer[0] + "; answer[1]: " + answer[1] + "; answer[2]: " + answer[2])
        };

        content.bind('input propertychange', function() {
            let misunderstanding = ["q", "x", ":"]
            misunderstanding.forEach(function(char) {
                gibberish_textarea.val(gibberish_textarea.val().replace( char,  "" ));
            });
            transcript_it($(this).data("gibberish-or-normal"));
            return false;
        });

        $('.char').on("click", function() {
            let direction = $(this).parent().data("gibberish-or-normal")
            let value = $(this).find('span').text();
            console.log("VALUE: " + value + "; direction: " + direction + ";");
            let textarea = $("#rm_" + direction + " textarea");
            textarea.val(textarea.val() + value);
            console.log("TEXTAREA: " + textarea.val());
            transcript_it(direction);
        });

        function transcript_it(gibberish_or_normal){
            let textarea = $("#rm_"+ gibberish_or_normal +" textarea")
            let value_to_send = textarea.val().replace(/["]/g,'\\"');
            //value_to_send = value_to_send.replace(/[/]/g,'\/');
            //value_to_send = value_to_send.replace(/[\\]/g,'\\');
            console.log("value_to_send: " + value_to_send)
            ws.send(gibberish_or_normal + "@" + value_to_send);
            return false;
        }

    })();

});