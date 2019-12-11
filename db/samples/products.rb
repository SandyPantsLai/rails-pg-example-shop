require 'data_transformer'
require 'resource_creator'

csv_path = File.join(__dir__, "initial_bricks.csv")

data_transformer = DataTransformer.new
resource_creator = ResourceCreator.new
model_class = "Spree::Product".constantize

df = data_transformer.replace_names_with_object(csv_path, "Product")
resource_creator.create_objects_from_dataframe("Product", df)

