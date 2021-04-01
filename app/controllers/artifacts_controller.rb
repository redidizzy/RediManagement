class ArtifactsController < ApplicationController
  before_action :set_artifact, only: %i[ show edit update destroy ]

  # GET /artifacts or /artifacts.json
  def index
    @project = Project.find_by(id: params[:id])
    @artifacts = @project.artifacts
  end

  # GET /artifacts/1 or /artifacts/1.json
  def show
  end

  # GET /artifacts/new
  def new
    @project = Project.find(params[:id])
    @artifact = Artifact.new
  end

  # POST /artifacts or /artifacts.json
  def create
    project = Project.find(params[:id])
    @artifact = Artifact.new(artifact_params.merge(project: project))

    respond_to do |format|
      if @artifact.save
        format.html { redirect_to @artifact, notice: "Artifact was successfully created." }
        format.json { render :show, status: :created, location: @artifact }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @artifact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artifacts/1 or /artifacts/1.json
  def destroy
    project = @artifact.project
    @artifact.destroy
    respond_to do |format|
      format.html { redirect_to artifacts_url(project), notice: "Artifact was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artifact
      @artifact = Artifact.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def artifact_params
      params.require(:artifact).permit(:name, :file)
    end
end
