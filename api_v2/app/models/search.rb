class Search

  def self.get(keyword, type)

    case type
    when 'nest'
      TmpSearchTagResult.fetch(SecureRandom.base64, keyword, 1, nil, [keyword])
    when 'user'
      get_similar_users keyword
    when 'tags'
      get_similar_tags keyword
    else
      get_similar_jots keyword
    end

    #    if @type == 'nest'
    #
    #      get_similiar_tags @keyword
    #
    #    else
    #      user_names = Twitter::Extractor.extract_mentioned_screen_names(keyword)
    #      tag_names = Twitter::Extractor.extract_hashtags(keyword)
    #
    #      if user_names.present?
    #        data = {:users => User.where({:username.in => user_names}), :keywords => user_names}
    #
    #        JsonizeHelper.format({:content => data}, {
    #            :except => User::NON_PUBLIC_FIELDS,
    #            :include => User::RELATION_PUBLIC
    #          })
    #
    #      elsif tag_names.present?
    #        data = {:tags => Tag.where({:name.in => tag_names}), :keywords => tag_names}
    #
    #        JsonizeHelper.format({:content => data}, {
    #            :except => Tag::NON_PUBLIC_FIELDS,
    #            :include => Tag::RELATION_PUBLIC
    #          })
    #      else
    #        data = {:jots => Jot.where({:title => /#{keyword}/i}), :keywords => keyword }
    #        JsonizeHelper.format({:content => data}, {
    #            :except => Jot::NON_PUBLIC_FIELDS,
    #            :include => Jot::RELATION_PUBLIC
    #          })
    #      end
    #    end
  end



  #protected

  def self.get_similar_users(keyword)
    user = Twitter::Extractor.extract_mentioned_screen_names(keyword)

    content = User.where(:username => /#{ user.last }/i)

    JsonizeHelper.format :content => content
  end

  def self.get_similar_tags(keyword)
    tags = Twitter::Extractor.extract_mentioned_screen_names(keyword)
    tags_array = tags.each { |tag| /#{ tag }/i}

    content = User.where(:tag_ids.in => tags_array)

    JsonizeHelper.format :content => content
  end

  def self.get_similar_jot_of_user_with_tags(keyword)
    extracted_user = Twitter::Extractor.extract_mentioned_screen_names(keyword).last
    extracted_tags = Twitter::Extractor.extract_hashtags(keyword)
    extracted_tags_regex = extracted_tags.map { |tag| /#{tag}/i }

    user = User.where(:username => extracted_user).first

    content = Jot.where(:user_id => user.id, :tags.all => extract_tags)

    JsonizeHelper.format :content => content
  end

  def self.get_similar_jots(keyword)
    text_array = keyword.split(/,\s|\s,|\s/).map { |text| /#{ text }/i }

    content = Jot.where(:title.all => text_array)

    JsonizeHelper.format :content => content
  end
end
