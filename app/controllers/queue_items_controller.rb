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
    normalize_queue_items
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      normalize_queue_items
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Something went wrong"
      redirect_to my_queue_path
      return
    end
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    QueueItem.create(video: video, user: current_user, list_order: new_qitem_order) unless current_user_queued_video?(video)
  end

  def new_qitem_order
    current_user.queue_items.count + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def updated_params
    params.permit("queue_items")
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      updated_params.each do |updated_qitem|
        qitem = QueueItem.find(updated_qitem["id"])
        qitem.update_attributes!(list_order: updated_qitem["list_order"]) if qitem.user == current_user
      end
    end
  end

  def normalize_queue_items
    current_user.queue_items.each_with_index do |qitem, i|
      qitem.update_attributes(list_order: i + 1)
    end
  end

end
