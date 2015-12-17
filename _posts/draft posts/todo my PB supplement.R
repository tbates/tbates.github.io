library(jsonlite)
library(RPushbullet)
devtools::install_github("eddelbuettel/RPushbullet")

defaultTxt = {
    \"key\": \"\",
    \"devices\": [],
    \"names\": []
}"
userFile       = "~/.rpushbullet.json"

if(!file.exists(userFile)){
	file.create(userFile)
	writeLines(defaultTxt, userFile)
}else{
	# get the key here
	# ask to overwrite or just update devices, ask user what they want to do
}

PBdata         = jsonlite::fromJSON(userFile)
myDevices      = jsonlite::fromJSON(pbGetDevices("lBCuYBWKwAt6m3aAXF6S3Htw32X0L9hD"))
myDevices      = myDevices$devices[,c("iden", "nickname")]
PBdata$devices = myDevices$iden
PBdata$names   = myDevices$nickname
txt = jsonlite::toJSON(PBdata, pretty = TRUE)
writeLines(txt, userFile)
message("COol! Now you can send notifcations to these devices:")
fromJSON(pbGetDevices())$devices[,c("iden", "nickname")]
# offer to open file, show user some valid examples
message("Try this:")
message("pbPost('note', 'My first note!', 'Body of message is pretty short though :-).', verbose = TRUE)")
message("Or this:")
message("pbPost(type='address', devices = 'udhmhdjAuXDo0g56', title='It ran! - see you for a beer', body='Under The Stairs, 3A Merchant St, EH1 2QD, UK')")
message("pbPost(type='link', devices = 'udhmhdjAuXDo0g56', title='PB repo', url='https://github.com/eddelbuettel/rpushbullet')")

# file.show(userFile)
[Dirks page](http://dirk.eddelbuettel.com/code/rpushbullet.html)
[PB repo](https://github.com/eddelbuettel/rpushbullet)

pbPost(type='address', devices = 'udhmhdjAuXDo0g56', title='It ran! - see you for a beer', body='EH1 2QD, UK')