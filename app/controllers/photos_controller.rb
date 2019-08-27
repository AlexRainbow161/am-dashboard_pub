class PhotosController < ApplicationController
  before_action :set_photo, except: [:new, :create]
  before_action :set_job

  def show; end
  def new
    @photo = Photo.new
  end
  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      respond_to do |format|
        format.html {redirect_to job_path(@job), success: "Фото успешно добавлено"}
        format.js
      end
    else
      puts "******************"
      puts @photo.errors.full_messages
      puts "******************"
    end
  end
  def edit; end
  def update
    @photo = @photo.update(photo_params)
    if @photo.save
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def destroy
    if @photo.destroy
      respond_to do |format|
        format.html {redirect_to job_path(@job), success: "Фото успешно удалено"}
        format.js
      end
    else
      respond_to do |format|
        format.html {redirect_to job_path(@job), danger: "Ошибка удаления #{@photo.errors.full_messages}"}
        format.js
      end
    end
  end

  private
    def set_photo
      @photo = Photo.find(params[:id])
    end
    def set_job
      @job = Job.find(params[:job_id])
    end
    def photo_params
      params.require(:photo).permit(:job_id, :image, :comment, :zone_id, :eq_id)
    end
end
