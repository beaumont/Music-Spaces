require 'xmlrpc/client'
require 'digest/md5'
require 'rexml/document'
require 'open-uri'

class LiveJournalFriends

  @@config = { :server => 'www.livejournal.com', 
               :path => '/interface/xmlrpc'}

  @@server = nil
  
  class << self
    
    def method_missing(methodname, args = {})
      self.send(:process_request, methodname, args)
    end

    def process_request(methodname, args = {})
      setup_server unless @@server
      @@server.call("LJ.XMLRPC.#{methodname.to_s}", args)
    end
    
    def friends_of(username)
      res = []
      url = nil
      unless username.blank?
        subdomain = username.gsub('_', '-').strip
        url = "http://#{subdomain}.livejournal.com/data/foaf"
        doc = REXML::Document.new(open(url)).
          each_element(('///foaf:knows/foaf:Person/foaf:nick/')) do |e|
            res << e.text
          end
      end
      res
    rescue REXML::ParseException
      []
    rescue OpenURI::HTTPError => e
      raise "Error fetching LJ friends list from #{url} : #{e.inspect}"
    end
      
    private
    
      def setup_server
        @@server = XMLRPC::Client.new( @@config[:server], 
                                       @@config[:path], 
                                       @@config[:port] || 80)
      end
      
  end    
  
end
