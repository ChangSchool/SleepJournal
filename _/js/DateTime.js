// DateTime jQuery plugin for Sleep Journal

;(function ( $, window, document, undefined ) {
 
	// Create the defaults
	var pluginName = "DateTime",
		defaults = {
			currentDate: new Date(),
			selectedDate: new Date(),
			months: [
				{label: "January", days: 31},
				{label: "February", days: (new Date()).getFullYear() % 4 ? 28 : 29},
				{label: "March", days: 31},
				{label: "April", days: 30},
				{label: "May", days: 31},
				{label: "June", days: 30},
				{label: "July", days: 31},
				{label: "August", days: 31},
				{label: "September", days: 30},
				{label: "October", days: 31},
				{label: "November", days: 30},
				{label: "December", days: 31}]
		};
 
	// Plugin constructor
	function Plugin( element, options ) {
		this.element = element;
		this.options = $.extend( {}, defaults, options ? options : {}) ;
		this._defaults = defaults;
		this._name = pluginName;
		this.init();
	}
	
	// Initialize plugin
	Plugin.prototype.init = function () {
		var current, selected, today, tomorrow, d, h, m, a, $el, id, $formfield,
			$selectors, $date, $hour, $minute, $ampm;
		
		$el = $(this.element);
		
		/*if ($el.data("date")) {
			console.log($el);
			console.log($el.data("date"));
		}*/
		
		current = this.options.currentDate;
		selected = this.options.selectedDate;
		today = [current.getMonth() + 1, current.getDate(), current.getFullYear()].join("/");
		tomorrow = new Date(current.getFullYear(), current.getMonth(), current.getDate() + 1);
		tomorrow = [tomorrow.getMonth() + 1, tomorrow.getDate(), tomorrow.getFullYear()].join("/");
		
		// formfield
		$formfield = $("<input/>").attr({"type": "hidden", "name": "_" + $el.attr("id")}).addClass("dt_formfield");
		
		// selectors
		$date = $("<select/>").attr({"aria-label": "Select date"}).addClass("dt_date").on("change", {plugin: this}, onClickSelect);
		//$("<option/>").val(today).text(today).appendTo($date);
		//$("<option/>").val(today).text(tomorrow).appendTo($date);
		$("<option/>").val(today).text(this.options.months[current.getMonth()].label + " " + this.leadingZero(current.getDate())).appendTo($date);
		$("<option/>").val(tomorrow).text("Next day").appendTo($date);
		
		$hour = $("<select/>").attr({"aria-label": "Select hour"}).addClass("dt_hour").on("change", {plugin: this}, onClickSelect);
		for (var i = 1, l = 12; i <= l; i++) {
			$("<option/>").val(i).text(this.leadingZero(i)).appendTo($hour);
		}
		
		$minute = $("<select/>").attr({"aria-label": "Select minutes"}).addClass("dt_minute").on("change", {plugin: this}, onClickSelect);
		for (var i = 0, l = 60; i < l; i++) {
			$("<option/>").val(i).text(this.leadingZero(i)).appendTo($minute);
		}
		
		$ampm = $("<select/>").attr({"aria-label": "Select AM or PM"}).addClass("dt_ampm").on("change", {plugin: this}, onClickSelect);
		$("<option/>").val(0).text("AM").appendTo($ampm);
		$("<option/>").val(1).text("PM").appendTo($ampm);
		
		$selectors = $("<div/>").append(
			$("<span/>").addClass("css-select").append($date),
			$("<span/>").addClass("css-select").append($hour), 
			$("<span/>").addClass("css-select").append($minute), 
			$("<span/>").addClass("css-select").append($ampm));
		
		$el.find("select").wrap("<span></span>");
		
		$el.append($selectors, $formfield);
		
		d = [selected.getMonth() + 1, selected.getDate(), selected.getFullYear()].join("/");;
		h = selected.getHours();
		m = selected.getMinutes();
		if (h < 12) {
			h = (h == 0) ? 12 : h;
			a = 0;
		} else {
			h = (h == 12) ? h : h - 12;
			a = 1;
		}
		
		$date.val(d);
		$hour.val(h);
		$minute.val(m);
		$ampm.val(a);
		$formfield.val(this.formatDate(selected));
		
		function onClickSelect(e) {
			e.data.plugin.updateDisplay();
		};
		
	};
	
	
	Plugin.prototype.updateDisplay = function () {
		var $el = $(this.element),
			date = this.options.currentDate,
			d, h, m, a;
		
		d = $el.find(".dt_date").val();
		h = parseInt($el.find(".dt_hour").val());
		m = parseInt($el.find(".dt_minute").val());
		a = parseInt($el.find(".dt_ampm").val());
		
		d = new Date($el.find(".dt_date").val());
		d.setHours( a ? h + 12 : (h == 12) ? 0 : h);
		d.setMinutes(m);
				
		$(this.element).find(".dt_formfield").val(date = this.formatDate(d));
			
	};
	
	Plugin.prototype.formatDate = function (d) {
		return (this.leadingZero(d.getMonth()+1))+"/"+this.leadingZero(d.getDate())+"/"+d.getFullYear()+" "+
			this.leadingZero(d.getHours())+":"+this.leadingZero(d.getMinutes());
	};
	
	Plugin.prototype.leadingZero = function (n) {
		return n <= 9 ? "0" + n : n;
	};
	
	// Prevent initialization
	$.fn[pluginName] = function ( options ) {
		return this.each(function (ind, elem) {
			if ( !$.data(this, "plugin_" + pluginName )) {
				$.data( this, "plugin_" + pluginName,
				new Plugin( this, options ));
			}
		});
	}
 
})( jQuery, window, document );