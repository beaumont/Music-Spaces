module PasswordHelper
  def show_password_field(obj)
    show_field = obj.password_validated_fields.any?{|field| obj.errors.on(field) }
    js = %{
      <script type="text/javascript">
        ask_for_password([#{obj.password_validated_fields.collect{|f| %Q{"#{f}"}}.join(",")}]);
      </script>
    }
    content_for(:bottom_javascript){ js }
    
    %{
      <div id="validate_password" style="#{show_field ? "" : "display:none;"}">
        <p>
          <span style="padding:6px;display:block;">#{"In order to save this form, you will need to enter your Kroogi password.".t}</span>
          #{password_field_tag(:password, nil, :style => "width:200px;", :class => "feedback_input")}
        </p>
      </div>
    }
  end
  
end