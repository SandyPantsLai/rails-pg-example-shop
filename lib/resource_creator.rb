require 'resource_updater'

class ResourceCreator

  def initialize
    @fields_to_exclude_from_create = {
      "Product" => ["taxon", "stock", "available_on", "condition", "num_parts", "set_num", "year"]
    }

    @postcreate_function = {
      "Product" => "update_product_related_properties"
    }
  end

	def create_objects_from_dataframe(df, resource_name)
    resource_updater = ResourceUpdater.new
    model_class = "Spree::#{resource_name.classify}".constantize

    df.each(:row).with_index(2) do |row, row_num|
      row_hash = row.to_h
      created_object = model_class.create!(row_hash.except(*@fields_to_exclude_from_create[resource_name]))
      if created_object and @postcreate_function[resource_name] then
        resource_updater.method(@postcreate_function[resource_name]).call(row_hash, created_object)
      end
      puts "Created object from row #{row_num}"
      rescue ActiveRecord::RecordInvalid => e
        puts "Row #{row_num}: #{e.to_s}\n"

    end
  end

  def create_nested_taxons(df, taxonomy_name)
    taxonomy = Spree::Taxonomy.where(name: I18n.t("spree.taxonomies.#{taxonomy_name}")).first_or_create!
    parent_taxon = Spree::Taxon.where(name: I18n.t("spree.taxonomies.#{taxonomy_name}")).first_or_create!

    # Find all unique parent taxons and create them, all nested under the main parent taxon
    df.uniq("parent")["parent"].each do |parent|
      unless parent.nil?
        taxon = parent_taxon.children.where(name: parent, position: 0).first_or_create!
        taxon.permalink = taxon.permalink.gsub("taxonomy_name/", "")
        taxon.taxonomy = taxonomy
        taxon.save!
      end
    end

    # create children taxons to nest under each parent taxon
    df.each(:row) do |row|
      row["parent"].nil? ? parent_name = I18n.t("spree.taxonomies.#{taxonomy_name}") : parent_name = row["parent"] 
      parent = Spree::Taxon.where(name: parent_name).first
      
      taxon = parent.children.where(name: row["name"]).first_or_create!
      taxon.permalink = taxon.permalink.gsub("taxonomy_name/#{row['parent']}", "")
      taxon.taxonomy = taxonomy
      taxon.save!
    end
  end

end