class DocumentationsController < ApplicationController
  # GET /documentations
  # GET /documentations.json
  def index
    @documentations = Documentation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documentations }
    end
  end

  # GET /documentations/1
  # GET /documentations/1.json
  def show
    @documentation = Documentation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @documentation }
    end
  end

  # GET /documentations/new
  # GET /documentations/new.json
  def new
    @documentation = Documentation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @documentation }
    end
  end

  # GET /documentations/1/edit
  def edit
    @documentation = Documentation.find(params[:id])
  end

  # POST /documentations
  # POST /documentations.json
  def create
    @documentation = Documentation.new(params[:documentation])

    respond_to do |format|
      if @documentation.save
        format.html { redirect_to @documentation, notice: 'Documentation was successfully created.' }
        format.json { render json: @documentation, status: :created, location: @documentation }
      else
        format.html { render action: "new" }
        format.json { render json: @documentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documentations/1
  # PUT /documentations/1.json
  def update
    @documentation = Documentation.find(params[:id])

    respond_to do |format|
      if @documentation.update_attributes(params[:documentation])
        format.html { redirect_to @documentation, notice: 'Documentation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @documentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documentations/1
  # DELETE /documentations/1.json
  def destroy
    @documentation = Documentation.find(params[:id])
    @documentation.destroy

    respond_to do |format|
      format.html { redirect_to documentations_url }
      format.json { head :no_content }
    end
  end
end
