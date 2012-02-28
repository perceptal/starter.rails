app.searching = (function() {
	var sidebar_template = app.utils.load_template("search/sidebar.html");
	var paging_template = app.utils.load_template("search/paging.html");
	
	function search_after_delay(input, delay, callback) {
		var timer = null;
		input
			.attr("autocomplete", "off")
			.keyup(function() {
				if (timer) {
					window.clearTimeout(timer);
				}
				timer = window.setTimeout(function() {
					timer = null;
					callback();
	      }, delay );
	  });
	  input = null;
	}
	
	function search(input, url, area, template, retain, param, q, p) {
		if (q.length === 0) return;
		
		input.addClass("searching");

		var querystring = param + "=" + q;
		if (p) querystring += "&p=" + p;
		
		var controller = $("body").attr("data-controller");
		if (controller == "patients" || controller == "staff") {
			querystring += ("&t=" + controller);
		}
		
		var main = $("section#main");
		app.dialog.hide();
		var header = $("section#main header");

		$.ajax({
			url: url,
			dataType: "json",
			type: "get",
			data: querystring
		})
		.success(function(data) {
			var results = data.results;
			
			if (data.total == 1 && results[0].resource !== undefined) {
				var resource = results[0].resource.toLowerCase();
				app.menu.navigate(results[0].uri, { area: resource, controller: resource, action: "index" });
			}
			else {				
				if (data.total > 0) {
					if (!retain) display_sidebar(q, sidebar_template);

					fix_environment(area);
					display_results(main, header, retain, data, q, template);
					app.search.bind_selection();
					bind_paging(input, url, area, template, retain, param, data);
				}
				
				if (!p) {
					var message = build_message(data, q);
					app.dialog.set_message(message.text, message.type);
				}
			}
		})
		.error(function(status) {
			console.log(status);
			
			if (status.status == 503) {
				app.dialog.set_message(I18n.t("search.index.secure"), "warning");
			}
			else {
				app.dialog.set_message(I18n.t("error.application"), "error");
			}
		})
		.complete(function() { 
			input.removeClass("searching"); 
		});
	}

	function display_sidebar(q, sidebar_template) {
		$("aside#sidebar")
			.html($.tmpl(sidebar_template, { query: q }));	
	}

	function display_results(main, header, retain, data, q, template) {
		main.empty();
		
		if (retain) {
			main.append(header);
			app.menu.init_sub_menu("#main header");
			app.utils.init_search();
		}
		
		main
			.append($.tmpl(paging_template, data))
			.append($.tmpl(template, data.results))
			.append($.tmpl(paging_template, data));
			
		app.utils.highlight(main.find(".content"), q);	
	}
	
	function bind_paging($input, url, area, template, retain, param, data) {
		$(".paging a.next").click(function(e) {
			e.preventDefault();
			search($input, url, area, template, retain, data.query, param, data.page + 1);
		});
		
		$(".paging a.previous").click(function(e) {
			e.preventDefault();
			search($input, url, area, template, retain, data.query, param, data.page - 1);
		});
	}

	function fix_environment(area) {
		$("nav > ul").attr("class", area);
		$("body").attr("class", area);
		$(document).attr("title", I18n.t("search.index.title") + " |" + $(document).attr("title").split("|")[1]);
	}

	function build_message(data, q) {
		var type = "info", message = data.total + I18n.t("search.index.some_results");

		if (q.length === 0) {
			type = "error";
			message = I18n.t("search.index.error");
		}
		else if (data.total === 0) {
			type = "warning";
			message = I18n.t("search.index.no_results");
		}
		else if (data.total == 1) {
			message = I18n.t("search.index.one_result");
		}
		
		return { type: type, text: message };
	}
	
	return {		
		init: function($input, url, area, template, retain, param) {			
			search_after_delay($input, 1000, function() {
				search($input, url, area, template, retain, param, $input.val());
			});	
		}			
	};
})();



