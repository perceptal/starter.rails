app.locations = (function() {
	function setup_address_transfer() {
		$("input#organisation").click(function() { 
			if ($(this).is(":checked")) {
				$("input#group_address_line_1").val($("input#group_group_address_line_1").val());
				$("input#group_address_locality").val($("input#group_group_address_locality").val());
				$("input#group_address_area").val($("input#group_group_address_area").val());
				$("input#group_address_country").val($("input#group_group_address_country").val());
				$("input#group_address_postcode").val($("input#group_group_address_postcode").val());
			}
			else {
				$("input#group_address_line_1").val("");
				$("input#group_address_locality").val("");
				$("input#group_address_area").val("");
				$("input#group_address_country").val("");
				$("input#group_address_postcode").val("");
			}
		});
	}
	
	return {
		init: function() {
			$("article.item").setup_list();
			app.menu.click("article.item a.edit");
			app.menu.click("article.item a.new");

			app.utils.table("destroy");
			app.utils.table("edit");
		},

		"new": function() {
			setup_address_transfer();
			app.utils.first_focus();	
		},

		edit: function() {
			setup_address_transfer();
			app.utils.first_focus();	
		}
	};
})();	
