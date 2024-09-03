# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.csv { send_data UserRegistrationReport.report @competition }
    end
  end

  def mailing_list_export
    respond_to do |format|
      format.csv { send_data MailingListExport.new(@competition).to_csv }
    end
  end

  def mailing_list_export_id_desc
    respond_to do |format|
      format.csv { send_data MailingListExport.new(@competition).to_csv_by_date }
    end
  end

  def show
    @user = User.find params[:id]
    @profile = @user.profile
  end

  def confirm
    (@user = User.find params[:id]).confirm
    if @user.confirmed?
      redirect_to admin_user_path(@user), notice: 'User confirmed'
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :show
    end
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy
    redirect_to admin_users_path, notice: 'User destroyed'
  end

  def act_on_behalf_of_user
    user = User.find params[:id]
    current_user.update! acting_on_behalf_of_user: user
    redirect_to admin_user_path user
  end

  def cease_acting_on_behalf_of_user
    user = current_user.acting_on_behalf_of_user
    current_user.update! acting_on_behalf_of_user: nil
    redirect_to admin_user_path user
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges? Competition.all

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :full_name, :email
  end
end
