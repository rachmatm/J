class TmpSearchTagResult
  include Mongoid::Document
  recursively_embeds_many
  
  field :tag_id, :type => String
  field :tag_name, :type => String
  field :weight, :type => Integer
  field :tmp_id, :type => String
  field :level, :type => Integer, :defaults => 1

  scope :get, ->(tmp_id) { where(:tmp_id => tmp_id).order_by([[:weight, :desc], [:tag_id, :asc]])}
  scope :by_level, ->(level) { where(:level => level) }

  def self.fetch(tmp_id, keyword, level = 1, parent = nil, created_data_log = [], done = true)

    parent_tag = Tag.where({:name => keyword}).first

    return unless parent_tag.present?

    if parent.present?
      parent_tag.tag_similiarity_ids.uniq.each do |tag|

        next  if created_data_log.include? tag

        child = parent.child_tmp_search_tag_results.build(:tag_id => tag,
          :weight => parent_tag.tag_similiarity_ids.count(tag), :tmp_id => tmp_id, :level => level)
        child.save

        created_data_log.push tag
      end
    else
      batch = parent_tag.tag_similiarity_ids.uniq.collect do |tag|

        next if created_data_log.include? tag
        created_data_log.push tag

        {:tag_id => tag, :weight => parent_tag.tag_similiarity_ids.count(tag), :tmp_id => tmp_id, :level => level}
      end

      self.collection.insert batch.compact
    end

    self.get(tmp_id).by_level(level).each do |tmp| 
      self.fetch(tmp_id, tmp.tag_id, level + 1, tmp, created_data_log, false)
    end

    if done == true
      data = self.get(tmp_id)
      result = JsonizeHelper.format :content => data
      data.destroy_all
      return result
    end    
  end
end