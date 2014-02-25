require 'spec_helper'

# To set up, we need 3 users 
  # a user that will create playlist
  # one user that has access to playlist
  # one use that doesn't have access to playlist

describe "a user can share a playlist" do
  let(:creator) do 
    User.create!({
      email: "test@test.com",
      password: "m",
      password_confirmation: "m",
      first_name: "Marco",
      last_name: "Test",
      dob: Date.today,
      balance: 1000.00
    }) 
  end

  let(:shareable_user) do 
    User.create!({
      email: "su@test.com",
      password: "su",
      password_confirmation: "su",
      first_name: "Jenn",
      last_name: "Test",
      dob: Date.today,
      balance: 1.00
    }) 
  end  

  let(:lame_user) do 
    User.create!({
      email: "la@test.com",
      password: "la",
      password_confirmation: "la",
      first_name: "Bob",
      last_name: "Test",
      dob: Date.today,
      balance: 0.00
    }) 
  end  

#need to create a playlist

  let(:awesome_playlist) do 
    Playlist.create!({
      title: "Sweet Beats",
      user: creator,
      created_at: Date.now,
      update_at: Date.today 
      })
  end

#steps for user to implement this feature
  
  it "shares a playlist" do
  #setup

    #login(creator)
    login(creator)

    #workflow
    # add one user to shared
    visit user_path(creator)
    # visit the playlist -- expect creator to see 
    click_link "View Playlist"
    fill_in "Title", with: "Sweet Beats"
    select shareable_user.first_name, from: "users"
    click_button "Share"
    click_button "Log out"

    #login user(shared user)
    login(shareable_user)
    #visit playlist -- expect they can see playlist
    visit user_path(shareable_user)
    click_link "View Shared Playlist"
    # Expectations
    within ".playlist" do
      expect(page).to have_content "Sweet Beats"
    end
    #logout
    click_button "Log out"

    login(lame_user)
    #login user(not shared user)
    visit user_path(lame_user)
    #visit playlist show page -- expect not to see it
    click_link "View Shared Playlist"

    within ".playlist" do
      expect(page).not_to have_content "Sweet Beats"
    end

  end

    def login(user)
      visit "/login"
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button "Log in!"
    end

end