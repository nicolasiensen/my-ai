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

# Setup training data model
train = RubyFann::TrainData.new(
  inputs: training_x_data,
  desired_outputs: training_y_data
)

# Setup model and train using training data
model = RubyFann::Standard.new(
  num_inputs: 2,
  hidden_neurons: [6],
  num_outputs: 1
)

# 5000 max_epochs, 500 errors between reports and 0.01 desired
# mean-squared-error
model.train_on_data(train, 5000, 500, 0.01)

predicted = []

test_x_data.each do |params|
  predicted.push(model.run(params).map(&:round))
end

correct_data = predicted.collect.with_index do |e, i|
  e == test_y_data[i] ? 1 : 0
end

correct_sum = correct_data.inject { |sum, e| sum + e }

puts "Accuracy: #{((correct_sum.to_f / test_set_size) * 100).round(2)}%"
puts "Test set of size #{test_size_percentange}%"
