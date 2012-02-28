app.save = (function() {
	function get_metadata(method) {
		var csrf_token = $("meta[name=csrf-token]").attr("content");
		var metadata = { _method: method, authenticity_token: csrf_token };
		
		return metadata;
	}
	
	function post(url, form_data, form) {
		$.post(url, form_data)
			.success(function(data) {
				window.scrollTo(0, 0);
				app.menu.display($("#content"), data, app.utils.get_route(), url);
			})
			.error(function(status) {
				console.log(status);
				app.dialog.set_message("Error", "error");
			})
			.complete(function() {
				$(".reveal-modal-bg").fadeOut(200);
				document.body.style.cursor = "default";

				if (form) {
					enable_button(form);
				}
			});
	}
	
	function disable_button(form) {
		document.body.style.cursor = "wait";

		var button = form.find("input[type='submit']");
		button.attr("data-value", button.val());
		button
			.attr("disabled", true)
			.val(button.attr("data-submit-message") || "Saving...");
	}
	
	function enable_button(form) {
		var button = form.find("input[type='submit']");

		button
			.attr("disabled", false)
			.val(button.attr("data-value") || "Save &rarr;");
	}
			
	return {
		init_post: function(first) {
			if (first === false) {
				$("form:not(.post)[data-validate]").validate();
			}
			
			$("form.post").submit(function() {
				disable_button($(this));
			});
			
			$("form:not(.post)").submit(function(e) {
				e.preventDefault();
				var form = $(this);
				
				var valid = true;

				if (form.attr("data-validate")) {
					var settings = window[form.attr("id")];
					valid = form.isValid(settings.validators);
				}
				
				if (valid) {
					disable_button(form);
					post($(this).attr("action"), $(this).serialize(), form);					
				}
			});
		},
		
		init_put_links: function() {
			$("a[data-method='put']").click(function(e) {
				e.preventDefault();
				e.stopPropagation();
				
				document.body.style.cursor = "wait";
				post($(this).attr("href"), get_metadata("put"));
			});
		},
		
		init_delete_links: function() {
			$("a[data-method='delete']").click(function(e) {
				e.preventDefault();
				e.stopPropagation();
				
				var url = $(this).attr("href");
				var message = $(this).data("message") || "Deleting...";
				var confirm = $(this).data("confirm") || "Are you sure you want to delete?";
				
				app.dialog.confirm(function() {					
					app.dialog.set_message(message, "loading");	
					document.body.style.cursor = "wait";
			
					post(url, get_metadata("delete"));
			
				}, confirm);
			});
		}
	};
})();	
