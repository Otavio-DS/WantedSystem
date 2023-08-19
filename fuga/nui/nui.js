// base de dados para jogos https://www.codigofonte.net/scripts/javascript/games

$(() => {
	$("body").hide()
	window.addEventListener("message", function (event) {
		switch (event.data.action) {
			case "abrindo":
				$("body").show()
				startItem()
                Demente.init();
				break;
		}
	});

});

var Demente = {}
Demente = {
	init: function () {
		document.onkeyup = function (data) {
			if (data.which == 27) {
				$("body").hide()
				$.post("http://elite_wanted/ButtonClick", JSON.stringify({ action: "quebrou", pontos:0 }));
			}
		}
	}
}
