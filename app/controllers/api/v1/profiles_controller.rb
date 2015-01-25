class Api::V1::ProfilesController < Api::V1::ApiController

  def me
    respond_with current_resource_owner
  end

end