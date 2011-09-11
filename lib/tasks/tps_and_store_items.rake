namespace :kroogi do
  def load_project(login)
    project = User.find_by_login(login)
    raise 'Specify PROJECT!' unless project
    project
  end

  def goodies_data(project, prefix)
    raise 'Specify FOR!' unless prefix
    data = YAML.load(ERB.new(File.read(File.join(File.dirname(__FILE__), 'data', 'store', project.login, prefix + "_goodies.yml"))).result(binding))
    content = Content.find(data['content_id'])
    return data, content
  end
  
  def load_goodies(project, prefix)
    data, content = goodies_data(project, prefix)
    Thread.current['user'] = project
    data['goodies'].each do |goodie_data|
      goodie = Tps::Goodie.find_by_content_id_and_identifier(content.id, goodie_data['identifier'])
      goodie ||= Tps::Goodie.new(:content_id => content.id)
      goodie_data.reject! {|key, value| key == 'left'} unless goodie.new? #we don't want updating counters after it goes live
      goodie.attributes = goodie_data
      goodie.save!
    end
  end

  namespace :tps do
    def load_tps_content(project)
      tps_content = Tps::Content.of_project(project).last
      return tps_content
    end

    namespace :content do
      task :load => :environment do
        project = load_project(ENV['PROJECT'])
        tps_content = load_tps_content(project)
        data = YAML.load(ERB.new(File.read(File.join(File.dirname(__FILE__), 'data', 'tps', project.login, "content.yml"))).result(binding))
        data.merge!(:user => project)
        tps_content ||= Tps::Content.new
        tps_content.attributes = data
        raise 'related_content_id needs to refer to existing Album (or be empty)' unless tps_content.related_content_id.blank? || tps_content.related_content
        Thread.current['user'] = project
        tps_content.make_private! if tps_content.new?
        tps_content.save!
        load_goodies(project, 'tps')
      end

      task :make_public => :environment do
        tps_content = load_tps_content(load_project(ENV['PROJECT']))
        tps_content.make_public!
      end

      task :make_private => :environment do
        tps_content = load_tps_content(load_project(ENV['PROJECT']))
        tps_content.make_private!
      end
    end

  end

  namespace :goodies do
    task :load => :environment do
      project = load_project(ENV['PROJECT'])
      load_goodies(project, ENV['FOR'])
    end

    task :increase => :environment do
      data, content = goodies_data(load_project(ENV['PROJECT']), ENV['FOR'])
      raise 'please specify GOODIE' if ENV['GOODIE'].blank?
      goodie = Tps::Goodie.find(:first, :conditions => {:content_id => content.id, :identifier => ENV['GOODIE']})
      by = ENV['BY']
      raise 'please specify BY' if by.blank?
      goodie.update_attribute(:left, goodie.left + by.to_i)
    end
  end

  task :send_requests => :environment do
    Tps::GoodieTicket.find(:all, :conditions => ['state = ?', 'succeeded']).each do |ticket|
      ticket.create_or_update_participant
    end
  end
end

