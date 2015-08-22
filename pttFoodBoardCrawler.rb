#!/usr/bin/ruby

require 'net/telnet'
require 'iconv'

id = 'asdfgh5566'
password = '70d5e76a'
host = 'ptt.cc'
logFile = File.new 'log', 'w'
tn = Net::Telnet.new(
	'Host' => host,
#	'Port' => 23,
	'Port' => 3000, 
	'Timeout' => 5, 
	'WaitTime' => 1
)

AnsiSetDisplayAttr = /\x1B\[(?>(?>(?>\d+;)*\d+)?)m/
WaitForInput = '(?>\s+)(?>\x08+)'
tn.waitfor /\x08\Z/ do |s| print s end

#輸入帳號
tn.print "#{id}\n"
tn.waitfor /\s\Z/ do |s| print s end

PressAnyKey = '\xBD\xD0\xAB\xF6\xA5\xF4\xB7\x4E\xC1\xE4\xC4\x7E\xC4\xF2'
PressAnyKeyToContinue = /#{AnsiSetDisplayAttr}\s*(?>(?:\xA2\x65)+)#{AnsiSetDisplayAttr}\s*#{PressAnyKey}(?>\s*)#{AnsiSetDisplayAttr}(?>(?:\xA2\x65)+)\s*#{AnsiSetDisplayAttr}\Z/
#輸入密碼
tn.print "#{password}\n"
tn.waitfor /m\Z/ do |s| print s end

AnsiCursorHome = /\x1B\[(?>(?>\d+;\d+)?)H/
#任意鍵繼續
tn.print "\n"
tn.waitfor /H\Z/ do |s| print s end

#不填註冊單
tn.print "\n"
tn.waitfor /H\Z/ do |s| print s end

#按s選擇看板
tn.print 's'
tn.waitfor /\Z/ do |s| print s end

ArticleList = '\(b\)' + 
			  "#{AnsiSetDisplayAttr}" +
			  '\xB6\x69\xAA\x4F\xB5\x65\xAD\xB1\s*' +
			  "#{AnsiSetDisplayAttr}#{AnsiCursorHome}"

#進到food板
tn.print "food\n"
tn.waitfor PressAnyKeyToContinue do |s| print s end

#板標-任意鍵繼續
tn.print "\n"
tn.waitfor /#{ArticleList}\Z/ do |s| print s end

#按z進到精華區
tn.print 'z'
tn.waitfor /H\Z/ do |s| print s end
AnsiEraseLine = /\x1B\[K/
Location = /(z-3.*-(\d+))#{AnsiSetDisplayAttr}/
#WhereAmI = /\d+\.\s\S\S\s([^\x1B\x0D]+)\x0D*\s*(#{AnsiEraseLine}|\n)*#{AnsiCursorHome}?#{PressAnyKeyToContinue}/
dir = ''
isType = true
ArticleBottom = /#{AnsiSetDisplayAttr}.*\(\s*(\d+)%\).*\xC2\xF7\xB6\x7D#{AnsiSetDisplayAttr}#{AnsiCursorHome}\Z/
TypeList = ['z-3-1','z-3-1-1', 'z-3-1-2', 'z-3-1-3', 'z-3-1-3-90', 'z-3-1-4', 'z-3-1-4-1', 'z-3-1-5',
'z-3-1-6', 'z-3-1-6-1', 'z-3-1-6-2', 'z-3-1-6-3', 'z-3-1-7', 'z-3-1-8', 'z-3-1-9', 'z-3-1-9-1', 'z-3-1-10',
'z-3-1-11', 'z-3-1-11-1', 'z-3-1-11-2', 'z-3-1-11-3', 'z-3-1-11-4', 'z-3-1-11-5', 'z-3-1-11-6',
'z-3-1-11-7', 'z-3-1-11-8', 'z-3-1-11-9', 'z-3-1-11-10', 'z-3-1-11-11', 'z-3-1-11-11-1', 'z-3-1-11-11-2',
'z-3-1-11-11-3', 'z-3-1-11-12', 'z-3-1-11-12-1', 'z-3-1-11-12-2', 'z-3-1-11-12-3', 'z-3-1-12', 'z-3-1-12-1',
'z-3-1-12-2', 'z-3-1-12-3', 'z-3-1-12-4', 'z-3-1-12-5', 'z-3-1-12-6', 'z-3-1-13', 'z-3-2', 'z-3-2-1',
'z-3-2-2', 'z-3-2-2-2', 'z-3-2-2-3', 'z-3-2-2-4', 'z-3-2-3', 'z-3-2-4', 'z-3-2-5', 'z-3-2-6', 'z-3-2-7',
'z-3-2-8', 'z-3-2-9', 'z-3-2-10', 'z-3-2-11', 'z-3-2-12', 'z-3-2-13', 'z-3-2-14', 'z-3-2-15', 'z-3-2-16',
'z-3-2-17', 'z-3-2-18', 'z-3-2-19', 'z-3-2-19-1', 'z-3-2-19-2', 'z-3-2-20', 'z-3-3', 'z-3-3-1', 'z-3-3-1-1',
'z-3-3-1-2', 'z-3-3-1-3', 'z-3-3-1-4', 'z-3-3-1-5', 'z-3-3-1-6', 'z-3-3-1-7', 'z-3-3-1-8', 'z-3-3-1-9',
'z-3-3-1-10', 'z-3-3-1-11', 'z-3-3-1-12', 'z-3-3-1-13', 'z-3-3-1-14', 'z-3-3-1-15', 'z-3-3-2', 'z-3-4',
'z-3-4-1', 'z-3-4-2', 'z-3-5', 'z-3-6', 'z-3-6-1', 'z-3-6-2', 'z-3-6-3', 'z-3-6-4', 'z-3-6-5', 'z-3-6-6',
'z-3-6-7', 'z-3-6-8', 'z-3-6-9', 'z-3-6-10', 'z-3-6-11', 'z-3-6-12', 'z-3-6-13', 'z-3-6-14', 'z-3-6-15',
'z-3-7', 'z-3-7-1', 'z-3-7-2', 'z-3-7-3', 'z-3-7-4', 'z-3-7-4-1', 'z-3-7-4-2', 'z-3-7-4-3', 'z-3-7-5', 
'z-3-7-6', 'z-3-7-7', 'z-3-7-8', 'z-3-7-9', 'z-3-7-10', 'z-3-7-11', 'z-3-7-12', 'z-3-7-13', 'z-3-7-14',
'z-3-7-15', 'z-3-8', 'z-3-9', 'z-3-9-1', 'z-3-9-2', 'z-3-9-3', 'z-3-9-4', 'z-3-9-5', 'z-3-9-6', 'z-3-9-7',
'z-3-10', 'z-3-10-2', 'z-3-10-3', 'z-3-10-4', 'z-3-10-5', 'z-3-10-6', 'z-3-10-7', 'z-3-10-8', 'z-3-10-9',
'z-3-10-10', 'z-3-10-11', 'z-3-10-12', 'z-3-10-13', 'z-3-10-14', 'z-3-10-15', 'z-3-10-16', 'z-3-10-17',
'z-3-10-18', 'z-3-10-19', 'z-3-10-20', 'z-3-10-21', 'z-3-10-22', 'z-3-10-23', 'z-3-10-24', 'z-3-10-25',
'z-3-10-26', 'z-3-10-27', 'z-3-10-28', 'z-3-10-29', 'z-3-10-30', 'z-3-10-31', 'z-3-10-32', 'z-3-10-33',
'z-3-10-34', 'z-3-11', 'z-3-12', 'z-3-13', 'z-3-13-1', 'z-3-13-2', 'z-3-14', 'z-3-15', 'z-3-15-12', 
'z-3-17', 'z-3-17-1', 'z-3-17-2', 'z-3-17-3', 'z-3-17-4', 'z-3-17-5', 'z-3-17-6', 'z-3-17-7', 'z-3-17-8', 
'z-3-17-9', 'z-3-17-10', 'z-3-17-11', 'z-3-17-12', 'z-3-17-13', 'z-3-17-14', 'z-3-17-15', 'z-3-17-16', 
'z-3-17-17', 'z-3-17-18', 'z-3-17-19', 'z-3-17-20', 'z-3-17-21', 'z-3-17-22', 'z-3-17-23', 'z-3-17-24', 
'z-3-17-25', 'z-3-17-26', 'z-3-17-27', 'z-3-17-28', 'z-3-17-29', 'z-3-17-30', 'z-3-17-31', 'z-3-17-32', 
'z-3-17-33', 'z-3-18', 'z-3-18-1', 'z-3-18-2', 'z-3-18-3', ] 

SkipList = ['z-3-1-1-23-10', 'z-3-1-1-81', 'z-3-1-1-90', 'z-3-1-3-12-12', 'z-3-1-3-39-10', 'z-3-1-3-50-8',
'z-3-1-3-87', 'z-3-1-3-90-2-9', 'z-3-1-3-90-5-5', 'z-3-1-3-90-17', 'z-3-1-4-54-10', 'z-3-1-4-57-5',
'z-3-1-4-145-6', 'z-3-1-4-152', 'z-3-1-5-1', 'z-3-1-5-12', 'z-3-1-5-14-3', 'z-3-1-5-19', 'z-3-1-5-30',
'z-3-1-6-3-26-4', 'z-3-1-7-25-2', 'z-3-1-7-96', 'z-3-1-9-1-41', 'z-3-1-10-50', 'z-3-1-10-57', 'z-3-1-10-58',
'z-3-1-11-1-233', 'z-3-1-11-3-46', 'z-3-1-11-4-13', 'z-3-1-11-5-6-14', 'z-3-1-11-5-11', 'z-3-1-11-6-9', 
'z-3-1-11-7-10-1', 'z-3-1-11-9-3-12', 'z-3-1-11-9-7-8', 'z-3-1-11-9-39', 'z-3-1-11-10-14',
'z-3-1-11-11-1-20', 'z-3-1-11-12-1-53', 'z-3-1-11-12-2-20', 'z-3-1-11-12-3-30', 'z-3-1-11-12-4',
'z-3-1-12-1-26', 'z-3-1-12-3-25', 'z-3-1-12-4-26', 'z-3-1-12-5-17', 'z-3-1-12-6-37', 'z-3-1-12-7',
'z-3-1-79-12', 'z-3-1-92-3', 'z-3-1-212-10', 'z-3-1-218-8', 'z-3-1-532', 'z-3-1-837-6', 'z-3-1-863',
'z-3-2-1-1-10-2-9', 'z-3-2-1-1-10-2-20', 'z-3-2-1-1-11-9', 'z-3-2-1-1-11-10', 'z-3-2-1-1-20-4-6-1',
'z-3-2-1-1-20-5', 'z-3-2-1-2-2-8', 'z-3-2-1-2-7-5', 'z-3-2-2-1', 'z-3-2-2-2-1-37-9', 'z-3-2-2-2-1-40-7', 
'z-3-2-2-2-3-1', 'z-3-2-2-2-3-7', 'z-3-2-2-2-3-21', 'z-3-2-2-2-4-1', 'z-3-2-2-2-4-17', 'z-3-2-2-2-5-1',
'z-3-2-2-2-5-7', 'z-3-2-2-2-5-10', 'z-3-2-2-3-1-5-5', 'z-3-2-2-3-1-5-12', 'z-3-2-2-3-1-25-9', 
'z-3-2-2-3-1-28-6', 'z-3-2-2-4-2-19-5', 'z-3-2-2-4-2-19-12', 'z-3-2-2-4-2-44-6', 'z-3-2-2-4-2-150', 
'z-3-2-3-20-2-4-1', 'z-3-2-3-20-2-4-10', 'z-3-2-3-20-2-6', 'z-3-2-4-35-4', 'z-3-2-4-38-4-1',
'z-3-2-4-38-47', 'z-3-2-4-38-58', 'z-3-2-4-61-8', 'z-3-2-4-61-12', 'z-3-2-4-61-13', 'z-3-2-4-61-14',
'z-3-2-4-102', 'z-3-2-4-107', 'z-3-2-5-8-4', 'z-3-2-8-9', 'z-3-2-8-10', 'z-3-2-8-11', 'z-3-2-9-4',
'z-3-2-9-6', 'z-3-2-9-7', 'z-3-2-11-1', 'z-3-2-11-3', 'z-3-2-13-6', 'z-3-2-15-1', 'z-3-2-17-1',
'z-3-2-17-2', 'z-3-2-17-4', 'z-3-2-17-5', 'z-3-2-18-1', 'z-3-2-18-12', 'z-3-2-18-15', 'z-3-2-19-107',
'z-3-2-20-302', 'z-3-2-20-310', 'z-3-2-20-312-21', 'z-3-3-1-3-25', 'z-3-3-1-4-1-15-6', 'z-3-3-1-4-1-21-5',
'z-3-3-1-4-1-21-10', 'z-3-3-1-5-31', 'z-3-3-1-7-58', 'z-3-3-1-7-60', 'z-3-3-1-8-7-6', 'z-3-3-1-9-155',
'z-3-3-1-10-1-5-6', 'z-3-3-1-12-7', 'z-3-3-1-13-9-8', 'z-3-3-1-13-70', 'z-3-3-1-13-75', 'z-3-3-1-13-76',
'z-3-3-1-13-77', 'z-3-3-1-13-78', 'z-3-3-1-13-79', 'z-3-3-1-13-80', 'z-3-3-1-13-81', 'z-3-3-1-13-82',
'z-3-3-1-13-83', 'z-3-3-1-13-85', 'z-3-3-1-14-21', 'z-3-3-1-251', 'z-3-5-1-4-5', 'z-3-5-1-9-10',
'z-3-5-1-11-5', 'z-3-5-2-1-5', 'z-3-5-7-3-5', 'z-3-5-9-1-5', 'z-3-6-1-33', 'z-3-6-1-41-5', 'z-3-6-5-1',
'z-3-6-5-2', 'z-3-6-5-20', 'z-3-7-3-6-3', 'z-3-7-3-8-2', 'z-3-7-3-10-2', 'z-3-7-5-30-3', 'z-3-7-11-36-3',  
'z-3-10-12-4', 'z-3-10-19-1-5', 'z-3-11-128-4', 'z-3-11-221', 'z-3-11-241', 'z-3-12-4-18-6', 'z-3-12-9-10',
'z-3-12-10-1-3', 'z-3-12-24-5', 'z-3-14-6-26', 'z-3-15-2-86-9', 'z-3-15-2-86-10', 'z-3-15-11', 'z-3-16',
'z-3-17-20-32', 'z-3-17-23-24', 'z-3-18-2-2-42-9', 'z-3-18-2-2-42-10', 'z-3-18-2-2-55-4', 
'z-3-18-2-2-149-5', 'z-3-18-2-3-14-5', 'z-3-18-2-4-15-11', 'z-3-18-2-5-16-7', 'z-3-18-2-5-30-11', 
'z-3-18-2-7-9-11', 'z-3-18-2-11-6-5', 'z-3-18-3-44-5', ]

QuitList = ['z-3-1-2-44', 'z-3-1-3-91', 'z-3-1-5-32', 'z-3-1-6-2-43', 'z-3-1-9-31', 'z-3-1-11-1-278',
'z-3-1-11-5-20', 'z-3-1-11-8-48', 'z-3-1-11-12-13', 'z-3-2-1-7', 'z-3-2-2-2-1-56-5', 'z-3-2-2-4-2-112-3', 
'z-3-2-2-5',  'z-3-2-3-27', 'z-3-2-5-18', 'z-3-2-6-16', 'z-3-2-7-3', 'z-3-2-10-2', 'z-3-2-12-4',
'z-3-2-14-2', 'z-3-2-17-7', 'z-3-2-18-17', 'z-3-2-19-107', 'z-3-3-1-1-97', 'z-3-3-1-2-11', 'z-3-3-1-4-10',
'z-3-3-1-6-10', 'z-3-3-1-8-18', 'z-3-3-1-10-10', 'z-3-3-1-11-16', 'z-3-3-1-15-154', 'z-3-3-1-583',
'z-3-3-2-142', 'z-3-4-1-231', 'z-3-4-2-83', 'z-3-5-13', 'z-3-6-1-82', 'z-3-6-2-223', 'z-3-6-3-17',
'z-3-6-4-98', 'z-3-6-5-87', 'z-3-6-6-23', 'z-3-6-7-22', 'z-3-6-9-5', 'z-3-6-10-12', 'z-3-6-11-10',
'z-3-6-12-70', 'z-3-6-13-119', 'z-3-6-17', 'z-3-7-2-13', 'z-3-7-3-80', 'z-3-7-4-1-26', 'z-3-7-4-2-22',
'z-3-7-14-40', 'z-3-7-269', 'z-3-8-105', 'z-3-9-1-143', 'z-3-9-2-98', 'z-3-9-3-16', 'z-3-9-4-29',
'z-3-9-5-14', 'z-3-9-6-113', 'z-3-9-7-89', 'z-3-9-295', 'z-3-10-2-45', 'z-3-10-3-49', 'z-3-10-8-4', 
'z-3-10-9-13', 'z-3-10-10-14', 'z-3-10-11-19', 'z-3-10-12-34', 'z-3-10-13-10', 'z-3-10-14-4', 
'z-3-10-15-18', 'z-3-10-18-4', 'z-3-10-19-10', 'z-3-10-22-4', 'z-3-10-23-5', 'z-3-10-25-8', 'z-3-11-222-4',
'z-3-12-19-23', 'z-12-31', 'z-3-13-1-51', 'z-3-14-24', 'z-3-15-13', 'z-3-17-1-42', 'z-3-17-2-4',
'z-3-17-3-8', 'z-3-17-4-14', 'z-3-17-5-18', 'z-3-17-6-27', 'z-3-17-7-36', 'z-3-17-8-45', 'z-3-17-9-6',
'z-3-17-10-37', 'z-3-17-11-6', 'z-3-17-14-9', 'z-3-17-17-4', 'z-3-17-19-17', 'z-3-17-21-8', 'z-3-17-24-14', 'z-3-17-26-20', 'z-3-17-27-19', 'z-3-17-28-12', 'z-3-17-29-32', 'z-3-17-30-20', 'z-3-17-31-10', 
'z-3-17-33-37',  'z-3-18-1-62', 'z-3-18-2-14', 'z-3-18-3-254', ]

path = '客官，今天吃點什麼？（依食物種類分類）'
StartDir = 'z-3-1'
number = '000000'
typeIndex = TypeList.index StartDir
#typeIndex = TypeList.index 'z-3-18-3'
quitIndex = 0
QuitList.each_with_index do |s,t|
	if s =~ /#{StartDir}/
		quitIndex = t
		break
	end
end
#quitIndex = QuitList.index 'z-3-18-3-254'
skipIndex = 0
SkipList.each_with_index do |s,t|
	if s =~ /#{StartDir}/
		skipIndex = t
		break
	end
end
#skipIndex = SkipList.index 'z-3-18-2-5-16-7'
EndDir = 'z-3-4'
Dir.mkdir path unless FileTest.exist? path
#輸入3-1進到食物種類分類
tn.print StartDir+"\n"
lines = tn.waitfor /H\Z/ do |s| print s end
TypeName = /\A#{AnsiCursorHome}(#{AnsiSetDisplayAttr}\s*)?#{AnsiSetDisplayAttr}(\xA1\xBB )?\s*([^\n\x1B]+)(\n|\x1B)/
typeStack = []
begin
	#DFS進去一個文章
	begin
		#我在哪
		tn.print "\x17"
		lines = tn.waitfor PressAnyKeyToContinue do |s| print s 
		end
		raise 'Location doesn\'t match!' if lines !~ Location
		while $1 == SkipList[skipIndex]
			skipIndex += 1
			#任意鍵
			tn.print "\n"
			tn.waitfor /H\Z/ do |s| print s end
			#往下
			tn.print 'j'
			#我在哪
			tn.print "\x17"
			lines = tn.waitfor PressAnyKeyToContinue do |s| print s end
			raise 'Location doesn\'t match!' if lines !~ Location
		end
		if isType = TypeList[typeIndex] == $1
			typeIndex += 1
			typeStack.push($1)
		end
		#任意鍵
		tn.print "\n"
		tn.waitfor /H\Z/ do |s| print s end
		#進去目錄
		tn.print "\n"
		lines = tn.waitfor /H\Z/ do |s| print s 
		logFile.puts s end
		if isType
			if TypeName !~ lines
				logFile.puts lines
				raise 'Name doesn\'t match!'
			end
			#path加一層
			logFile.puts $3 + number
			path += '/' + Iconv.conv('utf8', 'big5', $3).strip.squeeze(' ').gsub(' ', '_')
			Dir.mkdir path unless FileTest.exist? path
		end
	end until lines =~ ArticleBottom
	#存取文章
	#logFile.puts $1
	#theEnd = ($1 == '100')
	article = lines.dup
	article.sub! /\([^)]*\)/, '()'
	article.gsub! ArticleBottom, ''
#	until theEnd
#		tn.print 'j'
#		lines = tn.waitfor /H\Z|m\Z/ do |s| print s 
#		logFile.puts s end
#		theEnd = ($1 == '100');
#		lines.gsub! ArticleBottom, ''
#		gets 
#	end
	article.gsub! /#{AnsiCursorHome}|#{AnsiEraseLine}/, "\n"
	article.gsub! AnsiSetDisplayAttr, ''
	article.strip!.squeeze! "\n"
	writeFile = File.new "#{path}/#{number.next!}.txt", 'w'
	writeFile.puts article
	writeFile.close	
	#退出來一格
	tn.print 'q'	
	lines = tn.waitfor /H\Z/ do |s| print s end
	begin
		#我在哪
		tn.print "\x17"
		lines = tn.waitfor PressAnyKeyToContinue do |s| print s end
		#任意鍵
		tn.print "\n"
		tn.waitfor /H\Z/ do |s| print s end
		raise 'Location doesn\'t match!' if lines !~ Location
		#從分類出來的話，path要少一層
		if typeStack.include? $1
			path.slice! path.rindex('/')...path.size
			typeStack.pop
			isType = true
		end
		begin
			#往下
			tn.print 'j'
			#我在哪
			tn.print "\x17"
			lines = tn.waitfor PressAnyKeyToContinue do |s| print s end
			#任意鍵
			tn.print "\n"
			tn.waitfor /H\Z/ do |s| print s end
			raise 'Location doesn\'t match!' if lines !~ Location
			break if reachEnd = $1 == EndDir
			if $1 == SkipList[skipIndex]
				skipIndex += 1
				redo
			end
		end while false
		break if reachEnd
		if $1 == QuitList[quitIndex]
			quitIndex += 1
		else
			break unless $2 == '1'
		end
		#退出來一格
		tn.print 'q'	
		lines = tn.waitfor /H\Z/ do |s| print s end
	end while true
end until reachEnd
logFile.close

