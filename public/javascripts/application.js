// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function(){
  var width = 500;

  var pathname = jQuery(location).attr('pathname') || window.location.pathname;
  if (pathname == '/activity/new' || pathname == '/activity/new/') width = 425;

  resize_videos(width);

  jQuery('a[disabled]').die().unbind().attr('href', 'javascript:void(0);').attr('onclick', '');

  initDropdown('#account_button', '#account_dropdown')
  initDropdown('#signin_button', '#signin_dropdown')
});

function initDropdown(button_id, dropdown_id){
  jQuery(button_id).click(function(){
    jQuery(dropdown_id).toggle();
  });

  jQuery('body').click(function() {
    if(jQuery(dropdown_id).is(':visible')){
      jQuery(dropdown_id).hide();          
    }
  });

  jQuery(button_id + ', ' + dropdown_id).click(function(event){
    event.stopPropagation();
  });
}

function post_comment(form_id) {
  jQuery('#' + form_id + ' .update_progress').show();
  jQuery('#' + form_id + ' button').attr('class', 'button_gr').attr("disabled", "true");
}

function next_comments_block(link) {
  return $(link).up('span').up('div.right').next('.comments_container');
}

//TODO: remove this later
function show_next_comments_block(link) {
  $(link).up('div').down('.show_link').hide();
  $(link).up('div').down('.hide_link').show();
  div = next_comments_block(link);
  div.show();
  input = div.down("textarea");
  input.focus();
}

function hide_next_comments_block(link) {
  $(link).up('div').down('.show_link').show();
  $(link).up('div').down('.hide_link').hide();
  div = next_comments_block(link);
  div.hide();
}

function show_comments_block(block_id) {
  var comments_block = jQuery('#' + block_id);
  comments_block.parent().find('.show_link').hide();
  comments_block.parent().find('.hide_link').show();
  comments_block.show();
  comments_block.find('textarea').focus();
}

function hide_comments_block(block_id) {
  var comments_block = jQuery('#' + block_id);
  comments_block.parent().find('.show_link').show();
  comments_block.parent().find('.hide_link').hide();
  comments_block.hide();
}


function toggleDiv(divid, linkid) {
  var div = document.getElementById(divid);
  var linkele = document.getElementById(linkid);
  div.style.display = div.style.display == 'inline' ? 'none' : 'inline';
  linkele.style.display = linkele.style.display == 'inline' ? 'inline' : 'none';
}

// BA Invite friends wizard
function create_new_div(id){
  if(jQuery("#"+id).size() == 0){
    newdiv = document.createElement("div");
    newdiv.setAttribute("id",id);
    newdiv.setAttribute("style","display: none;");
    document.body.appendChild(newdiv);
  }
}

function cleanup_ovr(nongrata){ //we hide all overlays except 'nongrata'
    jQuery(".overlay_waitindicator").hide();
    ovr_list = [ 'add_friends_overlay', 'select_followed_overlay', 'thank_you_overlay', 'externals_to_invite_overlay' ];
    for(i=0;i<ovr_list.length;i++){
      if(nongrata != ovr_list[i]){
        jQuery('#'+ovr_list[i]).dialog('destroy');
        jQuery('#'+ovr_list[i]).empty();
      }
    }
  }
//

/*
moves an element in a drag and drop list one position up
*/
function moveElementUpforList(list, key) {
  var sequence=Sortable.sequence(list);
  var newsequence=[];
  var reordered=false;

  //move only, if there is more than one element in the list
  if (sequence.length>1) for (var j=0; j<sequence.length; j++) {

    //move, if not already first element, the element is not null
    if (j>0 &&
      sequence[j].length>0 &&
      sequence[j]==key) {

      var temp=newsequence[j-1];
      newsequence[j-1]=key;
      newsequence[j]=temp;
      reordered=true;
    }

    //if element not found, just copy array
    else {
      newsequence[j]=sequence[j];
    }
  }

  if (reordered) Sortable.setSequence(list,newsequence);
    return reordered;

}

/*
moves an element in a drag and drop list one position down
*/
function moveElementDownforList(list, key) {
  var sequence=Sortable.sequence(list);
  var newsequence=[];
  var reordered=false;

  //move, if not already last element, the element is not null
  if (sequence.length>1) for (var j=0; j<sequence.length; j++) {

    //move, if not already first element, the element is not null
    if (j<(sequence.length-1) &&
      sequence[j].length>0 &&
      sequence[j]==key) {

      newsequence[j+1]=key;
      newsequence[j]=sequence[j+1];
      reordered=true;
      j++;
    }

    //if element not found, just copy array
    else {
      newsequence[j]=sequence[j];
    }
  }

  if (reordered) Sortable.setSequence(list,newsequence);
    return reordered;
}

/* for actionscript degbugging */
ACTIONSCRIPT_DEBUG = false;
function log (message) {
  if (ACTIONSCRIPT_DEBUG) {
    // log to console, use Firebug
    try {
      console.log (message);
    } catch (e) {
      //do nothing
    }
  }
}


// When link contains comment_item_nn anchor, highlight that comment
// Could be extended to higlight other elements, if desired
function highlightCurrent() {
  obj = document.location.hash.match(/comment_item_(\d+)/);
  if (obj) {
    $('comment_item_'+obj[1]).addClassName('js_highlighted');
    // The above should be enough to dynamicall define CSS styles, but it's not working, so...
    $$('.js_highlighted .comment_header')[0].style.backgroundColor = '#FDF1C6';
    $('comment_item_'+obj[1]).scrollTo();
  }
}
Element.observe(window, 'load', highlightCurrent);

