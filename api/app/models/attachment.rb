class Attachment
  include Mongoid::Document
  include Mongoid::Timestamps

  #-- Relations
  has_and_belongs_to_many :users
  has_and_belongs_to_many :jots

  #-- Fields
  field :source, :type => String
  field :media_type, :type => String
  field :api_name, :type => String
  field :embed_html, :type => String
  field :thumbnail_url, :type => String

  def self.set(media, api_name, access_token = "", media_type = "Video")
    if api_name == "facebook" and media_type == "Video"
      facebook_video_id = ActiveSupport::JSON.decode(media)['id']
      facebook_video_info_request = Typhoeus::Request.new("https://graph.facebook.com/#{facebook_video_id}", :params => {:access_token => access_token}, :method => :get)

      hydra = Typhoeus::Hydra.new
      hydra.queue(facebook_video_info_request)
      hydra.run

      facebook_video_info = ActiveSupport::JSON.decode facebook_video_info_request.response.body

      parameters = {:source => facebook_video_info['embed_html'].scan(/http:\/\/www\.facebook\.com\/v\/\d+/)[0],
                    :media_type => media_type,
                    :api_name => api_name,
                    :embed_html => facebook_video_info['embed_html'],
                    :thumbnail_url => facebook_video_info['picture']}
    elsif api_name == "youtube"
      parameters = {:source => "https://www.youtube.com/watch?v=#{media.unique_id}",
                    :media_type => media_type,
                    :api_name => api_name,
                    :embed_html => media.embed_html,
                    :thumbnail_url => media.thumbnails[0].url}
    end

    data = self.create(parameters)

    return data
  end
end
