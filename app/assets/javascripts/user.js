app.user = (function() {
	return {
		init: function() {
		},

		dashboard: function() {
			app.search.bind_selection();
		},

		password: function() {
			$("input#existing").focus();		
		}
	};
})();	
