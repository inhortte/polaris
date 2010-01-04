class BlogController < ApplicationController
#  the use of 'model' (in this sense) is depreciated.
#  model :user
  layout 'blog'

  before_filter :login_timeout
  before_filter :authorize,
    :only => [ :new, :create, :edit, :update, :destroy,
               :comment, :create_comment, :destroy_comment ]

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def topic
    session[:shown_topic] = params[:id]
    redirect_to :action => :index
  end

  def user
    session[:shown_user] = params[:id]
    redirect_to :action => :index
  end

  def list
    options = { :order => 'created_at desc' }
    conditions = [ ]
    vars = [ ]
    if session[:shown_topic]
      options[:include] = :topics
      conditions << 'topics.id = ?'
      vars << session[:shown_topic]
    end
    if session[:shown_user]
      conditions << 'user_id = ?'
      vars << session[:shown_user]
    end
    options[:conditions] = [ conditions.join(' and ') ] + vars if
      conditions.length > 0
    @entry_pages, @entries = paginate :entries, options
  end

  def show_date
    start_time = Time.local(params[:year],
			    params[:month],
			    params[:day])
    options = { :order => 'created_at asc' }
    conditions = [ 'created_at > ?', start_time ]
    # add here user/topic filters, also, as per 'list'.
    options[:conditions] = conditions
    @entry_pages, @entries = paginate :entries, options
    render :action => :list
  end

  def comment
    @entry = Entry.find(params[:id])
    @comments = Comment.find(:all,
			     :conditions =>
                             ["entry_id = ? and parent_id is NULL", @entry.id])
    @comment = nil
    # This is set nil before the page is rendered so that
    # the new comment input form will be invisible initially.
    session[:show_new_comment] = nil
    session[:shown_reply_to_comment] = []
  end

  def create_comment
    @comment = Comment.new(params[:comment])
    if @comment.save
      flash[:notice] = 'New comment added.'
    else
      flash[:notice] = 'That comment just evaporated!'
    end
    redirect_to :action => :comment, :id => params[:comment][:entry_id]
  end

  def comment_on_comment
    @comment = Comment.find(params[:id])
    # Always changing params to Fixnums is irritating... (but needed)
    @comment.depth = params[:depth].to_i
    # Change the id to a Fixnum.
    show_comment_on_comment(params[:id].to_i)
  end

  def uncomment_on_comment
    @comment = Comment.find(params[:id])
    # Always changing params to Fixnums is irritating...
    @comment.depth = params[:depth].to_i
    # Change the id to a Fixnum.
    collapse_comment_on_comment(params[:id].to_i)
  end

  def show
    @entry = Entry.find(params[:id])
    show_entry(params[:id])
#    redirect_to :action => 'index'
  end

  def collapse
    @entry = Entry.find(params[:id])
    collapse_entry(params[:id])
#    redirect_to :action => 'index'
  end

  def toggle_topics
    toggle_something('topics')
  end

  def toggle_users
    toggle_something('users')
  end

  def toggle_calendar
    toggle_something('calendar')
  end

  def toggle_new_comment
    session[:show_new_comment] = !session[:show_new_comment]
  end

  def new
    @entry = Entry.new
  end

  def create
    if params[:new_topic].strip.length > 0
      topics = new_topic(params[:new_topic].strip)
    else
      topics = [ Topic.find(params[:topic_id]) ]
    end
    if params[:new_mood].strip.length > 0
      params[:entry][:mood_id] = new_mood(params[:new_mood].strip)
    end
    params[:new_topic] = params[:new_mood] = nil
    params[:entry][:user_id] = session[:user_id]
    @entry = Entry.new(params[:entry])
    if @entry.save
      topics.each { |topic| @entry.topics << topic }
      flash[:notice] = 'Entry was successfully created.'
      redirect_to :action => 'list'
    else
      flash[:notice] = 'The entry was not fucking saved, you cunt.'
      render :action => 'new'
    end
  end

  def edit
    @entry = Entry.find(params[:id])
  end

  def update
    if params[:new_topic].strip.length > 0
      topics = new_topic(params[:new_topic].strip)
    else
      topics = [ Topic.find(params[:topic_id]) ]
    end
    @entry = Entry.find(params[:id])
    if @entry.update_attributes(params[:entry])
      @entry.topics.clear
      topics.each { |topic| @entry.topics << topic }
      flash[:notice] = 'Entry was successfully updated.'
      redirect_to :action => :index, :id => @entry
    else
      render :action => 'edit'
    end
  end

  def destroy
    entry = Entry.find(params[:id])
    # Clean up topics. This should be in the model. I'm chunking it, anyway.
