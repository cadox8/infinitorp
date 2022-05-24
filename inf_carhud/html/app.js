$(function () {
    showCarHud(false)
    function showCarHud(bool) {
        if (bool)
            $(".box").fadeIn(300);
         else
            $(".box").fadeOut(300);
    }

    function initCarhud(data) {
        $(".velocidad2").text(Math.round(data.speed) + "");
        $(".progressFuel").css("height", (data.fuel) * 0.18 + "");
        $(".marchas-texto").text((data.gear));
        $(".rpm").css("width", (data.speed) * 0.45 + "");
        showCarHud(true)

        if (data.fuel === -1) {
            $('#gasolina-icon').hide()
            $(".progressBarFuel").hide()
            $(".progressFuel").hide()
        } else {
            $('#gasolina-icon').show()
            $(".progressBarFuel").show()
            $(".progressFuel").show()
        }

        if (data.limitador)
            $(".velocidad2").css({ color: 'red' });
        else
            $(".velocidad2").css({ color: 'white' });


        if (data.cinturon !== -1) {
            $("#seat").show()
            $("#seat").attr('src', data.cinturon ? 'seatbelt.svg' : 'seatbelt_off.svg');
        } else {
            $("#seat").hide()
        }

        // DAÑO DEL VEHICULO
        const damage = data.damage /10;
        if (damage > 80 && damage <= 100) {
            $("#engine-icon").css(
                {
                    color: "green",
                }
            )
        } else if (damage > 50 && damage < 79) {
            $("#engine-icon").css(
                {
                    color: "yellow",
                }
            )
        } else if (damage > 30 && damage < 49) {
            $("#engine-icon").css(
                {
                    color: "orange",
                }
            )
        } else if (damage > 0 && damage < 29) {
            $("#engine-icon").css(
                {
                    color: "red",
                }
            )
        }
        if (data.gear === 0) {
            $(".marchas-texto").text("R");
        }
    }
    window.addEventListener('message',  function(event){
        let v =  event.data;
        if (v.action === 'speedometer') {
            initCarhud(v);
        } else if (v.action === 'hideSpeedo') {
            showCarHud(false);
        } else if (v.action === 'sound') {
            new Audio(v.sound + '.mp3').play();
        }
    })
});