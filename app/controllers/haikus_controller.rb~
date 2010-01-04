class HaikusController < ApplicationController
  before_filter :authorize

  # GET /haikus
  # GET /haikus.xml
  def index
    options = { :order => 'created_at desc', :per_page => 10 }
    @haiku_pages, @haikus = paginate :haikus, options
#    @haikus = Haiku.find(:all)

    respond_to { |format|
      format.html {
	render :html => 'index.html'
      }
      format.xml {
	render :xml => @haikus.to_xml
      }
    }
  end

  # GET /haikus/1
  # GET /haikus/1.xml
  def show
    @haiku = Haiku.find(params[:id])

    respond_to { |format|
      format.html # show.rhtml
      format.xml {
	render :xml => @haiku.to_xml
      }
    }
  end

  # GET /haikus/new
  def new
    @haiku = Haiku.new
  end

  # GET /haikus/1;edit
  def edit
    @haiku = Haiku.find(params[:id])
  end

  # POST /haikus
  # POST /haikus.xml
  def create
    @haiku = Haiku.new(params[:haiku])

    respond_to { |format|
      if @haiku.save
	flash[:notice] = 'The haiku was created, honey.'

	# Return to index. The first haiku listed will be the new one.
	format.html {
	  redirect_to haikus_url
	}
	format.xml {
	  head :created, :location => haiku_url(@haiku)
	}
      else
	format.html {
	  render :action => 'new'
	}
	format.xml {
	  render :xml => @haiku.errors.to_xml
	}
      end
    }
  end

  # PUT /haikus/1
  # PUT /haikus/1.xml
  def update
    @haiku = Haiku.find(params[:id])

    respond_to { |format|
      if @haiku.update_attributes(params[:haiku])
	flash[:notice] = 'The haiku was updated, vole!'

	# After a haiku is updated, the redirection should position
        # the page on the proper haiku, so anchors should be created
        # in _haiku.rhtml. This has just been done. Now I must redirect
        # to that anchor.
	format.html {
	  redirect_to haikus_url + "#haiku" + @haiku.id.to_s
	}
	format.xml {
	  head :ok
	}
      else
	format.html {
	  render :action => 'edit'
	}
	format.xml {
	  render :xml => @haiku.errors.to_xml
	}
      end
    }
  end

  # DELETE /haikus/1
  # DELETE /haikus/1.xml
  def destroy
    @haiku = Haiku.find(params[:id])
    @haiku.destroy

    respond_to { |format|
      format.html {
	redirect_to haikus_url
      }
      format.xml {
	head :ok
      }
    }
  end

  def toggle
    haiku = Haiku.find(params[:id])
    haiku.good_flag = ! haiku.good_flag
    haiku.save!
    
    render :update do |page|
      page.replace_html 'acceptable' + haiku.id.to_s,
	:partial => 'acceptable',
	:locals => { :haiku => haiku }
    end
  end
end
