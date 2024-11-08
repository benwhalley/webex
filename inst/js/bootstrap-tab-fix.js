$(document).ready(function () {
    // jump to anchor in hash even if it is a bootstrap tab
    url = document.location.href;
    toshow = window.location.hash.split("#")[1];
    // should prob check this is actually a bs tab or tab body before doign this
    $("#" + toshow).click();

    // by default, bootstrap doesn't push the hash of specific tabs when switching...
    // do this too and then urls can be copied from the browser bar
    $(".nav-tabs a").on("shown.bs.tab", function (e) {
      // requires that tab element ids end in "-tab"
      history.pushState(null, null, e.target.hash + "-tab");
    });

    // append index link
    // XXX todo fix this so it only does for main menu not submenu
    if (!document.location.href.endsWith("index.html")) {
      $("#toc ul").append(
        '<li><a href="index.html"><small>⏎ return to the index</small></a></li>'
      );
    }
});
