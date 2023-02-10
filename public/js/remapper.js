$(document).ready(function() {

    (function(){
        var content                  = $("textarea");
        var rm_gibberish                   = $("#rm_gibberish textarea");
        var rm_gibberish_transcription     = $("#rm_gibberish .transcription");
        var rm_gibberish_map               = $(".rm_gibberish_map")

        var rm_normal               = $("#rm_normal textarea");
        var rm_normal_transcription = $("#rm_normal .transcription");
        var rm_normal_map           = $(".rm_normal_map")

        var ws       = new WebSocket('ws://' + window.location.host + window.location.pathname);
        ws.onopen    = function()  { console.log("Socket open") };
        ws.onclose   = function()  { console.log("Socket closed") }
        ws.onmessage = function(m) {
            console.log(m.data);
            answer = JSON.parse(m.data);

            $("#rm_" + answer[0] + " textarea").val(answer[1]);
            $("#rm_" + answer[0] + " .transcription").val(answer[1]);
        };

        content.bind('input propertychange', function() {
            console.log("FIRE")
            transcript_it($(this).data("gibberish-or-normal"));
            return false;
        });
//-----------------------------
        $(".rm_" + answer[0] + "_map").find('.char').on("click", function() {
            value = $(this).find('span').text();
            console.log("VALUE: " + value);
            rm_gibberish.val(rm_gibberish.val() + value);
            console.log("TEXTAREA: " + rm_gibberish.val());
            transcript_it();
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

        function transcript_it(gibberish_or_normal){
            console.log("gibberish_or_normal " + gibberish_or_normal);
            $(".transcription[data-gibberish_or_normal='"+ gibberish_or_normal +"']").html($("#rm_"+ gibberish_or_normal +" textarea").val());
            let value_to_send = $("#rm_"+ gibberish_or_normal +" textarea").val().replace(/["]/g,'\\"')
            ws.send(`{"direction": "`+ gibberish_or_normal +`", "text": "`+ value_to_send + `" }`);
            console.log("transcript: " + `{"direction": "`+ gibberish_or_normal +`", "text": "`+ value_to_send + `" }`);
            return false;
        }

    })();

});