require_relative '../extractors/save_content_html'
require_relative '../extractors/save_page_source'
require_relative '../extractors/save_video'
require_relative '../pages/episode_page'

class EpisodeLink < Struct.new(:href)
  def call
    return unless is_episode?
    return if is_downloaded?

    download_episode
  end

  def download_episode
    EpisodePage.new(link_obj).download_episode
  end

  def is_downloaded?
    @episode_regex[:episode_number].to_i <= ALREADY_DOWNLOADED.to_i
  end

  def is_episode?
    episode_regex
  end

  def episode_regex
    @episode_regex ||= href.match(/(episode-)(?<episode_number>\d{3})(-?)(?<episode_name>.*)/)
  end

  def link_obj
    {
      href: href,
      episode_number: episode_regex[:episode_number],
      episode_name: episode_regex[:episode_name]
    }
  end
end
