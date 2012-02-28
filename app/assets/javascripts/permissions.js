app.permissions = (function() {	
	return {
		init: function() {
			app.edit.bind_inline();
		},

		"new": function() {
			app.utils.first_focus();
		}
	};
})();	
