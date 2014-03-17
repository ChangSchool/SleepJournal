
var des = des || {};

des.Tabs = des.Tabs || function(elem) {
	
	var $container, $tabbar, $tabs, $panels, _selectedIndex, keys, i, l, init, selectTab;
	
	_selectedIndex = arguments[1] || 0;
	
	init();
	
	function init() {
		$container = $("#" + elem).addClass("tabs");
		$panels = $container.children("div");
		$tabbar = $("<ul/>").attr("role","tablist").addClass("tabbar clearfix");
		
		for (i = 0, l = $panels.length; i < l; i++) {
			var $panel, $tab, lbl;
			$panel = $($panels[i]);
			lbl = $panel.attr("title");
			$panel.attr({
				id: "panel" + i,
				role: "tabpanel",
				"aria-hidden": "true"
			}).removeAttr("title").addClass("tabcontent");
			$tab = $("<li/>").attr({
				id: "tab" + i,
				role: "tab", 
				tabindex: -1,
				"aria-controls": $panel.attr("id")}
			).html(lbl);
			$tab.appendTo($tabbar);
		}
		
		$container.prepend($tabbar);
		$tabs = $tabbar.find("li");
		
		keys = keyCodes();
		
		selectTab(_selectedIndex);
		
		$tabs.blur();
		
		$tabs.on("click", function(e) {
			selectTab($(this).index($tabs));
		});
		$tabs.on("keydown", function(e) {
			var newInd, $panel;
			switch (e.keyCode) {
				case keys.right:
					newInd = ++_selectedIndex;
					if (newInd >= $tabs.length) newInd = _selectedIndex = 0;
					selectTab(newInd);
					e.preventDefault();
					break;
				case keys.left:
					newInd = --_selectedIndex;
					if (newInd < 0) newInd = _selectedIndex = $tabs.length - 1;
					selectTab(newInd);
					e.preventDefault();
					break;
				case keys.down:
					$panels.attr("tabindex", -1);
					$($panels[_selectedIndex]).attr("tabindex", 0).focus();
					console.log($panels[_selectedIndex]);
					e.preventDefault();
					break;
			}
		});
		$panels.on("keydown", function(e) {
			if (e.keyCode == keys.up) {
				$panels.attr("tabindex", -1);
				selectTab(_selectedIndex);
			}
		});
	};
		
	function selectTab(ind) {
		$panels.removeClass("selected").attr({"aria-hidden": "true", "tabindex": -1});
		$panels.eq(ind).addClass("selected").attr({"aria-hidden": "false", "tabindex": 0});
		$tabs.removeClass("selected").attr({'tabindex': -1, "aria-selected": "false"});
		$tabs.eq(ind).addClass("selected").attr({'tabindex': 0, "aria-selected": "true"}).focus();
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
		selectedIndex: _selectedIndex
	};
}