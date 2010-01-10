module HaikusHelper

  def haikuify(s)
    s.strip!
    s.gsub!(/\n/,'<br />')
    return s
  end

end
