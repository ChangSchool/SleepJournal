// JavaScript Document


document.createElement('header');
document.createElement('nav');
document.createElement('menu');
document.createElement('section');
document.createElement('article');
document.createElement('aside');
document.createElement('footer');

$(document).ready(function(){
	/*$('a:not([target])').click(function(){
		self.location = $(this).attr('href');
		return false;
	});*/
	$("a").attr("target","_self");
	$(".required input").attr({"aria-required":"true"});
});

function userLogOut() {
	var form = document.forms["frmLogout"];
	//console.log(form);
	form.submit();
	return false;
}
function validateField(field, type, options) {
	var $p, $field, val, $error, eid, re, msg = "";
	$field = $("#" + field);
	val = $field.val();
	$p = $field.parents("p");
	$p.removeClass("invalid").find("span").remove();
	$field.attr({"aria-invalid":"false"}).removeAttr("aria-describedby");
	if ($field.attr("aria-required") && val == "") {
		msg = "This field is empty.";
	} else {
		switch(type) {
			case "email":
				re = new RegExp("^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$");
				if (val > "" && !re.test(val)) msg = "This is not a valid email address.";
				break;
			case "text":
				re = new RegExp("^." + "{" + (options.min || 0) + "," + (options.max && options.min < options.max ? options.max : "") + "}$");
				if (!re.test(val)) {
					if (options.max) {
						msg = "This value must be between " + options.min + " and " + options.max + " characters long.";
					} else if (options.min) {
						msg = "This value must be at least " + options.min + " characters long.";
					}
				}
				break;
			case "password":
				if (options.strong) {
					re = new RegExp("^.*(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%&_-]).*$");
					if (!re.test(val)) msg = "The password must contain at least one lowercase, one uppercase letter, one digit, and one of the following special characters (@, #, $, %, &, _, -).";
				}			
				re = new RegExp("^.{" + (options.min || 0) + "," + (options.max && options.min < options.max ? options.max : "") + "}$");
				if (!re.test(val)) {
					if (options.max) {
						msg = "This value must be between " + options.min + " and " + options.max + " characters long.";
					} else {
						msg = "This value must be at least " + options.min + " characters long.";
					}
				}
				
				break;
			case "compare":
				if ($("input[name=" + options.field + "]").val() != $field.val()) msg = "This value must match the value of " + options.label + " field.";
				break;
		}
	}
	if (msg > "") {
		eid = "err" + $field.attr("id");
		$p.addClass("invalid");
		$field.attr({"aria-invalid":"true", "aria-describedby":eid});
		$error = $("<span/>").addClass("error").attr("id", eid).text(msg);
		$p.remove("span.error").append($error);
		return 1;
	} else {
		return 0;
	}
}


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