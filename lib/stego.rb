require "stego/version"
# require "stego/wrapper"

module Stego
  STEGO_APP  = 'java -jar /usr/local/java/openstego-0.6.1/lib/openstego.jar'

  # Public: Embed data into image.
  #
  # original_filename - (string)      Full path to original image file
  # embedded_filename - (string)      Full path to name of generated embedded file
  # options:          - (hash)        Hash of OpenStego options
  #   embed_data      - (string)      Raw data to embed into original_filename (replacement for :messagefile)
  #   messagefile     - (filename)    File with text data to embed into original filename (replacement for :embed_data)
  #   compress        - (true/false)  Compress the message file before embedding (default)
  #   nocompress      - (true/false)  Do not compress the message file before embedding
  #   encrypt         - (true/false)  Encrypt the message file before embedding
  #   noencrypt       - (true/false)  Do not encrypt the message file before embedding (default)
  #   password        - (string)      Password to be used for encryption
  #
  # Examples
  #
  #   embed('/tmp/orig_image.jpg', '/tmp/new_embed_image.png', {embed_data: 'Super Secret', encrypt: true, password: 'tellme'})
  #   # => true
  #
  # Embeds data into image passed in and returns true, false or nil.
  def self.embed(original_filename, embedded_filename, options={})
    # TODO: Data can be written to file first and deleted for security in future version
    stego_embed_cmd = "#{embed_raw_data(options)}#{STEGO_APP} embed#{build_embed_cmd_options(options)} --coverfile #{original_filename} --stegofile #{embedded_filename}"
    #Rails.logger.info "Running cmd: #{stego_embed_cmd}"
    system(stego_embed_cmd)
  end

  # Public: Extract embedded data from image into file or directory.
  #
  # embedded_filename - (string)      Full path to name of image with embedded data
  # extract_data_path - (string)      Full path to file or directory to export data
  # options:          - (hash)        Hash of OpenStego options
  #   stegofile       - (string)      Stego file containing the embedded message
  #   extractfile     - (string)      Optional filename for the extracted data. Use this to override the filename embedded in the stego file
  #   extractdir      - (string)      Directory where the message file will be extracted. If this option is not provided, then the file is extracted to current directory
  #   password        - (string)      Password to be used for decryption.
  #
  # Examples
  #
  #   extract('/tmp/orig_image.jpg',{extractfile: '/tmp/get_data.txt', password: 'tellme'})
  #   # => true
  #
  # Extracts data from image passed in and returns true, false or nil.
  def self.extract(embedded_filename, options={})
    stego_extract_cmd = "#{STEGO_APP} extract --stegofile #{embedded_filename}#{build_extract_cmd_options(options)}"
    #Rails.logger.info "Running cmd: #{stego_extract_cmd}"
    system(stego_extract_cmd)
  end

  private

  # Build command line embed options for OpenStego
  def self.build_embed_cmd_options(options={})
    cmd_options     = ''
    cmd_options     += ' --messagefile -' if options[:embed_data]
    cmd_options     += " --messagefile #{options[:messagefile]}" if options[:messagefile]
    cmd_options     += ' --compress' if options[:compress]
    cmd_options     += ' --nocompress' if options[:nocompress]
    cmd_options     += ' --encrypt' if options[:encrypt]
    cmd_options     += ' --noencrypt' if options[:noencrypt]
    cmd_options     += " --password #{options[:password]}" if options[:password]

    cmd_options
  end

  # Set embedded raw data for OpenStego
  def self.embed_raw_data(options={})
    # Set Embed Data
    embed_raw_data  = ''
    embed_raw_data  += "echo '#{options[:embed_data]}' | " if options[:embed_data]

    embed_raw_data
  end

  # Build command line extract options for OpenStego
  def self.build_extract_cmd_options(options={})
    cmd_options   = ''
    cmd_options   += " --extractfile #{options[:extractfile]}" if options[:extractfile]
    cmd_options   += " --extractdir #{options[:extractdir]}" if options[:extractdir]
    cmd_options   += " --password #{options[:password]}" if options[:password]

    cmd_options
  end
end
