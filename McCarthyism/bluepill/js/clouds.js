function moveClouds(e, s, d) {
    $(e).css('right', '-20%');
        var wait = window.setTimeout(function(){
            $(e).animate ({
                right: '120%'
            }, s, 'linear', function() {
            moveClouds(e, s, d);
        });
    },d);
}

if(!Modernizr.cssanimations) {
    var clouds = [1,2,3,4,5,6,7,8,9,10,11,12];
		    
    $.each(clouds, function() {
        var e = $('.cloud-' + this);
        moveClouds(e, e.data('speed'), e.data('delay'));
    });
}