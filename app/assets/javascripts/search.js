app.search = (function() {
	return {
		init: function() {
			var q = app.utils.get_parameter_by_name("q");

			app.utils.highlight($("section#main .content"), q);
			app.menu.click(".paging a");
			this.bind_selection();	
		},
		
		index: function() {
			$("input#patient").focus();
		},
		
		bind_selection: function() {
			var item = $("section#main article.search");
			
			item.find(".open a").click(function(e) { e.preventDefault(); });

			item.click(function() {	
				var $item = $(this);
				var $resource = $item.find(".resource");
				
				var uri = $item.find(".open a").attr("href");
				var resource = $resource.data("resource").toLowerCase();
				var area = $resource.data("area");
				
				if (area === undefined) area = resource;
				
				app.menu.navigate(uri, { area: area.toLowerCase(), controller: resource, action: "index" });
			});
		}
	};
})();	
