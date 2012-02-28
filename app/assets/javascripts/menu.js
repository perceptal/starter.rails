app.menu = (function() {
	function set_title_and_address(url) {
		var title = get_title();
		$(document).attr("title", title);
		if (app.utils.supports_history()) {
			window.history.pushState(null, title, url);	
		}
	}

	function get_title() {
		title = unescape(escape($("h1").html()).replace("%u2192", "|"));
		title = title + $(document).attr("title").split("|")[1];

		return title;
	}

	function set_route(route) {
		$("body")
			.attr("class", route.area)
			.attr("data-controller", route.controller)
			.attr("data-action", route.action);
		
		$("nav:not('#security') ul").attr("class", route.area);
		$("nav:not('#security') ul").attr("data-area", route.area);
		
		$("nav#security ul").attr("class", route.controller);
	}
	
	function clear_search() {
		$("#search").val("");
	}
	
	return {
		click: function(selector) {
			$(selector).click(app.menu.on_click);
		},
		
		on_click: function(e) {
			e.preventDefault();
			e.stopPropagation();

			var link = $(this);
			var url = link.attr("href");
			
			if (url == "javascript:void(0);" || link.data("method") == "put" || link.data("method") == "delete") return;
			
			if ($("body").attr("data-password") !== undefined) {
				app.menu.navigate("/password", { area: "home", controller: "home", action: "password" });
			}
			else {		
				app.menu.navigate(url, determine_route(link));
			}
			
			function determine_route(link) {
				link.removeClass("active");
			
				var action = link.attr("class") || "index";
				var controller = link.parent().attr("id") || link.parent().attr("class") || $("body").attr("data-controller");
				var area = link.parent().attr("data-area") || link.parent().parent().attr("data-area") || controller;
				
				if (action.indexOf(",") >= 0) {
					action = action.substr(0, action.indexOf(","));
				}
				
				if (controller.indexOf(",") >= 0) {
					controller = controller.substr(0, controller.indexOf(","));
				}
				
				return { area: area.toLowerCase(), controller: controller.toLowerCase(), action: action.toLowerCase() };				
			}
		},
				
		navigate: function(url, route) {
			var content = $("#content");

			app.utils.show_spinner();

			$.ajax({
				url: url,
				dataType: "html",
				type: "get"
			})
			.success(function(data) {
				app.menu.display(content, data, route, url);
			})
			.error(function(status) {
				console.log(status);
				
				// Redirect to signin				
				if (status.status == 401) {
					window.location = "sign_in";
				}
				else if (status.status == 500) {
					app.menu.display(content, status.responseText, route, url);
				} else {
					var message = "Error";
					if (status.status == 404) message = I18n.t("error.not_found");
					
					app.dialog.set_message(message, "error");
					
					// Unbind navigation?

					app.utils.hide_spinner();
				}
			})
			.complete(function() { app.utils.set_response_time(); });		
		},
		
		display: function(content, data, route, url) {
			app.dialog.hide();
			
			content.html(data);	
			
			set_route(route);	
			set_title_and_address(url);
			clear_search();
			
			app.utils.init_page(false);
			app.utils.init_controller(route);

			app.utils.hide_spinner();			
		},
		
		init_sub_menu: function(selector) {
			var header = $(selector); 
			
			if (header.length > 0) {
				set_heading("pages", "actions");
				set_heading("actions", "pages");

				bind_hover("pages", "actions");
				bind_hover("actions", "pages");

				app.menu.click(selector + " nav.pages ul a");
				app.menu.click(selector + " nav.actions ul a");
				app.menu.click(selector + " div.root nav a");
			}

			function set_heading(menu, other) {
				var link = header.find("nav." + menu + " > a");
				var selected = header.find("nav." + menu + " ul a.active");
				
				if (selected.length === 0) {
					var active = header.find("nav." + other + " ul a.active");
					
					if (active.length > 0) {
						selected = header.find("nav." + menu + " ul li." + active.parent().attr("class") + " a");					
					}
					
					if (selected.length === 0) {
						selected = header.find("nav." + menu + " ul a:first");
					}	
				}
				else {
					link.addClass("active");
				}
				
				link.html(selected.html());
				
				if (selected.length > 1) selected = $(selected[0]);	// Only trigger first "selected"
				link.click(function() { selected.trigger("click"); });
			}		

			function bind_hover(show, hide) {			
				var menu = header.find("nav." + show + " ul");
				
				header.find("nav." + show).hover(
					function() {
						header.find("nav." + hide + " ul").hide();
						menu.css("display", "table");	
						menu_display_hack();
				},function() {
						menu.hide();
						menu_display_hack();
				});
			}

			function menu_display_hack() {
				header.removeClass("hack");
				if (header.find("nav.pages ul").is(":visible")) {
					header.addClass("hack");				
				}
			}
		}
	};
})();

