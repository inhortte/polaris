class LepersController < ApplicationController
  # GET /lepers
  # GET /lepers.xml
  def index
    @lepers = Leper.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @lepers.to_xml }
    end
  end

  # GET /lepers/1
  # GET /lepers/1.xml
  def show
    @leper = Leper.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @leper.to_xml }
    end
  end

  # GET /lepers/new
  def new
    @leper = Leper.new
  end

  # GET /lepers/1;edit
  def edit
    @leper = Leper.find(params[:id])
  end

  # POST /lepers
  # POST /lepers.xml
  def create
    @leper = Leper.new(params[:leper])

    respond_to do |format|
      if @leper.save
        flash[:notice] = 'Leper was successfully created.'
        format.html { redirect_to leper_url(@leper) }
        format.xml  { head :created, :location => leper_url(@leper) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @leper.errors.to_xml }
      end
    end
  end

  # PUT /lepers/1
  # PUT /lepers/1.xml
  def update
    @leper = Leper.find(params[:id])

    respond_to do |format|
      if @leper.update_attributes(params[:leper])
        flash[:notice] = 'Leper was successfully updated.'
        format.html { redirect_to leper_url(@leper) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @leper.errors.to_xml }
      end
    end
  end

  # DELETE /lepers/1
  # DELETE /lepers/1.xml
  def destroy
    @leper = Leper.find(params[:id])
    @leper.destroy

    respond_to do |format|
      format.html { redirect_to lepers_url }
      format.xml  { head :ok }
    end
  end
end
