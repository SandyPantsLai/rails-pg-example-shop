class DataTransformer

  def initialize
    @fields_to_replace = {
      "Product" => ["shipping_category", "tax_category", "taxon"]
    }
  end

  def replace_names_with_object(csv_path, resource_type)
    df = Daru::DataFrame.from_csv(csv_path)
    @fields_to_replace[resource_type].each do |field|
      field_class = "Spree::#{field.classify}".constantize
      unique_fields = df.uniq(field)[field]

      unique_fields.each do |field_data| #iterate through rows with unique values for field
        df[field].replace_values(field_data,field_class.where(name: field_data).first_or_create!)
      end
      rescue NoMethodError # occurs if unique_fields only contains one field
        df[field].replace_values(unique_fields,field_class.where(name: unique_fields).first_or_create!)
    end
    return df
  end

end