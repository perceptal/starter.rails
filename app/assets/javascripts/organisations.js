app.organisations = (function() {
	return {
		init: function() {
			app.search.bind_selection();
			app.utils.first_focus();
		},
		
		"new": function() {
			app.utils.first_focus();
		}
	};
})();	
