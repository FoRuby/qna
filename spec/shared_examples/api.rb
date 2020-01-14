shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)

      expect(response).to have_http_status(401)
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: { access_token: 'invalid_token' }, headers: headers)

      expect(response).to have_http_status(401)
    end
  end
end

shared_examples_for 'Successful request' do
  it 'return 2xx status' do
    expect(response).to be_successful
  end
end

shared_examples 'Public fields' do
  it 'return all public fields' do
    attributes.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end
end

shared_examples 'Private fields' do
  it 'does not returns private fields' do
    attributes.each do |attr|
      expect(resource_response).to_not have_key(attr)
    end
  end
end

shared_examples 'List' do
  it 'returns list of resources' do
    expect(resource_response.size).to eq resource.size
  end
end
