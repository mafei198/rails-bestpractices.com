module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
    when /sign in page/
      new_user_session_path
    when /sign in failure page/
      user_session_path
    when /sign up page/
      new_user_registration_path
    when /sign up failure page/
      users_path
    when /user edit page/
      edit_user_registration_path
    when /the posts page/
      posts_path
    when /create post failure page/
      posts_path
    when /update post failure page/
      post_path(Post.last) # this is super brittle
    when /comment post failure page/
      post_comments_path(Post.last) # this is super brittle
    when /create question failure page/
      questions_path
    when /update question failure page/
      question_path(Question.last)
    when /answer question failure page/
      question_answers_path(Question.last)
    when /the user show page for (.*)/
      user = User.find_by_login($1)
      user_path(user)

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
