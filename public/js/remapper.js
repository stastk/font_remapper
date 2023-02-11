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
            console.log("FIRE")
            gibberish_textarea.val(gibberish_textarea.val().replace( "q",  "" ));
            gibberish_textarea.val(gibberish_textarea.val().replace( "x",  "" ));
            transcript_it($(this).data("gibberish-or-normal"));
            return false;
        });

        $('.char').on("click", function() {
            let direction = $(this).parent('div[data-gibberish_or_normal]').data("gibberish-or-normal")
            let value = $(this).find('span').text();
            console.log("VALUE: " + value + "; direction: " + direction + ";");
            let textarea = $("#rm_" + direction + " textarea")
            $(".rm_" + direction + "_map").val(textarea.val() + value);
            console.log("TEXTAREA: " + textarea.val());
            transcript_it(direction);
        });

        $('.char1').on("click", function(){
            value = $(this).find('span').text();
            let $temp = $("<input>");
            $("body").append($temp);
            $temp.val(value).select();
            document.execCommand("copy");
            $temp.remove();
        })

        function transcript_it(gibberish_or_normal){
            //console.log("gibberish_or_normal " + gibberish_or_normal);
            let textarea = $("#rm_"+ gibberish_or_normal +" textarea")
            //$(".transcription[data-gibberish_or_normal='"+ gibberish_or_normal +"']").html(textarea.val());
            let value_to_send = textarea.val().replace(/["]/g,'\\"')
            ws.send(`{"direction": "`+ gibberish_or_normal +`", "text": "`+ value_to_send + `" }`);
            //console.log("transcript: " + `{"direction": "`+ gibberish_or_normal +`", "text": "`+ value_to_send + `" }`);
            return false;
        }

    })();

});