module ResponseBuilder
  def create_response(obj, msg, url=nil)
    respond_to do |format|
      if obj.save
        format.html { redirect_to url || obj, notice: msg }
        format.json { render :show, status: :created, location: obj }
      else
        format.html { render :new }
        format.json { render json: obj.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_response(obj, params, msg, url=nil)
    respond_to do |format|
      if obj.update(params)
        format.html { redirect_to url || obj, notice: msg }
        format.json { render :show, status: :ok, location: obj }
      else
        format.html { render :edit }
        format.json { render json: obj.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_response(url, msg)
    respond_to do |format|
      format.html { redirect_to url, notice: msg }
      format.json { head :no_content }
    end
  end
end