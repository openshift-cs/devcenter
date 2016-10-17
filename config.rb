require 'yaml'
###
# Settings
###
set :site_title, "OpenShift Developer Portal"
set :site_url, 'https://developers.openshift.com/'
set :openshift_assets, 'https://assets.openshift.net/content'
set :dtm_url, '//www.redhat.com/dtm.js'

set :asciidoc_attributes, %w(icons=font source-highlighter=coderay coderay-css=style)
set :haml, { :ugly => true, :format => :html5 }
###
# Assets
###
set :css_dir, 'stylesheets'
set :fonts_dir, 'fonts'
set :images_dir, 'images'
set :js_dir, 'javascripts'

###
# Page command
###
page "/sitemap.xml", layout: false

# activate :navtree do |options|
#   options.data_file = 'tree.yml' # The data file where our navtree is stored.
#   options.automatic_tree_updates = true # The tree.yml file will be updated automatically when source files are changed.
#   options.ignore_files = ['sitemap.xml', 'robots.txt', 'index.adoc', 'contact.adoc', 'search.html.erb', 'report.html.erb'] # An array of files we want to ignore when building our tree.
#   options.ignore_dir = ['assets', '_fragments'] # An array of directories we want to ignore when building our tree.
#   options.home_title = 'Home' # The default link title of the home page (located at "/"), if otherwise not detected.
#   #options.promote_files = ['index.adoc'] # Any files we might want to promote to the front of our navigation
#   options.ext_whitelist = [] # If you add extensions (like '.md') to this array, it builds a whitelist of filetypes for inclusion in the navtree.
# end

helpers do

  # Builds breadcrumbs for the top of the pages
  def build_breadcrumb(current_page)
    breadcrumbs = {}
    current_path = []
    current_page.path.split(File::SEPARATOR).each do |element|
      current_path.push element
      if element == current_page.path.split(File::SEPARATOR).last
        breadcrumbs["#{current_page.data.title}"] = "/"+current_path.join(File::SEPARATOR)
      else
        breadcrumbs["#{displayname(element)}"] = "/"+current_path.join(File::SEPARATOR)
      end
    end
    html = ""
    breadcrumbs.each_pair do |key,value|
      html += "<li><a href='#{value}'>#{key}</a></li>"
    end
    return html
  end

  def build_navtree(root = nil)
    html = ""
    if root == nil 
      root = navtree_yaml = YAML.load_file('data/tree.yml')
    end
    root.each_pair do |folder,contents|
      if contents.is_a?(String)
        extensionlessPath = sitemap.extensionless_path(contents)
      else
        extensionlessPath = sitemap.extensionless_path(folder)
      end
      
        if extensionlessPath.end_with? ".html"
          resource = sitemap.find_resource_by_path(extensionlessPath)
          if resource.nil?
            puts extensionlessPath
          end
          html << "<li><a href='#{resource.url}' class='#{resource == current_page ? 'active' : ''}'>#{resource.data.title}</a></li>"
        else
          if current_page.path.split(File::SEPARATOR).count > 1
            html << "<li><a href='/#{current_page.path.split(File::SEPARATOR).first}/#{folder}' class=''>#{displayname(folder)}</a></li>"
          else
            html << "<li class='parent nav-header'><label class='toggle'><span class='symbol fa fa-angle-right'></span> #{displayname(folder)}</label>"
          end
          html << "<ul>"
          #html << build_navtree(contents)
          if current_page.path.split(File::SEPARATOR).count < 2
            contents.each do |k,v|
              if v.is_a?(String)
                extensionlessPath = sitemap.extensionless_path(v)
              else
                extensionlessPath = sitemap.extensionless_path(k)
              end
              if extensionlessPath.end_with? ".html"
                resource = sitemap.find_resource_by_path(extensionlessPath)
                html << "<li><a href='#{resource.url}' class='#{resource == current_page ? 'active' : ''}'>#{resource.data.title}</a></li>"
              else
                html << "<li><a href='#{folder}/#{k}' class=''>#{displayname(k)}</a></li>"
              end
            end
          end
          html << "</ul>"
          html << "</li>"
        end
    end
    return html
  end

  def nav_index(current_page)
    path = current_page.path.split(File::SEPARATOR)
    if path.count == 1
      return data.tree
    elsif path.count == 2
      return data.tree[path[0]]
    elsif path.count == 3
      return data.tree[path[0]][path[1]]
    end
  end

  def displayname(name)
    if data.displaynames[name]
      return data.displaynames[name]
    else
      return name.titlecase
    end
  end
end

# Development configuration
configure :development do
  set :site_url, 'https://developers-openshift.c9users.io/'
  set :dtm_url, 'http://dpal-itmarketing.itos.redhat.com/www.openshift.com'
  #set :openshift_assets, 'https://assets-openshift.c9.io/content'
end

# Build-specific configuration
configure :build do
  config.ignored_sitemap_matchers[:source_dotfiles] = proc { |file|
    file =~ %r{/\.} && file !~ %r{/\.(openshift|htaccess|htpasswd|nojekyll|git)}
  }

  activate :minify_css
  activate :minify_javascript
end

# Deployment configuration
activate :deploy do |deploy|
  deploy.method = :git
  deploy.build_before = false # default: false
  deploy.remote = 'production' # remote name or git url, default: origin
  deploy.strategy = :force_push
  deploy.branch = 'master' # default: gh-pages
end

activate :sitemap, :gzip => false, :hostname => "https://developers.openshift.com"
