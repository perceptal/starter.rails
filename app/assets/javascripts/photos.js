app.photos = (function() {
	return {
		init: function() {
			$(".image[title]").tooltip();
			
			$("img[data-image]").click(function() {
				
				$("#photo-modal img").attr("src", $(this).attr("data-image"));
				
				$("#photo-modal").reveal({
					animation: "fade", 
					animationspeed: 300, 
					closeonbackgroundclick: true
				});
			});
			
			$("form.post").submit(function(e) {
				document.body.style.cursor = "wait";
				app.dialog.set_message("Uploading photo...", "loading");
			});
		}
	};
})();	
