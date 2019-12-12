require 'data_transformer'
require 'resource_creator'

["initial-bricks.csv", "initial-sets.csv"].each do |filename|
	csv_path = File.join(__dir__, filename)

	data_transformer = DataTransformer.new
	resource_creator = ResourceCreator.new
	model_class = "Spree::Product".constantize

	df = Daru::DataFrame.from_csv(csv_path)
	df = data_transformer.replace_names_with_object(df, "Product")

	resource_creator.create_objects_from_dataframe(df, "Product")
end
