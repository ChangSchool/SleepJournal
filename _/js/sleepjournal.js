// JavaScript Document


document.createElement('header');
document.createElement('nav');
document.createElement('menu');
document.createElement('section');
document.createElement('article');
document.createElement('aside');
document.createElement('footer');

$(document).ready(function(){
	
});


/*

var des = des || {};
des.sleepjournal = {};
des.sleepjournal.calendar = (function($){
	
	var initialize, date, monthNames;
	
	monthNames = ["January","February","March","April","May","June","July","August","September","October","November","December"];
	
	initialize = function(y, m, $div) {
		var first, last, current, start, $date, i, total;
		first = new Date(y, m, 1);
		last = new Date(y, m + 1, 0);
		current = new Date(y, m, 1 - first.getDay());
		total = Math.ceil((first.getDay() + last.getDate()) / 7) * 7;
		i = 0;
		while (i < total) {
			$date = $("<a/>").html(current.getDate()).addClass("date").on("click", {d: current.getTime()}, function(e){
				window.location.href = "entry.cfm#" + e.data.d;
			});
			if (current.getMonth() != m) $date.addClass("disabled");
			if (i > 7 && i < 20) {
				if (i == 17) $date.addClass("missed")
					else $date.addClass("entered");
			}
			$div.append($date);
			current = new Date(current.setDate(current.getDate() + 1));
			i++;
		}
		$("<h2/>").text(monthNames[m] + " " + y).prependTo($div);
		$div.addClass("cal clearfix");
		
	};
	
	dateObject = function(d) {
		return {
			monthName: monthNames[d.getMonth()],
			date: d.getDate(),
			fullYear: d.getFullYear()
		};
	};
	
	return {
		init: initialize,
		dateObject: dateObject
	};
})(jQuery, undefined);

*/