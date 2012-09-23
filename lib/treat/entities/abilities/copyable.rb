module Treat::Entities::Abilities::Copyable
  
  require 'fileutils'
  
  # Only happens if the document/
  # collection is stored on disk.
  def copy_into(collection)
    unless collection.is_a?(
    Treat::Entities::Collection)
      raise Treat::Exception,
      "Cannot copy an entity into " +
      "something else than a collection."
    end
   return unless has?(:file) || has?(:folder)
    if type == :document
      copy_document_into(collection)
    elsif type == :collection
      copy_collection_into(collection)
    else
      raise Treat::Exception,
      "Can only copy a document " +
      "or collection into a collection."
    end
  end
  
  def copy_collection_into(collection)
    copy = dup; folder = get(:folder)
    return copy unless folder
    f = File.dirname(folder)
    f = f.split(File::SEPARATOR)[-1]
    f = File.join(collection.folder, f)
    return if File.readable?(f)
    FileUtils.mkdir(f) unless
    FileTest.directory(f)
    FileUtils.cp_r(folder, f)
    copy.set :folder, f
    copy
  end
  
  def copy_document_into(collection)
    copy = dup; file = get(:file)
    return copy unless file
    f = File.basename(file)
    f = File.join(collection.folder, f)
    return if File.readable?(f)
    FileUtils.cp(file, f)
    copy.set :file, f
    copy
  end

end
