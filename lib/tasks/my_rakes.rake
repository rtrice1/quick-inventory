desc "Import Inventory"
  task :import_inventories => :environment do
    File.open("inventory.csv", "r").each do |line|
      AssetTag, Model, Serial, Description, Location, POC, Disposition, Win7, Office, Access, Visio, Project = line.strip.split(",")
      i = Inventory.new(:AssetTag => AssetTag, :Model => Model, :Serial => Serial, :Description => Description, :Location => Location, :POC => POC, :Disposition => Disposition, :Win7 => Win7, :Office => Office, :Access => Access, :Visio => Visio, :Project => Project)
      i.save
    end
  end
