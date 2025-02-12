require 'rails_helper'
RSpec.describe 'New Viewing Party' do
  before :each do
    @user = User.create(username: 'test_user', email: 'user@test.com', password: 'test_password', password_confirmation: 'test_password')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    allow(Time).to receive(:now).and_return(Time.zone.parse("2021-07-10 01:00:00 -0600"))

    response_body = File.read('./spec/fixtures/toy_story.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/862?api_key=#{ENV['MOVIE_DB_KEY']}&language=en&append_to_response=credits,reviews")
        .with(
          headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v1.4.1'
          })
        .to_return(status: 200, body: response_body, headers: {})

    visit '/movies/862'
  end

  it "has a link to root path" do
    click_on 'Create Viewing Party for Movie'
    expect(current_path).to eq new_party_path
    expect(page).to have_link("Welcome Page")

    click_on "Welcome Page"

    expect(current_path).to eq root_path
  end

  it "has a link to dashboard" do
    click_on 'Create Viewing Party for Movie'
    expect(current_path).to eq new_party_path
    expect(page).to have_link("Dashboard")
    
    click_on "Dashboard"

    expect(current_path).to eq dashboard_path
  end

  it "Creates a new viewing party" do
    @user2 = User.create(username: 'test_user2', email: 'user2@test.com', password: 'test_password', password_confirmation: 'test_password')
    @user3 = User.create(username: 'test_user3', email: 'user3@test.com', password: 'test_password', password_confirmation: 'test_password')
    @user4 = User.create(username: 'test_user4', email: 'user4@test.com', password: 'test_password', password_confirmation: 'test_password')
    @friendship1 = Friendship.create(user_id: @user.id, friend_id: @user2.id)
    @friendship2 = Friendship.create(user_id: @user.id, friend_id: @user3.id)
    @friendship3 = Friendship.create(user_id: @user.id, friend_id: @user4.id)

    expect(page).to have_content 'Toy Story'
    click_on 'Create Viewing Party for Movie'
    expect(current_path).to eq new_party_path

    duration = '81'
    starts_at_date = Date.parse('2021-07-14')
    starts_at_time = Time.zone.parse('19:00')

    fill_in 'party[duration]', with: duration
    fill_in 'party[starts_at_date]', with: starts_at_date
    fill_in 'party[starts_at_time]', with: starts_at_time
    
    check('test_user2')
    check('test_user3')
    check('test_user4')
    uncheck('test_user4')
    click_on "Create Party"

    expect(current_path).to eq dashboard_path
    within '.hosting' do
      expect(page).to have_content('Toy Story')
      expect(page).to have_content('1 hr 21 min')
      expect(page).to have_content('7:00pm')
      expect(page).to have_content('Wednesday, July 14, 2021')
      expect(page).to have_content(@user2.username)
      expect(page).to have_content(@user3.username)
      expect(page).not_to have_content(@user4.username)
    end
  end

  it "doesnt create party if user has no friends" do
    @user2 = User.create(username: 'test_user2', email: 'user2@test.com', password: 'test_password', password_confirmation: 'test_password')

    expect(page).to have_content 'Toy Story'
    click_on 'Create Viewing Party for Movie'
    expect(current_path).to eq new_party_path

    duration = '81'
    starts_at_date = Date.parse('2021-07-14')
    starts_at_time = Time.zone.parse('13:00')

    fill_in 'party[duration]', with: duration
    fill_in 'party[starts_at_date]', with: starts_at_date
    fill_in 'party[starts_at_time]', with: starts_at_time

    expect(page).to have_content("You currently have no friends to watch with")
    expect(page).not_to have_content('test_user2')

    click_on "Create Party"

    expect(page).to have_content("Error: Party must need friends.")
    expect(current_path).to eq new_party_path
  end


  it "doesnt create party if no fiends are added" do
    @user2 = User.create(username: 'test_user2', email: 'user2@test.com', password: 'test_password', password_confirmation: 'test_password')
    @user3 = User.create(username: 'test_user3', email: 'user3@test.com', password: 'test_password', password_confirmation: 'test_password')
    @user4 = User.create(username: 'test_user4', email: 'user4@test.com', password: 'test_password', password_confirmation: 'test_password')
    @friendship1 = Friendship.create(user_id: @user.id, friend_id: @user2.id)
    @friendship2 = Friendship.create(user_id: @user.id, friend_id: @user3.id)
    expect(page).to have_content 'Toy Story'
    click_on 'Create Viewing Party for Movie'
    expect(current_path).to eq new_party_path

    duration = "83"
    starts_at_date = Date.parse('2021-07-14')
    starts_at_time = Time.zone.parse('13:00')

    fill_in 'party[duration]', with: duration
    fill_in 'party[starts_at_date]', with: starts_at_date
    fill_in 'party[starts_at_time]', with: starts_at_time

    click_on "Create Party"

    expect(page).to have_content('Error: Party must need friends.')
    expect(current_path).to eq new_party_path
  end

  it 'does not create a party if time is in the past' do
    user2 = User.create(username: 'test_user2', email: 'user2@test.com', password: 'test_password', password_confirmation: 'test_password')

    friendship1 = Friendship.create(user_id: @user.id, friend_id: user2.id)

    expect(page).to have_content 'Toy Story'

    click_on 'Create Viewing Party for Movie'

    expect(current_path).to eq new_party_path

    duration = '81'
    starts_at_date = 5.days.ago
    starts_at_time = Time.parse('13:00')

    fill_in 'party[duration]', with: duration
    fill_in 'party[starts_at_date]', with: starts_at_date
    fill_in 'party[starts_at_time]', with: starts_at_time
    check('test_user2')

    click_on "Create Party"

    expect(page).to have_content "Party must be set for a future date"
  end

  it "does not create if party duration is less than movie duration" do
    @user2 = User.create(username: 'test_user2', email: 'user2@test.com', password: 'test_password', password_confirmation: 'test_password')
    @user3 = User.create(username: 'test_user3', email: 'user3@test.com', password: 'test_password', password_confirmation: 'test_password')
    @user4 = User.create(username: 'test_user4', email: 'user4@test.com', password: 'test_password', password_confirmation: 'test_password')
    @friendship1 = Friendship.create(user_id: @user.id, friend_id: @user2.id)
    @friendship2 = Friendship.create(user_id: @user.id, friend_id: @user3.id)
    @friendship3 = Friendship.create(user_id: @user.id, friend_id: @user4.id)

    expect(page).to have_content 'Toy Story'
    click_on 'Create Viewing Party for Movie'
    expect(current_path).to eq new_party_path

    duration = '60'#actually 81
    starts_at_date = Date.parse('2021-07-14')
    starts_at_time = Time.zone.parse('13:00')

    fill_in 'party[duration]', with: duration
    fill_in 'party[starts_at_date]', with: starts_at_date
    fill_in 'party[starts_at_time]', with: starts_at_time

    check('test_user2')
    click_on "Create Party"

    expect(current_path).to eq new_party_path
    expect(page).to have_content("Error: Party duration must match or exceed movie runtime.")
  end
end
