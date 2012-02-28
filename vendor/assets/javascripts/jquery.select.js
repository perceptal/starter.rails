(function($) {
  $.fn.customise_select = function(options) {
    var iOS = (navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i)) || (navigator.userAgent.match(/iPad/i)),
        android = (navigator.userAgent.match(/Android/i)),
        UP = 38, DOWN = 40, SPACE = 32, RETURN = 13, TAB = 9,
        matchString = '';

    // Sync custom display with original select box and set selected class and the correct <li>
    var update_select = function() {
      var $this = $(this),
          $dropdown = $this.siblings('.sb-dropdown'),
          $sbSelect = $this.siblings('.sb-select');
          
			if (this.selectedIndex >= 0) {
				var text = "";
				var item = this[this.selectedIndex];
				
				text = item.innerHTML;
	      $sbSelect.val(text);
	
				if (text !== "") {
					$items = $dropdown.children().removeClass('selected')
						.filter(':contains(' + text + ')');
				
					$items.each(function() {
						if ($(this).text() === text) {
							$(this).addClass('selected');
						} 
					});
				}
			}
		};
		
		var select_option = function($options) {
			if ($options.length > 0) {
				$options.parent().find('option').attr('selected', false);
				$options.attr('selected', true);
			}
		};

    // Update original select box, hide <ul>, and fire change event to keep everything in sync
    var dropdown_selection = function(e) {
      var $target = $(e.target),
          $options = $target.closest('.sb-custom').find('option').filter(':contains(' + $target.text() + ')');
          
      e.preventDefault();

			select_option($options);
      
			$target.closest('ul').hide();
      $options.parent().trigger('change');

			e.stopPropagation();
		};
    
    // Create the <ul> that will be used to change the selection on a non iOS/Android browser
    var create_dropdown = function($select, $input) {
      var $options = $select.children(),
          $dropdown = $('<ul class="sb-dropdown"/>');

			if ($input.is(':visible')) {
				$dropdown.css('width', $input.outerWidth() + 'px');
			}
			
      $options.each(function() {
				if ($(this).attr("combo") === undefined) {
					var className = this.className ? ' class="' + this.className + '"' : ''; 
					$dropdown.append('<li' + className + '><a href=".">' + $(this).text() + '</a></li>');
				}
      });
      $dropdown.bind('click', dropdown_selection);
      
      return $dropdown;
    };
    
    // 
    var set_text_entry = function(e) {
			var text = $(this).val();
			
			select_option($(this).closest('.sb-custom').find('option[combo=true]').text(text).val(text));
			$(this).closest('.sb-custom').find('.sb-dropdown').hide();
    };

    // Clear keystroke matching string and show dropdown
    var view_list = function(e) {
      var $this = $(this);
      clear();

			var $dropdown = $this.closest('.sb-custom').find('.sb-dropdown');

			if ($dropdown.is(':visible')) {
				$dropdown.hide();
			}
			else {
				$('.sb-dropdown').hide();
				$dropdown.show();
			}
      
      e.preventDefault();
    };
    
    // Hide the custom dropdown
    var hide_dropdown = function(e) {
      if (!$(e.target).closest('.sb-custom').length) {
				$('.sb-dropdown').hide();
      } 
    };
    
    // Manage keypress to replicate browser functionality
    var select_keypress = function(e) {
      var $this = $(this),
          $current = $this.siblings('ul').find('.selected');
      
      if ((e.keyCode == UP || e.keyCode == DOWN || e.keyCode == SPACE) && $current.is(':hidden')) {
        $current.focus();
        return;
      }
      
      if (e.keyCode == UP && $current.prev().length) {
        e.preventDefault();
        $current.removeClass('selected');
        $current.prev().addClass('selected');
      } else if (e.keyCode == DOWN && $current.next().length) {
        e.preventDefault();
        $current.removeClass('selected');
        $current.next().addClass('selected');
      }
      
      if (e.keyCode == RETURN || e.keyCode == SPACE) {
        $current.trigger('click');
        return;
      }
      
      if (e.keyCode >= 48 && e.keyCode <= 90) {
        matchString += String.fromCharCode(e.keyCode);
        check_for_match(e);
      }
      
      if (e.keyCode == TAB && $current.is(':visible')) {
        e.preventDefault();
        $current.trigger('click');
        hide_dropdown(e);
      }
    };
    
    // Check keys pressed to see if there is a text match with one of the options
    var check_for_match = function(e) {
      
      var re = '/' + matchString + '.*/';
      
      $(e.target).siblings('ul').find('a').each(function() {
        if (this.innerHTML.toUpperCase().indexOf(matchString) === 0) {
          $(this).trigger('click');
          return;
        }
      });
    };
    
    // Clear the string used for matching keystrokes to select options
    var clear = function() {
      matchString = '';
    };

    this.each(function() {
      var $self = $(this);

			$self.hide();
			
			$self.siblings(".sb-select").remove();
			$self.siblings(".sb-custom").remove();
			
			var $input = $('<input type="text" class="sb-select" />');
			
      if ($self.data("combo") === undefined || $self.data("combo") === false) {
				$input.attr("readonly", true);
			}
			else {
				$($self.find('option')[0]).attr("combo", true);
						
				$input.bind("keyup", set_text_entry);
			}

			$self.attr("tabindex", -1)
        .wrap('<div class="sb-custom ' + ($self.attr('class') || '') + '"/>')
        .after($input)
        .bind('change', update_select);

      if (iOS || android) {
        $self.show().css({
          'display': 'block',
          'opacity': 0,
          'position': 'absolute',
          'width': '100%',
          'z-index': 1000
        });
      } else {
        
				if ($self.find('option').length > 0) {
					$self.next().bind('click', view_list).after(create_dropdown($self, $input));
				}
      }

      $self.trigger('change');
    });
    
    // Hide dropdown when click is outside of the input or dropdown
    $(document).bind('click', hide_dropdown);
    
		$('.sb-custom').find('.sb-select')
			.live('keydown', select_keypress);

		$('.sb-custom').bind('blur', clear);
		$('.sb-dropdown').live('focus', view_list);
    
    return this;
  };
})(jQuery);