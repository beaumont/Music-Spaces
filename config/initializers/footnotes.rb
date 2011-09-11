# http://github.com/drnic/rails-footnotes/tree/master
# Footnotes::Filter.notes = [:session, :cookies, :params, :filters, :routes, :queries, :log, :general]

if ENV['FOOTNOTES'] && ((ENV['RAILS_ENV'] == 'development') || (ENV['RAILS_ENV'] == 'staging'))
  Footnotes::Filter.notes = [:session, :cookies, :params, :filters, :routes, :queries, :log, :general]
end