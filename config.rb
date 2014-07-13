require 'yaml'
require 'date'

class Middleman::Retter < Middleman::Extension
  Article = Struct.new(:date, :title, :name, :file_path) do
    class_attribute :app

    def date_str
      date.strftime('%Y%m%d')
    end

    def partial_path
      "entries/#{date_str}/#{name}"
    end

    def path
      "/entries/#{date_str}/#{name}.html"
    end

    def url
      app.settings.base_url + path
    end

    def render
      rendered = app.partial(partial_path)

      app.find_and_preserve(rendered)
    end
  end

  def app=(app)
    super

    Article.app = app
  end

  helpers do
    def articles
      Dir["#{Middleman::Application.root}/source/entries/**/*.md"].map {|entry|
        file_path   = File.expand_path(entry)
        frontmatter = YAML.load_file(file_path)
        date, name  = %r{source/entries/(?<date>.+)/(?<name>.+)\.html\.md}.match(file_path).captures

        Article.new(Date.parse(date), frontmatter['title'], name, file_path)
      }.sort_by(&:date).reverse
    end
  end

  Middleman::Extensions.register :retter, self
end

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
activate :retter

activate :deploy do |deploy|
  deploy.method = :git
  deploy.branch = 'master'
end

page '/entries/*/*.html', layout: 'article'
page '/entries.rss',      layout: false, format: :xhtml
