# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # called from views/blog/_entry.rhtml & views/haiku/_haiku.rhtml
  def format_date(d)
    return d.strftime("%d %b %Y - %H:%M")
  end

  # called from layout/blog.rhtml & layout/login.rhtml
  def get_banner
    cn = controller.controller_name

    logger.debug "\nCONTROLLER NAME\n" + cn + "\n"

    re = Regexp.new('^' + cn + 'banner')
    images_dir = '/home/polaris/rail_me/polaris/public/images'
    banners = Dir.entries(images_dir).select { |file|
      re.match(file)
    }
    return '/images/' + banners[rand(banners.length)]
  end

  def get_legend
    return 'Shag a sheep for Jesus'
  end

  def get_user(id = nil)
    if id.nil?
      if session[:user_id].nil?
	return nil
      else
	return User.find(session[:user_id])
      end
    else
      return User.find(id)
    end
  end

  def get_users
    return User.find(:all).sort { |x,y| x.login <=> y.login }
  end

  def is_current_user?(id)
    unless session[:user_id].nil?
      return session[:user_id] == id
    end
    return nil
  end

  def is_admin?
    unless session[:user_id].nil?
      return get_user.admin_flag == 1
    end
    return nil
  end

  def get_oblique_strategy
    return ObliqueStrategy.find(rand(ObliqueStrategy.count) + 1)
  end
end
