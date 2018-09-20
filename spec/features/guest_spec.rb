describe 'visiting page as guest', type: :feature do
  scenario 'guest visiting root page' do
    visit '/'

    expect(page.body).to include(
      'To use the application you have to sign in using your Google account.',
      'Sign in with Google'
    )
  end
end
