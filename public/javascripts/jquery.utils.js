jQuery.fn.extend({
  scrollTo : function(speed, easing) {
    return this.each(function() {
      var targetOffset = jQuery(this).offset().top;
      jQuery('html,body').animate({scrollTop: targetOffset}, speed, easing);
    });
  }
});

jQuery.fn.minitabs = function(speed,effect) {
  id = "#" + this.attr('id')
  jQuery(id + " #tabs_content>div:gt(0)").hide();
  jQuery(id + ">div>span.tab>a:first").addClass("selected");
  jQuery(id + ">div>span.tab>a").click(
    function(){
      jQuery(id + ">div>span.tab>a").removeClass("selected");
      jQuery(this).addClass("selected");
      jQuery(this).blur();
      var re = /([_\-\w]+$)/i;
      var target = jQuery('#' + re.exec(this.href)[1]);
      var old = jQuery(id + " #tabs_content>div");
      switch (effect) {
        case 'fade':
          old.fadeOut(speed).fadeOut(speed);
          target.fadeIn(speed);
          break;
        case 'slide':
          old.slideUp(speed);  
          target.fadeOut(speed).fadeIn(speed);
          break;
        default : 
          old.hide(speed);
          target.show(speed)
      }
      return false;
    }
 );
}