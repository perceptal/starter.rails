app.edit = (function() {
	var _modalBg;
	
	function modal() {
		_modalBg = $(".reveal-modal-bg");

		if (_modalBg.length === 0) {
			_modalBg = $("<div class='reveal-modal-bg' />").insertAfter($("body"));
			_modalBg.css({"cursor": "pointer"});
		}		
		
		return _modalBg;
	}
	
	function close() {
		if (document.activeElement) {
			$(document.activeElement).blur();
		}
		modal().fadeOut(200);
		view();
	}
	
	function edit(item) {
		item.addClass("active");
		item.find("form input[type='text']:first").focus();
		
		bind_keyboard(item);
	}
	
	function view() {
		$("section#main article.list").removeClass("active");
		$("body").unbind("keyup");
	}
	
	function bind_keyboard(item) {
		var index = parseInt(item.attr("data-index"), 10);
		
		item.find("select").keyup(function(e) {
			e.stopPropagation();
		});
		
		$("body").keyup(function(e) {
			switch(e.which) {
				case 13:
				case 27: 
					close();
					break;
					
				case 38:
					var previous = find_item_by_index(index-1);
					if (previous.length > 0) {
						view();
						edit(previous);
					}
					break;
					
				case 40:
					var next = find_item_by_index(index+1);
					if (next.length > 0) {
						view();
						edit(next);
					}
					break;
			}		
		});	
	}
		
	function find_item_by_index(index) {
		var item = $("section#main article.list[data-index=" + index + "]");
		return item;
	}
	
	return {
		bind_inline: function() {
			var items = $("section#main article.list");
			
			items.find("select").click(function(e) {
				e.stopPropagation();
			});
			
			items.click(function() {	
				var item = $(this);
				if (item.find(".edit").length > 0) {
					view();	

					app.dialog.hide();
					modal().fadeIn(200);
				
					edit(item);
				
					modal().bind("click.modalEvent", function() {
						close();
					});
				}
			});
		}
	};
})();	
