# chatapp
Chat application in which users can login register and chat 
users can edit and delete their messages also

DB structure:
users
    -doc
        -name
        -phone
        -email
        -uid


messages
    -chatId (user1_email, uesr2_email // concatinated after sorting)
        -chats
            -message
            -sender
            -reciver
            -timeStamp