class V1::PostsController < ApplicationController
  def splash
    instructions = {
      message: 'Welcome to Hempay.',
      instructions: [
        "To create a user account, send a POST request to 'v1/users' with the following parameters (all fields should be strings except 'employment_status', which should be boolean):",
        '- username',
        '- first_name',
        '- last_name',
        '- date_of_birth (in mm-dd-yyyy format)',
        '- employment_status (true/false)',
        '- bvn',
        '- home_address',
        '- office_address',
        '- phone_number'
      ]
    }

    render json: instructions, status: :ok
  end
end
