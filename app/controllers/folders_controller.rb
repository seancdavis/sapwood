# == Schema Information
#
# Table name: folders
#
#  id          :integer          not null, primary key
#  title       :string
#  slug        :string
#  ancestry    :string
#  property_id :integer
#  position    :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class FoldersController < ApplicationController

  def new
    @current_folder = Folder.new
  end

  def create
    @current_folder = Folder.new(create_params)
    if current_folder.save
      redirect_to property_folder_path(current_property, current_folder),
                  :notice => 'Folder created successfully!'
    else
      render 'new'
    end
  end

  def show
    redirect_to property_elements_path(current_property,
                                       :folder_id => current_folder.id)
  end

  private

    def folder_params
      params.require(:folder).permit(:title)
    end

    def create_params
      folder_params.merge(:property => current_property)
    end

end
