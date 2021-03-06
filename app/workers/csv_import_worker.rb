require 'data_transformer'
require 'resource_creator'

class CsvImportWorker < CsvWorker
  def perform(csv_path, resource_type)

    data_transformer = DataTransformer.new
    df = Daru::DataFrame.from_csv(csv_path)
    df = data_transformer.replace_names_with_object(df, resource_type)

    resource_creator = ResourceCreator.new

    resource_creator.create_objects_from_dataframe(df, resource_type)
  end
end
