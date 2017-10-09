class Tools::ImageCrawlController < Homepage::BaseController
  before_action :load_upload_jobs, only: :index
  before_action :execute_upload_job, only: [:url_crawl, :twitter_crawl, :flickr_crawl]

  def index
  end

  def twitter
  end

  def twitter_crawl
    redirect_to tools_image_crawl_url
  end

  def flickr
  end

  def flickr_crawl
    redirect_to tools_image_crawl_url
  end

  def url
  end

  def url_crawl
    redirect_to tools_image_crawl_url
  end

  def download_zip
    job = @visitor.upload_jobs.find_by(id: params[:job_id])
    job.downloaded!
    redirect_to job.upload_url
  end

  private
  def load_upload_jobs
    if @visitor.blank?
      @upload_jobs = []
    else
      @upload_jobs = @visitor.upload_jobs.where.not(state: :cleaned)
    end
  end

  def execute_upload_job
    if params[:action] == "flickr_crawl"
      prefix = "Datapool::FrickrImageMetum"
    elsif params[:action] == "twitter_crawl"
      prefix = "Datapool::TwitterImageMetum"
    else
      prefix = "Datapool::WebSiteImageMetum"
    end
    @upload_job = @visitor.upload_jobs.find_by(from_type: prefix, state: [:standby, :crawling, :compressing, :uploading])
    is_new = false
    if @upload_job.blank?
      @upload_job = @visitor.upload_jobs.find_or_initialize_by(token: params[:authenticity_token])
      @upload_job.from_type = prefix
      is_new = @upload_job.new_record?
      @upload_job.save!
    end
    if is_new
      flash[:notice] = "処理を受け付けました。処理が完了するまでしばらくお待ち下さい。"
      ImageCrawlWorker.perform_async(params.to_h.dup, @upload_job.id)
    else
      flash[:error] = "現在処理中のものがあるので、処理が終わって使うようにしてください"
    end
  end
end