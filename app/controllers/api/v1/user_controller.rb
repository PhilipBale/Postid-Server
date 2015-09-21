class Api::V1::UserController < Api::V1::ApiController

  def login_or_register_user
    login_params

    request_username = params[:user][:username]
    user = User.find_by(username: request_username)

    if !user.present?
      username = params[:user][:username]
      fail NotAuthenticatedError.new(3) if username == 'nil'
      user = User.create(login_params)

      if !user.save
        render json: {error: 'Unable to save new user', messages: @user.errors.full_messages, status: :precondition_failed},
               status: :precondition_failed and return
      end
    else
      pass = params[:user][:password]
      fail NotAuthenticatedError.new(5) unless user.password == pass
    end

    user.add_checkin
    user.update_ip(request)

    render json: {status: :ok, message: 'login success', user: user, friends: user.friend_state_ids}, status: :ok
  end

  def login_with_token
    params.require(:user).permit(:token)
    token = params[:user][:token]

    user = User.where(token: token).first
    fail NotAuthenticatedError.new(11) unless user.present?

    user.add_checkin
    user.update_ip(request)

    render json: {status: :ok, message: 'token login success', user: user, friends: user.friend_state_ids}, status: :ok
  end

  def update_phone_number
    authenticate_request
    update_phone_number_params

    @user.update_attributes(phone_number: params[:user][:phone_number])
    @user.update_ip(request)

    render json: {status: :created, message: 'Update phone success', user: @user}, status: :created

  end

  def friend_list
    authenticate_request
    @user.update_ip(request)

    render json: {status: :ok, message: 'Friend list success', user: @user, friends: @user.friend_ids}, status: :ok
  end

  def request_list
    authenticate_request
    @user.update_ip(request)

    render json: {status: :ok, message: 'Request list success', user: @user, requests: @user.request_ids}, status: :ok
  end

  def pending_list
    authenticate_request
    @user.update_ip(request)

    render json: {status: :ok, message: 'Pending list success', user: @user, pending: @user.pending_ids}, status: :ok
  end

  def add_friend
    authenticate_request
    friendship_params

    user_to_add = User.find(params[:friend][:id])
    if @user.friend_with?(user_to_add)
      # already friends
      puts "already friends"
      render json: {status: :bad_request, message: 'Already friends', user: @user}, status: :bad_request
    else
      if @user.invited?(user_to_add)
        # already invited
        puts "already invited"
        render json: {status: :bad_request, message: 'Already invited', pending: false, user: @user}, status: :bad_request
      elsif @user.invited_by?(user_to_add)
        # approve friendship
        puts "approving friendship"
        @user.approve(user_to_add)
        render json: {status: :created, message: 'Friendship created', pending: false, user: @user}, status: :created
      else
        # send invitation
        puts "sending invitation"
        @user.invite(user_to_add)
        render json: {status: :created, message: 'Friendship created', pending: true, user: @user}, status: :created
      end
    end
  end

  def remove_friend
    authenticate_request
    friendship_params

    @user.remove_friend(params[:friend][:id])

    render json: {status: :accepted, message: 'Friendship destroy sent', user: @user}, status: :accepted
  end

  def search_for_friends
    authenticate_request
    friend_search_params

    #todo return friend status and remove token from response

    query_string = params[:friend][:query]
    search_results = User.where('username like ? OR email like ?', "%#{query_string}%", "%#{query_string}%").order(:username).limit(20)
    render json: {status: :ok, message: 'Search complete', user: @user, search_results: search_results}, status: :ok
  end

  private
  def login_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :username)
  end

  def update_phone_number_params
    params.require(:user).permit(:token, :phone_number)
  end

  def friendship_params
    params.require(:friend).permit(:id)
  end

  def friend_search_params
    params.require(:friend).permit(:query)
  end

end