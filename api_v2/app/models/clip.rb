require 'carrierwave/mongoid'

class Clip
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIVATE_FIELDS = []

  PROTECTED_FIELDS = []

  PUBLIC_FIELD = [:file]

  NON_PUBLIC_FIELDS = PRIVATE_FIELDS + PROTECTED_FIELDS

  UPDATEABLE_FIELDS = PROTECTED_FIELDS + PUBLIC_FIELD

  RELATION_PUBLIC = []

  RELATION_PUBLIC_DETAIL = []

  attr_accessor :file

  field :title, :type => String
  field :embed_html, :type => String
  

  belongs_to :user

  after_create :current_clip_set_crosspost
  before_create :current_clip_set_title

  protected

  def current_clip_set_crosspost
    fbcon = self.user.connections.where(:permission => 'always', :provider => 'facebook').first
    uploader =  AttachmentUploader.new
    uploader.store! self.file

    type = /image|video/.match(uploader.content_type)

    if fbcon.present? and type.present? and type[0] == 'image'
      current_clip_set_crosspost_photos fbcon, uploader.filename, File.open(uploader.path)
    elsif fbcon.present? and type.present? and type[0] == 'video'
      current_clip_set_crosspost_videos fbcon, uploader.filename, File.open(uploader.path)
    end
  end

  def current_clip_set_crosspost_photos(conn, title, file)
    t = Thread.new do
      begin
        
        data = conn.publish('photos', {:title => title, :file => file})

        unless data['error'].present?
          current_clip = Clip.find self.id
          current_clip.update_attributes({:title => data['message'], :embed_html => "<img src='#{data['picture']}' alt='#{data['message']}'>"})
        else
          conn.destroy
        end
      rescue
        conn.destroy
      end
    end
    t.join
  end

  def current_clip_set_crosspost_videos(conn, title, file)
    t = Thread.new do
      begin
        data = conn.publish('videos', {:title => title, :file => file})
        
        unless data['error'].present?
          current_clip = Clip.find self.id
          current_clip.update_attributes({:title => data['message'], :embed_html =>  data['embed_html']})
        else
          conn.destroy 
        end
      rescue
        conn.destroy 
      end
    end
    t.join
  end

  def current_clip_set_title
    self.title = self.file[:filename]
  end
end