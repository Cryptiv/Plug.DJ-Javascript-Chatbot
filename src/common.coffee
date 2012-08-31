lockBooth: ->
	$.ajax({
	    url: "http://www.plug.dj/gateway/room.update_options",
	    type: 'POST',
	    data: JSON.stringify({
	        service: "room.update_options",
	        body: ["dubstep-den",{"boothLocked":true,"waitListEnabled":true,"maxPlays":1,"maxDJs":5}]
	    }),
	    async: this.async,
	    dataType: 'json',
	    contentType: 'application/json'
	});

unlockBooth: ->
	$.ajax({
	    url: "http://www.plug.dj/gateway/room.update_options",
	    type: 'POST',
	    data: JSON.stringify({
	        service: "room.update_options",
	        body: ["dubstep-den",{"boothLocked":false,"waitListEnabled":true,"maxPlays":1,"maxDJs":5}]
	    }),
	    async: this.async,
	    dataType: 'json',
	    contentType: 'application/json'
	});