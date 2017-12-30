require 'csv'
require 'ruby-fann'

x_data = []
y_data = []

# Load data from CSV file into two arrays - one for independent variables X
# and one for the dependent variable Y
CSV.foreach('./admission.csv', headers: false) do |row|
  x_data.push([row[0].to_f, row[1].to_f])
  y_data.push([row[2].to_i])
end

test_size_percentange = 20.0 # 20.0%
test_set_size = x_data.size * (test_size_percentange / 100.to_f)
test_x_data = x_data[0..(test_set_size - 1)]
test_y_data = y_data[0..(test_set_size - 1)]
training_x_data = x_data[test_set_size..x_data.size]
training_y_data = y_data[test_set_size..y_data.size]
