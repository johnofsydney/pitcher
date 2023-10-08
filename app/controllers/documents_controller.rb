require 'aws/s3'

class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show edit update destroy ]

  # GET /documents or /documents.json
  def index
    @documents = Document.all
  end

  # GET /documents/1 or /documents/1.json
  def show
    # @online = server_online?(server_url)
  end



# Replace 'http://example.com' with the URL of the server you want to ping
# server_url = 'http://example.com'
# server_online?(server_url)


  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents or /documents.json
  def create
    # TODO use the save to s3 method

    file = params[:document][:file]

    link = save_to_s3(params)[:link]
    key = save_to_s3(params)[:key]

    @document = Document.new(
      document_params.merge(
        {link: link, key: key}
      )
    )

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
    file = params[:document][:file]
    bucket = S3.new(S3::BUCKET)
    key = "document-#{Time.zone.today}-#{file.original_filename}"
    upload_results = bucket.put_object(
      key: key,
      body: file.tempfile
    )
    {
      link: upload_results[:address],
      key: key
    }
  end

  # PATCH/PUT /documents/1 or /documents/1.json
  def update
    link = save_to_s3(params)[:link]
    key = save_to_s3(params)[:key]

    respond_to do |format|
      if @document.update(
        document_params.merge(
          {link: link, key: key}
        )
      )
        format.html do

          HookService.new(@document).call


          redirect_to document_url(@document), notice: "Document was successfully updated."
        end



        # format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1 or /documents/1.json
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
