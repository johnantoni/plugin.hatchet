# Hatchet-harry
module HatchetHarry

  def clear_cache
    cache_dir = ActionController::Base.page_cache_directory
    unless cache_dir == RAILS_ROOT+"/public"
      FileUtils.rm_r(Dir.glob(cache_dir+"/*")) rescue Errno::ENOENT
      RAILS_DEFAULT_LOGGER.info("Cache directory '#{cache_dir}' fully sweeped.")
    end
  end

  def sql_days_start(m, y, b)
    return b+y+"-"+m+"-01"+b
  end

  def sql_days_left(m, y, b)
    return b+y+"-"+m+"-"+Time.days_in_month(m.to_i, y.to_i).to_s+b
  end

  def escape(str)
    require 'uri'
    str = URI.escape(str) if str.length > 0
    return str
  end

  def nl2br(str)
       str.gsub(/\n/, '<br>')
  end

  def ping_pingomatic(uri)
    if ENV['RAILS_ENV'] == 'production'
      require 'net/http'
      require 'uri'
      include ActionController::UrlWriter

      enc_uri = URI.escape(uri)

      #ping pingomatic
      ping_url = "pingomatic.com"
      ping_vars = "/ping/?title=&blogurl=#{enc_uri}&rssurl=http%3A%2F%2F&chk_weblogscom=on&chk_blogs=on&chk_technorati=on&chk_feedburner=on&chk_syndic8=on&chk_newsgator=on&chk_myyahoo=on&chk_pubsubcom=on&chk_blogdigger=on&chk_blogstreet=on&chk_moreover=on&chk_weblogalot=on&chk_icerocket=on&chk_newsisfree=on&chk_topicexchange=on"

      Net::HTTP.get(ping_url, ping_vars)
    end
  end

  def ping_sitemap(uri)
    if ENV['RAILS_ENV'] == 'production'
      require 'net/http'
      require 'uri'
      include ActionController::UrlWriter

      uri = uri+'/sitemap.xml'

      enc_uri = URI.escape(uri)
      default_url_options[:host] = enc_uri

      #ping sitemap
      Net::HTTP.get('www.google.com' , '/ping?sitemap=' + enc_uri)
    end
  end

  def call_rake(task, options = {})
    options[:rails_env] ||= Rails.env
    args = options.map { |n, v| "#{n.to_s.upcase}='#{v}'" }
    system "rake #{task} #{args.join(' ')} --trace 2>&1 >> #{Rails.root}/log/rake.log &"
  end

  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end

  def flash_redirect(msg, *params)
    flash[:notice] = msg
    redirect_to(*params)
  end

  # redirect somewhere that will eventually return back to here
  def redirect_away(*params)
    session[:original_uri] = request.request_uri
    redirect_to(*params)
  end

  # returns the person to either the original url from a redirect_away or to a default url
  def redirect_back(*params)
    uri = session[:original_uri]
    session[:original_uri] = nil
    if uri
      redirect_to uri
    else
      redirect_to(*params)
    end
  end

  def strip_object_tag
      self.gsub(/<object(| [^>]*)>/i, ' Flash Video ')
      #self.gsub(/<param(| [^>]*)>/i, ' ')
      #self.gsub(/<embed(| [^>]*)>/i, ' ')
  end

  def text_filter(body, filter_id)
    case filter_id.to_i
      when 1
        return body.to_s
      when 2
        return RDiscount.new(body).to_html
        #return BlueCloth.new(body).to_html
      when 3
        return RedCloth.new(body).to_html
    end
  end

  def truncate_words(text, length = 30, end_string = ' …')
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end

  def get_twitter(u, p)
    s = ""
    if (u.length > 0 && p.length > 0)
      client = Twitter::Client.new(:login => u, :pass => p)
      timeline = client.timeline_for(:user, :id => u.to_s, :count => 1) do |status|
        s = "<a href='http://twitter.com/#{status.user.screen_name}' alt='Twitter', title='Twitter'>#{status.user.screen_name}:</a> #{status.text}"
      end
    end
    return s
  end

end
