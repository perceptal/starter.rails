app.utils = (function() {
	return {
		init_page: function(first) {
			app.menu.init_sub_menu("#main header");
			this.init_form_style();
			this.init_tooltip();
			app.save.init_delete_links();
			app.save.init_put_links();
			app.save.init_post(first);
			app.dialog.show();
		},
				
		init_form_style: function() {
			$("select").customise_select();
			$("input:file").customise_file_input();
			$("input[data-typeahead]").type_ahead();
			$("input[data-taglist]").tag_list();
			$("input.date").datepicker();
			$("textarea:not(.processed)").text_area_resizer();
		},
		
		init_tooltip: function() {
			$("*[title]").tooltip();
		},
		
		supports_history: function() {
			return !!(window.history && window.history.pushState);
		},
		
		first_focus: function() {
			var $input = $("form.formtastic input[type='text']:first");
			if ($input.length > 0 && !$input.hasClass("date")) {
				$input.focus();
			}
			else {
				$("form.formtastic textarea:first").focus();
			}
		},
		
		table: function(link, no_clickthru) {
			$(".table")
				.css({ cursor: "pointer" })
				.hover(function() { $(this).find("a." + link).show(); }, function() { $(this).find("a." + link).hide(); });
			
			if (no_clickthru === undefined || no_clickthru === false) {
				$(".table").click(function() { $(this).find("a." + link).trigger("click"); });
			}
		},
		
		load_template: function(url) {
			var template;

			$.ajax({
				url: "/assets/tmpl/" + url,
				async: false,
				dataType: "html",
				success: function(data) {
					template = data;
				}
			});

			return template;
		},
		
		highlight: function(selector, q) {
			if (q && q.length > 0) {
				var regex;
				try { 
					regex = new RegExp(q, "ig");
				}
				catch (e) { return; }

				selector.highlight_regex(regex, { tagType: "em"});
			}
		},
		
		get_parameter_by_name: function(name) {
		  var match = RegExp('[?&]' + name + '=([^&]*)')
		    .exec(window.location.search);

		  return match && decodeURIComponent(match[1].replace(/\+/g, ' '));
		},
		
		init_controller: function(route) {
			if (app[route.controller]) {
				app[route.controller].init();
			}
			
			if (app[route.controller] && app[route.controller][route.action]) {
				app[route.controller][route.action]();
			}
		},	
		
		set_response_time: function() {
			$("#response").html($(".response").html());
		},
		
		get_route: function() {
			var body = $("body");
			var route = { 
				area: body.attr("class"), 
				controller: body.attr("data-controller"), 
				action: body.attr("data-action")
			};
			return route;
		},
		
		show_spinner: function() {
			$("nav#menu li.loading").fadeIn(200);
			document.body.style.cursor = "wait";
		},
		
		hide_spinner: function() {
			$("nav#menu li.loading").fadeOut(200);
			document.body.style.cursor = "default";
		}
	};
})();