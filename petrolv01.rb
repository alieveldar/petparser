require 'open-uri'
require 'digest/md5'
require 'roo'
require 'pg'
require 'zip'
require 'roo-xls'
download = open('http://locator.transitcard.ru/locator/web/v1/report/points?pointTypes=8&isStk=false&x1=-58.64249754650558&y1=-30.994994359375003&x2=81.09058618886175&y2=-174.784056859375&zoom=2&type=Xls')
_cat = Dir.pwd
name = Time.now
name = name.to_s
format = ".xls"
fullname = name + format
IO.copy_stream(download, fullname)
puts 'OK Bomb have been planted'
sleep 2
list = Dir.glob("*.xls") 
puts list
newfilemd5 = Digest::MD5.hexdigest(File.read(_cat + "/" + list[1]))
oldfilemd5 = Digest::MD5.hexdigest(File.read(_cat + "/" + list[0]))
puts newfilemd5 + "   New file"
sleep 2
puts oldfilemd5 + "   Old file"
if newfilemd5 == oldfilemd5 
	 
		File.delete(_cat + "/" + list[1])
		puts "New file not valid"
	 
else 
		File.delete(_cat + "/" + list[0])
		puts "Old file not valid"
	
end
list = Dir.glob("*.xls")
puts list
xlsfile = ("./" + (list[0].to_s))
puts xlsfile
xlsx = Roo::Spreadsheet.open(xlsfile)
puts xlsx
xlsx =  xlsx.to_csv
puts xlsx

