# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...



* Installing Shrine and assigning image uploading to Cloudinary

** gems to install:
- gem 'shrine', '~> 2.8'
- gem 'cloudinary', '~> 1.6'
- gem 'shrine-cloudinary', '~> 0.5.0'

** adding a new column to the existing database:
- rails g migration add_avatar_to_profile image_data:text

** create a new file called shrine.rb in config/initializers and paste there following code in the exact same form:

```
require "shrine"
require "shrine/storage/file_system"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"), # permanent
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for forms
Shrine.plugin :rack_file # for non-Rails apps
```

** create a new folder inside `app` called `uploaders`
** create a new file inside `uploaders` called `image_uploader.rb`
** paste following code to the `image_uploader.rb`
`class ImageUploader < Shrine

end`


** add validation requirement to your model/profile.rb
`include ImageUploader[:image]
validates :first_name, presence: true
validates :last_name, presence: true
validates :title, presence: true
validates :about, presence: true`

** create a new form field in the partial `_form.html.erb`
`<% if profile.image.present?%>
  <%= image_tag profile.image_url%>
<% end %>
<%= form.label :avatar %>
<%= form.hidden_field :image, value: @photo.cached_image_data %>
<%= form.file_field :image, class: "form-control", placeholder: "Upload your image" %>
</div>`

** add `:image` to the private method inside of the `profiles_controllers` so it looks like this:
`private
  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile).permit(:image, :first_name, :last_name, :title, :about)
  end`

  ** to display images on the `index.html.erb` and `show.html.erb` page paste there following syntax:
  `  <% if profile.image.present?%>
      <%= image_tag profile.image_url%>
    <% end %>`
