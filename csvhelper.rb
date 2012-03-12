require 'csv'
def to_csv arg
CSV.open('myfile.csv', 'w') do |csv|
  arg.each do |user|
    csv << [ user[0][:name], user[0][:id], user[0][:email], user[0][:provider], user[0][:uid]]
  end
end

end