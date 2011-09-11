module Facebook::SearchHelper

  def verify_search_input
    <<-HTML
    <script>
    <!--
      function confirm(term) {
        if(document.getElementById(term).getValue() == "")
        {
         new Dialog().showMessage('Search Kroogi Downloads', 'Please enter a term.');
         return false;
        }
      }
    //-->
    </script>
    HTML
  end
end
