module BlogHelper

  # called from views/blog/list.rhtml
  def get_h1
    return ''
  end


  def show_entry?(id)
    unless session[:shown_entries].nil? ||
	session[:shown_entries].empty?
      return session[:shown_entries].include?(id.to_s)
    end
    return nil
  end

  def get_shown_user
    unless session[:shown_user].nil?
      return User.find(session[:shown_user])
    end
    return nil
  end

  def get_topics
    return Topic.find(:all).sort { |x,y| x.topic <=> y.topic }
  end

  def get_topics_for_select
    return get_topics.collect { |topic| [ topic.topic, topic.id ] }
  end

  def get_moods
    return Mood.find(:all).sort { |x,y| x.mood <=> y.mood }
  end

  def get_mood(id)
    return Mood.find(id)
  end

  def get_moods_for_select
    return get_moods.collect { |mood| [ mood.mood, mood.id ] }
  end

  def get_topic
    if session[:shown_topic].nil?
      return nil
    else
      return Topic.find(session[:shown_topic])
    end
  end

  # The number of helpers is getting out of hand.
  # Called from _entry.rhtml to list the topics of an entry.
  # Called also from comment.rhtml.
  def entry_topics(topics)
    topics.collect { |topic|
      link_to(topic.topic, :action => :topic, :id => topic)
    }.join(', ')
  end

  def remove_tags(s)
    return s.gsub(/<[\/\w\s\"=\-]+>/,'')
  end

  def paragraphify(s)
    s.strip!
    s.gsub!(/\n\s*\n/,'<br /><br />')
    return s
  end

  def invisible_div(condition, attributes = { })
    if condition
      attributes['style'] = 'display: none'
    end
    attrs = tag_options(attributes.stringify_keys)
    return "<div #{attrs}>"
  end

  # Return an array of all the days which have entries
  # within the current month.
  def get_current_calendar
    session[:cal_time] ||= Time.now
    Entry.find(:all,
               :conditions => [ 'created_at > ? and created_at < ?',
		 session[:cal_time].at_beginning_of_month,
		 session[:cal_time].next_month.at_beginning_of_month ]
	       ).collect { |e|
      e.created_at.day
    }.uniq
  end

end
