$(document).ready(function () {
	$('.sidebar').find("li.parent ul").hide();
	$('.sidebar li.parent label').click(function () {
		if ($(this).children("span.symbol").hasClass('fa-angle-right')) {
			$(this).children("span.symbol").removeClass('fa-angle-right');
			$(this).children("span.symbol").addClass('fa-angle-down');
		} else {
			$(this).children("span.symbol").removeClass('fa-angle-down');
			$(this).children("span.symbol").addClass('fa-angle-right');
		}
		$(this).parent().children("ul").toggle(0);
	});
	$('.sidebar').find("a.active").parent().addClass("active");
});