desc "Delete duplicate relations"
namespace "db" do
  task :clear_relationship => :environment do
    relations = []
    puts Relationship.count
    Relationship.paginated_each(:per_page => 1000) do |r|
      marker = "#{r.user_id}-#{r.related_user_id}-#{r.relationshiptype_id}"
      if relations.include?(marker)
        r.destroy
        puts "Delete #{r.id} #{marker}"
      else
        relations << marker
      end
    end
    puts Relationship.count
  end
end