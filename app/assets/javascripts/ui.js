if (!String.prototype.startsWith){
	String.prototype.startsWith = function(text) {
		return !(this.toLowerCase().indexOf(text.toLowerCase()));
	};
}

$.fn.setup_list = function(options) {
	return this.each(function() {		
		var defaults = {};

		var opts = $.extend(defaults, options);		

		var $items = $(this);

		$items
			.hover(function() { 
				$(this).find(".links a").show(); }, function() { if (!$(this).hasClass("open")) { $(this).find(".links a").hide(); }});

		$items.filter(":not(.disabled)")
			.css({ cursor: "pointer" })
			.hover(function() { if (!$(this).hasClass("open")) $(this).find(".show").show(); }, function() { $(this).find(".show").hide(); })
			.click(function(e) {
				e.preventDefault();
				$this = $(this);
				$this.toggleClass("open").find(".detail").toggle();
				
				$this.find("input, select, textarea").click(function(e) { e.stopPropagation(); });
				$this.find(".show").hide().click(function(e) { e.preventDefault(); });
				if ($("body").data("action") != "print") {
 					$this.find(".hide").toggle().click(function(e) { e.preventDefault(); });
				}
				$this.find("a.no-nav").click(function(e) { e.stopPropagation(); });
			});
		
		$items.filter("[data-id='" + $("input#item_id").val() + "']").trigger("click");
		
		$("a.show_all").show().click(function(e) {
			e.preventDefault();
			$(this).hide();
			$("a.hide_all").show();

			$items.trigger("click");
		});
		
		$("a.hide_all").hide().click(function(e) {
			e.preventDefault();
			$(this).hide();
			$("a.show_all").show();

			$items.trigger("click");
		});
	});	
};

$.fn.tag_list = function(options) {	
	var create_hidden = function($input) {
		var name = $input.attr("name"),
				tags = $input.val();
		
		$input.attr("name", "").val("");
				
		return $("<input type='hidden'>")
			.attr("name", name)
			.attr("id", $input.attr("id") + "_hidden")
			.val(tags);
	};

	return this.each(function() {
		var defaults = {};

		var opts = $.extend(defaults, options);		

		var $input = $(this);

		$input
			.wrap($("<div class='taglist " + ($input.attr("class") || "") + "'/>"))
			.attr("autocomplete", "off")
			.before(create_hidden($input));
	});
};

