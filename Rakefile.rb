require "rubygems"
require "bundler/setup"
require "stringex"

source_dir      = "."    # source file directory
drafts_dir       = "_drafts"    # directory for blog files
posts_dir       = "_posts"    # directory for blog files
new_page_ext    = "md"  # default new page file extension when using the new_page task

desc "Generate jekyll site"
task :build do
  puts "## Generating Site with Jekyll"
  system "jekyll build --drafts"
end

desc "Serve jekyll site"
task :serve do
  puts "## Serving Site with Jekyll"
  system "jekyll serve --incremental"
end

# usage rake new_post[my-new-post] or rake new_post['my new post'] or rake new_post (defaults to "new-post")
desc "Begin a new post in #{source_dir}/#{posts_dir}"
task :new_post, :title do |t, args|
  create_post(args.title, posts_dir)
end

desc "Begin a new draft post in #{source_dir}/#{drafts_dir}"
task :new_draft, :title do |t, args|
  create_post(args.title, drafts_dir)
end

def create_post(title, folder)
  new_post_ext    = "md"  # default new post file extension when using the new_post task
  if not title
    title = get_stdin("Enter a title for your post: ")
  end
  filename = "#{folder}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{new_post_ext}"
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "author: Boguste"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
    post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M:%S %z')}"
    post.puts "tags: "
    post.puts "categories: "
    post.puts "thumbnail: http://upload.wikimedia.org/wikipedia/commons/2/23/HokusaiChushingura.jpg"
    post.puts "---"
  end
end

# usage rake new_page[my-new-page] or rake new_page[my-new-page.html] or rake new_page (defaults to "new-page.markdown")
desc "Create a new page in #{source_dir}/(filename)/index.#{new_page_ext}"
task :new_page, :filename do |t, args|
  raise "### You haven't set anything up yet. First run `rake install` to set up an Octopress theme." unless File.directory?(source_dir)
  args.with_defaults(:filename => 'new-page')
  page_dir = [source_dir]
  if args.filename.downcase =~ /(^.+\/)?(.+)/
    filename, dot, extension = $2.rpartition('.').reject(&:empty?)         # Get filename and extension
    title = filename
    page_dir.concat($1.downcase.sub(/^\//, '').split('/')) unless $1.nil?  # Add path to page_dir Array
    if extension.nil?
      page_dir << filename
      filename = "index"
    end
    extension ||= new_page_ext
    page_dir = page_dir.map! { |d| d = d.to_url }.join('/')                # Sanitize path
    filename = filename.downcase.to_url

    mkdir_p page_dir
    file = "#{page_dir}/#{filename}.#{extension}"
    if File.exist?(file)
      abort("rake aborted!") if ask("#{file} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
    end
    puts "Creating new page: #{file}"
    open(file, 'w') do |page|
      page.puts "---"
      page.puts "author: Boguste"
      page.puts "layout: page"
      page.puts "title: \"#{title}\""
      page.puts "permalink: /#{title}/"
      page.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
      page.puts "---"
    end
  else
    puts "Syntax error: #{args.filename} contains unsupported characters"
  end
end

def get_stdin(message)
  print message
  STDIN.gets.chomp
end

