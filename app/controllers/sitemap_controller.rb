class SitemapController < ApplicationController
  def projects
    response.headers['Content-Type'] = "application/xml"
    i = params[:id]

    #if an id is supplied, then show that list, otherwise
    #show the index.
    if i.nil?
      @max = Project.first(:order => "id desc").id
      render :layout => false, :action => "projects_index"
    else
      @projects = Project.all(:limit => 100,
        :conditions => ["id >= ? AND state = 'active'", i.to_i],
        :order => :id)
      render :layout => false, :action => "projects_show"
    end
  end
end
