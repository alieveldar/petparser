#FIRST TIME RUN THIS SCRIPT TWO TIMES!!! BECAUSE IN YOU FOLDER NOT ANY XLS FILE!!!

require 'open-uri'
require 'digest/md5'
require 'roo'
require 'pg'
require 'zip'
require 'roo-xls'

urltosave = "http://locator.transitcard.ru/locator/web/v1/report/points?pointTypes=8&isStk=false&x1=-58.64249754650558&y1=-30.994994359375003&x2=81.09058618886175&y2=-174.784056859375&zoom=2&type=Xls" #paste there your link from petrol locator
download = open(urltosave)
_cat = Dir.pwd
name = Time.now
name = name.to_s
format = ".xls" #the file format 
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
xlsx.parse(clean: true)
#puts xlsx.info
last_row = xlsx.last_row
first_row = xlsx.first_row + 2 #make 2 constant
first_column = xlsx.first_column
last_column = xlsx.last_column
puts 'первая строчка = ' + (first_row).to_s
puts 'последняя строчка = ' +  (last_row).to_s
puts 'первая колонка равна = '  + (first_column).to_s
puts 'последняя колонка равна =  ' + (last_column).to_s

conn = PG::Connection.open(:dbname => 'fuelcost') #basename
#res = conn.exec_params("INSERT INTO azsparse VALUES ($1, $2, $3, $4)", ['i', 'm', 'very', 'bad'])
#0puts res
#puts xlsx 
#puts (xlsx.row(4)).class
#sheet = xlsx.row(4)
#puts sheet.length
#puts sheet[4]
countrow = last_row + 1 #number of cycles for reading and writing data
startrow = 1 #number of first row in file xls
puts startrow 
conn.transaction do #Transaction for fast bd adding
	countrow.times do  |startrow|
	sheetrow = xlsx.row(startrow)
	res = conn.exec_params("INSERT INTO azsparse VALUES ($1, $2, $3, $4)", [sheetrow[0], sheetrow[1], sheetrow[2], sheetrow[3]])
end

end
