class Search

  def self.get(keyword, type)

    case type
    when 'nest'
      TmpSearchTagResult.fetch(SecureRandom.base64, keyword, 1, nil, [keyword])
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



  protected

  
end