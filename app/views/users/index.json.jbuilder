json.users @users, partial: 'users/user', as: :user
json.meta do
  json.total_pages @users.total_pages
  json.current_page @users.current_page
end
