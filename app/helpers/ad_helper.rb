module AdHelper

  def ad_manager_header
    unless @using_ad_manager.nil? or @using_ad_manager == false
      %q{ <script type="text/javascript" src="http://partner.googleadservices.com/gampad/google_service.js">
          </script>
          <script type="text/javascript">
            GS_googleAddAdSenseService("ca-pub-4499797372901855");
            GS_googleEnableAllServices();
          </script>
      }
    end
  end
  
  def ad_manager_slot(sid)
    @using_ad_manager = true
    content_for(:js) do
        "<script type='text/javascript'>GA_googleAddSlot('ca-pub-4499797372901855', '#{sid}');</script>\n"
    end
    "<script type='text/javascript'>GA_googleFillSlot('#{sid}');</script>\n"
  end

  def ad_manager_load_ads
    unless @using_ad_manager.nil? or @using_ad_manager == false
      %{<script type="text/javascript">
          GA_googleFetchAds();
        </script>}
    end
  end

  def ad_manager_add_targetting
    out_str = ''
    unless @using_ad_manager.nil? or @using_ad_manager == false
      out_str << "<script type='text/javascript'>"
      if logged_in?
        out_str << "  GA_googleAddAttr('logged_in', '1');"
      else
        out_str << "  GA_googleAddAttr('logged_in', '0');"
      end
      unless @entry.nil?
        out_str << "  GA_googleAddAttr('cntnt_type', '#{@entry.class.to_s}');"
      end
      out_str << "</script>"
    end
    out_str
  end
  
end
