function mailsnow {
    mails=(~/.mail/Inbox/new/*(N))
    (( $#mails )) && print  ✉ $#mails
}


