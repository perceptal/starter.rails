app.dialog = (function() {
	var timer = null;
	
	function centre_and_show(dialog) {
		//dialog.drag(true);
		dialog.css({ top:($(window).scrollTop() + 175) + "px", left:"50%", margin:"-" + (dialog.height() / 2) + "px 0 0 -" + (dialog.width() / 2) + "px" });
		dialog.fadeIn(500);			
	}
		
	function hide_dialog(dialog) {
		if (timer) {
			window.clearTimeout(timer);
			timer = null;
		}
				
		if (dialog.find(".message:not(:empty)").length > 0) {
			dialog.hide();
			dialog.find(".message:not(:empty)").text("");
			dialog.find(".message").hide(); 
		}		
	}	
	
	function hide_after_delay(delay, callback) {
		if (timer) {
			window.clearTimeout(timer);
			timer = null;
		}
		timer = window.setTimeout(function() {
			timer = null;
			callback();
			}, delay 
		);
	}
			
	return {
		show: function() {
			var auto_hide = true;
			var dialog = $("#dialog");
			
			if (dialog.find(".message:not(:empty)").length > 0) {
				if (dialog.find(".loading:not(:empty)").length > 0) {
					auto_hide = false;
				}
				
				dialog.find(".message:not(:empty)").show();
				centre_and_show(dialog);
				dialog.find(".close").click(function() { app.dialog.hide(); });
			
				if (auto_hide === true) {
					hide_after_delay(10000, app.dialog.hide);				
				}
			}
		},
		
		hide: function() {
			hide_dialog($("#dialog"));
		},
		
		confirm: function(callback, question, yes, no) {
			this.hide();
			
			var dialog = $("#confirm");
			if (question) dialog.find(".message").text(question);
			if (yes) dialog.find(".yes").text(yes); 
			if (no) dialog.find(".no").text(no);
			
			dialog.find(".message").show();
			centre_and_show(dialog);
			
			dialog.find(".yes").click(function() {
				callback();
				hide_dialog(dialog);
			});
			
			dialog.find(".no").click(function() {
				hide_dialog(dialog);
			});
			
			$(document).keyup(function(e) {
				if (e.keyCode == 13 || e.keyCode == 27) {
					$(document).unbind("keyup");
					hide_dialog(dialog);
				}
				
				if (e.keyCode == 13) {
					callback();
				}
			});
		},
		
		set_message: function(message, type) {
			this.hide();
			
			$("#dialog").find("." + type).text(message);
			
			this.show();
		}	
	};
})();	
