app.staff = (function() {
	return {
		init: function() {
			app.search.bind_selection();
			app.menu.click(".paging a");
			app.utils.first_focus();
		},

		"new": function() {
			app.utils.first_focus();
		},

		password: function() {
			$("form.formtastic input[type='password']:first").focus();
		}
	};
})();	
