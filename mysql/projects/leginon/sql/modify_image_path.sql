select concat('/groups/em/leginon/Data',substr(`image path`,19)) ,`image path` from SessionData where SessionData.`image path` like '/home/janelia%'

update dbemdata.SessionData set `image path` = concat('/groups/em/leginon/Data',substr(`image path`,19)) where SessionData.`image path` like '/home/janelia%'

select * from SessionData