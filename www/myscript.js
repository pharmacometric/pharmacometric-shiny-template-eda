//include stylesheet if not included
var link = document.createElement( "link" );
link.href = "myscript.css";
link.type = "text/css";
link.rel = "stylesheet";
link.media = "screen,print";
document.getElementsByTagName( "head" )[0].appendChild( link );

document.addEventListener("DOMContentLoaded", function(){



//include shadow for cards if not included
document.querySelectorAll('.jarviswidget').forEach(function(e) {
   // e.className = e.className + " shadow"
});


})
