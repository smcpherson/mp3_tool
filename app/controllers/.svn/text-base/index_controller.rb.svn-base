class IndexController < ApplicationController
  layout "index", :except => [:processing_begin, :processing_display, :folder_ajax, :folder_tracks]

  # Initial View:
  def view
  end

  
  # combine Folder data (artist, title, year) with ID3: 
  def combine_folder_and_id3(id, folder_info)
    folder = Folder.find(id)
    tracks = Item.find_all_by_folder_id(id)
    tags = []; data = Hash.new
    tracks.each{|track| tags << Tag.find_by_item_id(track.id)}
    tags
    data[:artist] = tags[0]['artist'] ||= folder_info['artist']
    data[:title] = tags[0]['album']   ||= folder_info['title']
    data[:genre] = tags[0]['genre']   ||= nil
    data[:year] = tags[0]['year']     ||= folder_info['year']
    data[:tracks] = tags.length       ||= 0
    data
  end


  # AJAX method -- Start parsing individual folder
  def folder_ajax
    id = params['id']
    this_folder = Hash.new
    folder = parse_folder(params['folder'])
    process_path = Option.getValue('process_path')+"\\"+params['folder']
    this_folder = combine_folder_and_id3(id, folder)
    # Return match:
    # max_attempts = 20 
    @attempt = 1
    while (!@result || @result.nil? || @result.length == 0) do
      @result = identify(this_folder, @attempt)
      @attempt += 1
    end
  end
  
  
  # AJAX method -- Find tracks for current track ID:
  def folder_tracks
    @params = params
    @tracks = Track.find_all_by_album_id(params['id'])
  end

  # I will call this multiple times, starting with most accurate search & going down from there.
  # Results should be sent back to browser so feedback is rendered as progress is made.
  def identify(folder_info, attempt=1)
    case attempt
      when 1 # Match: Artist, Title, Year, Track Count
        query = "SELECT * FROM albums
                   where artist = \"#{folder_info[:artist]}\"
                     and title = \"#{folder_info[:title]}\"
                     and year = #{folder_info[:year]}
                     and track_count = #{folder_info[:tracks]}
                     limit 1" unless (!folder_info[:artist] || !folder_info[:title] || !folder_info[:year])

      when 2 # Match: Artist, Title, Year
        query = "SELECT * FROM albums
                   where artist = \"#{folder_info[:artist]}\"
                     and title = \"#{folder_info[:title]}\"
                     and year = #{folder_info[:year]}
                     limit 1"  unless (!folder_info[:artist] || !folder_info[:title] || !folder_info[:year])
      when 3 # Match: Artist, Title, Track Count
        query = "SELECT * FROM albums
                   where artist = \"#{folder_info[:artist]}\"
                     and title = \"#{folder_info[:title]}\"
                     and track_count = #{folder_info[:tracks]}
                     limit 1"  unless (!folder_info[:artist] || !folder_info[:title] || !folder_info[:year])
      when 4
        query = "SELECT * FROM albums
                   where artist = \"#{folder_info[:artist]}\"
                     and title = \"#{folder_info[:title]}\"
                     and year = #{folder_info[:year]}
                     limit 1" unless (!folder_info[:artist] || !folder_info[:title] || !folder_info[:year])
      when 5
        query = "SELECT * FROM albums
                   where artist = \"#{folder_info[:artist]}\"
                     and title = \"#{folder_info[:title]}\"
                     limit 1"
      when 6
        query = "SELECT * FROM albums
                   where artist like \"%#{folder_info[:artist]}%\"
                     and title like \"%#{folder_info[:title]}%\"
                     limit 10"
      when 7
        query = "SELECT * FROM albums
                   where artist like \"%#{folder_info[:artist]}%\"
                     and title like \"%#{folder_info[:title]}%\"
                     and track_count = #{folder_info[:tracks]}
                     limit 10"
      when 8
        query = "SELECT * FROM albums 
                   where artist like \"%#{folder_info[:artist]}%\"
                     and track_count = #{folder_info[:tracks]}
                     and year = #{folder_info[:year]}
                     limit 10"
      when 9
        query = "SELECT * FROM albums 
                   where artist like \"%#{folder_info[:artist]}%\"
                     and track_count = #{folder_info[:tracks]}
                     limit 10"
      when 10
        query = nil
    end
    
    # return the results:
    
    query.nil? ? result = "No matches!" : result = Album.find_by_sql(query)
    
    
  end


  # Main Processing Method
  def processing_begin
    @process_path = Option.getValue('process_path')
    empty_tables  = Option.getValue('empty_tables')
    folders       = list_folders(@process_path)['folders'].sort
    false_strings = ['0', 'false', 'no', '', nil]
    unless (false_strings.include?(empty_tables.downcase))
      Folder.delete_all
      Tag.delete_all
      Item.delete_all
    end
    i = 0;
    # For each folder in the processing path:
    for folder in folders
      folder_path = @process_path+'/'+folder
      files   = list_folders(folder_path)['files'].sort
      parsed  = parse_folder(folder)
      # Add This Folder to DB
      db_folder           = Folder.new()
      db_folder.name      = folder
      db_folder.full_path = folder_path
      db_folder.artist = parsed['artist']
      db_folder.title  = parsed['title']
      db_folder.year   = parsed['year']
      db_folder.save
      # For each file in this folder:
      for file in files
        # Add This File/Item to DB
        db_item = Item.new()
        db_item.name       = file
        db_item.full_path  = folder_path+'/'+file
        db_item.folder_id  = db_folder.id
        db_item.length_sec =  `mp3info  -p "%S" "#{db_item.full_path}"`
        db_item.save
          # Add existing ID3 data to database:
          parsed_tags       =  parse_file(folder_path+'/'+file)
          db_tag            = Tag.new()
          db_tag.item_id    = db_item.id
          db_tag.album      = parsed_tags.album
          db_tag.artist     = parsed_tags.artist
          db_tag.comment    = parsed_tags.comment
          db_tag.composer   = parsed_tags.composer
          db_tag.conductor  = parsed_tags.conductor
          db_tag.date       = parsed_tags.date
          db_tag.disc       = parsed_tags.disc
          db_tag.genre      = parsed_tags.genre
          db_tag.performer  = parsed_tags.performer
          db_tag.publisher  = parsed_tags.publisher
          db_tag.time       = parsed_tags.time
          db_tag.track      = parsed_tags.track
          db_tag.year       = parsed_tags.year
          db_tag.save
      end
      i+=1
    end
    redirect_to :action => 'processing_display'
  end


  # Display processed folders:
  def processing_display
    @folders = Folder.find_all
  end


  # Method to Parse ID3
  def parse_file(file)
    process_path   = Option.getValue('process_path')
    update_mp3     = Option.getValue('update_mp3')
    tags           = ID3Lib::Tag.new(file)
    return tags
  end


  # List folder contents
  # Return array of folders
  def list_folders(path)
    result = Hash.new
    result["folders"] = Array.new
    result["files"] = Array.new
    ignore_strings  = ['.','..']
    root_folder_contents  = Array.new
    Dir.foreach(path){|x|
    	(File.directory?(path+'/'+x) && (ignore_strings.include?(x) == false)) ? result["folders"]  << x : ''
    	(File.file?(path+'/'+x) && File.extname(x).downcase == '.mp3') ? result["files"]  << x : ''
    }
    return result
  end


  # Parse folder name using a Regular expression.
  # Assign results to a hash, then return it.
  def parse_folder(path)
    pattern = /(.*) - (.*) \[(\d\d\d\d)\]?/
    path.scan(pattern)
    result = Hash.new
    result['artist'] = $1
    result['title'] = $2
    result['year'] = $3
    result['folder'] = path
    return result
  end


# End of controller
end
