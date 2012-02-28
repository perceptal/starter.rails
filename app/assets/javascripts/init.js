$().ready(function() {
	app.utils.init_page(true);

	// Hook up all navigation links to use ajax
	app.menu.click("header h2 a");
	app.menu.click("nav#security li.sessions a");
	app.menu.click("nav#menu a");
	
	// Enable ajax search
//	app.searching.init($("input#search"), "/search.json", "search", 
//		app.utils.load_template("search/person.html"), false, "q");
		
	// Initialise controller-specific scripts
	var body = $("body");
	app.utils.init_controller({
		controller: body.attr("data-controller"), action: body.attr("data-action") });
});