// If page has an element with ID top_password, clears background on focus
// (standard background is 'password' image)
function clearPasswordBg(el) {
  // Toggle password field label and type to password
  if(el.type == "text") {
    if (Prototype.Browser.IE) {
      $(el).hide().remove();
      $("top_password_clone").show();
      $("top_password_clone").focus();
    } else {
       el.type = 'password';
       el.value = '';
       el.focus();
    }
  }
}
function activate_wonder_menu () {
  $$(".wonder_menu").each(function(menu){
    $(menu).observe("mouseover", function() {
      menu.addClass("hovered");
    });
    $(menu).observe("mouseout", function() {
      menu.removeClass("hovered");
    });
  }, this);
}

Element.observe(window, 'load', activate_wonder_menu);


function findPosition( obj ) {
  if( typeof( obj.offsetParent ) != 'undefined' ) {
    for( var posX = 0, posY = 0; obj; obj = obj.offsetParent ) {
      posX += obj.offsetLeft;
      posY += obj.offsetTop;
    }
    return [ posX, posY ];
  } else {
    return [ obj.x, obj.y ];
  }
}

function position_modal_box (id) {
  var window_size = document.viewport.getDimensions();
  var offsets = document.viewport.getScrollOffsets();
  var box = $(id);
  var box_size = box.getDimensions();

  // box.toggleClassName("modal_viewing");
  // box.toggle();

  var box_top  = (window_size.height - offsets[0])/3 - box_size.height/2
  var box_left = (window_size.width - offsets[1])/2 - box_size.width/2

  box.setStyle({top: box_top + "px", left: box_left + "px"});
}

function modal_box (id, show_or_hide) {
  var box = $(id);
  position_modal_box(box);
  if (show_or_hide == "show") box.show();
  else box.hide();
}

function ask_for_password (elements) {
  $$(".password_validate_form").each(function(form){
    elements_list = []
    $A(elements).each(function(arg, index){
      var el = form.down("input[name*="+ arg +"]");
      el.writeAttribute("old_val", el.value);
      elements_list.push(el);
    });
    window.elements_list = elements_list;
    form.observe("submit",function(e) {
      var should_validate = elements_list.any(function(el) {return el.value != el.readAttribute("old_val");});
      if ( should_validate && $("validate_password").down("input").value == "") {
        Event.stop(e);
        $("validate_password").show();
      };
    }, this);
  }, this);
}


// For Share on Facebook links. See http://www.facebook.com/share_partners.php
function fbs_click() {
  u=location.href;
  t=document.title;
  window.open('http://www.facebook.com/sharer.php?u='+encodeURIComponent(u)+'&t='+encodeURIComponent(t),'sharer','toolbar=0,status=0,width=626,height=436');
  return false;
}

function clickable_textentries () {
  $$(".gallery_textentry").each(function(te){

    te.observe("click", function() {
        var url = te.down(".gallery_text_link").href;
        window.location = url
    });
  }, this);
}

Event.observe(window, "load", clickable_textentries)

// http://ecmanaut.blogspot.com/2006/07/encoding-decoding-utf8-in-javascript.html
function encode_utf8( s ) {
  return unescape( encodeURIComponent( s ) );
}
function decode_utf8( s ) {
  return decodeURIComponent( escape( s ) );
}

function clean_form(form_selector) {
  jQuery(':input', form_selector)
   .not(':button, :submit, :reset, :hidden')
   .val('')
   .removeAttr('checked')
   .removeAttr('selected');
}

function resize_videos(max_width) {
  jQuery('object, object > embed, .video_container > object, .video_container > object > embed, .video_container > embed, .video_container > iframe, iframe[src*="vkontakte"], iframe[src*="youtube"], iframe[src*="video"], iframe[src*="embed"]').each(function() {
    var width = jQuery(this).attr('width');
    var height = jQuery(this).attr('height');

    if (width > max_width) {
      var new_height = (max_width * height) / width;
      if (new_height == 0) new_height = max_width * 3 / 5;
      jQuery(this).attr('width', max_width);
      jQuery(this).attr('height', Math.round(new_height));
    }
  })
}

function resize_textentry_images(max_width, selector) {
  if (selector != null && selector != '') selector = selector + " img";
  else selector = '.main_body .wellspaced img';
  jQuery(selector).each(function() {
      var width = jQuery(this).attr('width');
      var height = jQuery(this).attr('height');
      var src =  jQuery(this).attr('src');

      var insert = this;
      var parent = this.parentNode;
      if (parent.tagName == "A") insert = parent;
      
      if (width > max_width) {
          var new_height = (max_width * height) / width;
          if (new_height == 0) new_height = max_width * 3 / 5;
          jQuery(this).attr('width', max_width);
          jQuery(this).attr('height', Math.round(new_height));
          jQuery('<div class="centered textentry_image_origin_size_link">\n\
            <a target="new" href="' + src + '">\n\
                <img border="0" src="/images/img_download.gif" alt="Img_download"> View Original Size (' + width + ' X ' + height + ')\n\
            </a>\n\
        </div>').insertAfter(insert);
      }
  })
}

