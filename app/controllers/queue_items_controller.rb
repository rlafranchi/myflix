class QueueItemsController < ApplicationController
  before_action :require_user
  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    qitem = QueueItem.find(params[:id])
    qitem.destroy if current_user.queue_items.include?(qitem)
    current_user.normalize_queue_items
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_items
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Something went wrong"
      redirect_to my_queue_path
      return
    end
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    QueueItem.create(video: video, user: current_user, list_order: current_user.new_qitem_order) unless current_user.queued_video?(video)
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      updated_params["up_queue_items"].each_with_index do |updated_qitem, index|
        qitem = QueueItem.find(updated_qitem["id"])
        qitem.update_attributes!(list_order: updated_qitem["list_order"]) if qitem.user == current_user
      end
    end
  end

  def updated_params
    params.permit!
  end

end
