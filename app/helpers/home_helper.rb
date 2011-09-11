module HomeHelper

  def validate_signup_interview
    javascript_tag "
    function write_errors(errors) {
      var errors_contaner = jQuery('div#instance_errors');

      errors_contaner.html('');
      if (errors.length == 0) return;

      errors_contaner.html('\\
      <div class=\"errorExplanation\" id=\"errorExplanation\">\\n\\
        <h2>' + errors.length + ' errors prohibited this user from being saved</h2>\\n\\
        <p>#{'There were problems with the following fields'.t}:</p>\\n\\
        <ul><li>' +
          errors.join('</li><li>') +
        '</li></ul>\\n\\
      </div>');
    }

    function checkLoginName() {
      var errors = [];
      var value  = jQuery('#user_login, #user_login_fb').val()
      var regexp = /^[A-Za-z0-9]{1}[A-Za-z0-9-]*[A-Za-z0-9]{1}$/i;

      if (value.length <= 1) {errors.push('#{'Login too short'.t}')}

      else if (value.length > 30){errors.push('#{'Login too long'.t}')}

      else if (value.match(/^\d+$/)) {errors.push('#{'Login must contain at least one non-numeric character'.t}')}

      else if (!regexp.test(value)) {errors.push('#{'Login should only contain A-Z, a-z, 0-9 and - (NOTE: no spaces allowed!). It cannot start or end with -, and must contain at least one non-numeric character.'.t}')}

      else jQuery.get('/home/check_field_availability', { model : 'user', field : 'login', value : value} , function(data) {
        if (data == 'false') {
          var error = '#{'Sorry, login already taken'.t}'
          if (jQuery('div#instance_errors').html() == '') write_errors([error]);
          else jQuery('div#instance_errors ul').append('<li>' + error + '</li>')
          jQuery('html, body').animate({scrollTop: jQuery('#main_content_left').offset().top},'slow');
        }
      });

      write_errors(errors)
      if (errors.length > 0) {
        jQuery('html, body').animate({scrollTop: jQuery('#main_content_left').offset().top},'slow');
        return false;
      } else {
        return true;
      }
    }

    function checkCheckBoxes() {
      var errors = [];

      if (!jQuery('#tos').attr('checked')) {
        errors.push('#{'You must read and accept Terms of Service to create an account.'.t}')
      }

      if (jQuery('#user_is_artist_true').attr('checked') &&
          !jQuery('#user_artist_kind_single').attr('checked') && !jQuery('#user_artist_kind_project').attr('checked') &&
          !jQuery('#user_artist_kind_single_plus_project').attr('checked')) {
        errors.push('#{'Please choose which kind of Artist are you.'.t}')
      }

      var need_project_name = jQuery('#user_is_artist_true').attr('checked') &&
          (jQuery('#user_artist_kind_project').attr('checked') || jQuery('#user_artist_kind_single_plus_project').attr('checked'))
      if ( need_project_name && jQuery('#project_login').val() == '') {
        errors.push('#{'Please enter a project name.'.t}')
      }

      if (need_project_name && jQuery('#project_login').val() == jQuery('#user_login').val()) {
        errors.push('#{'Your Project Kroogi Name needs to differ from Personal Login.'.t}')
      }

      if (jQuery('#user_birthdate').val() == '') {
        errors.push('#{'Please enter Your Birthday.'.t}')
      }

      var age = 13;

      var instance = jQuery('#user_birthdate').data('datepicker');

      var birthdate = jQuery.datepicker.parseDate(
        instance.settings.dateFormat || jQuery.datepicker._defaults.dateFormat,
        jQuery('#user_birthdate').val(),
        instance.settings
      );

      if (birthdate != null && birthdate != undefined) birthdate = birthdate.getFullYear();

      var currdate = new Date().getFullYear();
      if ((currdate - birthdate) <= age) {
        errors.push('#{'Please note that this Site is not aimed at users under thirteen (13) years of age.'.t + ' ' +
                 'Users thirteen (13) years or younger are required to have a parent or guardian review and complete any registration process, which may include age verification steps in addition to the standard process.'.t}')
      }

      if (jQuery('#user_email').val() == '') {
        errors.push('#{'Please enter Your Email Address.'.t}')
      }

      if (jQuery('#user_login').val() == '') {
        errors.push('#{'Please enter Your Personal Login Name.'.t}')
      }

      if (jQuery('#user_password').val() == '') {
        errors.push('#{'Please enter Your Password.'.t}')
      }

      if (jQuery('#user_password_confirmation').val() == '') {
        errors.push('#{'Please enter Confirm Password.'.t}')
      }
      
      if (jQuery('#user_password_confirmation').val() != jQuery('#user_password').val()) {
        errors.push(\"#{'Password doesn\'t match confirmation.'.t}\")
      }

      write_errors(errors)
      if (errors.length > 0) {
        jQuery('html, body').animate({scrollTop: jQuery('#main_content_left').offset().top},'slow');
        return false;
      } else {
        return true;
      }
    }"
  end

  def birthday_datapicker
    "jQuery.datepicker.setDefaults(jQuery.datepicker.regional['#{I18n.locale == 'en' ? '' : I18n.locale}']);
    jQuery('#user_birthdate').datepicker({
      dateFormat: '#{I18n.t('date.formats.birthday_jquery')}',
      changeYear: true,
      defaultDate: '-20y',
      minDate: '-110y',
      maxDate: '0d',
      yearRange: '-110y:110y'
    });"
  end

end