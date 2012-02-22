class S3Store
  def read_file(path)
    get_s3_folder().files.get(path)
  end

  def write_file(path, contents)
    get_s3_folder().files.create(
      :key    => path,
      :body   => StringIO.open(contents)
    )
  end

  private

  def get_s3_folder()
    storage = Fog::Storage.new(:provider => 'AWS', :aws_access_key_id => "AKIAIGWQEG3PEACTFTEQ", :aws_secret_access_key => "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")
    directory = storage.directories.get("gistill-ebooks")
  end
end
