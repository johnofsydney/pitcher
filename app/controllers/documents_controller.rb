class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show edit update destroy ]

  def index
    @documents = Document.all
  end

  def show
  end

  def new
    @document = Document.new
  end

  def edit
  end

  def create
    file = params[:document][:file]

    save_results = save_to_s3(params)
    link = save_results[:link]
    key = save_results[:key]

    @document = Document.new(document_params.merge({ link: link, key: key }))

    respond_to do |format|
      if @document.save
        format.html { redirect_to document_url(@document), notice: "Document was successfully created." }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def save_to_s3(params)
    # TODO: move to the S3 class
    file = params[:document][:file]
    bucket = S3.new(S3::BUCKET)
    key = "document-#{Time.zone.today}-#{file.original_filename}"
    save_results = bucket.put_object(
      key: key,
      body: file.tempfile
    )

    {
      link: save_results[:address],
      key: key
    }
  end

  def update
    link = save_to_s3(params)[:link]
    key = save_to_s3(params)[:key]

    respond_to do |format|
      if @document.update(document_params.merge({link: link, key: key}))
        format.html do
          HookService.new(@document).call # when delayed job is worked out, remove this and let hook servivce just run on cron

          redirect_to document_url(@document), notice: "Document was successfully updated."
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url, notice: "Document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @document = Document.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def document_params
    # file is different becuase it is not an attribute of the model / column in the database
    params.require(:document).permit(:description, :expiry_date, :link, :key)
  end
end
