shared_examples 'Search' do
  it 'calls search' do
    expect(ThinkingSphinx)
      .to receive(:search).with('foobar', classes: [scope.constantize])
    get :search, params: { search_string: 'foobar', search_scope: scope }
  end

  it 'render search view' do
    get :search, params: { search_string: 'foobar', search_scope: scope }
    expect(response).to render_template :search
  end
end
