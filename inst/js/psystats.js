// Extra stuff for hiding and showing asides

$(function() {
	$(".aside").append(" &#9432;");

	$(".aside").click(function(e) {
		$(this.hash).toggle();
		e.preventDefault();
	});
});
