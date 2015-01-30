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
    storage = Fog::Storage.new(:provider => 'AWS', :aws_access_key_id => "XXX", :aws_secret_access_key => "YYY")
    directory = storage.directories.get("gistill-ebooks")
  end
end
