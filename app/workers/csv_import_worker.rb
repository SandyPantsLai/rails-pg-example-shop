require 'open-uri'
require 'data_transformer'
require 'resource_creator'

class CsvImportWorker < CsvWorker
  def perform(csv_path, resource_type)

    data_transformer = DataTransformer.new

    df = data_transformer.replace_names_with_object(csv_path, resource_type)

    resource_creator = ResourceCreator.new

    resource_creator.create_objects_from_dataframe(resource_type, df)
  end
end
