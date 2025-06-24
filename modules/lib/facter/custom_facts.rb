Facter.add('greeting') do
  setcode do
    'Hello from custom fact!'
  end
end
