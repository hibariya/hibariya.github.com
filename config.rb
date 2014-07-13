require 'yaml'
require 'date'

Time.zone = 'Asia/Tokyo'

set :css_dir,    'stylesheets'
set :js_dir,     'javascripts'
set :images_dir, 'images'

set :relative_links, true

set :title,            'Hi'
set :site_name,        'Joy Luck Crab'
set :author,           'hibariya'
set :base_url,         'http://hibariya.github.io'
set :disqus_shortname, 'joyluckcrab'

set :markdown_engine, :redcarpet
set :markdown, {
  autolink:            true,
  space_after_headers: true,
  fenced_code_blocks:  true,
  strikethrough:       true,
  superscript:         true,
  fenced_code_blocks:  true,
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

activate :rouge_syntax

activate :blog do |blog|
  blog.permalink = '/entries/{year}{month}{day}/{title}.html'
  blog.sources = 'entries/{year}{month}{day}/{title}.html'
end

activate :deploy do |deploy|
  deploy.method = :git
  deploy.branch = 'master'
end

page '/entries/*/*.html', layout: 'article'
page '/entries.rss',      layout: false, format: :xhtml
