module HatchetHarry
  module CacheRefresh

    def empty_html_cache
      cache_dir = ActionController::Base.page_cache_directory
      unless cache_dir == RAILS_ROOT+"/public"
        FileUtils.rm_r(Dir.glob(cache_dir+"/*")) rescue Errno::ENOENT
        RAILS_DEFAULT_LOGGER.info("Cache directory '#{cache_dir}' fully sweeped.")
      end
    end

  end
end
