class UserProjectsController < ApplicationController
  before_action :set_user_project, only: [ :show, :edit, :update, :destroy ]

  # DELETE /user_projects/1 or /user_projects/1.json
  def destroy
    @user_project.destroy
    respond_to do |format|
      format.html { redirect_to project_users_path(id: @user_project.project), notice: "User was successfully removed from the project." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_project
      @user_project = UserProject.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_project_params
      params.require(:user_project).permit(:project_id, :user_id)
    end
end
