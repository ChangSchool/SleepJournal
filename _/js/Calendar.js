
var des = des || {};

des.Calendar = des.Calendar || function(elem) {
	
	var $container, $rows, $cells, _week, _day, keys, i, l, init, selectDate;
	
	_week = arguments[1] || 0;
	_day = arguments[2] || 0;
	keys = keyCodes();
	
	init();
	
	function init() {
		var $d, $r;
		$container = $("#" + elem).addClass("cal").attr("role", "grid");
		$rows = $container.find("tbody").attr("role", "rowgroup").find("tr").attr("role", "row");
		$cells = $container.find("tbody td");
		$d = $container.find("td[tabindex=0]");
		$r = $d.parents("tr");
		if ($d.length > 0) {
			_day = $r.find("td").index($d);
			_week = $rows.index($r);
		} else {
			_day = 0;
			_week = 0;
		}
		
		selectDate(_week, _day);
		
		$cells.on("keydown", function(e) {
			var newCell, newRow;
			switch (e.keyCode) {
				case keys.enter:
				case keys.space:
					document.location.href = "entry.cfm?d=" + $(this).data("date");
					e.preventDefault();
					return false;
				case keys.right:
					if (_day == 6) {
						if (_week == $rows.length - 1) {
							return false;
						} else {
							_week = ++_week;
							_day = 0;
						}
					} else {
						_day = ++_day;
					}
					selectDate(_week, _day, true);
					return false;
				case keys.left:
					if (_day == 0) {
						if (_week == 0) {
							return false;
						} else {
							_week = --_week;
							_day = 6;
						}
					}else {
						_day = --_day;
					}
					selectDate(_week, _day, true);
					e.preventDefault();
					return false;
				case keys.up:
					if (_week > 0) {
						_week = --_week;
					}
					selectDate(_week, _day, true);
					e.preventDefault();
					return false;
				case keys.down:
					if (_week < $rows.length -1 ) {
						_week = ++_week;
					}
					selectDate(_week, _day, true);
					e.preventDefault();
					return false;
			}
		}).on("click", function(e) {
			document.location.href = "entry.cfm?d=" + $(this).data("date");
			e.preventDefault();
			return false;
		});
	}
	
	function selectDate(week, day) {
		var $date, focused;
		focused = arguments[2] || false;
		_week = week;
		_day = day;
		$cells.attr({"aria-selected": "false", "tabindex": -1});
		$date = $($rows[week]).find("td").eq(day);
		$date.attr({"aria-selected": "true", "tabindex": 0});
		if (focused) $date.focus();
	}
	
	function keyCodes() {
		return {
			tab: 9,
			enter: 13,
			esc: 27,
			space: 32,
			left: 37,
			up: 38,
			right: 39,
			down:  40
		};	
	}
	
	return {
		
	};
}