require 'yaml'
require 'date'

Time.zone = 'Tokyo'

set :css_dir,    'stylesheets'
set :js_dir,     'javascripts'
set :images_dir, 'images'

set :relative_links, true

set :title,            'Hi'
set :site_name,        'Hibariya'
set :author,           'hibariya'
set :base_url,         'http://note.hibariya.org'
set :disqus_shortname, 'note-hibariya-org'

set :markdown_engine, :redcarpet
set :markdown, {
  autolink:            true,
  space_after_headers: true,
  fenced_code_blocks:  true,
  strikethrough:       true,
  superscript:         true,
  tables:              true
}

configure :development do
  activate :livereload
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
  activate :relative_assets
end

activate :syntax

activate :blog do |blog|
  blog.permalink = 'articles/{year}{month}{day}/{title}.html'
  blog.sources   = 'articles/{year}{month}{day}/{title}.html'
  blog.layout    = 'article'
end

page '/articles.xml', layout: false

activate :deploy do |deploy|
  deploy.method = :git
  deploy.branch = 'master'
end

# TODO: remove me
page '/articles.rss', layout: false, format: :xhtml
after_build do |builder|
  builder.run <<-SCRIPT
    cd build;
    rm -rf entries entries.rss
    cp -rp articles     entries;
    cp -p  articles.rss entries.rss;
  SCRIPT
end