$.fn.type_ahead = function(options) {
	var create_dropdown = function() {
    var $dropdown = $("<ul class='sb-dropdown'/>")
			.hide();
			
    return $dropdown;
  };

	var add_entries = function($input, data) {
		if (data.length === 0) return;

		if ($input.data("static")) {
			add_static_entries($input, data);
		}
		else {
			var $dropdown = $input.parent().find("ul");
			var display_field = $input.data("display") || "name";

			if (data.length == 1) {
				$dropdown.hide();
				$input.val(data[0][display_field]);
				$input.parent().find("input[type='hidden']").val(data[0].id).change();
			}
			else {
				$dropdown.find("li").remove();

				$.each(data, function(i, item) {
					var $entry = $("<li data-id='" + item.id + "'><a href='#'>" + item[display_field] + "</a></li>")
						.bind("click", dropdown_selection);
					$dropdown.append($entry);			
				});
				
				$dropdown.show();
			}
		}
	};
	
	var add_static_entries = function($input, data) {
		var $dropdown = $input.parent().find("ul");
		$dropdown.find("li").remove();
		
		var search = $input.val();
		var matched = 0;
		var found;
		
		$.each(data, function(i, item) {
			if (item.startsWith(search)) {
				found = item;
				matched++;

				var $entry = $("<li data-id='" + item + "'><a href='#'>" + item + "</a></li>")
					.bind("click", dropdown_selection);				
				$dropdown.append($entry);
			}		
		});
		
		if (matched == 1) {
			$input.val(found);
			$dropdown.hide();		
		}
		else if (matched > 1) {
			$dropdown.show();
		}
	};

  var dropdown_selection = function(e) {
		var $item = $(this);
		var $dropdown = $item.parent().hide();
		var $wrapper = $dropdown.parent();
		
		var $hidden = $wrapper.find("input[type='hidden']");
		$hidden.val($item.data("id")).change();
		
		var $input = $wrapper.find("input[type='text']");
		$input.val($item.text());
		
    e.preventDefault();
		e.stopPropagation();
  };

	var search_after_delay = function($input, delay, callback) {
		var timer = null;
		$input
			.keyup(function() {
				if (timer) {
					window.clearTimeout(timer);
				}
				timer = window.setTimeout(function() {
					timer = null;
					callback();
	      }, delay );
	  });
	};

	var search = function($input) {
		var q = $input.val();
		
		if (q.length === 0) {
			$input.parent().find("input[type='hidden']").val("").change();
			return;
		}
		
		var url = add_parameter($input.data("typeahead"), "q", q);
		
		$input.addClass("searching");

		$.getJSON(url, function(data) { add_entries($input, data); })
			.complete(function() { $input.removeClass("searching"); })
			.error(function(status) { console.log(status); });
	};
	
	var add_parameter = function(url, param_name, param) {
		if (url.indexOf("?") == -1) {
			url = url + "?" + param_name + "=" + param;
		}
		else {
			url = url + "&" + param_name + "=" + param;			
		}
		
		return url;
	};
	
	var create_hidden = function($input) {
		if ($input.data("static")) return;
		
		var name = $input.attr("name"),
				id = $input.val();
		
		$input.attr("name", "").val("");
		
		if (id.length > 0) {
			var url = add_parameter($input.data("typeahead"), "id", id);

			$.getJSON(url, function(data) {
				$input.val(data[($input.data("display") || "name")]);
			});
		}
		
		return $("<input type='hidden'>")
			.attr("name", name)
			.attr("id", $input.attr("id") + "_hidden")
			.val(id);
	};
	
	return this.each(function() {		
		var defaults = {};

		var opts = $.extend(defaults, options);		

		var $input = $(this);

		$input
			.wrap($("<div style='" + ($input.attr("style") || "") + "' class='sb-custom " + ($input.attr("class") || "") + "'/>"))
			.addClass("sb-select")
			.addClass("typeahead")
			.attr("autocomplete", "off")
			.after(create_dropdown())
			.before(create_hidden($input));

		search_after_delay($input, 500, function() {
			search($input);
		});		
	});		
};

$.fn.custom_checkbox = function(options) {
	return this.each(function() {
		var defaults = {
		};

		var opts = $.extend(defaults, options);		
	});	
};

$.fn.text_area_resizer = function() {
	var textarea, static_offset;  
	var minimum = 32;
	var grip;

	return this.each(function() {
		textarea = $(this).addClass('processed');
		static_offset = null;

	  $(this).wrap('<div class="resizable-textarea"><span></span></div>')
			.parent().append($('<div class="grippie"></div>')
			.bind("mousedown", {el: this}, start_drag)
			.click(function(e) { e.preventDefault(); e.stopPropagation(); }));

	  var $grippie = $('div.grippie', $(this).parent())[0];
	  $grippie.style.marginRight = ($grippie.offsetWidth - $(this)[0].offsetWidth) + 'px';

		function start_drag(e) {
			textarea = $(e.data.el);
			textarea.blur();
			last_mouse_position = get_mouse_position(e).y;
			static_offset = textarea.height() - last_mouse_position;
			textarea.css('opacity', 0.25);
			$(document).mousemove(perform_drag).mouseup(end_drag);

			return false;
		}

		function perform_drag(e) {
			var mouse_position = get_mouse_position(e).y;
			var position = static_offset + mouse_position;
			if (last_mouse_position >= (mouse_position)) {
				position -= 5;
			}
			last_mouse_position = mouse_position;
			position = Math.max(minimum, position);
			textarea.height(position + 'px');
			if (position < minimum) {
				end_drag(e);
			}
			return false;
		}

		function end_drag(e) {
			$(document).unbind('mousemove', perform_drag).unbind('mouseup', end_drag);
			textarea.css('opacity', 1);
			textarea.focus();
			textarea = null;
			static_offset = null;
			last_mouse_position = 0;
		}

		function get_mouse_position(e) {
			return { x: e.clientX + document.documentElement.scrollLeft, y: e.clientY + document.documentElement.scrollTop };
		}
	});
};

