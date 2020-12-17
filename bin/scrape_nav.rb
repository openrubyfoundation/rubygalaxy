#!/usr/local/rvm/wrappers/ruby-2.4.2/ruby

require 'net/imap'
require 'fileutils'

DIRNAME = File.dirname(__FILE__)

def run
  destination = "/var/local/email_scraper/incoming"

  imap = get_imap_connection

  [
    ['Procure Daily NAV','',"/bin/cat 'FILEPATH' | #{DIRNAME}/convert_nav.rb > #{DIRNAME}/../src/_data/nav.yml"], 
  ].each do |tuple|
    email_subject, file_name, command, subdir = tuple

    puts "fetch #{email_subject}"
    msg_ids = imap.search(["SUBJECT", email_subject])

    # Use only the last one

    begin
      msg = imap.fetch( msg_ids.last, ["ENVELOPE","UID","BODY"] ).first
      body = msg.attr["BODY"]
      body_index = 1
      name = nil
    rescue Exception => err
      puts "Error: #{err}"
      imap = get_imap_connection
      next
    end
    body.parts.each do |part|
      begin
        media_type = part.media_type
        name = ( file_name.to_s.empty? ? part.param['NAME'] : file_name ) || "#{email_subject.gsub(/\s/,'')}.#{media_type}"
      rescue Exception
        next
      end
      next unless name
      body_index += 1

      attachment = imap.fetch(msg_ids.last, "BODY[#{body_index}]").first.attr["BODY[#{body_index}]"]
      attachment_path = File.expand_path(File.join(destination,name))
      attachment_path = nil unless attachment_path =~ /^#{destination}/
      next unless destination != attachment_path

      puts "processing attachment"
      if attachment && attachment_path
        file_path = File.join([destination, subdir, name].compact)
        FileUtils.mkdir_p File.dirname(file_path) unless FileTest.exist? File.dirname(file_path)
        File.open(file_path,"wb+") {|fh| fh.write(base64?(attachment) ? attachment.unpack('m').join : attachment)}
        sha_new = `/usr/bin/shasum "#{file_path}"`.split(/\s+/).first
        sha_old = nil
        if FileTest.exist? "#{file_path}.sha"
          File.open("#{file_path}.sha","r") {|fh| sha_old = fh.read.chomp}
        end
        if sha_new != sha_old
          command_to_run = command.gsub(/FILEPATH/,file_path)
          puts command_to_run
          if system(command_to_run)
            File.open("#{file_path}.sha","w+") {|fh| fh.write sha_new }
          end
        end
      end
    end
  end

  imap.close
end

def get_imap_connection
  puts "get imap connection"
  imap = Net::IMAP.new('imap.gmail.com',993,true)
  imap.login('ram_cma@enigo.com','ramccmpwd')
  imap.examine('INBOX')
  imap
end

def base64?(value)
  value.gsub(/[\r\n]/,'') =~ /^([A-Za-z0-9+\/]{4})*([A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{2}==)?$/
end

run