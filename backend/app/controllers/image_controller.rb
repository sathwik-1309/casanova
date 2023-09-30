class ImageController < ApplicationController
  def show
    # Extract the filename from the URL
    filename = params[:filename]

    # Determine the directory where your images are stored
    images_directory = Rails.root.join('public', 'images')
    filepath = File.join(images_directory, filename)

    # Check if the file exists
    if File.exist?(filepath)
      # Serve the file
      send_file(filepath, type: 'image/jpeg', disposition: 'inline')
    else
      # Return a 404 response or handle it as you prefer
      render plain: 'Image not found', status: :not_found
    end
  end
end