#    entry.topics.each { |topic|
#      topic.destroy if topic.entries.length == 1
#    }
    # Clean up comments. This is already implicit in the model.
#    entry.comments.each { |comment|
#      comment.destroy
#    }
    entry.destroy
    redirect_to :action => 'list'
  end

  def destroy_comment
    comment = Comment.find(params[:id])
    entry_id = comment.entry_id
    comment.children.each { |c|
      c.parent = comment.parent
      c.save!
    }
    comment.reload
    comment.destroy
    redirect_to :action => :comment, :id => entry_id
  end

  def refresh_oblique_strategy
#    update_page do |page|
#      page.replace_html('sheep', :partial => 'oblique_strategy')
#    end
  end

  # params[:id] is either 'back' or 'forward'.
  # there must be a better way to send it rather than
  # via params[:id]. Also: the helper 'get_current_calendar'
  # MUST be called before this method is so that session[:cal_time]
  # is initialized.
  def change_calendar
    session[:cal_time] = (params[:id] == 'back' ?
			  session[:cal_time].last_month :
			  session[:cal_time].next_month)
    render :update do |page|
      page.replace_html('calendar', :partial => 'calendar')
    end
  end

  private

  # This sucks, but I don't know why! Fuck!
  def login_timeout
    unless session[:user_id].nil?
      time = Time.now
      user = User.find(session[:user_id])
      if !user.last_login.nil? &&
	  time.to_i - user.last_login.to_i > 3600
	session[:user_id] = nil
	redirect_to :action => :index
      else
	user.last_login = time
	user.update_attribute('last_login',time)
      end
    end
  end

  def toggle_something(something)
    session[('show_' + something).to_sym] =
      !session[('show_' + something).to_sym]
    render :update do |page|
      page[something.to_sym].visual_effect(session[('show_' + something).to_sym] ? :blind_down : :blind_up)
    end
  end

  # This would be better named 'new_topics' since it
  # handles any number of them, honeybunch.
  def new_topic(t)
    topics = [ ]
    t.split(',').each { |_t|
      topic = Topic.find_or_create_by_topic(_t.downcase)
      topics << topic
    }
    return topics
  end

  def new_mood(m)
    mood = Mood.find_or_create_by_mood(m.downcase)
    return mood.id
  end

  def show_entry(id)
    if session[:shown_entries].nil? ||
	session[:shown_entries].empty?
      session[:shown_entries] = [ id ]
    else
      session[:shown_entries] << id
    end
  end

  def collapse_entry(id)
    unless session[:shown_entries].nil? ||
	session[:shown_entries].empty?
      session[:shown_entries].delete(id)
    end
  end

  # id is a Fixnum!!
  def show_comment_on_comment(id)
    if session[:shown_reply_to_comment].nil? ||
	session[:shown_reply_to_comment].empty?
      session[:shown_reply_to_comment] = [ id ]
    else
      session[:shown_reply_to_comment] << id unless session[:shown_reply_to_comment].include? id
    end
  end

  # id is a Fixnum!!
  def collapse_comment_on_comment(id)
    unless session[:shown_reply_to_comment].nil? ||
	session[:shown_reply_to_comment].empty?
      session[:shown_reply_to_comment].delete(id) if session[:shown_reply_to_comment].include? id
    end
  end
end
