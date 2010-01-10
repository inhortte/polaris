module PhotoalbumsHelper

  def get_photoalbums
    unless session[:pa_parent]
      session[:pa_parent] = 1
    end
    return Photoalbum.find(session[:pa_parent]).children
  end

  def parent_name
    return Photoalbum.find(session[:pa_parent]).name
  end

  def get_parent(pa_id)
    Photoalbum.find(pa_id).parent
  end

  def at_root?
    logger.debug "\n:pa_parent => " + session[:pa_parent].to_s + "\n"
    return session[:pa_parent] == 1
  end

  def own_parent?
    Photoalbum.find(session[:pa_parent]).user_id == session[:user_id]
  end

  def own_pa?(pa)
    photoalbum = Photoalbum.find(pa)
    photoalbum.user_id == session[:user_id]
  end

  def breadcrumbs
#    crumbs = [ [ Photoalbum.find(session[:pa_parent]).name, session[:pa_parent] ] ]
    crumbs = [ ]
    current = session[:pa_parent]
    until current.nil?
      photoalbum = Photoalbum.find(current)
      crumbs += [ [ photoalbum.name, current ] ]
      current = photoalbum.parent_id
    end

    return crumbs.reverse

#    bc = ""
#    crumbs.reverse.each { |crumb|
#      bc += " -&gt; " + crumb[0]
#    }
#    return bc[7..-1]
  end

end
