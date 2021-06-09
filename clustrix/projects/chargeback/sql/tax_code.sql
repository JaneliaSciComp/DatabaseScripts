select max(close_date) into @close_date from compute_chargeback;

-- hours and $ to neuroseq
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93400', compute_chargeback.project = 'JVS016800'
where compute_chargeback.owner = 'suginok'
and compute_chargeback.department_code = '93428'
and compute_chargeback.close_date = @close_date;
-- Mackinnon hours and $ to project
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93400', compute_chargeback.project = 'JVS000250'
where compute_chargeback.owner = 'mackinnonr'
and compute_chargeback.department_code = '1102'
and compute_chargeback.close_date = @close_date;
-- JACS hours to Card
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93221'
where compute_chargeback.owner in ('ehrhardte')
and compute_chargeback.department_code = '1070'
and compute_chargeback.close_date = @close_date;
-- JACS hours to Dickson
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93221'
where compute_chargeback.owner in ('bakerc10','dicksonb','dicksonlab','mckellarc','minegishir','sterneg','senr')
and compute_chargeback.department_code = '1070'
and compute_chargeback.close_date = @close_date;
-- JACS hours to Dickson
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93418', compute_chargeback.project = 'JVS418010'
where compute_chargeback.owner in ('ditp','namikis')
and compute_chargeback.department_code = '1070'
and compute_chargeback.close_date = @close_date;
-- JACS hours and $ to flylight
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93416', compute_chargeback.project = 'JVS416010'
where compute_chargeback.owner in ('goldammerj','itom10','meissnerg')
and compute_chargeback.department_code = '1070'
and compute_chargeback.close_date = @close_date;
-- JACS hours to Jayaraman
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93305'
where compute_chargeback.owner = 'danc'
and compute_chargeback.department_code = '1070'
and compute_chargeback.close_date = @close_date;
-- JACS hours to Keleman
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93330'
where compute_chargeback.owner = 'leiz'
and compute_chargeback.department_code = '1070'
and compute_chargeback.close_date = @close_date;
-- JACS hours to Lee tz
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93217'
where compute_chargeback.owner = 'leetlab'
and compute_chargeback.department_code = '1070'
and compute_chargeback.close_date = @close_date;
-- JACS hours to rubin
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93205'
where compute_chargeback.owner in ('asoy','dolanm','nerna','wolfft')
and compute_chargeback.department_code = '1070'
and compute_chargeback.close_date = @close_date;
-- hours and $ to flylight
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93416', compute_chargeback.project = 'JVS416010'
where compute_chargeback.owner = 'flylight'
and compute_chargeback.department_code = '1084'
and compute_chargeback.close_date = @close_date;
--
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93204'
where compute_chargeback.owner = 'wdbpuser'
and compute_chargeback.department_code = '1048'
and compute_chargeback.close_date = @close_date;
--
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93219'
where compute_chargeback.owner = 'ravindranaths'
and compute_chargeback.department_code = '93184'
and compute_chargeback.close_date = @close_date;
-- Larval hours to Zlatic
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93313'
where compute_chargeback.owner in ('larval','larvalolympiad')
and compute_chargeback.department_code = '93424'
and compute_chargeback.close_date = @close_date;
--
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93105'
where compute_chargeback.owner = 'ravindranaths'
and compute_chargeback.department_code = '93428'
and compute_chargeback.close_date = @close_date;
--
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93218'
where compute_chargeback.owner = 'revyakina'
and compute_chargeback.department_code = '93400'
and compute_chargeback.close_date = @close_date;
--
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93418', compute_chargeback.project = 'JVS418010'
where compute_chargeback.owner = 'ditp'
and compute_chargeback.department_code = '93418'
and compute_chargeback.project = 'NONE'
and compute_chargeback.close_date = @close_date;
--
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93224'
where compute_chargeback.owner in ('cembrowskim','blosse')
and compute_chargeback.department_code = '93180'
and compute_chargeback.close_date = @close_date;
-- olympiad project code
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS418010'
where compute_chargeback.department_code = '93418'
and compute_chargeback.project = 'NONE'
and compute_chargeback.close_date = @close_date;
-- em project code
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS417010'
where compute_chargeback.department_code = '93417'
and compute_chargeback.project = 'NONE'
and compute_chargeback.close_date = @close_date;
-- light project code
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS416010'
where compute_chargeback.department_code = '93416'
and compute_chargeback.project = 'NONE'
and compute_chargeback.close_date = @close_date;
-- rowell hours and $ to transcription
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93423', compute_chargeback.project = 'JVS423010'
where compute_chargeback.owner = 'rowellw'
and compute_chargeback.department_code = '93426'
and compute_chargeback.close_date = @close_date;
-- neuroseq project code
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS428010'
where compute_chargeback.department_code = '93428'
and compute_chargeback.project = 'NONE'
and compute_chargeback.close_date = @close_date;
-- transcription imaging project code
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS423010'
where compute_chargeback.department_code = '93423'
and compute_chargeback.project = 'NONE'
and compute_chargeback.close_date = @close_date;
-- berg hours and $ em
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93417', compute_chargeback.project = 'JVS417010'
where compute_chargeback.owner = 'bergs'
and compute_chargeback.department_code = '1019'
and compute_chargeback.project = 'NONE'
and compute_chargeback.close_date = @close_date;
-- Lou S hours and $ em
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93417', compute_chargeback.project = 'JVS417010'
where compute_chargeback.project = 'flyemproj'
and compute_chargeback.close_date = @close_date;
-- branson lab
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93319',compute_chargeback.project = 'NONE'
where compute_chargeback.owner = 'bransonk'
and compute_chargeback.department_code = '93418'
and compute_chargeback.close_date = @close_date;
-- bransonlab
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93319',compute_chargeback.project = 'NONE'
where compute_chargeback.owner = 'bransonlab'
and compute_chargeback.department_code = '93418'
and compute_chargeback.close_date = @close_date;
-- heberlein lab
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93223',compute_chargeback.project = 'NONE'
where compute_chargeback.owner = 'heberlein'
and compute_chargeback.department_code = '93418'
and compute_chargeback.close_date = @close_date;
-- heberleinlab
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93223',compute_chargeback.project = 'NONE'
where compute_chargeback.owner = 'heberleinlab'
and compute_chargeback.department_code = '93418'
and compute_chargeback.close_date = @close_date;
-- truman lab
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93212',compute_chargeback.project = 'NONE'
where compute_chargeback.owner = 'trumant'
and compute_chargeback.department_code = '93418'
and compute_chargeback.close_date = @close_date;
-- flyTEM project
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93491',compute_chargeback.project = 'JTEM00001'
where compute_chargeback.owner = 'flyTEM'
and compute_chargeback.close_date = @close_date;
-- flyEM
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93417',compute_chargeback.project = 'JVS417010'
where compute_chargeback.owner = 'plazas'
and compute_chargeback.close_date = @close_date;
-- flyEM
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93417',compute_chargeback.project = 'JVS417010'
where compute_chargeback.owner = 'paragt'
and compute_chargeback.close_date = @close_date;
-- Druckmann lab
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93328',compute_chargeback.project = 'NONE'
where compute_chargeback.owner = 'weiz'
and compute_chargeback.close_date = @close_date;
-- Denk lab
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93419',compute_chargeback.project = 'NONE'
where compute_chargeback.owner = 'rickgauerj'
and compute_chargeback.close_date = @close_date;
-- olympiad
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93426',compute_chargeback.project = ''
where compute_chargeback.owner = 'olympiad'
and compute_chargeback.close_date = @close_date;
-- gennady denisov using dudman lab
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93098',compute_chargeback.owner = 'denisovg'
where compute_chargeback.owner = '093307'
and compute_chargeback.department_code = '93098'
and compute_chargeback.close_date = @close_date;
-- eric yttri using dudman lab department #
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93307',compute_chargeback.owner = 'yttrie'
where compute_chargeback.owner = '093307'
and compute_chargeback.department_code = '93307'
and compute_chargeback.close_date = @close_date;
-- undergrad scholar with dudman lab
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93307'
where compute_chargeback.close_date = @close_date
and compute_chargeback.department_code = '93181'
and compute_chargeback.owner = 'phillipsj10';
-- graduate scholar with ahrens lab
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93327'
where compute_chargeback.close_date = @close_date
and compute_chargeback.department_code = '93184'
and compute_chargeback.owner = 'bennettd';
-- brenowitz using department code 1060
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93421', compute_chargeback.project = 'JVS421010'
where compute_chargeback.close_date = @close_date
and compute_chargeback.department_code = '1060'
and compute_chargeback.owner = 'brenowitzs';
-- rubin charges
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93205'
where compute_chargeback.close_date = @close_date
and compute_chargeback.department_code = '93418'
and compute_chargeback.owner = 'rubin';
-- undergrad with svoboda lab
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93204'
where compute_chargeback.close_date = @close_date
and compute_chargeback.owner = 'sofroniewn'
and compute_chargeback.department_code = '93180';
-- update 93432 project code
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS432010'
where compute_chargeback.close_date = @close_date
and compute_chargeback.department_code = '93432';
-- update 93421 project code
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS421010'
where compute_chargeback.close_date = @close_date
and compute_chargeback.department_code = '93421';
-- update 93434 project code
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS434010'
where compute_chargeback.close_date = @close_date
and compute_chargeback.department_code = '93434';
-- update furukawah
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS016300'
where compute_chargeback.close_date = @close_date
and compute_chargeback.owner = 'furukawah'
and compute_chargeback.department_code = '93400';
-- update massonj
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS015401'
where compute_chargeback.close_date=@close_date
and compute_chargeback.owner = 'massonj'
and compute_chargeback.department_code = '93400';
-- update moharb
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS018800'
where compute_chargeback.close_date = @close_date
and compute_chargeback.owner = 'moharb'
and compute_chargeback.department_code = '93400';
-- update longs
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS020100'
where compute_chargeback.close_date = @close_date
and compute_chargeback.owner = 'longs'
and compute_chargeback.department_code = '93400';
-- update rubinovm
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS000100'
where compute_chargeback.close_date = @close_date
and compute_chargeback.owner = 'rubinovm'
and compute_chargeback.department_code = '93400';
-- update aboucharl
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS016400'
where compute_chargeback.close_date = @close_date
and compute_chargeback.owner = 'aboucharl'
and compute_chargeback.department_code = '93400';
-- update holtzman
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS016100'
where compute_chargeback.close_date = @close_date
and compute_chargeback.owner = 'holtzman'
and compute_chargeback.department_code = '93400';
-- update friedrich
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS020000'
where compute_chargeback.close_date = @close_date
and compute_chargeback.owner = 'friedrichj'
and compute_chargeback.department_code = '93400';
-- update bergmang
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93219'
where compute_chargeback.close_date = @close_date
and compute_chargeback.owner = 'bergmang'
and compute_chargeback.department_code = '93400';
-- update klibaiteu
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93219'
where compute_chargeback.close_date = @close_date
and compute_chargeback.owner = 'klibaiteu'
and compute_chargeback.department_code = '93400';
-- update kirkham
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93307'
where compute_chargeback.close_date = @close_date
and compute_chargeback.owner = 'kirkhamj'
and compute_chargeback.department_code = '93099';
-- update goinac
update chargeback.compute_chargeback
set compute_chargeback.department_code = '93098'
where compute_chargeback.close_date = @close_date
and compute_chargeback.owner = 'goinac'
and compute_chargeback.department_code = '93099';
-- nwb project code
update chargeback.compute_chargeback
set compute_chargeback.project = 'JVS016600'
where compute_chargeback.department_code = '93400'
and compute_chargeback.owner = 'nwb'
and compute_chargeback.close_date = @close_date;

